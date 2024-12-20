# Makes the priority-[num] attribute depending on the position of the priority enum among other priorities,
# rather than on the id of the enum itself, since other types of enums may make these numbers random.
# As a consequence, the issues color styling in theme is then univoquely defined.

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

module IssuePriorityPatch
  def css_classes
    "priority-#{position} priority-#{position_name}"
  end
end

unless IssuePriority.included_modules.include?(IssuePriorityPatch)
    IssuePriority.send(:prepend, IssuePriorityPatch)
end


