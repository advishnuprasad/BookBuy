# == Schema Information
# Schema version: 20110717102531
#
# Table name: currencies
#
#  id          :integer(38)     not null, primary key
#  name        :string(255)
#  code        :string(255)
#  created_by  :integer(38)
#  modified_by :integer(38)
#  created_at  :datetime
#  updated_at  :datetime
#

class Currency < ActiveRecord::Base
  belongs_to :created_by_user, :foreign_key => "created_by", :class_name => "User"
  belongs_to :modified_by_user, :foreign_key => "modified_by", :class_name => "User"
  
  validates :name,              :presence => true
  validates :code,              :presence => true, :length => { :is => 3 }
  
  before_save :set_defaults
  
  private
    def set_defaults
      self.code = code.upcase
    end
end
