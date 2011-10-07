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
        if @titlereceipt.error == "Order Quantity Exceeded"
          flash[:error] = "Order quantity exceeded!"
          format.html { render :new }
          format.xml { render :nothing => true, :status => :precondition_failed }
        elsif @titlereceipt.error == "ISBN not found in PO"
          flash[:error] = "Validations failed!"
          format.html { render :new }
          format.xml { render :nothing => true, :status => :not_found }
        else
          # error - invoice is based on po & invoice while , titlereceipts is based only on po
          @pending_cnt = Invoice.of_po_and_invoice(Po.find_by_code(@titlereceipt.po_no).id, @titlereceipt.invoice_no).first.quantity - Titlereceipt.of_po(@titlereceipt.po_no).count
          flash[:success] = "Title Receipt captured successfully!"
          format.html { redirect_to titlereceipts_path}
          format.xml
        end
      else
        flash[:error] = "Some error occured!/Box Capacity Breached"
        format.html { render :new }
        format.xml { render :nothing => true, :status => :not_found }
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
