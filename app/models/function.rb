######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 

#
# Accessors take control over the acessibility of application-functions, postings and pages
#
class Function < ActiveRecord::Base
  has_many    :accessors, :dependent => :destroy
  has_many    :users, :through => :accessors
  
  has_many    :postings
  has_many    :pages
end
