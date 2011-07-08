class DropPublishernameFromImprints < ActiveRecord::Migration
  def self.up
    remove_column :imprints, :publishername
  end

  def self.down
  end
end
