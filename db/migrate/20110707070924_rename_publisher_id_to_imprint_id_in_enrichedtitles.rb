class RenamePublisherIdToImprintIdInEnrichedtitles < ActiveRecord::Migration
  def self.up
    rename_column :enrichedtitles, :publisher_id, :imprint_id
  end

  def self.down
  end
end
