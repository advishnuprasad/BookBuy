class AddImageRemoteUrlToEnrichedtitles < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitles, :cover_remote_url, :string
    add_column :enrichedtitle_versions, :cover_remote_url, :string
  end

  def self.down
    remove_column :enrichedtitles, :cover_remote_url
    remove_column :enrichedtitle_versions, :cover_remote_url
  end
end
