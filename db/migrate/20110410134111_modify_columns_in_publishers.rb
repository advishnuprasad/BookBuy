class ModifyColumnsInPublishers < ActiveRecord::Migration
  def self.up
    rename_column   :publishers, :name, :imprintname
    add_column      :publishers, :publishername, :string
  end

  def self.down
  end
end
