class Ibtr < ActiveResource::Base
  self.site = AMSSettings.ibtr_url
  self.user = AMSSettings.ibtr_user
  self.password = AMSSettings.ibtr_password
  
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
  
  def self.pending_procurements(updated_at)
    updated_at ||= Time.zone.today
    
    Date.strptime(updated_at,'%Y-%m-%d') rescue return []
    
    ibtrs = Ibtr.find(:all, :from => :search, :params => {:per_page => 200, :updated_at => updated_at, :Assigned => :Assigned, :branchVal => 951, :searchBy => "respondent_id" })
    enrichedtitles = Enrichedtitle.valid.find_all_by_title_id( ibtrs.collect { |ibtr| ibtr.title_id }.uniq )    
    titles = Title.find_all_by_titleid( ibtrs.collect { |ibtr| ibtr.title_id }.uniq )
    listitems = Listitem.find_all_by_ibtr_id( ibtrs.collect {|ibtr| ibtr.id}.uniq )
    ibtrs.each do |ibtr|
      ibtr.listitem = listitems.detect { |t| t.ibtr_id == ibtr.id }
      ibtr.enrichedtitle = enrichedtitles.detect { |er| er.title_id == ibtr.title_id }
      ibtr.title = titles.detect { |t| t.id == ibtr.title_id }
    end
    
    ibtrs
  end
  
end