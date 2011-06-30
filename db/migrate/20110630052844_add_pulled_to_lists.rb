class AddPulledToLists < ActiveRecord::Migration
  def self.up
    add_column :lists, :pulled, :string
  end

  def self.down
    remove_column :lists, :pulled
  end
end
