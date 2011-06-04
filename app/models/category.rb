# == Schema Information
# Schema version: 20110603110110
#
# Table name: categories
#
#  id       :integer         not null, primary key
#  name     :string(100)
#  division :string(40)
#

class Category < ActiveRecord::Base
  has_many :titles
end
