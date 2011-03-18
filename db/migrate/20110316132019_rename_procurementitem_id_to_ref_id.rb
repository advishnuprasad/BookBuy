class RenameProcurementitemIdToRefId < ActiveRecord::Migration
  def self.up
    rename_column :workitems, :procurementitem_id, :ref_id
  end

  def self.down
  end
end
