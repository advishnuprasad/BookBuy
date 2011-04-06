class CreatePublishers < ActiveRecord::Migration
  def self.up
    create_table :publishers do |t|
      t.integer :code
      t.string :name

      t.timestamps
    end
    
    add_index :publishers, :code, {:unique => true}
  end

  def self.down
    drop_table :publishers
  end
end
