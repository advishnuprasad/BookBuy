class ImprintsController < ApplicationController
  # GET /imprints
  # GET /imprints.xml
  def index
    filter = params[:filter]
    filter ||= 'all'
    if filter == 'to_fill'
      @imprints = Imprint.to_fill
    elsif filter == 'for_procurement'
      if params[:procurement_id]
        @imprints = Imprint.to_fill_in_procurement(params[:procurement_id])
      else
        @imprints = Imprint.to_fill
      end
    else
      @imprints = Imprint.order("group_id").all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @imprints }
    end
  end

  # GET /imprints/1
  # GET /imprints/1.xml
  def show
    @imprint = Imprint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @imprint }
    end
  end

  # GET /imprints/new
  # GET /imprints/new.xml
  def new
    @imprint = Imprint.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @imprint }
    end
  end

  # GET /imprints/1/edit
  def edit
    @imprint = Imprint.find(params[:id])
  end

  # POST /imprints
  # POST /imprints.xml
  def create
    @imprint = Imprint.new(params[:imprint])

    respond_to do |format|
      if @imprint.save
        format.html { redirect_to(@imprint, :notice => 'Imprint was successfully created.') }
        format.xml  { render :xml => @imprint, :status => :created, :location => @imprint }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @imprint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /imprints/1
  # PUT /imprints/1.xml
  def update
    @imprint = Imprint.find(params[:id])

    respond_to do |format|
      if @imprint.update_attributes(params[:imprint])
        format.html { redirect_to(@imprint, :notice => 'Imprint was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @imprint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /imprints/1
  # DELETE /imprints/1.xml
  def destroy
    @imprint = Imprint.find(params[:id])
    @imprint.destroy

    respond_to do |format|
      format.html { redirect_to(imprints_url) }
      format.xml  { head :ok }
    end
  end
end
