# == Schema Information
# Schema version: 20110316070023
#
# Table name: suppliers
#
#  id           :integer         not null, primary key
#  name         :string(100)
#  contact      :string(100)
#  phone        :string(100)
#  city         :string(100)
#  type         :decimal(, )
#  discount     :decimal(, )
#  creditperiod :decimal(, )
#

class Supplier < ActiveRecord::Base
  has_many :supplierdiscounts
  has_many :publishers, :through => :supplierdiscounts
end
