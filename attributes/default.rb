::Chef::Node.send(:include, Opscode::OpenSSL::Password)

# Always restart percona on configuration changes
default["percona"]["auto_restart"] = true

case node["platform_family"]
when "debian"
  default["percona"]["server"]["socket"]                        = "/var/run/mysqld/mysqld.sock"
  default["percona"]["server"]["default_storage_engine"]        = "InnoDB"
  default["percona"]["server"]["includedir"]                    = "/etc/mysql/conf.d/"
  default["percona"]["server"]["pidfile"]                       = "/var/run/mysqld/mysqld.pid"
end

# Cookbook Settings
default["percona"]["main_config_file"]                          = "/etc/my.cnf"

# Start percona server on boot
default["percona"]["server"]["enable"]                          = true

# Basic Settings
default["percona"]["server"]["root_password"]                   = "root"
default["percona"]["server"]["debian_password"]                 = "root"
default["percona"]["server"]["username"]                        = "mysql"
default["percona"]["server"]["datadir"]                         = "/var/lib/mysql"
default["percona"]["server"]["tmpdir"]                          = "/tmp"
default["percona"]["server"]["debian_username"]                 = "debian-sys-maint"
default["percona"]["server"]["nice"]                            = 0
default["percona"]["server"]["open_files_limit"]                = 16384
default["percona"]["server"]["hostname"]                        = "localhost"
default["percona"]["server"]["basedir"]                         = "/usr"
default["percona"]["server"]["port"]                            = 3306
default["percona"]["server"]["language"]                        = "/usr/share/mysql/english"
default["percona"]["server"]["character_set"]                   = "utf8"
default["percona"]["server"]["collation"]                       = "utf8_unicode_ci"
default["percona"]["server"]["skip_name_resolve"]               = false
default["percona"]["server"]["skip_external_locking"]           = true
default["percona"]["server"]["net_read_timeout"]                = 120

# # Fine Tuning
default["percona"]["server"]["key_buffer"]                      = "16M"
default["percona"]["server"]["max_allowed_packet"]              = "64M"
default["percona"]["server"]["thread_stack"]                    = "192K"
default["percona"]["server"]["thread_cache_size"]               = 16
default["percona"]["server"]["group_concat_max_len"]            = 4096

# Query Cache Configuration
default["percona"]["server"]["query_cache_size"]                = "64M"
default["percona"]["server"]["query_cache_limit"]               = "2M"

# Logging and Replication
default["percona"]["server"]["slow_query_log"]                  = 1
default["percona"]["server"]["slow_query_log_file"]             = "/var/log/mysql/mysql-slow.log"
default["percona"]["server"]["long_query_time"]                 = 2

# InnoDB Specific
default["percona"]["server"]["innodb_file_per_table"]           = true
