class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.integer :key
      t.string :isbn
      t.string :title
      t.string :author
      t.string :publisher
      t.integer :publisher_id
      t.integer :quantity
      t.float :listprice
      t.string :currency
      t.string :category
      t.string :subcategory
      t.integer :branch_id
      t.integer :created_by
      t.integer :modified_by

      t.timestamps
    end
  end

  def self.down
    drop_table :lists
  end
end
