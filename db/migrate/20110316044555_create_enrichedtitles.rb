class CreateEnrichedtitles < ActiveRecord::Migration
  def self.up
    create_table :enrichedtitles do |t|
      t.integer :title_id
      t.string :title
      t.integer :author_id
      t.integer :publisher_id
      t.string :isbn
      t.string :language
      t.string :category
      t.string :subcategory
      t.string :isbn10

      t.timestamps
    end
  end

  def self.down
    drop_table :enrichedtitles
  end
end
