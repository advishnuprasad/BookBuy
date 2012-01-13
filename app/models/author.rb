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
  establish_connection "jbprod_#{RAILS_ENV}"
  set_table_name :authorprofile
  set_primary_key :authorid
  
  has_many :titles

  def name
    v = ' '
    v = v + self.firstname unless self.firstname.nil?
    v = v + ' ' + self.middlename unless self.middlename.nil?
    v = v + ' ' + self.lastname unless self.lastname.nil?
    v.squeeze.strip
  end
  
end
