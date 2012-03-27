class CreateTitlebranches < ActiveRecord::Migration
  def self.up
    create_table :titlebranches do |t|
      t.integer :title_id
      t.integer :branch_id
      t.integer :times_rented
      t.integer :total_cnt
      t.integer :available_cnt

      t.timestamps
    end
  end

  def self.down
    drop_table :titlebranches
  end
end
