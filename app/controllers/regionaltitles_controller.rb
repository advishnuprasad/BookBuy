class RegionaltitlesController < ApplicationController
  # GET /regionaltitles
  # GET /regionaltitles.xml
  def index
    @regionaltitles = Regionaltitle.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @regionaltitles }
    end
  end

  # GET /regionaltitles/1
  # GET /regionaltitles/1.xml
  def show
    @regionaltitle = Regionaltitle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @regionaltitle }
    end
  end

  # GET /regionaltitles/new
  # GET /regionaltitles/new.xml
  def new
    @regionaltitle = Regionaltitle.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @regionaltitle }
    end
  end

  # GET /regionaltitles/1/edit
  def edit
    @regionaltitle = Regionaltitle.find(params[:id])
  end

  # POST /regionaltitles
  # POST /regionaltitles.xml
  def create
    @regionaltitle = Regionaltitle.new(params[:regionaltitle])

    respond_to do |format|
      if @regionaltitle.save
        format.html { redirect_to(@regionaltitle, :notice => 'Regionaltitle was successfully created.') }
        format.xml  { render :xml => @regionaltitle, :status => :created, :location => @regionaltitle }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @regionaltitle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /regionaltitles/1
  # PUT /regionaltitles/1.xml
  def update
    @regionaltitle = Regionaltitle.find(params[:id])

    respond_to do |format|
      if @regionaltitle.update_attributes(params[:regionaltitle])
        format.html { redirect_to(@regionaltitle, :notice => 'Regionaltitle was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @regionaltitle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /regionaltitles/1
  # DELETE /regionaltitles/1.xml
  def destroy
    @regionaltitle = Regionaltitle.find(params[:id])
    @regionaltitle.destroy

    respond_to do |format|
      format.html { redirect_to(regionaltitles_url) }
      format.xml  { head :ok }
    end
  end
  
  def search
      
  end
end
