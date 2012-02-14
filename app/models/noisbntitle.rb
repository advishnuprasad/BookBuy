class Noisbntitle < ActiveRecord::Base
  acts_as_versioned
  
  belongs_to :publisher
  belongs_to :category
  belongs_to :jbtitle, :foreign_key => "title_id", :class_name => "Title"
  
  has_attached_file :cover, :styles => {:thumb => "100x100>", :medium => "200x200>"}, 
  :path => ':style/:id.:extension', :default_url => "/images/missing_:style.jpg"
  
  validates :title, :presence => true
  validates :author, :presence => true
  validates :language, :presence => true
  validates :currency, :presence => true
  validates :listprice, :presence => true, :numericality => true
  validates :category_id, :presence => true, :numericality => true
  validates :publisher_name, :presence => true
  validates :publisher_id, :presence => true, :numericality => true
  validates :pub_year, :presence => true, :numericality => true
  validates :format, :presence => true
  validates :page_cnt, :presence => true, :numericality => true
  validates :t_title, :presence => true
  validates :t_author, :presence => true
  
  validates_attachment_size :cover, :less_than => 50.kilobytes, :message => 'file size maximum 50 KB allowed'
  validates_attachment_content_type :cover, :content_type => ['image/jpeg']
  
  before_create :set_defaults_on_create

  def self.new_from_title(legacytitleid)
    nt = new
    legacytitle = Title.find(legacytitleid)
  
    return if legacytitle.nil?
  
    nt.jbtitle = legacytitle
    nt.title = legacytitle.title
    nt.author = legacytitle.author.name unless legacytitle.author.nil?

    nt
  end
  
  private
  def set_defaults_on_create
    self.verified = 'N'
    self.enriched = 'N'
  end
    
  
end
