class AddTitleIdToProcurementitems < ActiveRecord::Migration
  def self.up
    add_column :procurementitems, :title_id, :integer
  end

  def self.down
    remove_column :procurementitems, :title_id
  end
end
