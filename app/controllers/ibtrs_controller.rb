class IbtrsController < ApplicationController
  def index
    params[:ibtr_created_at] ||= Time.zone.today
    @ibtrs = Ibtr.pending_procurements(params[:ibtr_created_at])
    @list = List.new(:name => 'IBTR-'+(Time.now.to_f*1000).round.to_s, :kind => 'IBTR', :pulled => 'N', :description => 'IBTR List Description')
    @ibtrs.each do |ibtr|      
      unless ibtr.enrichedtitle.nil?
        if ibtr.listitem.nil?
          @list.listitems.build(:isbn => ibtr.enrichedtitle.isbn, 
                                :quantity => 1, 
                                :branch_id => ibtr.branch_id, 
                                :member_id => ibtr.member_id, 
                                :card_id => ibtr.card_id, 
                                :ibtr_id => ibtr.id)
        end
      end
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