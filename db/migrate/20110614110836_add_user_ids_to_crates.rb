class AddUserIdsToCrates < ActiveRecord::Migration
  def self.up
    add_column :crates, :created_by, :integer
    add_column :crates, :modified_by, :integer
  end

  def self.down
    remove_column :crates, :modified_by
    remove_column :crates, :created_by
  end
end
