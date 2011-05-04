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
        flash[:success] = "Title Receipt captured successfully!"
        format.html { redirect_to titlereceipts_path}
        format.xml
      else
        #TODO - is there a better way of doing this??
        if @titlereceipt.errors[:po_no].first && @titlereceipt.errors[:po_no].first.include?("order quantity")
          flash[:error] = "Order quantity exceeded!"
          format.html { render :new }
          format.xml { render :nothing => true, :status => :precondition_failed }
        else
          flash[:error] = "Validations failed!"
          format.html { render :new }
          format.xml { render :nothing => true, :status => :not_found }
        end
      end
    end
  end
  
  # DELETE /titlereceipts/1
  # DELETE /titlereceipts/1.xml
  def destroy
    @titlereceipt = Titlereceipt.find(params[:id])
    @titlereceipt.destroy

    respond_to do |format|
      format.html { redirect_to(titlereceipts_url) }
      format.xml  { head :ok }
    end
  end
end
