class AddErrorToLists < ActiveRecord::Migration
  def self.up
    add_column :lists, :error, :string
  end

  def self.down
    remove_column :lists, :error
  end
end
