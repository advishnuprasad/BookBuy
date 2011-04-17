class AddInvoicesCountToPos < ActiveRecord::Migration
  def self.up
    add_column :pos, :invoices_count, :integer
  end

  def self.down
    remove_column :pos, :invoices_count
  end
end
