module PluginVersionPatch
  # Set requirements on the versions of a set of Redmine plugins
  # Raises a PluginRequirementError exception if any requirement is not met
  #
  # Usage example
  #   plugin = Redmine::Plugin.register :redmine_my_plugin do
  #      ...
  #   end
  #   
  #   # each hash contains conditions in AND; plugin is supported if any hash in array matches 
  #   # :mandatory and :required are synonyms (default true)
  #   supported_plugins = {
  #     redmine_any:               { required: true },              # any version, but required
  #     redmine_any_too:           { },                             # this is also required
  #     redmine_specific:          { version: '5.1.0' }             # 5.1.0 only
  #     redmine_list:              { version: ['5.1.0', '5.1.1'] }, # 5.1.0 or 5.1.1
  #     redmine_same_minor:        { tilde_greater_than: '5.1.0' }, # 5.1.x
  #     redmine_same_major:        { tilde_greater_than: '5.1' },   # 5.x.y, x>=1
  #     redmine_minimum:           { version_or_higher:  '5.1.1' }, # x.y.z, x>5 or (x=5 and y>=1) or (x=5, y=1 and x>=1)  
  #     redmine_string:            '5.1.1',                         # equivalent to :version_or_higher
  #     redmine_maximum:           { version_lower_than: '5.2.1' }, # up to 5.1.x or 5.2.0 
  #     redmine_in_between:        { tilde_greater_than: '5.1.0',   # 5.1.0 or 5.1.1 
  #                                  version_lower_than: '5.1.2' },
  #     redmine_optional:          { version_or_higher:  '5.1.0', mandatory: false } # warning if <5.1
  #   }
  #   
  #   Rails.configuration.after_initialize do
  #       # raise exception in case. Ignore call if Redwine is not installed
  #       if plugin.methods.include? :compatible_redmine_plugins
  #           plugin.compatible_redmine_plugins(supported_plugins, true);
  #       end
  #   end
  def compatible_redmine_plugins(supported_plugins, fail=true, complain_unlisted=false)
    # check mandatory presence
    supported_plugins.each do |pname, list|
      unless list.is_a? Array
        list = [list]
      end
  
      mandatory = true
      list.each do |conditions|
        conditions = {version_or_higher: conditions} unless conditions.is_a?(Hash)
        conditions.each do |key, value|
          case key
          when :mandatory
            mandatory = value
          when :required
            mandatory = value
          end
        end
      end
      
      if mandatory
        begin
          Redmine::Plugin.find(pname)
        rescue Redmine::PluginNotFound
          manage_not_installed(pname, fail)
        end
      end
    end
    
    # check versions
    Redmine::Plugin.all.each do |plugin|
      name = plugin.id
      if nil == supported_plugins[name]
        if complain_unlisted
          raise "Plugin #{name.to_s} is not explicitly supported"
        end
      else
        current = plugin.version.split('.').collect(&:to_i)
        list = supported_plugins[name]
        unless list.is_a? Array
          list = [list]
        end

        supported = false
        list.each do |conditions|
          supported = true
          conditions = {version_or_higher: conditions} unless conditions.is_a?(Hash)
          conditions.assert_valid_keys(:version, :version_or_higher, :version_lower_than, 
            :tilde_greater_than, :mandatory, :required)

          conditions.each do |key, value|
            next if key == :mandatory
            next if key == :required
            value = [] << value unless value.is_a?(Array)
            varr = value.collect {|s| s.split('.').collect(&:to_i)}
            case key
            when :version
              supported = false unless varr.include?(current)
            when :version_or_higher
              supported = false unless (current <=> varr.first) >= 0
            when :version_lower_than
              supported = false unless (current <=> varr.first) < 0
            when :tilde_greater_than
              supported = false unless (current[0, varr.first.count-1] <=> varr.first[0..-2]) == 0
              supported = false unless (current <=> varr.first) >= 0
            end
          end

          break if supported
        end

        unless supported
          # delegated to method, so it can be overridden for further behaviors
          manage_unsupported(plugin, fail)
        end
      end
    end
  end

  def manage_not_installed(pname, fail)
    if fail
      raise Redmine::PluginRequirementError.new("#{id} plugin requires the #{pname} plugin")
    else
      Rails.logger.warn(
        "WARNING: #{id} plugin requires the #{pname} plugin")
    end
  end
  
  def manage_unsupported(plugin, fail)
    if fail 
      raise Redmine::PluginRequirementError.new(
        "#{id} plugin does not support version #{plugin.version} of the #{plugin.id.to_s} plugin"
      )
    else 
      Rails.logger.warn(
        "WARNING: #{id} plugin does not support version #{plugin.version} of the #{plugin.id.to_s} plugin")
    end
  end
  
end

unless Redmine::Plugin.included_modules.include?(PluginVersionPatch)
  Redmine::Plugin.send(:prepend, PluginVersionPatch)
end
