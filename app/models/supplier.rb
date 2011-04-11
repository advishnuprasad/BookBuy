# == Schema Information
# Schema version: 20110330092840
#
# Table name: suppliers
#
#  id             :integer         not null, primary key
#  name           :string(100)
#  contact        :string(100)
#  phone          :string(100)
#  city           :string(100)
#  typeofshipping :decimal(, )
#  discount       :decimal(, )
#  creditperiod   :decimal(, )
#

class Supplier < ActiveRecord::Base
  attr_accessible :publisher_ids
  has_many :supplierdiscounts
  has_many :publishers, :through => :supplierdiscounts
  has_many :pos
end
