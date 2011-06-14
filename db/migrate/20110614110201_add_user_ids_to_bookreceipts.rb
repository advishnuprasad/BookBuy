class AddUserIdsToBookreceipts < ActiveRecord::Migration
  def self.up
    add_column :bookreceipts, :created_by, :integer
    add_column :bookreceipts, :modified_by, :integer
  end

  def self.down
    remove_column :bookreceipts, :modified_by
    remove_column :bookreceipts, :created_by
  end
end
