class AddIsbnverifiedToEnrichedtitleVersions < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitle_versions, :isbnverified, :string
  end

  def self.down
    remove_column :enrichedtitle_versions, :isbnverified
  end
end
