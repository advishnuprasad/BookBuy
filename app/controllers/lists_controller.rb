require 'csv'
class ListsController < ApplicationController
  # GET /lists
  # GET /lists.xml
  def index
    @lists = List.order("id DESC").all.paginate(:per_page => 15, :page => params[:page])

    breadcrumbs.add 'Lists'
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lists }
    end
  end

  # GET /lists/1
  # GET /lists/1.xml
  def show
    @list = List.find(params[:id])

    breadcrumbs.add 'Lists', lists_path
    breadcrumbs.add @list.id

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @list }
    end
  end

  # GET /lists/new
  # GET /lists/new.xml
  def new
    @list = List.new

    breadcrumbs.add 'Lists', lists_path
    breadcrumbs.add 'New'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @list }
    end
  end

  # GET /lists/1/edit
  def edit
    @list = List.find(params[:id])
    
    breadcrumbs.add 'Lists', lists_path
    breadcrumbs.add @list.id
  end

  # POST /lists
  # POST /lists.xml
  def create
    @list = List.new(params[:list])
    @list.created_by = current_user.id
    
    respond_to do |format|
      if @list.save
        format.html { redirect_to(@list, :notice => 'List was successfully created.') }
        format.xml  { render :xml => @list, :status => :created, :location => @list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lists/1
  # PUT /lists/1.xml
  def update
    @list = List.find(params[:id])

    respond_to do |format|
      if @list.update_attributes(params[:list])
        format.html { redirect_to(@list, :notice => 'List was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.xml
  def destroy
    @list = List.find(params[:id])
    @list.destroy

    respond_to do |format|
      format.html { redirect_to(lists_url) }
      format.xml  { head :ok }
    end
  end
  
  def upload
    @list = List.find(params[:id])
    if @list.listitems.count > 0 
      flash[:error] = "List details already exists"  
    else
      ListStaging.destroy_all(:list_id => @list.id)
      row_index = 0
      data = params[:list][:csv].read
      i = 0
      CSV.parse(data) do |rows|
        if i > 0 
          table = ListStaging.new
          
          table.isbn = rows[0]
          table.title = rows[1]
          table.author = rows[2]
          table.publisher = rows[3]
          table.publisher_id = rows[4]
          table.quantity = rows[5]
          table.listprice = rows[6]
          table.currency = rows[7]
          table.category = rows[8]
          table.subcategory = rows[9]
          table.branch_id = rows[10]
          table.created_by = current_user.id
          table.list_id = @list.id
          
          table.save
        end
        i+=1
      end
    end
    
    redirect_to @list
  end
  
  def import
    @list = List.find(params[:id])
    
    if @list.listitems.count > 0  or @list.list_stagings.in_error.count > 0
      flash[:error] = "Invoice details already exists or csv has error"  
    else  
      @list.pull_items_from_staging_area(current_user.id)
      if @list.listitems != @list.list_stagings
        flash[:error] = "Failed to save List items"
      end
    end
    redirect_to @list
  end
end
