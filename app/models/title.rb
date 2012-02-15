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
  
  set_primary_key :titleid
  set_sequence_name :seq_titles
  
  has_many :enrichedtitles
  has_many :procurementitems
  has_many :noisbntitles
  
  belongs_to :author, :foreign_key => :authorid
  belongs_to :category, :foreign_key => :category
  belongs_to :publisher, :foreign_key => :publisherid
  
  scope :with_enrichedtitles, where('titleid in ( select distinct title_id from enrichedtitles )')
  scope :with_noisbntitles, where('titleid in ( select distinct title_id from noisbntitles)')
  
#  scope :with_similarity, lambda { |title, similarity, score|
#    return unless similarity == 'J'
#    score ||= 80
#    where("utl_match.jaro_winkler_similarity(title, 'Hello') > 50")
#  }
end

