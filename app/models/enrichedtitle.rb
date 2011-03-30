# == Schema Information
# Schema version: 20110330092840
#
# Table name: enrichedtitles
#
#  id           :integer(38)     not null, primary key
#  title_id     :integer(38)
#  title        :string(255)
#  author_id    :integer(38)
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
#

class Enrichedtitle < ActiveRecord::Base
  acts_as_versioned
  
  belongs_to :author
  belongs_to :publisher
end
