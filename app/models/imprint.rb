# == Schema Information
# Schema version: 20110707073346
#
# Table name: imprints
#
#  id           :integer(38)     not null, primary key
#  code         :string(255)
#  name         :string(255)
#  created_at   :timestamp(6)
#  updated_at   :timestamp(6)
#  publisher_id :integer(38)
#

class Imprint < ActiveRecord::Base
  named_scope :with_names, :conditions => ["publishername IS NOT NULL"]
  
  belongs_to :publisher
  has_many :enrichedtitles
  
  scope :to_fill, where("publisher_id is NULL")
  scope :to_fill_in_procurement_det, lambda {|procurement_id|
      joins(:enrichedtitles => :procurementitems).
      where(:procurementitems => {:procurement_id => procurement_id}).
      where("publisher_id is NULL")
    }
  scope :to_fill_in_procurement, lambda {|procurement_id|
      where(:id => to_fill_in_procurement_det(procurement_id).collect {|imprint| imprint.id}.uniq)
    }
    
  def self.get_publisher_name(publisher_id)
    Publisher.find_by_publisher_id(publisher_id).name
  end
end
