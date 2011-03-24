class RemovePriorityFromPublishersuppliermapping < ActiveRecord::Migration
  def self.up
    remove_column :publishersuppliermappings, :priority
  end

  def self.down
    add_column :publishersuppliermappings, :priority, :integer
  end
end
