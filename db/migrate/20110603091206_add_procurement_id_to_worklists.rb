class AddProcurementIdToWorklists < ActiveRecord::Migration
  def self.up
    add_column :worklists, :procurement_id, :integer
  end

  def self.down
    remove_column :worklists, :procurement_id
  end
end
