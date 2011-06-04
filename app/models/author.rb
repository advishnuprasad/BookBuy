# == Schema Information
# Schema version: 20110603110110
#
# Table name: authors
#
#  id         :integer(10)     primary key
#  name       :string(357)
#  firstname  :string(255)
#  middlename :string(50)
#  lastname   :string(50)
#

class Author < ActiveRecord::Base
  has_many :titles
end
