class AddCategoriesToEnrichedtitleVersions < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitle_versions, :category1, :string
    add_column :enrichedtitle_versions, :category2, :string
    add_column :enrichedtitle_versions, :category3, :string
  end

  def self.down
    remove_column :enrichedtitle_versions, :category1
    remove_column :enrichedtitle_versions, :category2
    remove_column :enrichedtitle_versions, :category3
  end
end
