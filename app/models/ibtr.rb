class Ibtr < ActiveResource::Base
  self.site = "http://127.0.0.1:3001"
  self.user = "nazia"
  self.password = "justbooks12"
  
  attr_accessor :enrichedtitle, :title, :isbn
  
  def set_title_id(enrichedtitle)
    if enrichedtitle.nil?
      errors.add(:isbn, "ISBN Not Present in AMS, please add first.")
      return false
    else
      if enrichedtitle.isbnvalid != 'Y'
        errors.add(:isbn, "ISBN Is present in AMS, but is marked as invalid - this item cannot be processed")
        return false
      else
        self.title_id = enrichedtitle.title_id
        return true
      end
    end
  end
end