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
    @titlereceipt.created_by = current_user.id
    
    respond_to do |format|
      if @titlereceipt.save
        @pending_cnt = @titlereceipt.invoice.quantity - @titlereceipt.invoice.received_cnt
        flash[:success] = "Title Receipt captured successfully!"
        format.html { redirect_to titlereceipts_path}
        format.xml
      else
        format.html { render :new }
        format.xml { 
          if @titlereceipt.errors.include?(:procurementitem_id)
            render :nothing => true, :status => :not_found 
          elsif @titlereceipt.errors.include?(:isbn)
            render :nothing => true, :status => :precondition_failed
          elsif @titlereceipt.errors.include?(:invoice_id)
            render :nothing => true, :status => :precondition_failed
          else
            render :nothing => true, :status => :not_found 
          end
        }
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
