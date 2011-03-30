# == Schema Information
# Schema version: 20110329115540
#
# Table name: workitems
#
#  id          :integer(38)     not null, primary key
#  worklist_id :integer(38)
#  item_type   :string(255)
#  ref_id      :integer(38)
#  status      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Workitem < ActiveRecord::Base
  belongs_to  :worklist
  belongs_to  :referenceitem, :foreign_key => "ref_id", :class_name => "Procurementitem"
end
