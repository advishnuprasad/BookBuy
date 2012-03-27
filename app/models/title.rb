# == Schema Information
# Schema version: 20110603110110
#
# Table name: titles
#
#  id                :integer(11)     not null, primary key
#  title             :string(200)
#  author_id         :integer(11)
#  publisher_id      :integer
#  yearofpublication :integer(11)
#  edition           :string(50)
#  category_id       :string(100)
#  isbn10            :string(16)
#  isbn13            :string(16)
#  noofpages         :integer(11)
#  language          :string(100)
#  cnt_rated         :integer(11)
#  rating            :integer(11)
#  no_of_rented      :integer(11)
#  title_type        :string(100)
#

class Title < ActiveRecord::Base
  establish_connection "jbprod_#{RAILS_ENV}"
  
  # alias attributes added for web-store
  alias_attribute :publisher_id, :publisherid
  alias_attribute :author_id, :authorid
  alias_attribute :times_rented, :no_of_rented
  alias_attribute :isbn, :isbn_13
  
  set_primary_key :titleid
  set_sequence_name :seq_titles
  
  has_many :enrichedtitles
  has_many :procurementitems
  has_many :noisbntitles
  
  belongs_to :author, :foreign_key => :authorid
  belongs_to :category
  belongs_to :publisher, :foreign_key => :publisherid
  
  has_many :titlebranches
  has_many :branches, :through => :titlebranches
  
  scope :with_enrichedtitles, where('titleid in ( select distinct title_id from enrichedtitles )')
  scope :with_noisbntitles, where('titleid in ( select distinct title_id from noisbntitles)')
  
  searchable do
    text :title, :stored => true, :more_like_this => true
    text :author, :stored => true, :more_like_this => true do
      author.nil? ? '' : author.name
    end
    text :publisher, :stored => true, :more_like_this => true do
      publisher.nil? ? '' : publisher.name
    end
    text :isbn, :stored => true
    integer :publisher_id, :references => Publisher, :stored => true
    integer :author_id, :references => Author, :stored => true
    integer :times_rented, :stored => true
    integer :id, :stored => true
    integer :category_id, :references => Category, :stored => true
    boolean :book, :using => :book?
    integer :branch_ids, :multiple => true, :references => Branch, :stored => true
  end
  
  def self.search(option, category_id, branch_ids, keyword, page, per_page, onlybooks = true)
    search = Sunspot.new_search(Title) do
      paginate(:page => page, :per_page => per_page)
      order_by(:times_rented, :desc)
      facet(:category_id, :branch_ids)
    end

    if option == 'All'
      search.build do
        fulltext keyword
      end
    elsif option == 'Title'
      search.build do
        fulltext keyword do
          fields :title
        end
      end
    elsif option == 'Author'
      search.build do
        fulltext keyword do
          fields :author
        end
      end
    elsif option == 'Publisher'
      search.build do
        fulltext keyword do
          fields :publisher
        end
      end
    end

    if category_id
      search.build do
        with(:category_id).equal_to(category_id)
      end
    end
    
    if branch_ids
      search.build do
        with(:branch_ids, branch_ids)
      end
    end
    
    search.build do
      with :book, onlybooks
    end

    search.execute
  end
  
  def book?
    titletype == 'B'
  end  
  
#  scope :with_similarity, lambda { |title, similarity, score|
#    return unless similarity == 'J'
#    score ||= 80
#    where("utl_match.jaro_winkler_similarity(title, 'Hello') > 50")
#  }
end

