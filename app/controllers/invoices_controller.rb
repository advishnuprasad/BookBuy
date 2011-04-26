class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def new
    @invoice = Invoice.new
  end
  
  def new_with_supplier
    @invoice = Invoice.new
    @pos = Po.open_pos.find_by_supplier_id(params[:supplier_id])
    @supplier = Supplier.find(params[:supplier_id])
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    if @invoice.save
      flash[:success] = "Save Successfully!"
      redirect_to invoice_path(@invoice.id)
    else
      flash[:error] = "Cataloging failure!"
      render :new
    end
  end

  def regenerate
    @invoice = Invoice.find(params[:id])
    @invoice.regenerate
    redirect_to invoice_path
  end
  
  def autocomplete
    respond_to do |format|
      po_nos = Po.like(params[:q]).collect {|po| po.code}.join(' ')
      format.json { render :json => po_nos.to_json }
    end
  end
end
