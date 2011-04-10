class AddListpriceToEnrichedtitleVersions < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitle_versions, :listprice, :float
  end

  def self.down
    remove_column :enrichedtitle_versions, :listprice
  end
end
