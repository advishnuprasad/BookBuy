# == Schema Information
# Schema version: 20110617100008
#
# Table name: worklists
#
#  id             :integer(38)     not null, primary key
#  description    :string(255)
#  status         :string(255)
#  open_date      :timestamp(6)
#  close_date     :timestamp(6)
#  created_by     :string(255)
#  list_type      :string(255)
#  created_at     :timestamp(6)
#  updated_at     :timestamp(6)
#  procurement_id :integer(38)
#

class Worklist < ActiveRecord::Base
  has_many :workitems
  belongs_to :procurement
  
  scope :open, where(:status => 'Open')
end
