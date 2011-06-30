class CreateListStagings < ActiveRecord::Migration
  def self.up
    create_table :list_stagings do |t|
      t.integer :key
      t.string :isbn
      t.string :title
      t.string :author
      t.string :publisher
      t.string :publishercode
      t.integer :quantity
      t.float :listprice
      t.string :currency
      t.string :category
      t.string :subcategory
      t.integer :branch_id
      t.string :error

      t.timestamps
    end
  end

  def self.down
    drop_table :list_stagings
  end
end
