class RenamePublishercodeToPublisherIdInListStagings < ActiveRecord::Migration
  def self.up
    rename_column :list_stagings, :publishercode, :publisher_id
  end

  def self.down
  end
end
