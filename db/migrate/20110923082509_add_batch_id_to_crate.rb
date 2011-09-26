class AddBatchIdToCrate < ActiveRecord::Migration
  def self.up
    add_column :crates, :batch_id, :integer
  end

  def self.down
    remove_column :crates, :batch_id
  end
end
