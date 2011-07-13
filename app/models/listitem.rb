# == Schema Information
# Schema version: 20110713050822
#
# Table name: listitems
#
#  id           :integer(38)     not null, primary key
#  isbn         :string(255)
#  title        :string(255)
#  author       :string(255)
#  publisher    :string(255)
#  publisher_id :integer(38)
#  quantity     :integer(38)
#  listprice    :decimal(, )
#  currency     :string(255)
#  category     :string(255)
#  subcategory  :string(255)
#  branch_id    :integer(38)
#  created_by   :integer(38)
#  modified_by  :integer(38)
#  created_at   :timestamp(6)
#  updated_at   :timestamp(6)
#  error        :string(255)
#  pulled       :string(255)
#  list_id      :integer(38)
#

class Listitem < ActiveRecord::Base
  belongs_to :list
  
  validates :list_id, :presence => true
  validates :isbn, :presence => true
  validates :title, :presence => true
  validates :author, :presence => true
  validates :publisher, :presence => true
  validates :quantity, :presence => true
  validates :listprice, :presence => true
  validates :currency, :presence => true
end
