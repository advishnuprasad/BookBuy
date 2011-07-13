class AddCreatedByToListStaging < ActiveRecord::Migration
  def self.up
    add_column :list_stagings, :created_by, :integer
  end

  def self.down
    remove_column :list_stagings, :created_by
  end
end
