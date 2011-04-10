class SuppliersController < ApplicationController
  def index
    @suppliers = Supplier.paginate(:per_page => 10, :page => params[:page])
  end

  def show
  end

  def new
    @supplier = Supplier.new
  end

  def create
  end

  def edit
    @supplier = Supplier.find(params[:id])
  end

  def update
  end

end
