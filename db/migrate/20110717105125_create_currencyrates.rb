class CreateCurrencyrates < ActiveRecord::Migration
  def self.up
    create_table :currencyrates do |t|
      t.string :code1
      t.string :code2
      t.float :rate
      t.date :effective_from
      t.integer :created_by
      t.integer :modified_by

      t.timestamps
    end
  end

  def self.down
    drop_table :currencyrates
  end
end
