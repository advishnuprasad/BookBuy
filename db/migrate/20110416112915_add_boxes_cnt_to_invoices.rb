class AddBoxesCntToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :boxes_cnt, :integer
  end

  def self.down
    remove_column :invoices, :boxes_cnt
  end
end
