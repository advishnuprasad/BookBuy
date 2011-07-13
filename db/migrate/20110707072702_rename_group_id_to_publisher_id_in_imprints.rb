class RenameGroupIdToPublisherIdInImprints < ActiveRecord::Migration
  def self.up
    rename_column :imprints, :group_id, :publisher_id
  end

  def self.down
  end
end
