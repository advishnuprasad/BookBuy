class AddPoIdToBookreceipts < ActiveRecord::Migration
  def self.up
    add_column :bookreceipts, :po_id, :integer
  end

  def self.down
    remove_column :bookreceipts, :po_id
  end
end
