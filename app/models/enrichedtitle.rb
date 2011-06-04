# == Schema Information
# Schema version: 20110602060441
#
# Table name: enrichedtitles
#
#  id           :integer(38)     not null, primary key
#  title_id     :integer(38)
#  title        :string(255)     not null
#  publisher_id :integer(38)
#  isbn         :string(255)     not null
#  language     :string(255)
#  category     :string(255)
#  subcategory  :string(255)
#  isbn10       :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  version      :integer(38)
#  verified     :string(255)
#  author       :string(255)
#  isbnvalid    :string(255)
#  listprice    :integer(38)
#  currency     :string(255)
#  enriched     :string(255)
#

require 'isbnutil/isbn.rb'

class Enrichedtitle < ActiveRecord::Base
  acts_as_versioned
  
  belongs_to :publisher
  belongs_to :jbtitle, :foreign_key => "title_id", :class_name => "Title"
  has_many :procurementitems
  
  named_scope :unscanned, :conditions => ["isbnvalid IS NULL"]
  
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
  
  def self.validate(id, isbn)
    title = Enrichedtitle.find(id)
    unless title.nil?
      #ISBN validity
      isbn = Isbnutil::Isbn.parse(isbn, nil)
      if isbn
        title.isbnvalid = 'Y'
        
        #Publisher entry
        unless isbn.publisher.nil?
          pub = Publisher.find_by_code(isbn.group + '-' + isbn.publisher)
          if pub.nil?
            pub = Publisher.new
            pub.code = isbn.group + '-' + isbn.publisher
            pub.save
          end
          title.publisher_id = pub.id
        end
        
        #ISBN 13 generation
        if isbn.isIsbn10
          title.isbn10 = isbn.asIsbn10.gsub(/-/,'')
          title.isbn = isbn.asIsbn13.gsub(/-/,'')
          
          #Update Items if ISBN was updated to ISBN13
          procurementitems.each do |item|
            item.isbn = title.isbn
            item.save
          end
        end
      else
        title.isbnvalid = 'N'
      end
      
      if title.changed?
        if title.save
          return true
        else
          puts "Errors - " + title.errors
          return false
        end
      end
    end
  end
  
end
