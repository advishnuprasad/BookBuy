# == Schema Information
# Schema version: 20110630101137
#
# Table name: list_stagings
#
#  id           :integer(38)     not null, primary key
#  isbn         :string(255)
#  title        :string(255)
#  author       :string(255)
#  publisher    :string(255)
#  publisher_id :string(255)
#  quantity     :integer(38)
#  listprice    :decimal(, )
#  currency     :string(255)
#  category     :string(255)
#  subcategory  :string(255)
#  branch_id    :integer(38)
#  error        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  list_id      :integer(38)
#  created_by   :integer(38)
#

class ListStaging < ActiveRecord::Base
  belongs_to  :list
  
  before_save :set_error
  
  scope :in_error, where("error IS NOT NULL")
  
  private
    def set_error
      error = ""
      if quantity.nil? or quantity.blank? or quantity < 0 or quantity > 500
        error += 'invalid quantity;'
      end
      
      if isbn.include?('+') or isbn.include?('.') or isbn.nil? or isbn.blank?
        error += 'invalid isbn;'
      end
      
      if title.nil? or title.blank?
        error += 'invalid title;'
      end
      
      if author.include?('+') or author.nil? or author.blank?
        error += 'invalid author;'
      end
      
      if publisher.include?('+') or publisher.nil? or publisher.blank?
        error += 'invalid publisher;'
      end
      
      if currency.nil? or currency.blank?
        error += 'invalid currency;'
      end
      
      if listprice.nil? or listprice.blank? or listprice == 0
        error += 'incorrect listprice;'
      end
      
      self.error = error
    end
end
