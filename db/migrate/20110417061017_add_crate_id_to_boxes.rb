class AddCrateIdToBoxes < ActiveRecord::Migration
  def self.up
    add_column :boxes, :crate_id, :integer
  end

  def self.down
    remove_colulmn :boxes, :crate_id
  end
end
