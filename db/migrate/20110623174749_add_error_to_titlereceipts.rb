class AddErrorToTitlereceipts < ActiveRecord::Migration
  def self.up
    add_column :titlereceipts, :error, :string
  end

  def self.down
    remove_column :titlereceipts, :error
  end
end
