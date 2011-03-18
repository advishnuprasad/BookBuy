# == Schema Information
# Schema version: 20110316070023
#
# Table name: procurementitems
#
#  id               :integer(38)     not null, primary key
#  source           :string(255)
#  source_id        :integer(38)
#  enrichedtitle_id :integer(38)
#  isbn             :string(255)
#  status           :string(255)
#  po_number        :string(255)
#  book_number      :string(255)
#  cancel_reason    :string(255)
#  deferred_by      :integer(38)
#  last_action_date :datetime
#  supplier_id      :integer(38)
#  avl_status       :string(255)
#  avl_quantity     :integer(38)
#  expiry_date      :datetime
#  member_id        :integer(38)
#  card_id          :string(255)
#  branch_id        :integer(38)
#  created_at       :datetime
#  updated_at       :datetime
#

class Procurementitem < ActiveRecord::Base
  belongs_to :enrichedtitle
  belongs_to :supplier
end
