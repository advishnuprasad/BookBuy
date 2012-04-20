class Book < ActiveRecord::Base
  establish_connection "jbprod_#{RAILS_ENV}"
  
  set_primary_key :bookid
  set_sequence_name :seq_books
  
  belongs_to :title, :foreign_key => :titleid
  belongs_to :originallocation, :foreign_key => :origlocation, :class_name => 'Branch'
  belongs_to :currentlocation, :foreign_key => :location, :class_name => 'Branch'
  
  searchable do
    text :titleid, :stored => true
    integer :times_rented, :stored => true
    integer :id, :stored => true
    text :decorated_book_no, :stored => true
    text :shelflocation, :stored => true
    integer :location, :references => Branch, :stored => true
    integer :origlocation, :references => Branch, :stored => true
    string :origlocation_type, :using => :origlocation_category, :stored => true
    boolean :available, :using => :available?, :stored => true
    integer :city_id, :stored => true
  end
  
  def title_type
    "B"
  end
    
  def decorated_book_no
    title_type + "0" + booknumber.to_s
  end
  
  def available?
    status == 'A'
  end
  
  def origlocation_category 
    return originallocation.category unless originallocation.nil?
    return nil
  end
  
  def city_id
    originallocation.city_id
  end
  
  def self.search(keyword, location, origlocation, available=nil, city_id=nil)
    search = Sunspot.new_search(Book) do
      paginate(:page => 1, :per_page => 500)
      facet(:location, :origlocation, :available, :city_id)
    end

    search.build do
      fulltext keyword
    end

    if origlocation
      search.build do
        with :origlocation, origlocation
      end
    end
    
    if location
      search.build do
        with :location, location
      end
    end
    
    if available
      search.build do
        with :available, available
      end
    end
    
    if city_id
      search.build do
        with :city_id, city_id
      end
    end
    
    search.build do
      with :origlocation_type, ['P', 'S']
    end
    
    search.execute
  end
end