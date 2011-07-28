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
  belongs_to :author
  belongs_to :category
end

