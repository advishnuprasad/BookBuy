class AddProcurementitemIdToListitems < ActiveRecord::Migration
  def self.up
    add_column :listitems, :procurementitem_id, :integer
  end

  def self.down
    remove_column :listitems, :procurementitem_id
  end
end
