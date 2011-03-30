class RenameIsbnverifiedToVerified < ActiveRecord::Migration
  def self.up
    rename_column :enrichedtitles, :isbnverified, :verified
  end

  def self.down
  end
end
