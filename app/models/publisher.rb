# == Schema Information
# Schema version: 20110410134111
#
# Table name: publishers
#
#  id            :integer(38)     not null, primary key
#  code          :string(255)
#  imprintname   :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  group_id      :integer(38)
#  publishername :string(255)
#

class Publisher < ActiveRecord::Base
  named_scope :with_names, :conditions => ["publishername IS NOT NULL"]
  
  has_many :supplierdiscounts
  has_many :suppliers, :through => :supplierdiscounts
  
  scope :to_fill, where("group_id is NULL or publishername is NULL")
end
