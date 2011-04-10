class AddGroupIdToPublishers < ActiveRecord::Migration
  def self.up
    add_column :publishers, :group_id, :integer
  end

  def self.down
    remove_column :publishers, :group_id
  end
end
