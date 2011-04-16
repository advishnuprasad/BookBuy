class RemoveBookNumberFromProcurementitems < ActiveRecord::Migration
  def self.up
    remove_column :procurementitems, :book_number
  end

  def self.down
  end
end
