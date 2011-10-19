class AddReferencesToTitlereceipts < ActiveRecord::Migration
  def self.up
    add_column :titlereceipts, :crate_id, :integer
    add_column :titlereceipts, :procurementitem_id, :integer
    add_column :titlereceipts, :po_id, :integer
    add_column :titlereceipts, :invoice_id, :integer
    add_column :titlereceipts, :box_id, :integer
  end

  def self.down
    remove_column :titlereceipts, :crate_id
    remove_column :titlereceipts, :procurementitem_id
    remove_column :titlereceipts, :po_id
    remove_column :titlereceipts, :invoice_id
    remove_column :titlereceipts, :box_id
  end
end