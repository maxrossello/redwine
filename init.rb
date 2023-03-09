# Redwine profile for Redmine
#
# Copyright (C) 2020-2023    Massimo Rossello 
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

Redmine::Plugin.register :redwine do
  name 'Redwine Core'
  author 'Massimo Rossello'
  description 'Redwine profile for Redmine. Contains main customizations and fixes wrt Redmine core code'
  version '4.2.10'
  url 'https://github.com/maxrossello/redwine.git'
  author_url 'https://github.com/maxrossello'
  requires_redmine :version => '4.2.10'
end 

require_dependency 'imap_patch'
require_dependency 'issue_priority_patch'
