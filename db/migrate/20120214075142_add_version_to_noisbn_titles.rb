class AddVersionToNoisbnTitles < ActiveRecord::Migration
  def self.up
    Noisbntitle.create_versioned_table
  end

  def self.down
    Noisbntitle.drop_versioned_table
  end
end
