class Regionaltitle < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :jbtitle, :foreign_key => "title_id", :class_name => "Title"
  
  validates :language, :presence => true
  validates :title, :presence => true
  validates :author, :presence => true
  validates :title_id, :presence => true
  
  before_create :set_data
  
  searchable do
    text :nls_title, :stored => true, :more_like_this => true , :boost => 6
	text :title, :stored => true, :more_like_this => true, :boost => 5
    text :author, :stored => true, :more_like_this => true , :boost => 2 
    text :category, :stored => true, :more_like_this => true 
	text :subcategory, :stored => true, :more_like_this => true 
	text :isbn, :stored => true, :more_like_this => true 
	
    text :publisher, :stored => true, :more_like_this => true do
      unless publisher.nil? 
        publisher.name
      else
        ''
      end
    end
    integer :id, :stored => true
    integer :title_id, :references => Title, :stored => true
    #integer :stock, :references => Stock, :multiple => true
    #integer :branch, :references => Stock, :multiple => true
  end   

  def set_data
    t_isbn = Isbnutil::Isbn.parse(self.isbn, nil)
    if t_isbn
      self.isbn_valid = 'Y'
    else
      self.isbn_valid = 'N'
    end
  end
  
  def self.search_alt_title(params)
  
    search = Sunspot.new_search(Regionaltitle) do
      paginate(:page => params[:page], :per_page => params[:per_page])
    end
    search.build do
      keywords(params[:query] )
    end
    
    
    regionaltitles = search.execute
    
    return regionaltitles
  
  end
end
