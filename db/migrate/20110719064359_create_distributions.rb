class CreateDistributions < ActiveRecord::Migration
  def self.up
    create_table :distributions do |t|
      t.integer :procurementitem_id
      t.integer :branch_id
      t.integer :quantity
      t.integer :procured_cnt
      t.integer :created_by
      t.integer :modified_by

      t.timestamps
    end
  end

  def self.down
    drop_table :distributions
  end
end
