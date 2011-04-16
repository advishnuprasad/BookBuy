class TitlereceiptsController < ApplicationController
  def index
    @titlereceipts = Titlereceipt.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @titlereceipt = Titlereceipt.find(params[:id])
  end

  def new
    @titlereceipt = Titlereceipt.new
  end

  def create
    @titlereceipt = Titlereceipt.new(params[:titlereceipt])
    respond_to do |format|
      if @titlereceipt.save
        puts 'Successfully saved!'
        flash[:success] = "Title Receipt captured successfully!"
        format.html { redirect_to titlereceipts_path}
        format.xml
      else
        flash[:error] = "Title Receipt capture failure!"
        format.html { render :new }
        format.xml { render :nothing => true, :status => :precondition_failed }
      end
    end
  end
end
