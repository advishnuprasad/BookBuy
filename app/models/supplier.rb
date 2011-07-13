# == Schema Information
# Schema version: 20110713050822
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
#  email          :string(255)
#

class Supplier < ActiveRecord::Base
  attr_accessible :name, :contact, :phone, :city, :typeofshipping, :discount, :creditperiod, :email
  
  has_many :supplierdiscounts
  has_many :imprints, :through => :supplierdiscounts
  has_many :pos
  has_many :procurementitems
  
  validates :name,                :presence => true
  validates :discount,            :presence => true
  validates :creditperiod,        :presence => true
  validates :contact,             :presence => true
  validates :phone,               :presence => true
  validates :city,                :presence => true
  
  validates :email,               :email => true
end
