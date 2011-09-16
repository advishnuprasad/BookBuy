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
  belongs_to :list
  
  validates :list_id, :presence => true
  validates :isbn, :presence => true
  validates :title, :presence => true
  validates :author, :presence => true
  validates :publisher, :presence => true
  validates :quantity, :presence => true
  validates :listprice, :presence => true
  validates :currency, :presence => true
  
  validate :list_is_valid_and_present
  
  private
    def list_is_valid_and_present
      begin
        list = List.find(list_id)
      rescue ActiveRecord::RecordNotFound
        errors.add(:list_id, " does not exist!")
      end
    end
end
