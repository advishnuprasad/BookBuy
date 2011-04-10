class CreatePos < ActiveRecord::Migration
  def self.up
    create_table :pos do |t|
      t.string :number
      t.integer :supplier_id
      t.integer :branch_id
      t.date :raised_on
      t.integer :titles_cnt
      t.integer :copies_cnt
      t.string :status
      t.string :user

      t.timestamps
    end
  end

  def self.down
    drop_table :pos
  end
end
