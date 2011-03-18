class CreateWorkitems < ActiveRecord::Migration
  def self.up
    create_table :workitems do |t|
      t.references :worklist
      t.string :item_type
      t.references :procurementitem
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :workitems
  end
end
