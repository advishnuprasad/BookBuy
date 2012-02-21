class CreateMatchingtitles < ActiveRecord::Migration
  def self.up
    create_table :matchingtitles do |t|
      t.references    :enrichedtitle
      t.references    :title
      t.string        :status, :limit => 10
      t.integer       :updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :matchingtitles
  end
end
