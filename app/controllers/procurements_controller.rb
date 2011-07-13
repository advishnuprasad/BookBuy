class ProcurementsController < ApplicationController
  # GET /procurements
  # GET /procurements.xml
  def index
    @procurements = Procurement.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @procurements }
    end
  end

  # GET /procurements/1
  # GET /procurements/1.xml
  def show
    @procurement = Procurement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @procurement }
    end
  end

  # GET /procurements/new
  # GET /procurements/new.xml
  def new
    @procurement = Procurement.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @procurement }
    end
  end

  # GET /procurements/1/edit
  def edit
    @procurement = Procurement.find(params[:id])
  end

  # POST /procurements
  # POST /procurements.xml
  def create
    @procurement = Procurement.new(params[:procurement])
    @procurement.created_by = current_user.id
    
    respond_to do |format|
      if @procurement.save
        format.html { redirect_to(@procurement, :notice => 'Procurement was successfully created.') }
        format.xml  { render :xml => @procurement, :status => :created, :location => @procurement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @procurement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /procurements/1
  # PUT /procurements/1.xml
  def update
    @procurement = Procurement.find(params[:id])
    @procurement.modified_by = current_user.id
    
    respond_to do |format|
      if @procurement.update_attributes(params[:procurement])
        format.html { redirect_to(@procurement, :notice => 'Procurement was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @procurement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /procurements/1
  # DELETE /procurements/1.xml
  def destroy
    @procurement = Procurement.find(params[:id])
    @procurement.destroy

    respond_to do |format|
      format.html { redirect_to(procurements_url) }
      format.xml  { head :ok }
    end
  end
  
  def pull
    unless params[:pull].nil?
      if params[:pull] == 'ibtr'
        cnt = Procurement.pending_ibtr_items_exist
        
        if cnt > 0
          id = Procurement.pull_ibtr_items
          @procurement = Procurement.find(id)
          
          @procurement.created_by = current_user.id
          @procurement.save
        else
          flash[:success] = "No pending IBTR Requests!"
        end
      elsif params[:pull] == 'nent'
        List.yet_to_pull.of_kind('NENT').each do |list|
          id = Procurement.pull_nent_items(list.id)
          
          @procurement = Procurement.find(id)
          
          @procurement.created_by = current_user.id
          @procurement.save
        end
      elsif params[:pull] == 'nstr'
        List.yet_to_pull.of_kind('NSTR').each do |list|
          id = Procurement.pull_nstr_items(list.id)
          
          @procurement = Procurement.find(id)
          
          @procurement.created_by = current_user.id
          @procurement.save
        end
      elsif params[:pull] == 'whse'
        List.yet_to_pull.of_kind('WHSE').each do |list|
          id = Procurement.pull_whse_items(list.id)
          
          @procurement = Procurement.find(id)
          
          @procurement.created_by = current_user.id
          @procurement.save
        end
      end
    end
    
    respond_to do |format|
      if id
        format.html { redirect_to(@procurement, :notice => 'Procurement was successfully created.') }
        format.xml  { render :xml => @procurement, :status => :created, :location => @procurement }
      else
        format.html { redirect_to(procurements_url, :notice => 'No pending IBTR Requests!') }
        format.xml  { head :ok }
      end
    end
  end
  
  def refresh
    @procurement = Procurement.find(params[:id])
    @procurement.refresh_worklists
    
    respond_to do |format|
      format.html { redirect_to(@procurement, :notice => 'Worklists regenerated.') }
      format.xml  { render :xml => @procurement }
    end
  end
  
  def generate_po
    @procurement = Procurement.find(params[:id])
    cnt = @procurement.generate_pos
    
    respond_to do |format|
      format.html { redirect_to(@procurement, :notice => cnt.to_s + ' POs generated!') }
      format.xml  { render :xml => @procurement }
    end
  end
  
  def download
    @procurement = Procurement.find(params[:id])
    
    if(@procurement.pos.count > 0)
      temppathstr = @procurement.download
      zip_file_name = @procurement.id.to_s + '.zip'
      send_file temppathstr, :type => 'application/zip',
                               :disposition => 'attachment',
                               :filename => zip_file_name
    end
  end
  
  def close
    @procurement = Procurement.find(params[:id])
    @procurement.status = 'Closed'
    
    respond_to do |format|
      if @procurement.save
        format.html { redirect_to(@procurement, :notice => 'Procurement was successfully closed.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @procurement.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def scan
    @procurement = Procurement.find(params[:id])
    
    @procurement.scan_titles
    respond_to do |format|
      format.html { render :action => "show" }
      format.xml  { render :xml => @procurement }
    end
  end
end
