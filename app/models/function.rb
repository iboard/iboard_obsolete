class Function < ActiveRecord::Base
  has_many    :accessors
  has_many    :users, :through => :accessors
  
  has_many    :postings
  has_many    :pages
end
