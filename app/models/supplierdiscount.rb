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
  
  scope :to_fill, where("discount is NULL or bulkdiscount is NULL")
  scope :to_fill_in_procurement_det, lambda {|procurement_id|
      joins([:supplier => {:procurementitems => :procurement}], [:publisher => {:enrichedtitles => {:procurementitems => :procurement}}]).
      where(:procurements => {:id => procurement_id}).
      where("supplierdiscounts.discount IS NULL OR supplierdiscounts.bulkdiscount IS NULL")
    }
  scope :to_fill_in_procurement, lambda {|procurement_id|
      where(:id => to_fill_in_procurement_det(procurement_id).collect {|discount| discount.id}.uniq)
    }
end
