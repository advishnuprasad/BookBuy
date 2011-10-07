# == Schema Information
# Schema version: 20110923082509
#
# Table name: enrichedtitles
#
#  id          :integer(38)     not null, primary key
#  title_id    :integer(38)
#  title       :string(255)     not null
#  isbn        :string(255)     not null
#  language    :string(255)
#  category    :string(255)
#  subcategory :string(255)
#  isbn10      :string(255)
#  created_at  :timestamp(6)
#  updated_at  :timestamp(6)
#  version     :integer(38)
#  verified    :string(255)
#  author      :string(255)
#  isbnvalid   :string(255)
#  listprice   :decimal(, )     not null
#  currency    :string(255)     not null
#  enriched    :string(255)
#  imprint_id  :integer(38)
#  category1   :string(1020)
#  category3   :string(1020)
#  category2   :string(1020)
#

require 'isbnutil/isbn.rb'

class Enrichedtitle < ActiveRecord::Base
  acts_as_versioned
  
  belongs_to :imprint
  belongs_to :jbtitle, :foreign_key => "title_id", :class_name => "Title"
  has_many :procurementitems
  
  belongs_to :jbcategory, :foreign_key => 'category_id', :class_name => "Category"
  
  validates :title,                  :presence => true
  validates :isbn,                   :presence => true
  validates :author,                 :presence => true
  validates :listprice,              :presence => true
  validates :currency,               :presence => true
  
  scope :unscanned, where(:isbnvalid => nil)
  scope :valid, where(:isbnvalid => 'Y')
  
  scope :of_procurement, lambda {|procurement_id|
      joins(:procurementitems).
      where(:procurementitems => {:procurement_id => procurement_id})
    }
    
  attr_accessible :category_id
    
  def self.scan_in_procurement(procurement_id)
    Enrichedtitle.of_procurement(procurement_id).unscanned.limit(1000).each do |title|
      if title.isbn.nil?
        title.isbnvalid = 'N'
        title.save
      else
        validate(title.id, title.isbn)
      end
    end
    return nil
  end
  
  def self.scan
    Enrichedtitle.unscanned.limit(1000).each do |title|
      if title.isbn.nil?
        title.isbnvalid = 'N'
        title.save
      else
        validate(title.id, title.isbn)
      end
    end
    return nil
  end
  
  def self.validate(id, isbnstr)
    title = Enrichedtitle.find(id)
    unless title.nil?
      #ISBN validity
      isbn = Isbnutil::Isbn.parse(isbnstr, nil)
      if isbn
        #Check if ISBN already exists and is valid
        title_isbn13 = Enrichedtitle.valid.find_by_isbn(isbn.asIsbn13.gsub(/-/,''))
        if title_isbn13
          #Title record exists
          #Update procurementitems to old enrichedtitle
          if title.procurementitems
            title.procurementitems.each do |item|
              item.enrichedtitle_id = title_isbn13.id
              item.isbn = title_isbn13.isbn
              item.save
            end
          end
          
          #Update ISBN10 in old enrichedtitle if blank
          title_isbn13.isbn10 = isbn.asIsbn10 if title_isbn13.isbn10.nil?
          
          if title_isbn13.changed?
            title_isbn13.save
          end
          
          #Remove the ISBN10 that was replaced
          title.destroy
          return true
        else
          #title record does not exist
          title.isbn10 = isbn.asIsbn10.gsub(/-/,'')
          title.isbn = isbn.asIsbn13.gsub(/-/,'')
          title.isbnvalid = 'Y'
          #Imprint entry
          unless isbn.imprint.nil?
            imp = Imprint.find_by_code(isbn.group + '-' + isbn.imprint)
            if imp.nil?
              imp = Imprint.new
              imp.code = isbn.group + '-' + isbn.imprint
              imp.save
            end
            title.imprint_id = imp.id
          end
          
          #Update Items if ISBN was updated to ISBN13
          if title.procurementitems
            title.procurementitems.each do |item|
              item.isbn = title.isbn
              item.save
            end
          end
          
          if title.save
            return true
          end
        end
      else
        #ISBN Invalid
        title.isbnvalid = 'N'
        if title.save
          return true
        end
      end
    end
    return false
  end
end
