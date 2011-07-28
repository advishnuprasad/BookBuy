class CreateRegionaltitles < ActiveRecord::Migration
  def self.up
    create_table :regionaltitles do |t|
      t.references :title
      t.string :title
      t.string :nls_title
      t.string :author
      t.references :publisher
      t.string :isbn
      t.string :isbn10
      t.string :language
      t.string :category
      t.string :subcategory
      t.string :verfied
      t.string :isbn_valid
      t.float :list_price
      t.string :currency
      t.integer :no_of_pages
      t.date :published_on
      t.integer :created_by
      t.integer :modified_by
      t.timestamps
    end
  end

  def self.down
    drop_table :regionaltitles
  end
end
