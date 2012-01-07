class Ibtr < ActiveResource::Base
  self.site = Settings.ibtr_url
  self.user = Settings.ibtr_user
  self.password = Settings.ibtr_password
  
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