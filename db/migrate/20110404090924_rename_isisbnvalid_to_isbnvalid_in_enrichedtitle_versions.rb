class RenameIsisbnvalidToIsbnvalidInEnrichedtitleVersions < ActiveRecord::Migration
  def self.up
    rename_column :enrichedtitle_versions, :isisbnvalid, :isbnvalid
  end

  def self.down
  end
end
