class RenamePublishersuppliermappingsToSupplierdiscounts < ActiveRecord::Migration
  def self.up
    rename_table :publishersuppliermappings, :supplierdiscounts
  end

  def self.down
    rename_table :supplierdiscounts, :publishersuppliermappings
  end
end
