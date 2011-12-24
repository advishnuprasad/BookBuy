class AddProcurementItemsToEnrichedtitles < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitles, :procurementitems_count, :integer, :default => 0
    
    Enrichedtitle.reset_column_information
    Enrichedtitle.find(:all).each do |e|
      Enrichedtitle.update_counters e.id, :procurementitems_count => e.procurementitems.length unless e.procurementitems.nil?
    end
  end

  def self.down
    remove_column :enrichedtitles, :procurementitems_count
  end
end
