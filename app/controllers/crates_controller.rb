class CratesController < ApplicationController
  def index
    @crates = Crate.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @crate = Crate.find(params[:id])
  end

  def new
    @crate = Crate.new
  end
  
  def create
    @crate = Crate.new(params[:crate])
    @crate.total_cnt = 0
    if @crate.save
      flash[:success] = "Saved Successfully!"
      redirect_to crate_path(@crate.id)
    else
      flash[:error] = "Save Failure!"
      render :new
    end
  end

  def fill
    @crate = Crate.find(params[:id])
    @crate.fill
    redirect_to crate_path
  end
  
  def regenerate
    @crate = Crate.find(params[:id])
    @crate.regenerate
    redirect_to crate_path
  end
  
  def fetch_by_crate_no
    @crate = Crate.find(params[:crate_no])
    respond_to do |format|
      if @crate
        format.html # show.html.erb
        format.xml  { render :xml => @crate }
      else
        flash[:error] = "Could not find Crate!"
        format.html { render :index }
        format.xml { render :nothing => true, :status => :not_found }
      end
    end
  end
end
