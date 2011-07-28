class AddKindToProcurements < ActiveRecord::Migration
  def self.up
    add_column :procurements, :kind, :string
  end

  def self.down
    remove_column :procurements, :kind
  end
end
