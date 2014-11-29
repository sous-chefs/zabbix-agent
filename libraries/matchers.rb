if defined?(ChefSpec)
  def source_agent_install(install)
    ChefSpec::Matchers::ResourceMatcher.new(:zabbix_agent_source, :install_agent, install)
  end
end
