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
end
