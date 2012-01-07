# == Schema Information
# Schema version: 20110410134111
#
# Table name: lists
#
#  id          :integer(38)     not null, primary key
#  name        :string(255)     not null
#  kind        :string(255)     not null
#  key         :integer(38)
#  pulled      :string(255)
#  created_by  :integer(38)
#  modified_by :integer(38)
#  created_at  :timestamp(6)
#  updated_at  :timestamp(6)
#  description :string(1020)    not null
#

class List < ActiveRecord::Base
  has_many :listitems, :inverse_of => :list, :before_add => :set_nest
  has_many :list_stagings, :dependent => :delete_all
  belongs_to :created_by_user, :foreign_key => "created_by", :class_name => "User"
  belongs_to :modified_by_user, :foreign_key => "modified_by", :class_name => "User"
  
  validates :name,              :presence => true
  validates :description,       :presence => true
  
  before_create :generate_key
  before_destroy {|rec| !(rec.pulled == 'Y')} # no error returned, destroy of a list will silently fail for pulled lists
  
  scope :yet_to_pull, where(:pulled => 'N')
  scope :of_kind, lambda { |kind|
      where(:kind => kind)
    }  
    
  attr_readonly :key
  attr_accessible :name, :kind, :pulled, :description, :listitems_attributes
  accepts_nested_attributes_for :listitems
  
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
      
      unless listitem.save
        Rails.logger.warn(listitem.errors.to_s)
      end
    end
    
    self.pulled = 'N'
    self.save
  end
  
  private
    def generate_key
      self.key = (Time.now.to_f*1000).round
    end
    
    def set_nest(listitem)
      if kind == 'IBTR' then
        er = Enrichedtitle.find_by_isbn(listitem.isbn)
        listitem.title = er.title
        listitem.author = er.author
        listitem.listprice = er.listprice
        listitem.currency = er.currency
        listitem.category = er.category
        listitem.subcategory = er.subcategory
        listitem.created_by = self.created_by
        listitem.pulled = 'N'
        
        unless er.imprint.nil?
          listitem.publisher = er.imprint.publisher.name unless er.imprint.publisher.nil?
          listitem.publisher_id = er.imprint.publisher.id unless er.imprint.publisher.nil?
        end
      end
    end
    
end
