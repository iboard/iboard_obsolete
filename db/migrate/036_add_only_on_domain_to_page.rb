class AddOnlyOnDomainToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :only_for_domain, :string
  end

  def self.down
    remove_column :pages, :only_for_domain
  end
  
end
