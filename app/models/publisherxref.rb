# == Schema Information
# Schema version: 20110329115540
#
# Table name: publisherxrefs
#
#  id                :integer(38)     not null, primary key
#  isbnpublishercode :integer(38)
#  publisher_id      :integer(38)
#  created_at        :datetime
#  updated_at        :datetime
#

class Publisherxref < ActiveRecord::Base
end
