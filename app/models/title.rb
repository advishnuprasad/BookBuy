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
  has_many :enrichedtitles
  has_many :procurementitems
  has_many :regionaltitles
  belongs_to :author
  belongs_to :category
  belongs_to :publisher
  
  attr_accessible :title, :yearofpublication, :edition, :isbn10, :isbn13, :noofpages, :language ,:no_of_rented, :title_type
  validates :title, :presence => true
  
  searchable do
    text :title, :stored => true, :more_like_this => true, :boost => 5
    text :author, :stored => true, :more_like_this => true , :boost => 2 do
      unless author.nil? 
        author.name
      else
        ''
      end
    end
    text :category, :stored => true, :more_like_this => true do
      unless category.nil? 
        category.name
      else
        ''
      end
    end
    text :publisher, :stored => true, :more_like_this => true do
      unless publisher.nil? 
        publisher.name
      else
        ''
      end
    end
    integer :id, :stored => true
    integer :category_id, :references => Category, :stored => true
    integer :publisher_id, :references => Publisher, :stored => true
    integer :author_id, :references => Author, :stored => true
    integer :no_of_rented, :stored => true
    string :title_type, :stored => true
    #integer :stock, :references => Stock, :multiple => true
    #integer :branch, :references => Stock, :multiple => true
    string :nls_title, :multiple => true do
      regionaltitles.collect{|x| x.nls_title}
    end
  end   

end
