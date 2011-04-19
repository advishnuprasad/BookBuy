# == Schema Information
# Schema version: 20110419010134
#
# Table name: procurementitems
#
#  id               :integer(38)     not null, primary key
#  source           :string(255)
#  source_id        :integer(38)
#  enrichedtitle_id :integer(38)
#  isbn             :string(255)
#  status           :string(255)
#  po_number        :string(255)
#  cancel_reason    :string(255)
#  deferred_by      :integer(38)
#  last_action_date :datetime
#  supplier_id      :integer(38)
#  expiry_date      :datetime
#  member_id        :integer(38)
#  card_id          :string(255)
#  branch_id        :integer(38)     not null
#  created_at       :datetime
#  updated_at       :datetime
#  quantity         :integer(38)
#  procured_cnt     :integer(38)
#

class Procurementitem < ActiveRecord::Base
  belongs_to :enrichedtitle
  belongs_to :supplier
  belongs_to :po, :foreign_key => "po_number", :primary_key => "po_number", :class_name => "Po"
  
  scope :mapped, joins(:enrichedtitle).where("enrichedtitles.title_id IS NOT NULL")
  scope :yet_to_order, where("po_number IS NULL")
  scope :to_be_procured, lambda { |isbn|
      where("isbn = :isbn AND procured_cnt < quantity AND po_number IS NOT NULL",:isbn => isbn).
      order("id").
      limit(1)
    }
    
  #Assumptions
  # Branch ID is the same
  def self.generatePOFromWorklist(worklist_id)
    worklist = Worklist.find(worklist_id)
    
    po = Po.new
    
    worklist.workitems.each do |item|
      po_items[item.supplier_id] = po_items[item.supplier_id].push(item.referenceitem.id)
    end
    
    worklist.each do |worklist|
    end
    
    #Loop through Hash items
    po_items.each do|supplier_id, items|
      #Create PO Master entry - Generate new PO Number
      
      po.number = Po.generatePONumber
      po.supplier_id = supplier_id
      #po.branch_id = <>
      po.raised_on = Time.now
      po.titles_cnt = items.count
      #po.copies_cnt = <>
      
      #Update PO Number for items in table
      Procurementitem.update_all({ :po_number => po.number },{ :id => po_items[supplier_id]})
      
      #Commit PO in Intermediate mode
      po.status = 'G'
      #po.user = <>
      unless po.save
        puts po.errors
      end
    end
  end
end
