# == Schema Information
# Schema version: 20110410134111
#
# Table name: new_store_inventories
#
#  branch_id   :integer(38)     not null
#  name        :string(298)
#  invoice_qty :decimal(, )
#  received    :decimal(, )
#  cataloged   :decimal(, )
#

class NewStoreInventory < ActiveRecord::Base
end
