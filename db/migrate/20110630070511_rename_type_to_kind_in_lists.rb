class RenameTypeToKindInLists < ActiveRecord::Migration
  def self.up
    rename_column :lists, :type, :kind
  end

  def self.down
  end
end
