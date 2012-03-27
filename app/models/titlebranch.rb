class Titlebranch < ActiveRecord::Base
  belongs_to :title
  belongs_to :branch
end
