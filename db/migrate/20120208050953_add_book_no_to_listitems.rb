class AddBookNoToListitems < ActiveRecord::Migration
  def self.up
    add_column :listitems, :book_no, :string
  end

  def self.down
    remove_column :listitems, :book_no
  end
end
