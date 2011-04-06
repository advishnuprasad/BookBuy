class DropAuthorIdFromEnrichedtitles < ActiveRecord::Migration
  def self.up
    remove_column :enrichedtitles, :author_id
  end

  def self.down
    add_column :enrichedtitles, :author_id, :integer
  end
end
