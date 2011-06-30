class AddListIdToListStaging < ActiveRecord::Migration
  def self.up
    add_column :list_stagings, :list_id, :integer
  end

  def self.down
    remove_column :list_stagings, :list_id
  end
end
