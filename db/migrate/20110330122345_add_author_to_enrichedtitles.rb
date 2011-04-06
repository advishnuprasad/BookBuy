class AddAuthorToEnrichedtitles < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitles, :author, :string
  end

  def self.down
    remove_column :enrichedtitles, :author
  end
end
