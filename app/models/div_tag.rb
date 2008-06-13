######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 

#
# DivTags are assigned to pages and columns.
# Pages and Columns wrapped by this div-definitions at runtime
#
class DivTag < ActiveRecord::Base
  has_many  :pages
  has_many  :columns
end
