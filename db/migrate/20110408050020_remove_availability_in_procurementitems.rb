class RemoveAvailabilityInProcurementitems < ActiveRecord::Migration
  def self.up
    add_column    :procurementitems, :quantity, :integer
    remove_column :procurementitems, :avl_status
    remove_column :procurementitems, :avl_quantity
  end

  def self.down
  end
end
