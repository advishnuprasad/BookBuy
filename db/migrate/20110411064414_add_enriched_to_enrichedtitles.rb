class AddEnrichedToEnrichedtitles < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitles, :enriched, :string
  end

  def self.down
    remove_column :enrichedtitles, :enriched
  end
end
