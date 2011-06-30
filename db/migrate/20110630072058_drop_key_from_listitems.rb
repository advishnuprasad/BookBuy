class DropKeyFromListitems < ActiveRecord::Migration
  def self.up
    remove_column :listitems, :key
  end

  def self.down
    add_column :listitems, :key, :integer
  end
end
