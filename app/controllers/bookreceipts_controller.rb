class BookreceiptsController < ApplicationController
  def index
    @bookreceipts = Bookreceipt.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @bookreceipt = Bookreceipt.find(params[:id])
  end

  def new
    @bookreceipt = Bookreceipt.new
  end

  def create
    @bookreceipt = Bookreceipt.new(params[:bookreceipt])
    respond_to do |format|
      if @bookreceipt.save
        puts 'Successfully saved!'
        flash[:success] = "Cataloged Successfully!"
        format.html { redirect_to bookreceipts_path}
        format.xml
      else
        flash[:error] = "Cataloging failure!"
        format.html { render :new }
        format.xml { render :nothing => true, :status => :precondition_failed }
      end
    end
  end
end
