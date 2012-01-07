class AddIbtrToListitem < ActiveRecord::Migration
  def self.up
    add_column :listitems, :ibtr_id, :integer
    add_column :listitems, :card_id, :string
    add_column :listitems, :member_id, :integer
  end

  def self.down
    remove_column :listitems, :ibtr_id
    remove_column :listitems, :card_id
    remove_column :listitems, :member_id
  end
end
