class RenameIsisbnvalidToIsbnvalidInEnrichedtitles < ActiveRecord::Migration
  def self.up
    rename_column :enrichedtitles, :isisbnvalid, :isbnvalid
  end

  def self.down
  end
end
