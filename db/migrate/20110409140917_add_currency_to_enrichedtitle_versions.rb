class AddCurrencyToEnrichedtitleVersions < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitle_versions, :currency, :string
  end

  def self.down
    remove_column :enrichedtitle_versions, :currency
  end
end
