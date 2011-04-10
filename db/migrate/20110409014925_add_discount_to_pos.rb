class AddDiscountToPos < ActiveRecord::Migration
  def self.up
    add_column :pos, :discount, :float
  end

  def self.down
    remove_column :pos, :discount
  end
end
