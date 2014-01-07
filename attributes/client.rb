case node["platform_family"]
when "debian"
  normal['mysql']['client']['packages'] = %w{libmysqlclient-dev percona-server-client}
end
