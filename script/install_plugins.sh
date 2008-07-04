#!/bin/bash
#
# Install Plugins used by iBoard
#


#
# WILL PAGINATE
#
# obsolete # ./script/plugin install svn://errtheblog.com/svn/plugins/will_paginate
sudo gem install will_paginate
sudo gem install activemerchant
sudo gem install money

# textile_editor_helper
script/plugin install http://svn.webtest.wvu.edu/repos/rails/plugins/textile_editor_helper/
rake textile_editor_helper:install