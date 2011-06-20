class CreateInvoiceitems < ActiveRecord::Migration
  def self.up
    create_table :invoiceitems do |t|
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
      t.timestamps
    end
  end

  def self.down
    drop_table :invoiceitems
  end
end
