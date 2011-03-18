class AddVersionToEnrichedtitles < ActiveRecord::Migration
  def self.up
    Enrichedtitle.create_versioned_table
  end

  def self.down
    Enrichedtitle.drop_versioned_table
  end
end
