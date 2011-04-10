# == Schema Information
# Schema version: 20110407131609
#
# Table name: enrichedtitles
#
#  id           :integer(38)     not null, primary key
#  title_id     :integer(38)
#  title        :string(255)
#  publisher_id :integer(38)
#  isbn         :string(255)
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
#  listprice    :decimal(, )
#  currency     :string(255)
#

require 'isbnutil/isbn.rb'

class Enrichedtitle < ActiveRecord::Base
  acts_as_versioned
  
  belongs_to :publisher
  
  named_scope :unscanned, :conditions => ["isbnvalid IS NULL"]
  
  def self.scan
    Enrichedtitle.unscanned.each do |title|
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
      isbn = Isbnutil::Isbn.parse(title.isbn, nil)
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
        end
      else
        title.isbnvalid = 'N'
      end
      
      puts "title.changed? - " + title.changed?
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
