class CreateCrates < ActiveRecord::Migration
  def self.up
    create_table :crates do |t|
      t.string :po_no
      t.string :invoice_no
      t.integer :total_cnt

      t.timestamps
    end
  end

  def self.down
    drop_table :crates
  end
end
