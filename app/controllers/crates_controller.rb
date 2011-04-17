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
  
  def new_with_po
    @crate = Crate.new
    @po = Po.find_by_code(params[:crate][:po_no])
    @crate.po_no = @po.code
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

end
