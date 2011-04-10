# == Schema Information
# Schema version: 20110409014925
#
# Table name: pos
#
#  id          :integer(38)     not null, primary key
#  number      :string(255)
#  supplier_id :integer(38)
#  branch_id   :integer(38)
#  raised_on   :datetime
#  titles_cnt  :integer(38)
#  copies_cnt  :integer(38)
#  status      :string(255)
#  user        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  discount    :decimal(, )
#

class Po < ActiveRecord::Base
end
