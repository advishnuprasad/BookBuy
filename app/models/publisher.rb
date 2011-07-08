# == Schema Information
# Schema version: 20110707072351
#
# Table name: publishers
#
#  id         :integer(38)     not null, primary key
#  name       :string(255)
#  country    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Publisher < ActiveRecord::Base
  has_many :imprints
  
  has_many :supplierdiscounts
  has_many :suppliers, :through => :supplierdiscounts
end
