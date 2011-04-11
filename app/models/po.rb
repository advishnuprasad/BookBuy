# == Schema Information
# Schema version: 20110409014925
#
# Table name: pos
#
#  id          :integer(38)     not null, primary key
#  number      :string(255)
#  supplier_id :integer(38)
#  branch_id   :integer(38)
#  raised_on   :datetime
#  titles_cnt  :integer(38)
#  copies_cnt  :integer(38)
#  status      :string(255)
#  user        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  discount    :decimal(, )
#

class Po < ActiveRecord::Base
  belongs_to :supplier
  has_many :procurementitems, :inverse_of => "po"
  
  #Type Codes
    #New Branch
    #Member IBT
    #Branch IBT
    
  def initialize(type)
    #Initialization should fix the new PO Number
  end
  
  def self.generatePONumber
    #Fix unique type codes for different kinds of POs as Constants
    #Format can be <Code>-<YYYYMMDDMM>-<NNNN>
  end
end
