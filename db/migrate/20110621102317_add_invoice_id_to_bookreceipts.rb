class AddInvoiceIdToBookreceipts < ActiveRecord::Migration
  def self.up
    add_column :bookreceipts, :invoice_id, :integer
  end

  def self.down
    remove_column :bookreceipts, :invoice_id
  end
end
