class AddCreatedByToTitlereceipts < ActiveRecord::Migration
  def self.up
    add_column :titlereceipts, :created_by, :integer
  end

  def self.down
    remove_column :titlereceipts, :created_by
  end
end
