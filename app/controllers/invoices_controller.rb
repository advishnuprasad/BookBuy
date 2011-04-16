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

  def edit
    @invoice = Invoice.find(params[:id])
  end

  def update
  end

end
