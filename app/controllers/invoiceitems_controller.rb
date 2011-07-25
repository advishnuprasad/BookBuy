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
  
  def save
    invoice_id = params[:invoice_id]
    @invoice = Invoice.find(invoice_id)
    user_id = params[:user_id]
    csvdata  = CsvStage.find_all_by_invoice_id(invoice_id)
    csv_error_count = CsvStage.find(:all, :conditions => ['invoice_id = ? AND ltrim(rtrim(error)) != ?',invoice_id, ' ']).size
    invoiceitems = Invoiceitem.find_all_by_invoice_id(invoice_id)
    if invoiceitems.size > 0  or csv_error_count > 0
      flash[:error] = "Invoice details already exists or csv has error"  
    else  
      csvdata.each do |csv|
        invoice_item = Invoiceitem.new
        invoice_item.copy_data(csv, current_user.id)
        if !invoice_item.save
          err_msg = ''
          if invoice_item.errors.any?
            invoice_item.errors.full_messages.each do |msg|
              err_msg = msg 
            end
          end
          flash[:error] = "failed to save invoice details("+invoice_item.isbn+"): "+err_msg
          break
        end
      end
    end
    redirect_to invoiceitems_url(:invoice_id => invoice_id, :error => flash[:error] )
  end
  
end
