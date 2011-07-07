# == Schema Information
# Schema version: 20110617100008
#
# Table name: workitems
#
#  id          :integer(38)     not null, primary key
#  worklist_id :integer(38)
#  item_type   :string(255)
#  ref_id      :integer(38)
#  status      :string(255)
#  created_at  :timestamp(6)
#  updated_at  :timestamp(6)
#

class Workitem < ActiveRecord::Base
  belongs_to  :worklist
  belongs_to  :referenceitem, :foreign_key => "ref_id", :class_name => "Procurementitem"
  
  scope :of_publisher, lambda { |publisher|
      joins([:referenceitem => {:procurementitems => :procurement}])
    }
end
