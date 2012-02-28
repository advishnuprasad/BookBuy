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
  has_attached_file :cover, :styles => {:thumb => "100x100>", :medium => "200x200>"}, 
  :path => ':style/:isbn.:extension', :default_url => "/images/missing_:style.jpg"
  
  belongs_to :jbcategory, :foreign_key => 'category_id', :class_name => "Category"
  
  validates :title,       :presence => true
  validates :isbn,        :presence => true
  validates :author,      :presence => true
  validates :listprice,   :presence => true, :numericality => true
  validates :currency,    :presence => true
  validates :language,    :presence => true, :on => :create # new fields, existing data not set
  validates :category_id, :presence => true, :on => :create # new fields, existing data not set
  validates :isbnvalid,   :inclusion => { :in => ['Y'], :message => 'ISBN Is Invalid' }
  validate :currency_is_valid_and_present
  
  before_create :create_legacy_title
  before_validation :parse_isbn, :on => :create

  before_validation :download_remote_image, :if => :image_url_provided?
  validates_attachment_size :cover, :less_than => 50.kilobytes, :message => 'file size maximum 50 KB allowed'
  validates_attachment_content_type :cover, :content_type => ['image/jpeg']
  
  scope :unscanned, where(:isbnvalid => nil)
  scope :valid, where(:isbnvalid => 'Y')
  
  scope :of_procurement, lambda {|procurement_id|
      joins(:procurementitems).
      where(:procurementitems => {:procurement_id => procurement_id})
  }
  
  attr_accessor :publisher, :pubdate, :page_cnt, :image_url, :use_image_url
  attr_accessible :category_id, :language, :listprice, :currency
  attr_protected :cover_file_name, :cover_content_type, :conver_file_size, :conver_updated_at
  
  def currency_is_valid_and_present
    begin
      curr = Currency.find_by_code!(currency)
    rescue ActiveRecord::RecordNotFound
      errors.add(:currency, " does not exist!")
    end
  end
      
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
        validate(title.id, title.isbn, true)
      end
    end
    return nil
  end
  
  def self.validate(id, isbnstr, validateCheckDigit)
    if validateCheckDigit.nil?
      validateCheckDigit = false
    end
    
    title = Enrichedtitle.find(id)
    unless title.nil?
      #ISBN validity
      isbn = Isbnutil::Isbn.parse(isbnstr, nil, validateCheckDigit)
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
          
          #If validateCheckDigit is false, a manual scan is being triggered
          title.isbn = isbn.asIsbn13.gsub(/-/,'') if validateCheckDigit
          
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

  def self.new_from_web(isbn)
    et = new
    et.isbn = isbn
    finfo = FlipkartInfo.book_info(isbn)
    unless finfo.nil?
      et.title = finfo[:title]
      et.author =  finfo[:authors]
      et.publisher = finfo[:publisher]
      et.pubdate = finfo[:pubdate]
      et.page_cnt = finfo[:page_cnt]
      et.language = finfo[:language]
      et.listprice = finfo[:listprice].scan(/\d/).join('')
      et.image_url = finfo[:image]
      
      et.author ||= '.'  # there are times when author is not set even in flip
    end
    et
  end
  
  private
  
  def image_url_provided?
    !image_url.blank?
  end
  
  def download_remote_image
    self.cover = do_download_remote_image
    self.cover_remote_url = image_url
  end
  
  def do_download_remote_image
      require 'open-uri'
      io = open(URI.parse(image_url))
      def io.original_filename; base_uri.path.split('/').last; end
      io.original_filename.blank? ? nil : io
  rescue
    self.cover = nil
  end  
  
  def parse_isbn
    isbn = Isbnutil::Isbn.parse(self.isbn, nil, true)
    if isbn 
      self.isbnvalid = 'Y'
      self.isbn10 = isbn.asIsbn10.gsub(/-/,'')
      
      unless isbn.imprint.nil?
        self.imprint = Imprint.find_or_create_by_code(isbn.group + '-' + isbn.imprint)
      end      
    else
      self.isbnvalid = 'N'
    end
  end
  
  def create_legacy_title
    
  flag_isbn_image = 'N'
  publisher_id = 50
  
  flag_isbn_image = 'Y' unless self.cover_file_name.nil?
  publisher_id = self.imprint.publisher.id unless self.imprint.publisher.nil?
  
  title = Title.create( :title => self.title,
                        :author => Author.find_or_create_by_firstname(self.author),
                        :publisherid => publisher_id,
                        :isbn_10 => self.isbn10,
                        :isbn_13 => self.isbn,
                        :category => self.category,  
                        :language => self.language,
                        :titletype => 'B',
                        :insertdate => Time.zone.now,
                        :userid => 'AMS',
                        :flag_isbn_image => flag_isbn_image,
                        :mrp => self.listprice,
                        )
                          
    self.title_id = title.id
    title.save

  end
end

