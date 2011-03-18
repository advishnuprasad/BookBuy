# == Schema Information
# Schema version: 20110316070023
#
# Table name: worklists
#
#  id          :integer(38)     not null, primary key
#  description :string(255)
#  status      :string(255)
#  open_date   :datetime
#  close_date  :datetime
#  created_by  :string(255)
#  list_type   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Worklist < ActiveRecord::Base
  has_many :workitems
end
