class AddProcurementIdToPos < ActiveRecord::Migration
  def self.up
    add_column :pos, :procurement_id, :integer
  end

  def self.down
    remove_column :pos, :procurement_id
  end
end
