class PosController < ApplicationController
  def index
    @pos = Po.paginate(:per_page => 10, :page => params[:page])
  end

  def show
  end

  def new
  end

  def create
  end

end
