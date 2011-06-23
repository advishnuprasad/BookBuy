class AddReceivedCntToProcurementitems < ActiveRecord::Migration
  def self.up
    add_column :procurementitems, :received_cnt, :integer
  end

  def self.down
    remove_column :procurementitems, :received_cnt
  end
end
