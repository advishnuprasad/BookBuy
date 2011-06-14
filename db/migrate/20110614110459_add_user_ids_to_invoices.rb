class AddUserIdsToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :created_by, :integer
    add_column :invoices, :modified_by, :integer
  end

  def self.down
    remove_column :invoices, :modified_by
    remove_column :invoices, :created_by
  end
end
