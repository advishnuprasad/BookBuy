# == Schema Information
# Schema version: 20110329115540
#
# Table name: supplierdiscounts
#
#  id           :integer(38)     not null, primary key
#  publisher_id :integer(38)
#  supplier_id  :integer(38)
#  discount     :decimal(, )
#  created_at   :datetime
#  updated_at   :datetime
#

class Supplierdiscount < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :supplier
end
