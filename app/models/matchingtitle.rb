class Matchingtitle < ActiveRecord::Base

  MATCH_STATUS = [
    SAME = "Same",
    DIFFERENT = "Different",
    CANT_SAY = "Cant Say"
  ]
  
  belongs_to :enrichedtitle
  belongs_to :title
  
  attr_accessible :status, :updated_by
end