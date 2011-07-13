class ListitemsController < ApplicationController
  # GET /listitems
  # GET /listitems.xml
  def index
    @listitems = Listitem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @listitems }
    end
  end

  # GET /listitems/1
  # GET /listitems/1.xml
  def show
    @listitem = Listitem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @listitem }
    end
  end

  # GET /listitems/new
  # GET /listitems/new.xml
  def new
    @listitem = Listitem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @listitem }
    end
  end

  # GET /listitems/1/edit
  def edit
    @listitem = Listitem.find(params[:id])
  end

  # POST /listitems
  # POST /listitems.xml
  def create
    @listitem = Listitem.new(params[:listitem])

    respond_to do |format|
      if @listitem.save
        format.html { redirect_to(@listitem, :notice => 'Listitem was successfully created.') }
        format.xml  { render :xml => @listitem, :status => :created, :location => @listitem }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @listitem.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /listitems/1
  # PUT /listitems/1.xml
  def update
    @listitem = Listitem.find(params[:id])

    respond_to do |format|
      if @listitem.update_attributes(params[:listitem])
        format.html { redirect_to(@listitem, :notice => 'Listitem was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @listitem.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /listitems/1
  # DELETE /listitems/1.xml
  def destroy
    @listitem = Listitem.find(params[:id])
    @listitem.destroy

    respond_to do |format|
      format.html { redirect_to(listitems_url) }
      format.xml  { head :ok }
    end
  end
end
