# == Schema Information
# Schema version: 20110719064359
#
# Table name: distributions
#
#  id                 :integer(38)     not null, primary key
#  procurementitem_id :integer(38)
#  branch_id          :integer(38)
#  quantity           :integer(38)
#  procured_cnt       :integer(38)
#  created_by         :integer(38)
#  modified_by        :integer(38)
#  created_at         :datetime
#  updated_at         :datetime
#

class Distribution < ActiveRecord::Base
  belongs_to :procurementitem
  belongs_to :branch
  
  belongs_to :created_by_user, :foreign_key => "created_by", :class_name => "User"
  belongs_to :modified_by_user, :foreign_key => "modified_by", :class_name => "User"
  
  validates :procurementitem_id,      :presence => true
  validates :branch_id,               :presence => true
  validates :quantity,                :presence => true
  
  scope :of_item, lambda {|procurementitem_id|
      where(:procurementitem_id => procurementitem_id)
    }
end
