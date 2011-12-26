class AddProcurementItemstoEnrichedtitlesVersions < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitle_versions, :procurementitems_count, :integer, :default => 0
  end

  def self.down
    remove_column :enrichedtitle_versions, :procurementitems_count
  end
end
