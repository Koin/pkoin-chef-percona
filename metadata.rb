name              "percona"
maintainer        "PKoin"
maintainer_email  "pkoin.koin@gmail.com"
description       "Installs Percona MySQL client and server"
version           "0.1.0"

recipe "percona",                   "Includes the client recipe to configure a client"

recipe "percona::client",           "Installs client libraries"
recipe "percona::server",           "Installs the server daemon"

recipe "percona::package_repo",     "Used internally to set up the package repository"
recipe "percona::configure_server", "Used internally to manage the server configuration"
recipe "percona::access_grants",    "Used internally to grant permissions for recipes"

depends "apt", "~> 1.9"
depends "openssl"
depends "mysql", "~> 3.0"

%w[debian].each do |os|
  supports os
end
