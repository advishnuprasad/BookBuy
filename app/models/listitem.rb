# == Schema Information
# Schema version: 20110410134111
#
# Table name: listitems
#
#  id           :integer(38)     not null, primary key
#  isbn         :string(255)     not null
#  title        :string(255)     not null
#  author       :string(255)
#  publisher    :string(255)     not null
#  publisher_id :integer(38)     not null
#  quantity     :integer(38)
#  listprice    :decimal(, )     not null
#  currency     :string(255)     not null
#  category     :string(255)
#  subcategory  :string(255)
#  branch_id    :integer(38)
#  created_by   :integer(38)
#  modified_by  :integer(38)
#  created_at   :timestamp(6)
#  updated_at   :timestamp(6)
#  error        :string(255)
#  pulled       :string(255)
#  list_id      :integer(38)     not null
#

class Listitem < ActiveRecord::Base
  belongs_to :list, :inverse_of => :listitems
  validates_presence_of :list
  
  validates :isbn, :presence => true
  validates :title, :presence => true
  validates :author, :presence => true
  validates :publisher, :presence => true
  validates :quantity, :presence => true
  validates :listprice, :presence => true
  validates :currency, :presence => true

  attr_accessible :isbn, :quantity, :branch_id, :ibtr_id, :member_id, :card_id
  attr_accessor :ready_to_order
  
end
