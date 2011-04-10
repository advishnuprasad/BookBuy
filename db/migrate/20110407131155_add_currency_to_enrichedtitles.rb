class AddCurrencyToEnrichedtitles < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitles, :currency, :string
  end

  def self.down
    remove_column :enrichedtitles, :currency
  end
end
