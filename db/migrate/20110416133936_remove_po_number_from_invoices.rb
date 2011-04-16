class RemovePoNumberFromInvoices < ActiveRecord::Migration
  def self.up
    remove_column :invoices, :po_no
  end

  def self.down
  end
end
