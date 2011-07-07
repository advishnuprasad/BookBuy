class RenamePublishersToImprints < ActiveRecord::Migration
  def self.up
    rename_table :publishers, :imprints
  end

  def self.down
    rename_table :imprints, :publishers
  end
end
