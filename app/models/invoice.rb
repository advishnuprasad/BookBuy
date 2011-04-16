# == Schema Information
# Schema version: 20110416133936
#
# Table name: invoices
#
#  id              :integer(38)     not null, primary key
#  invoice_no      :string(255)
#  po_id           :integer(38)
#  date_of_receipt :datetime
#  quantity        :integer(38)
#  amount          :decimal(, )
#  created_at      :datetime
#  updated_at      :datetime
#  boxes_cnt       :integer(38)
#

class Invoice < ActiveRecord::Base
  belongs_to :po
end
