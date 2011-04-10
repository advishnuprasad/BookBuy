class ChangeListpriceToFloatInEnrichedtitles < ActiveRecord::Migration
  def self.up
    change_column :enrichedtitles, :listprice, :float
  end

  def self.down
  end
end
