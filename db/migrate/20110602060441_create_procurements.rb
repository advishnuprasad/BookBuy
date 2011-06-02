class CreateProcurements < ActiveRecord::Migration
  def self.up
    create_table :procurements do |t|
      t.integer :source_id
      t.string :description
      t.integer :requests_cnt
      t.integer :created_by
      t.integer :modified_by

      t.timestamps
    end
  end

  def self.down
    drop_table :procurements
  end
end
