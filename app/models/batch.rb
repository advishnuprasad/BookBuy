# == Schema Information
# Schema version: 20110923082509
#
# Table name: batches
#
#  id            :integer(38)     not null, primary key
#  total_cnt     :integer(38)     not null
#  completed_cnt :integer(38)     not null
#  created_at    :timestamp(6)
#  updated_at    :timestamp(6)
#

class Batch < ActiveRecord::Base
  CAPACITY = 2000
  
  has_many :crates
  
  scope :current_batch, where("id = (select max(id) from batches)")
  
  before_save :set_defaults
  
  def has_capacity
    total_cnt < (Batch::CAPACITY)
  end
  
  private
    def set_defaults
      self.total_cnt = 0 if total_cnt.nil?
      self.completed_cnt = 0 if completed_cnt.nil?
    end
end
