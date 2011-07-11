# == Schema Information
# Schema version: 20110617100008
#
# Table name: procurements
#
#  id           :integer(38)     not null, primary key
#  source_id    :integer(38)
#  description  :string(255)
#  requests_cnt :integer(38)
#  created_by   :integer(38)
#  modified_by  :integer(38)
#  created_at   :timestamp(6)
#  updated_at   :timestamp(6)
#  status       :string(255)
#

require 'zip/zip'
require 'zip/zipfilesystem'

class Procurement < ActiveRecord::Base
  has_many :procurementitems
  has_many :worklists
  has_many :pos
  belongs_to :created_by_user, :foreign_key => "created_by", :class_name => "User"
  belongs_to :modified_by_user, :foreign_key => "modified_by", :class_name => "User"
  
  def refresh_worklists
    if description == 'IBTR'
      plsql.worklist_generator.regenerate_ibtr_wl(id)
    elsif description == 'NSTR'
      plsql.worklist_generator.regenerate_nstr_wl(id)
    elsif description == 'NENT'
      plsql.worklist_generator.regenerate_nent_wl(id)
    elsif description == 'WHSE'
      plsql.worklist_generator.regenerate_whse_wl(id)
    end
  end
  
  def generate_pos
    plsql.po_generator.generate(id, description)
  end
  
  def pending_imprint_updates_cnt
    #procurementitems.joins(:enrichedtitle => :imprint).where(:imprints => {:group_id => nil}).count
    Imprint.to_fill_in_procurement(id).count
  end
  
  def pending_supplier_updates_cnt
    procurementitems.where('supplier_id is NULL').count
  end
  
  def pending_discount_updates_cnt
    #procurementitems.joins([:enrichedtitle => {:imprint => :supplierdiscounts}], :supplier).where("supplierdiscounts.bulkdiscount is NULL OR supplierdiscounts.discount is NULL").count
    Supplierdiscount.to_fill_in_procurement(id).count
  end
  
  def items_ready_to_order_cnt
    procurementitems.to_order_in_procurement(id).count
  end
  
  def download
    if pos.count > 0
      t = Tempfile.new(id.to_s + "-#{Time.now}")
      Zip::ZipOutputStream.open(t.path) do |z|
        pos.each do |po|
          gen_file = plsql.po_generator.extract(po.code)
          z.put_next_entry(gen_file)
          z.write IO.read(Paths::PO_FILE_PATH + gen_file)
        end
      end
      temppathstr = t.path
      t.close
      return temppathstr
    end    
  end
  
  def self.pending_ibtr_items_exist
    cnt = plsql.data_pull.get_ibtr_items_count
    return cnt      
  end
  
  def self.pull_ibtr_items
    #Create New Procurement Entity
    procurement = Procurement.new
    procurement.source_id = 1
    procurement.description = 'IBTR'
    procurement.status = 'Open'
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
  
  def self.pull_nent_items(list_id)
    #Create New Procurement Entity
    procurement = Procurement.new
    procurement.source_id = list_id
    procurement.description = 'NENT'
    procurement.status = 'Open'
    if procurement.save
      #Pull Items
      cnt = plsql.data_pull.pull_nent_items(procurement.id, list_id)
      
      procurement.requests_cnt = cnt
      procurement.save
    end
    
    #Scan ISBNs
    Enrichedtitle.scan
    
    #Create initial Worklists
    plsql.worklist_generator.generate_nent_wl(procurement.id)
    
    return procurement.id
  end
  
  def self.pull_nstr_items(list_id)
    #Create New Procurement Entity
    procurement = Procurement.new
    procurement.source_id = list_id
    procurement.description = 'NSTR'
    procurement.status = 'Open'
    if procurement.save
      #Pull Items
      cnt = plsql.data_pull.pull_nstr_items(procurement.id, list_id)
      
      procurement.requests_cnt = cnt
      procurement.save
    end
    
    #Scan ISBNs
    Enrichedtitle.scan
    
    #Create initial Worklists
    plsql.worklist_generator.generate_nstr_wl(procurement.id)
    
    return procurement.id
  end
  
  def self.pull_whse_items(list_id)
    #Create New Procurement Entity
    procurement = Procurement.new
    procurement.source_id = list_id
    procurement.description = 'WHSE'
    procurement.status = 'Open'
    if procurement.save
      #Pull Items
      cnt = plsql.data_pull.pull_whse_items(procurement.id, list_id)
      
      procurement.requests_cnt = cnt
      procurement.save
    end
    
    #Scan ISBNs
    Enrichedtitle.scan
    
    #Create initial Worklists
    plsql.worklist_generator.generate_whse_wl(procurement.id)
    
    return procurement.id
  end
end
