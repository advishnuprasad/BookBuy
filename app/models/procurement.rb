# == Schema Information
# Schema version: 20110602060441
#
# Table name: procurements
#
#  id           :integer(38)     not null, primary key
#  source_id    :integer(38)
#  description  :string(255)
#  requests_cnt :integer(38)
#  created_by   :integer(38)
#  modified_by  :integer(38)
#  created_at   :datetime
#  updated_at   :datetime
#

class Procurement < ActiveRecord::Base
  has_many :procurementitems
  has_many :worklists
  
  def refresh_worklists
    plsql.worklist_generator.regenerate_ibtr_wl(id)
  end
  
  def generate_pos
    plsql.generate_pos(id, description)
  end
  
  private
    def self.pending_ibtr_items_exist
      cnt = plsql.data_pull.get_ibtr_items_count
      return cnt      
    end
    
    def self.pull_ibtr_items
      #Create New Procurement Entity
      procurement = Procurement.new
      procurement.source_id = 1
      procurement.description = 'IBTR'
      #TODO - Fill Requests Count
      if procurement.save
        #Pull Items
        cnt = plsql.data_pull.pull_ibtr_items(procurement.id)
        
        procurement.requests_cnt = cnt
        procurement.save
      end
      
      #Scan ISBNs
      Enrichedtitle.scan  
      
      #Create initial Worklists
      plsql.worklist_generator.generate_ibtr_wl(procurement.id)
      
      return procurement.id
    end
end
