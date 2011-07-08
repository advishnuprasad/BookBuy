class RenamePublisherIdToImprintIdInEnrichedtitleVersions < ActiveRecord::Migration
  def self.up
    rename_column :enrichedtitle_versions, :publisher_id, :imprint_id
  end

  def self.down
  end
end
