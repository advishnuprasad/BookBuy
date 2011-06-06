class AddCurrencyToPos < ActiveRecord::Migration
  def self.up
    add_column :pos, :currency, :string
  end

  def self.down
    remove_column :pos, :currency
  end
end
