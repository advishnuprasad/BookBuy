class IbtrsController < ApplicationController
  def index    
    @ibtrs = Ibtr.find(:all, :from => :search, :params => { :Assigned => :Assigned, :branchVal => 951, :searchBy => "respondent_id" })
    enrichedtitles = Enrichedtitle.valid.find_all_by_title_id( @ibtrs.collect { |ibtr| ibtr.title_id }.uniq )
    titles = Title.find_all_by_id( @ibtrs.collect { |ibtr| ibtr.title_id }.uniq )
    @ibtrs.each do |ibtr|
      ibtr.enrichedtitle = enrichedtitles.detect { |er| er.title_id == ibtr.title_id }
      ibtr.title = titles.detect { |t| t.id.to_i == ibtr.title_id }
    end
  end
  
  def edit
    @ibtr = Ibtr.find(params[:id])
    @ibtr.title = Title.find(:first, :conditions => { :id => @ibtr.title_id})
  end
  
  def update
    @ibtr = Ibtr.find(params[:id])
    @ibtr.title = Title.find(:first, :conditions => { :id => @ibtr.title_id})
    
    respond_to do |format|
      if @ibtr.set_title_id(Enrichedtitle.find_by_isbn(params[:ibtr][:isbn]))
        if @ibtr.get(:set_alttitle, :title_id => @ibtr.title_id)
          format.html { redirect_to(ibtrs_path, :notice => 'Ibtr was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "index" }
          format.xml  { render :xml => @ibtr.errors, :status => :unprocessable_entity }
        end
      else
        format.html { render :action => "edit" }
        format.xml { head :unprocessable_entity }
      end
    end

  end
end