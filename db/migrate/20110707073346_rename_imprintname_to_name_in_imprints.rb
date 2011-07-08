class RenameImprintnameToNameInImprints < ActiveRecord::Migration
  def self.up
    rename_column :imprints, :imprintname, :name
  end

  def self.down
  end
end
