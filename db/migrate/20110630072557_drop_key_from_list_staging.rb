class DropKeyFromListStaging < ActiveRecord::Migration
  def self.up
    remove_column :list_stagings, :key
  end

  def self.down
    add_column :list_stagings, :key, :integer
  end
end
