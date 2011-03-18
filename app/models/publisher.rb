# == Schema Information
# Schema version: 20110316070023
#
# Table name: publishers
#
#  id      :integer         not null, primary key
#  name    :string(100)
#  country :string(100)
#

class Publisher < ActiveRecord::Base
  has_many :publishersuppliermappings
  has_many :suppliers, :through => :publishersuppliermappings
end
