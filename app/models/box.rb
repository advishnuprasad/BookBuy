# == Schema Information
# Schema version: 20110410134111
#
# Table name: boxes
#
#  id         :integer(38)     not null, primary key
#  box_no     :integer(38)     not null
#  po_no      :string(255)     not null
#  invoice_no :string(255)     not null
#  total_cnt  :integer(38)
#  created_at :timestamp(6)
#  updated_at :timestamp(6)
#  crate_id   :integer(38)
#

class Box < ActiveRecord::Base

  attr_accessible :box_no, :po_no, :invoice_no, :invoice_id
  
  validates :invoice_no,    :presence => true
  validates :po_no,         :presence => true
  validates :box_no,        :presence => true, :numericality => { :greater_than => 0, :only_integer => true }
  
  belongs_to :invoice

  before_create :set_defaults
  
  def get_supplier_name
    Po.find_by_code(po_no).supplier.name
  end
  
  private
    def set_defaults
      self.total_cnt = 0      
    end

end
