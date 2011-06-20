# == Schema Information
# Schema version: 20110617100008
#
# Table name: publishers
#
#  id            :integer(38)     not null, primary key
#  code          :string(255)
#  imprintname   :string(255)
#  created_at    :timestamp(6)
#  updated_at    :timestamp(6)
#  group_id      :integer(38)
#  publishername :string(255)
#

class Publisher < ActiveRecord::Base
  named_scope :with_names, :conditions => ["publishername IS NOT NULL"]
  
  has_many :enrichedtitles
  has_many :supplierdiscounts
  has_many :suppliers, :through => :supplierdiscounts
  
  scope :to_fill, where("group_id is NULL or publishername is NULL")
  scope :to_fill_in_procurement, lambda {|procurement_id|
      joins(:enrichedtitles => :procurementitems).
      where(:procurementitems => {:procurement_id => procurement_id}).
      where("group_id is NULL or publishername is NULL")
    }
    
  def self.get_publisher_name(group_id)
    Publisher.find_by_group_id(group_id).publishername
  end
end
