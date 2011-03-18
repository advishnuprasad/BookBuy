class Publishersuppliermapping < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :supplier
end
