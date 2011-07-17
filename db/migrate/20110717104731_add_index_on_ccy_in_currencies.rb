class AddIndexOnCcyInCurrencies < ActiveRecord::Migration
  def self.up
    add_index :currencies, :code, {:unique => true}
  end

  def self.down
  end
end
