# Make sure that emails in folder don't have the Seen flag, since moving from the main folder 
# via a filter may have set it

# Copyright (C) 2020-   Massimo Rossello https://github.com/maxrossello
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

module ImapPatch
  def check(imap_options={}, options={})
    host = imap_options[:host] || '127.0.0.1'
    port = imap_options[:port] || '143'
    ssl = !imap_options[:ssl].nil?
    starttls = !imap_options[:starttls].nil?
    folder = imap_options[:folder] || 'INBOX'

    imap = Net::IMAP.new(host, port, ssl)
    if starttls
      imap.starttls
    end
    imap.login(imap_options[:username], imap_options[:password]) unless imap_options[:username].nil?
    imap.select(folder)
    # redwine customization start
    imap.uid_search(['ALL']).each do |uid|
      imap.uid_fetch(uid,'RFC822')[0].attr['RFC822']
      imap.uid_store(uid, "-FLAGS", [:Seen])
    end
    # redwine customization end
    imap.logout
    imap.disconnect
    super(imap_options, options)
  end
end

unless Redmine::IMAP.singleton_class.included_modules.include?(ImapPatch)
  Redmine::IMAP.singleton_class.send(:prepend, ImapPatch)
end


