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
  
  def fetch_by_invoice_no
    po = Po.like(params[:po_no].to_s.gsub(/_/,'/'))
    if po[0]
      @invoice = Invoice.find_by_po_id_and_invoice_no(po[0].id, params[:invoice_no].to_s.gsub(/_/,'/'))
    end
    respond_to do |format|
      unless @invoice.nil?
        format.html # show.html.erb
        format.xml  { render :xml => @invoice }
      else
        flash[:error] = "Could not find invoice!"
        format.html { render :index }
        format.xml { render :nothing => true, :status => :not_found }
      end
    end
  end
end
