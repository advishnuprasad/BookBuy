class AddCrateIdToBookreceipts < ActiveRecord::Migration
  def self.up
    add_column :bookreceipts, :crate_id, :integer
  end

  def self.down
    remove_column :bookreceipts, :crate_id
  end
end
