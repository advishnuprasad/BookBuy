class AddIsisbnvalidToEnrichedtitles < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitles, :isisbnvalid, :string
  end

  def self.down
    remove_column :enrichedtitles, :isisbnvalid
  end
end
