class AddPostingRestrictions < ActiveRecord::Migration
  def self.up
    add_column :postings, :restricted_to_function_id, :integer, :default => nil
    add_column :postings, :allow_editing, :integer, :default => 0 #0=only by author, #1=by registred users, #2=by function-members, #99=public
  end

  def self.down
    remove_column :postings, :restricted_to_function_id
    remove_column :postings, :allow_editing
  end
end
