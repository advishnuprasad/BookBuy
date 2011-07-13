class SupplierdiscountsController < ApplicationController
  # GET /supplierdiscounts
  # GET /supplierdiscounts.xml
  def index
    filter = params[:filter]
    filter ||= 'all'
    if filter == 'to_fill'
      #Order by Supplier and Publisher (Group)
      @supplierdiscounts = Supplierdiscount.order("supplier_id").includes(:publisher).order("publishers.id").to_fill
    elsif filter == 'for_procurement'
      if params[:procurement_id]
        @supplierdiscounts = Supplierdiscount.to_fill_in_procurement(params[:procurement_id])
      else
        @supplierdiscounts = Supplierdiscount.order("supplier_id").includes(:publisher).order("publishers.id").to_fill
      end
    elsif filter == 'of_procurement'
      @supplierdiscounts = Supplierdiscount.of_procurement(params[:procurement_id])
    else
      #Order by Supplier and Publisher (Group)
      @supplierdiscounts = Supplierdiscount.order("supplier_id").includes(:publisher).order("publishers.id").all
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @supplierdiscounts }
    end
  end

  # GET /supplierdiscounts/1
  # GET /supplierdiscounts/1.xml
  def show
    @supplierdiscount = Supplierdiscount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @supplierdiscount }
    end
  end

  # GET /supplierdiscounts/new
  # GET /supplierdiscounts/new.xml
  def new
    @supplierdiscount = Supplierdiscount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @supplierdiscount }
    end
  end

  # GET /supplierdiscounts/1/edit
  def edit
    @supplierdiscount = Supplierdiscount.find(params[:id])
  end

  # POST /supplierdiscounts
  # POST /supplierdiscounts.xml
  def create
    @supplierdiscount = Supplierdiscount.new(params[:supplierdiscount])

    respond_to do |format|
      if @supplierdiscount.save
        format.html { redirect_to(@supplierdiscount, :notice => 'Supplierdiscount was successfully created.') }
        format.xml  { render :xml => @supplierdiscount, :status => :created, :location => @supplierdiscount }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @supplierdiscount.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /supplierdiscounts/1
  # PUT /supplierdiscounts/1.xml
  def update
    @supplierdiscount = Supplierdiscount.find(params[:id])

    respond_to do |format|
      if @supplierdiscount.update_attributes(params[:supplierdiscount])
        format.html { redirect_to(@supplierdiscount, :notice => 'Supplierdiscount was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @supplierdiscount.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /supplierdiscounts/1
  # DELETE /supplierdiscounts/1.xml
  def destroy
    @supplierdiscount = Supplierdiscount.find(params[:id])
    @supplierdiscount.destroy

    respond_to do |format|
      format.html { redirect_to(supplierdiscounts_url) }
      format.xml  { head :ok }
    end
  end
  
  def update_records
    data = params[:data]
    
    result = true
    data.each {|key, value|
      supplierdiscount = Supplierdiscount.find(value["id"])
      
      if supplierdiscount
        supplierdiscount.publisher.imprintname = value["imprintname"] unless value["imprintname"].nil?
        supplierdiscount.discount = value["discount"] unless value["discount"].nil?
        supplierdiscount.bulkdiscount = value["bulkdiscount"] unless value["bulkdiscount"].nil?
        
        if supplierdiscount.changed?
          unless supplierdiscount.save
            result = false
          end
        end
      else
        result = false
      end
    }
    
    if result == true
      flash[:success] = "Items have been Successfully Updated!"
    else
      flash[:error] = "Items updation failed!"
    end
    
    respond_to do |format|
      format.js
    end
  end
end
