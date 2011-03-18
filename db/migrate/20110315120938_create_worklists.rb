class CreateWorklists < ActiveRecord::Migration
  def self.up
    create_table :worklists do |t|
      t.string :description
      t.string :status
      t.date :open_date
      t.date :close_date
      t.string :created_by
      t.string :list_type

      t.timestamps
    end
  end

  def self.down
    drop_table :worklists
  end
end
