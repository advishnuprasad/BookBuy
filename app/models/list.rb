# == Schema Information
# Schema version: 20110630070511
#
# Table name: lists
#
#  id          :integer(38)     not null, primary key
#  name        :string(255)
#  kind        :string(255)
#  key         :integer(38)
#  pulled      :string(255)
#  created_by  :integer(38)
#  modified_by :integer(38)
#  created_at  :datetime
#  updated_at  :datetime
#

class List < ActiveRecord::Base
  has_many :listitems
  has_many :list_stagings
  
  before_create :generate_key
  before_create :set_defaults
  
  scope :yet_to_pull, where(:pulled => 'N')
  scope :of_kind, lambda { |kind|
      where(:kind => kind)
    }  
  
  def pull_items_from_staging_area (user_id)
    list_stagings.each do |list_staging|
      listitem = Listitem.new

      listitem.isbn = list_staging.isbn
      listitem.title = list_staging.title
      listitem.author = list_staging.author
      listitem.publisher = list_staging.publisher
      listitem.publisher_id = list_staging.publisher_id
      listitem.quantity = list_staging.quantity
      listitem.listprice = list_staging.listprice
      listitem.currency = list_staging.currency
      listitem.category = list_staging.category
      listitem.subcategory = list_staging.subcategory
      listitem.branch_id = list_staging.branch_id
      listitem.created_by = user_id
      listitem.list_id = id
      listitem.pulled = 'N'
      
      listitem.save
    end
  end
  
  private
    def generate_key
      self.key = (Time.now.to_f*1000).round
    end
    
    def set_defaults
      self.pulled = 'N'
    end
end
