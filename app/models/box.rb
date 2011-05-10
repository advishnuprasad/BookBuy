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
  
  scope :unassigned, where("crate_id IS NULL").order("id")
  scope :unassigned_among_pos, lambda { |po_nos|
    where(:po_no => po_nos).order("id")
    }
  scope :unassigned_in_po_and_invoice, lambda { |po_no, invoice_no|
    where("crate_id IS NULL AND po_no = ? and invoice_no = ?", po_no, invoice_no)
    }  
  scope :is_assigned, lambda { |crate_id|
    where("crate_id = :crate_id", :crate_id => crate_id)
    }
  
  def get_supplier_name
    Po.find_by_code(po_no).supplier.name
  end
  
  def self.fill_crate(crate_id)
    current_cnt = 0
    added_boxes = Array.new
    
    unassigned_boxes = Box.unassigned.unassigned_among_pos(Po.pos_for_supplier(Po.find_by_code(Box.unassigned.first.po_no).supplier_id).collect {|po| po.code})
    
    #More Intelligence
    #1. Get the Biggest boxes first
    #2. The first box might be lesser than capacity, but the next may be more than capacity
    
    #If first crate has more books than capacity
    if unassigned_boxes.first.total_cnt > Crate::CAPACITY
      box = unassigned_boxes.first
      current_cnt = current_cnt + box.total_cnt
      added_boxes.push(box)
    #else loop and fill crate
    else
      unassigned_boxes.each do |box|
        if current_cnt + box.total_cnt <= Crate::CAPACITY
          current_cnt = current_cnt + box.total_cnt
          added_boxes.push(box)
        end
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
