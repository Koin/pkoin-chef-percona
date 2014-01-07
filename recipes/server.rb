include_recipe "percona::package_repo"

case node["platform_family"]

when "debian"
  package "percona-server-server-5.6" do
    action :install
    options "--force-yes"
  end
end

include_recipe "percona::configure_server"

# access grants
include_recipe "percona::access_grants"
