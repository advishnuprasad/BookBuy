class DropPublishers < ActiveRecord::Migration
  def self.up
    drop_table :publishers
  end

  def self.down
  end
end
