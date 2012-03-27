class DropAddlnColumnsInTitleBranches < ActiveRecord::Migration
  def self.up
    remove_column :titlebranches, :times_rented
    remove_column :titlebranches, :total_cnt
    remove_column :titlebranches, :available_cnt
  end

  def self.down
    add_column :titlebranches, :times_rented, :integer
    add_column :titlebranches, :total_cnt, :integer
    add_column :titlebranches, :available_cnt, :integer
  end
end
