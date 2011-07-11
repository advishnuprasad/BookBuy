# == Schema Information
# Schema version: 20110711085056
#
# Table name: suppliers
#
#  id             :integer(38)     not null, primary key
#  name           :string(100)
#  contact        :string(100)
#  phone          :string(100)
#  city           :string(100)
#  typeofshipping :integer(38)
#  discount       :integer(38)
#  creditperiod   :integer(38)
#  created_at     :datetime
#  updated_at     :datetime
#

class Supplier < ActiveRecord::Base
  attr_accessible :publisher_ids
  has_many :supplierdiscounts
  has_many :imprints, :through => :supplierdiscounts
  has_many :pos
  has_many :procurementitems
end
