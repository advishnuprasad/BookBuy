# == Schema Information
# Schema version: 20110404112924
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
#

require 'isbnutil/isbn.rb'

class Enrichedtitle < ActiveRecord::Base
  acts_as_versioned
  
  belongs_to :publisher
  
  named_scope :unscanned, :conditions => ["isbnvalid IS NULL"]
  
  def self.scan
    Enrichedtitle.unscanned.each do |title|
      #ISBN validity
      if title.isbn.nil?
        title.isbnvalid = 'N'
      else
        isbn = Isbnutil::Isbn.parse(title.isbn, nil)
        if isbn
          title.isbnvalid = 'Y'
          
          #Publisher entry
          if !isbn.publisher.nil?
            pub = Publisher.find_by_code(isbn.group + '-' + isbn.publisher)
            if pub.nil?
              pub = Publisher.new
              pub.code = isbn.group + '-' + isbn.publisher
              puts pub.code
              pub.save
            end
            title.publisher_id = pub.id
          end
        else
          title.isbnvalid = 'N'
        end
      end
      
      if !title.save
        puts title.errors
      end
    end
    return nil
  end
end
