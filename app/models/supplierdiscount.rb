# == Schema Information
# Schema version: 20110410134111
#
# Table name: supplierdiscounts
#
#  id           :integer(38)     not null, primary key
#  publisher_id :integer(38)
#  supplier_id  :integer(38)
#  discount     :integer(38)
#  created_at   :datetime
#  updated_at   :datetime
#  bulkdiscount :decimal(, )
#

class Supplierdiscount < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :supplier
end
