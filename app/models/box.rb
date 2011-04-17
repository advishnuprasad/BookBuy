# == Schema Information
# Schema version: 20110417061158
#
# Table name: boxes
#
#  id         :integer(38)     not null, primary key
#  box_no     :integer(38)
#  po_no      :string(255)
#  invoice_no :string(255)
#  total_cnt  :integer(38)
#  created_at :datetime
#  updated_at :datetime
#  crate_id   :integer(38)
#

class Box < ActiveRecord::Base
  belongs_to :crate
  
  scope :unassigned, where("crate_id IS NULL")
  
  scope :unassigned_in_po_and_invoice, lambda { |po_no, invoice_no|
    where("crate_id IS NULL AND po_no = ? and invoice_no = ?", po_no, invoice_no)
  }
  
  def self.fill_crates(po_no, invoice_no, crate_id)
    current_cnt = 0
    added_boxes = Array.new
    
    #Find total count of books in un-assigned boxes by PO-Invoice
    Box.unassigned_in_po_and_invoice(po_no, invoice_no).each do |box|
      if current_cnt + box.total_cnt < Crate::CAPACITY
        current_cnt = current_cnt + box.total_cnt
        added_boxes.push(box)
      end
    end
    
    #Create entries for Crate and update crate_id in Boxes
    if current_cnt > 0
      #Assign box to crate
      added_boxes.each do |added_box|
        added_box.crate_id = crate_id
        added_box.save
      end
      
      #Update Crate with Total Items
      crate = Crate.find(crate_id)
      crate.total_cnt = current_cnt
      crate.save
    end
  end
end
