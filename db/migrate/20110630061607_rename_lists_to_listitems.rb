class RenameListsToListitems < ActiveRecord::Migration
  def self.up
    rename_table :lists, :listitems
  end

  def self.down
    rename_table :listitems, :lists
  end
end
