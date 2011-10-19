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
  CAPACITY = 100
  
  has_many :crates
  accepts_nested_attributes_for :crates
  
  scope :current_batch, where("id = (select max(id) from batches)")
  
  before_create :set_defaults
  
  validate :batch_size_with_capacity

  private
    def set_defaults
      self.completed_cnt ||= 0 
    end
    
    def batch_size_with_capacity
      self.total_cnt ||= 0
      crates.each  { |c| self.total_cnt += c.total_cnt } 
      errors.add(:id, "Batch Capacity exceeded") if total_cnt > Batch::CAPACITY
    end

end
