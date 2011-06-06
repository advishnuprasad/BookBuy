class AddStatusToProcurement < ActiveRecord::Migration
  def self.up
    add_column :procurements, :status, :string
  end

  def self.down
    remove_column :procurements, :status
  end
end
