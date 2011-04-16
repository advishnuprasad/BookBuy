class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.string :invoice_no
      t.integer :po_id
      t.string :po_no
      t.date :date_of_receipt
      t.integer :quantity
      t.float :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
