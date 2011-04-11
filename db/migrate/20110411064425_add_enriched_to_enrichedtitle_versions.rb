class AddEnrichedToEnrichedtitleVersions < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitle_versions, :enriched, :string
  end

  def self.down
    remove_column :enrichedtitle_versions, :enriched
  end
end
