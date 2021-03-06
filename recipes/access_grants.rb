percona = node["percona"]
server  = percona["server"]

# define access grants
template "/etc/mysql/grants.sql" do
  source "grants.sql.erb"
  variables(
    :root_password        => server["root_password"],
    :debian_user          => node["percona"]["server"]["debian_username"],
    :debian_password      => server["debian_password"]
  )
  owner "root"
  group "root"
  mode "0600"
end

# execute access grants
execute "mysql-install-privileges" do
  command "/usr/bin/mysql < /etc/mysql/grants.sql"
  action :nothing
  subscribes :run, resources("template[/etc/mysql/grants.sql]"), :immediately
end

# This rewind can come out after https://github.com/phlipper/chef-percona/issues/91
# and/or https://github.com/phlipper/chef-percona/issues/67 is/are fixed.
chef_gem "chef-rewind"
require 'chef/rewind'
rewind "execute[mysql-install-privileges]" do
  command "mysql -p'" + server["root_password"] + "' -e '' &> /dev/null > /dev/null &> /dev/null ; if [ $? -eq 0 ] ; then /usr/bin/mysql -p'" + server["root_password"] + "' < /etc/mysql/grants.sql ; else /usr/bin/mysql < /etc/mysql/grants.sql ; fi ;"
end
