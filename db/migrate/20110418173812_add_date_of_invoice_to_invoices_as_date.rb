class AddDateOfInvoiceToInvoicesAsDate < ActiveRecord::Migration
  def self.up
    add_column :invoices, :date_of_invoice, :date
  end

  def self.down
    remove_column :invoices, :date_of_invoice
  end
end
