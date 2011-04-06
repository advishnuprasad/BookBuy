class DropAuthorsFromEnrichedtitlesVersions < ActiveRecord::Migration
  def self.up
    remove_column :enrichedtitle_versions, :author_id
  end

  def self.down
    add_column :enrichedtitle_versions, :author_id, :integer
  end
end
