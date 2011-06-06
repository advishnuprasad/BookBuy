class AddAvailabilityToProcurementitems < ActiveRecord::Migration
  def self.up
    add_column :procurementitems, :availability, :string
  end

  def self.down
    remove_column :procurementitems, :availability
  end
end
