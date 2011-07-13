class AddEmailToSuppliers < ActiveRecord::Migration
  def self.up
    add_column :suppliers, :email, :string
  end

  def self.down
    remove_column :suppliers, :email
  end
end
