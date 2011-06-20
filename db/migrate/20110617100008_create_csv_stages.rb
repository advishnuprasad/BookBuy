class CreateCsvStages < ActiveRecord::Migration
  def self.up
    create_table :csv_stages do |t|
      t.references :invoice
      t.integer :quantity
      t.string  :author
      t.string  :title
      t.string  :isbn
      t.string  :publisher
      t.string  :currency 
      t.float   :unit_price
      t.float   :unit_price_inr
      t.float   :conv_rate
      t.float   :discount
      t.float   :net_amount
      t.references :user
      t.string :error
      t.timestamps
    end
  end

  def self.down
    drop_table :csv_stages
  end
end
