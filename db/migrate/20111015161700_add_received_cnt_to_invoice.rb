class AddReceivedCntToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :received_cnt, :integer
  end

  def self.down
    remove_column :invoices, :received_cnt
  end
end
