class AddListIdToListitems < ActiveRecord::Migration
  def self.up
    add_column :listitems, :list_id, :integer
  end

  def self.down
    remove_column :listitems, :list_id
  end
end
