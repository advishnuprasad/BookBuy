class CreateBoxes < ActiveRecord::Migration
  def self.up
    create_table :boxes do |t|
      t.integer :box_no
      t.string :po_no
      t.string :invoice_no
      t.integer :total_cnt

      t.timestamps
    end
  end

  def self.down
    drop_table :boxes
  end
end
