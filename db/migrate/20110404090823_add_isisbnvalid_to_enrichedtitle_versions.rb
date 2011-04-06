class AddIsisbnvalidToEnrichedtitleVersions < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitle_versions, :isisbnvalid, :string
  end

  def self.down
    remove_column :enrichedtitle_versions, :isisbnvalid
  end
end
