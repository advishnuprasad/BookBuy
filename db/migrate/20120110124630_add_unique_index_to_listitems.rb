class AddUniqueIndexToListitems < ActiveRecord::Migration
  def self.up
    add_index :listitems, :ibtr_id, {:name => "in_listitems_ibtr_id", :unique => true}
  end

  def self.down
    remove_index :listitems, :name => "in_listitems_ibtr_id"
  end
end
