class PosController < ApplicationController
  def index
    @pos = Po.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @po = Po.find(params[:id])
  end

  def edit
    @po = Po.find(params[:id])
  end
  
  def update
    @po = Po.new(params[:po])
    if @po.save
        flash[:success] = "Po saved successfully!"
        redirect_to pos_path
      else
        flash[:error] = "Po saving failed!"
      end
  end
end
