class CreatePublishersuppliermappings < ActiveRecord::Migration
  def self.up
    create_table :publishersuppliermappings do |t|
      t.references :publisher
      t.references :supplier
      t.integer :priority
      t.float :discount

      t.timestamps
    end
  end

  def self.down
    drop_table :publishersuppliermappings
  end
end
