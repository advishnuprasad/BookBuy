# == Schema Information
# Schema version: 20110711085056
#
# Table name: publishers
#
#  id         :integer(38)     not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  name       :string(1020)
#  country    :string(1020)
#

class Publisher < ActiveRecord::Base
  has_many :imprints
  
  has_many :supplierdiscounts
  has_many :suppliers, :through => :supplierdiscounts
end
