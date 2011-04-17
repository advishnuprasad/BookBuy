# == Schema Information
# Schema version: 20110417061158
#
# Table name: crates
#
#  id         :integer(38)     not null, primary key
#  po_no      :string(255)
#  invoice_no :string(255)
#  total_cnt  :integer(38)
#  created_at :datetime
#  updated_at :datetime
#

class Crate < ActiveRecord::Base
  CAPACITY    = 100;
  
  has_many :boxes
  
  def self.fill_crates
    #Find boxes which have not been assigned
    boxes = Box.unassigned
    
    #Find total count of books in un-assigned boxes by PO-Invoice
    boxes.each do |box|
    end
    
    #Create entries for Crate and update crate_id in Boxes
  end
end
