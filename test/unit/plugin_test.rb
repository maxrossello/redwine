# frozen_string_literal: true

# Redmine - project management software
# Copyright (C) 2006-2023  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require_relative '../test_helper'

class << Redmine::Plugin
    def save_plugins
        @saved = @registered_plugins
    end
    def registered_plugins
        @registered_plugins
    end
    def reload
        @registered_plugins = @saved
    end
end

class Redmine::PluginTest < ActiveSupport::TestCase
  def setup
    @klass = Redmine::Plugin
    @klass.save_plugins  # redmine_testsuites
    # Change plugin directory for testing to default
    # plugins/foo => test/fixtures/plugins/foo
    @klass.directory = Rails.root.join('test/fixtures/plugins')
    # In case some real plugins are installed
    @klass.clear

    # Change plugin loader's directory for testing
    Redmine::PluginLoader.directory = @klass.directory
    Redmine::PluginLoader.setup
  end

  def teardown
    @klass.clear
    @klass.reload
  end

  def test_compatible_redmine_plugins
    test = self
    other_version = '0.5.0'
    @klass.register :other_plugin do
      name 'Other'
      version other_version
    end
    plugin = @klass.register :foo_plugin do end
    
    test.assert plugin.compatible_redmine_plugins({other_plugin: {version_or_higher: '0.1.0'}})
    test.assert plugin.compatible_redmine_plugins({other_plugin: {version_or_higher: other_version}})
    test.assert plugin.compatible_redmine_plugins({other_plugin: other_version})
    test.assert plugin.compatible_redmine_plugins({other_plugin: '0.4.0'})  # version or higher
    test.assert_raise Redmine::PluginRequirementError do
      plugin.compatible_redmine_plugins({other_plugin: {version_or_higher: '99.0.0'}})
    end
    test.assert plugin.compatible_redmine_plugins({other_plugin: {version: other_version}})
    test.assert plugin.compatible_redmine_plugins({other_plugin: {version: [other_version, '99.0.0']}})
    test.assert_raise Redmine::PluginRequirementError do
      plugin.compatible_redmine_plugins({other_plugin: {version: '99.0.0'}})
    end
    test.assert_raise Redmine::PluginRequirementError do
      plugin.compatible_redmine_plugins({other_plugin: {version: ['98.0.0', '99.0.0']}})
    end
    test.assert plugin.compatible_redmine_plugins({other_plugin: {version_lower_than: '0.5.1'}})
    test.assert plugin.compatible_redmine_plugins({other_plugin: {version_lower_than: '0.6.0'}})
    test.assert plugin.compatible_redmine_plugins({other_plugin: {version_lower_than: '1.0.0'}})
    test.assert plugin.compatible_redmine_plugins({other_plugin: {version_lower_than: '1.0.0'}})
    test.assert_raise Redmine::PluginRequirementError do
      test.assert plugin.compatible_redmine_plugins({other_plugin: {version_lower_than: other_version}})
    end
    test.assert_raise Redmine::PluginRequirementError do
      test.assert plugin.compatible_redmine_plugins({other_plugin: {version_lower_than: '0.4'}})
    end
    test.assert_raise Redmine::PluginRequirementError do
      test.assert plugin.compatible_redmine_plugins({other_plugin: {version_lower_than: '0.5'}})
    end
    test.assert plugin.compatible_redmine_plugins({other_plugin: {tilde_greater_than: '0.5.0'}})
    test.assert plugin.compatible_redmine_plugins({other_plugin: {tilde_greater_than: '0.4'}})
    test.assert plugin.compatible_redmine_plugins({other_plugin: {tilde_greater_than: '0.5'}})
    test.assert plugin.compatible_redmine_plugins({other_plugin: {tilde_greater_than: '0'}})
    test.assert_raise Redmine::PluginRequirementError do
      test.assert plugin.compatible_redmine_plugins({other_plugin: {tilde_greater_than: '0.5.1'}})
    end
    test.assert_raise Redmine::PluginRequirementError do
      test.assert plugin.compatible_redmine_plugins({other_plugin: {tilde_greater_than: '0.6'}})
    end
    test.assert_raise Redmine::PluginRequirementError do
      test.assert plugin.compatible_redmine_plugins({other_plugin: {tilde_greater_than: '1'}})
    end
  end

  def test_compatible_redmine_plugins_fail
    test = self
    other_version = '0.5.0'
    @klass.register :other_plugin do
      name 'Other'
      version other_version
    end
    plugin = @klass.register :foo_plugin do end

    test.assert_raise Redmine::PluginRequirementError do
      plugin.compatible_redmine_plugins({other_plugin: {version_or_higher: '99.0.0'}}, fail=true)
    end
    plugin.compatible_redmine_plugins({other_plugin: {version_or_higher: '99.0.0'}}, fail=false)
    test.assert_raise Redmine::PluginRequirementError do
      plugin.compatible_redmine_plugins({other_plugin: {version: '99.0.0'}}, fail=true)
    end
    plugin.compatible_redmine_plugins({other_plugin: {version: '99.0.0'}}, fail=false)
    test.assert_raise Redmine::PluginRequirementError do
      plugin.compatible_redmine_plugins({other_plugin: {version: ['98.0.0', '99.0.0']}}, fail=true)
    end
    plugin.compatible_redmine_plugins({other_plugin: {version: ['98.0.0', '99.0.0']}}, fail=false)
    test.assert_raise Redmine::PluginRequirementError do
      test.assert plugin.compatible_redmine_plugins({other_plugin: {version_lower_than: other_version}}, fail=true)
    end
    test.assert plugin.compatible_redmine_plugins({other_plugin: {version_lower_than: other_version}}, fail=false)
    test.assert_raise Redmine::PluginRequirementError do
      test.assert plugin.compatible_redmine_plugins({other_plugin: {version_lower_than: '0.4'}}, fail=true)
    end
    test.assert plugin.compatible_redmine_plugins({other_plugin: {version_lower_than: '0.4'}}, fail=false)
    test.assert_raise Redmine::PluginRequirementError do
      test.assert plugin.compatible_redmine_plugins({other_plugin: {version_lower_than: '0.5'}}, fail=true)
    end
    test.assert plugin.compatible_redmine_plugins({other_plugin: {version_lower_than: '0.5'}}, fail=false)
    test.assert_raise Redmine::PluginRequirementError do
      test.assert plugin.compatible_redmine_plugins({other_plugin: {tilde_greater_than: '0.5.1'}}, fail=true)
    end
    test.assert plugin.compatible_redmine_plugins({other_plugin: {tilde_greater_than: '0.5.1'}}, fail=false)
    test.assert_raise Redmine::PluginRequirementError do
      test.assert plugin.compatible_redmine_plugins({other_plugin: {tilde_greater_than: '0.6'}}, fail=true)
    end
    test.assert plugin.compatible_redmine_plugins({other_plugin: {tilde_greater_than: '0.6'}}, fail=false)
    test.assert_raise Redmine::PluginRequirementError do
      test.assert plugin.compatible_redmine_plugins({other_plugin: {tilde_greater_than: '1'}}, fail=true)
    end
    test.assert plugin.compatible_redmine_plugins({other_plugin: {tilde_greater_than: '1'}}, fail=false)
  end
  
  def test_compatible_redmine_plugins_missing
    test = self
    plugin = @klass.register :foo_plugin do end

    test.assert_raise Redmine::PluginRequirementError do
      plugin.compatible_redmine_plugins({missing: {version_or_higher: '0.1.0'}})
    end
    test.assert_raise Redmine::PluginRequirementError do
      plugin.compatible_redmine_plugins({missing: '0.1.0'})
    end
    test.assert_raise Redmine::PluginRequirementError do
      plugin.compatible_redmine_plugins({missing: {version: '0.1.0'}})
    end
    
    test.assert_raise Redmine::PluginRequirementError do
    plugin.compatible_redmine_plugins({missing: {version_or_higher: '0.1.0', required: true}})
    end
    test.assert_raise Redmine::PluginRequirementError do
      plugin.compatible_redmine_plugins({missing: {version: '0.1.0', required: true}})
    end

    test.assert_raise Redmine::PluginRequirementError do
      plugin.compatible_redmine_plugins({missing: {version_or_higher: '0.1.0', mandatory: true}})
    end
    test.assert_raise Redmine::PluginRequirementError do
      plugin.compatible_redmine_plugins({missing: {version: '0.1.0', mandatory: true}})
    end

    plugin.compatible_redmine_plugins({missing: {version_or_higher: '0.1.0', required: false}})
    plugin.compatible_redmine_plugins({missing: {version: '0.1.0', required: false}})
      
    plugin.compatible_redmine_plugins({missing: {version_or_higher: '0.1.0', mandatory: false}})
    plugin.compatible_redmine_plugins({missing: {version: '0.1.0', mandatory: false}})
    
    # a warning is only printed
    plugin.compatible_redmine_plugins({missing: {version_or_higher: '0.1.0'}}, fail=false)
    plugin.compatible_redmine_plugins({missing: '0.1.0'}, fail=false)
    plugin.compatible_redmine_plugins({missing: {version: '0.1.0'}}, fail=false)
  end
end