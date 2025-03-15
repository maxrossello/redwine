# Redwine profile for Redmine
#
# Copyright (C) 2020-        Massimo Rossello 
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'redmine'

Rails.logger.info 'Redwine'

plugin = Redmine::Plugin.register :redwine do
  name 'Redwine Core'
  author 'Massimo Rossello'
  description 'Redwine profile for Redmine. Contains main customizations and fixes wrt Redmine core code. Defines consistent set of tested plugin versions.'
  version '5.1.7'
  url 'https://github.com/maxrossello/redwine.git'
  author_url 'https://github.com/maxrossello'
  requires_redmine :version => '5.1.7'
end 

require_relative 'lib/imap_patch'
require_relative 'lib/issue_priority_patch'
require_relative 'lib/plugin_version_patch'

# each hash contains conditions in AND; plugin is supported if any hash in array matches 
supported_plugins = {
  redmine_translation_terms: { tilde_greater_than: '5.1.4', mandatory: false },
  redmine_base_deface:       { version_or_higher:  '5.1.1', mandatory: false },
  redmine_better_overview:   { tilde_greater_than: '5.1.0', mandatory: false },
  redmine_extended_watchers: { tilde_greater_than: '5.1.4', mandatory: false },
  redmine_pluggable_themes:  { tilde_greater_than: '5.1.0', mandatory: false },
  sidebar_hide:              { version_or_higher:  '5.1.1', mandatory: false }
}

Rails.configuration.after_initialize do
  if plugin.methods.include? :compatible_redmine_plugins
    plugin.compatible_redmine_plugins(supported_plugins)
  end
end
