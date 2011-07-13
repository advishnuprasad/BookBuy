class AddDatesToSuppliers < ActiveRecord::Migration
  def self.up
    add_column :suppliers, :created_at, :date
    add_column :suppliers, :updated_at, :date
  end

  def self.down
    remove_column :suppliers, :updated_at
    remove_column :suppliers, :created_at
  end
end
