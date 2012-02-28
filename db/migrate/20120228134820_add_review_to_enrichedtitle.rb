class AddReviewToEnrichedtitle < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitles, :review_file_name, :string
    add_column :enrichedtitle_versions, :review_file_name, :string
  end

  def self.down
    remove_column :enrichedtitles, :review_file_name
    remove_column :enrichedtitle_versions, :review_file_name
  end
end
