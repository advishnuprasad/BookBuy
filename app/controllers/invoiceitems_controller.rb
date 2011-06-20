class InvoiceitemsController < ApplicationController
  # GET /invoiceitems
  # GET /invoiceitems.xml
  def index
    invoice_id = params[:invoice_id]
    @invoiceitems = Invoiceitem.find_all_by_invoice_id(invoice_id)
    @invoice = Invoice.find(invoice_id)
    if !params[:error].blank? and !params[:error].nil?
      flash[:error] = params[:error]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoiceitems }
    end
  end

  # GET /invoiceitems/1
  # GET /invoiceitems/1.xml
  def show
    @invoiceitem = Invoiceitem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invoiceitem }
    end
  end

  # GET /invoiceitems/new
  # GET /invoiceitems/new.xml
  def new
    @invoiceitem = Invoiceitem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invoiceitem }
    end
  end

  # GET /invoiceitems/1/edit
  def edit
    @invoiceitem = Invoiceitem.find(params[:id])
  end

  # POST /invoiceitems
  # POST /invoiceitems.xml
  def create
    @invoiceitem = Invoiceitem.new(params[:invoiceitem])

    respond_to do |format|
      if @invoiceitem.save
        format.html { redirect_to(@invoiceitem, :notice => 'Invoiceitem was successfully created.') }
        format.xml  { render :xml => @invoiceitem, :status => :created, :location => @invoiceitem }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invoiceitem.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invoiceitems/1
  # PUT /invoiceitems/1.xml
  def update
    @invoiceitem = Invoiceitem.find(params[:id])

    respond_to do |format|
      if @invoiceitem.update_attributes(params[:invoiceitem])
        format.html { redirect_to(@invoiceitem, :notice => 'Invoiceitem was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoiceitem.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invoiceitems/1
  # DELETE /invoiceitems/1.xml
  def destroy
    invoice_id = params[:invoice_id]
    Invoiceitem.destroy_all(:invoice_id => invoice_id)
    @invoice = Invoice.find(invoice_id)
    respond_to do |format|
      format.html { redirect_to(invoice_path(@invoice)) }
      format.xml  { head :ok }
    end
  end
end
