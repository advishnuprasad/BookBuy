class AddInvoiceToBox < ActiveRecord::Migration
  def self.up
    add_column :boxes, :invoice_id, :integer
  end

  def self.down
    remove_column :boxes, :invoice_id
  end
end
