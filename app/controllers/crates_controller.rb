class CratesController < ApplicationController
  def index
    @crates = Crate.recent.paginate(:per_page => 10, :page => params[:page])
    @current_batch = Batch.current_batch.first
    breadcrumbs.add 'Crates'
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @crates }
    end
  end

  def show
    @crate = Crate.find(params[:id])
    
    breadcrumbs.add 'Crates', crates_path
    breadcrumbs.add @crate.id

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @crate }
    end
  end

  def new
    @crate = Crate.new
    
    breadcrumbs.add 'Crates', crates_path
    breadcrumbs.add 'New'

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @crate }
    end
  end
  
  def create
    @crate = Crate.new(params[:crate])
    @crate.created_by = current_user.id
    @crate.total_cnt = 0
    @crate.batch = Batch.current_batch.first
    if @crate.save
      flash[:success] = "Saved Successfully!"
      redirect_to crate_path(@crate.id)
    else
      render :new
    end
  end

  def fill
    @crate = Crate.find(params[:id])
    
    @crate.modified_by = current_user.id
    @crate.save!
    if @crate.batch.has_capacity
      @crate.fill
      redirect_to crate_path(@crate.id)
    else
      flash[:error] = "Batch Full!"
      render :index 
    end
  end
  
  def regenerate
    @crate = Crate.find(params[:id])
    
    @crate.modified_by = current_user.id
    @crate.save
    
    @crate.regenerate
    redirect_to crate_path
  end
  
  def fetch_by_crate_no
    @crate = Crate.find(params[:crate_no])
    retval = plsql.fn_is_crate_valid_for_catalog(@crate.id)
    
    respond_to do |format|
      if @crate && retval == 0
        format.html # show.html.erb
        format.xml # fetch_by_crate_no.xml.erb
      else
        format.html {
          flash[:error] = "Could not find Crate!"
          render :index 
        }
        format.xml { render :nothing => true, :status => :not_found }
      end
    end
  end
end
