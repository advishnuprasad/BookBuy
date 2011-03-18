class CreatePublisherxrefs < ActiveRecord::Migration
  def self.up
    create_table :publisherxrefs do |t|
      t.integer :isbnpublishercode
      t.references :publisher

      t.timestamps
    end
  end

  def self.down
    drop_table :publisherxrefs
  end
end
