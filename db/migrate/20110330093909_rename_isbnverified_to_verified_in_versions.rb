class RenameIsbnverifiedToVerifiedInVersions < ActiveRecord::Migration
  def self.up
    rename_column :enrichedtitle_versions, :isbnverified, :verified
  end

  def self.down
  end
end
