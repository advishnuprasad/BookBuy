# == Schema Information
# Schema version: 20110602060441
#
# Table name: procurements
#
#  id           :integer(38)     not null, primary key
#  source_id    :integer(38)
#  description  :string(255)
#  requests_cnt :integer(38)
#  created_by   :integer(38)
#  modified_by  :integer(38)
#  created_at   :datetime
#  updated_at   :datetime
#

class Procurement < ActiveRecord::Base
end
