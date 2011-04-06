class ChangePublisherCodeToString < ActiveRecord::Migration
  def self.up
    change_column :publishers, :code, :string
  end

  def self.down
  end
end
