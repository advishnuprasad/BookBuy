class AddCategoriesToEnrichedtitles < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitles, :category1, :string
    add_column :enrichedtitles, :category2, :string
    add_column :enrichedtitles, :category3, :string
  end

  def self.down
    remove_column :enrichedtitles, :category1
    remove_column :enrichedtitles, :category2
    remove_column :enrichedtitles, :category3
  end
end
