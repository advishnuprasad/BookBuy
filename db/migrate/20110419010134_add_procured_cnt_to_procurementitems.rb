class AddProcuredCntToProcurementitems < ActiveRecord::Migration
  def self.up
    add_column :procurementitems, :procured_cnt, :integer
  end

  def self.down
    remove_column :procurementitems, :procured_cnt
  end
end
