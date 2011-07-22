class ProcurementitemsController < ApplicationController
  # GET /procurementitems
  # GET /procurementitems.xml
  def index
    filter = params[:filter]
    filter ||= 'all'
    if filter.starts_with?("of_procurement")
      if filter == 'of_procurement_to_order' && params[:procurement_id]
        @procurementitems = Procurementitem.to_order_in_procurement(params[:procurement_id])
      elsif filter == 'of_procurement' && params[:procurement_id]
        if params[:status]
          if params[:status] == 'Deferred'
            @procurementitems = Procurementitem.of_procurement(params[:procurement_id]).deferred
          elsif params[:status] == 'Cancelled'
            @procurementitems = Procurementitem.of_procurement(params[:procurement_id]).cancelled
          end
        else
          @procurementitems = Procurementitem.of_procurement(params[:procurement_id])
        end
      else
        @procurementitems = Procurementitem.all
      end
    else
      @procurementitems = Procurementitem.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @procurementitems }
    end
  end

  # GET /procurementitems/1
  # GET /procurementitems/1.xml
  def show
    @procurementitem = Procurementitem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @procurementitem }
    end
  end

  # GET /procurementitems/new
  # GET /procurementitems/new.xml
  def new
    @procurementitem = Procurementitem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @procurementitem }
    end
  end

  # GET /procurementitems/1/edit
  def edit
    @procurementitem = Procurementitem.find(params[:id])
    branch_ids = @procurementitem.distributions.collect { |dist| dist.branch_id }
    Branch.parent_branches.order("id").each do |branch| 
      @procurementitem.distributions.build(:branch_id => branch.id) unless branch_ids.include?(branch.id)
    end
  end

  # POST /procurementitems
  # POST /procurementitems.xml
  def create
    @procurementitem = Procurementitem.new(params[:procurementitem])

    respond_to do |format|
      if @procurementitem.save
        format.html { redirect_to(@procurementitem, :notice => 'Procurementitem was successfully created.') }
        format.xml  { render :xml => @procurementitem, :status => :created, :location => @procurementitem }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @procurementitem.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /procurementitems/1
  # PUT /procurementitems/1.xml
  def update
    @procurementitem = Procurementitem.find(params[:id])
    respond_to do |format|
      if @procurementitem.update_attributes(params[:procurementitem])
        format.html { redirect_to(@procurementitem, :notice => 'Procurementitem was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @procurementitem.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /procurementitems/1
  # DELETE /procurementitems/1.xml
  def destroy
    @procurementitem = Procurementitem.find(params[:id])
    @procurementitem.destroy

    respond_to do |format|
      format.html { redirect_to(procurementitems_url) }
      format.xml  { head :ok }
    end
  end
end
