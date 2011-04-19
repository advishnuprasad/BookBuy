class AddBookNoToTitlereceipts < ActiveRecord::Migration
  def self.up
    add_column :titlereceipts, :book_no, :string
  end

  def self.down
    remove_column :titlereceipts, :book_no
  end
end
