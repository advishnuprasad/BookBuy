class AddIsbnverifiedToEnrichedtitles < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitles, :isbnverified, :string
  end

  def self.down
    remove_column :enrichedtitles, :isbnverified
  end
end
