class CreateBookreceipts < ActiveRecord::Migration
  def self.up
    create_table :bookreceipts do |t|
      t.string :book_no
      t.string :po_no
      t.string :invoice_no
      t.string :isbn
      t.integer :title_id

      t.timestamps
    end
  end

  def self.down
    drop_table :bookreceipts
  end
end
