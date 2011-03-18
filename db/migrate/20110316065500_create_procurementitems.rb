class CreateProcurementitems < ActiveRecord::Migration
  def self.up
    create_table :procurementitems do |t|
      t.string :source
      t.integer :source_id
      t.integer :enrichedtitle_id
      t.string :isbn
      t.string :status
      t.string :po_number
      t.string :book_number
      t.string :cancel_reason
      t.integer :deferred_by
      t.date :last_action_date
      t.integer :supplier_id
      t.string :avl_status
      t.integer :avl_quantity
      t.date :expiry_date
      t.integer :member_id
      t.string :card_id
      t.integer :branch_id

      t.timestamps
    end
  end

  def self.down
    drop_table :procurementitems
  end
end
