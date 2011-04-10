class AddListpriceToEnrichedtitles < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitles, :listprice, :string
  end

  def self.down
    remove_column :enrichedtitles, :listprice
  end
end
