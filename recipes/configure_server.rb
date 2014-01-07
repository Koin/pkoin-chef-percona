percona = node["percona"]
server  = percona["server"]

template "/root/.my.cnf" do
  variables(:root_password => server["root_password"])
  owner "root"
  group "root"
  mode 0600
  source "my.cnf.root.erb"
end

user = server["username"]
datadir = server["datadir"]

# this is where we dump sql templates for replication, etc.
directory "/etc/mysql" do
  owner "root"
  group "root"
  mode 0755
end

# setup the data directory
directory datadir do
  owner user
  group user
  recursive true
  action :create
end

# setup the tmp directory
directory server["tmpdir"] do
  owner user
  group user
  recursive true
  action :create
end

# setup the include directory
directory server["includedir"] do
  owner user
  group user
  recursive true
  action :create
end

# define the service
service "mysql" do
  supports :restart => true
  action server["enable"] ? :enable : :disable
end

# install db to the data directory
execute "setup mysql datadir" do
  command "mysql_install_db --user=#{user} --datadir=#{datadir}"
  not_if "test -f #{datadir}/mysql/user.frm"
end

# setup the main server config file
template percona["main_config_file"] do
  source "my.cnf.standalone.erb"
  owner "root"
  group "root"
  mode 0744
  notifies :restart, "service[mysql]", :immediately if node["percona"]["auto_restart"]
end

# now let's set the root password only if this is the initial install
execute "Update MySQL root password" do
  command "mysqladmin --user=root --password='' password '#{server["root_password"]}'"
  not_if "test -f /etc/mysql/grants.sql"
end

# setup the debian system user config
template "/etc/mysql/debian.cnf" do
  source "debian.cnf.erb"
  variables(:debian_password => server["debian_password"])
  owner "root"
  group "root"
  mode 0640
  notifies :restart, "service[mysql]", :immediately if node["percona"]["auto_restart"]

  only_if { node["platform_family"] == "debian" }
end
