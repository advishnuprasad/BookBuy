class CreateTitlereceipts < ActiveRecord::Migration
  def self.up
    create_table :titlereceipts do |t|
      t.string :po_no
      t.string :invoice_no
      t.string :isbn
      t.integer :box_no

      t.timestamps
    end
  end

  def self.down
    drop_table :titlereceipts
  end
end
