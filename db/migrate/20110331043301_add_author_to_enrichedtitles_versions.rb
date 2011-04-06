class AddAuthorToEnrichedtitlesVersions < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitle_versions, :author, :string
  end

  def self.down
    remove_column :enrichedtitle_versions, :author
  end
end
