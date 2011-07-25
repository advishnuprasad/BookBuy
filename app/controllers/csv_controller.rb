require 'csv'
class CsvController < ApplicationController
  def import
    invoice_id = params[:invoice_id]
    @invoice = Invoice.find(invoice_id)
    @csvdata  = CsvStage.find_all_by_invoice_id(invoice_id)
    @csv_error_count = CsvStage.find(:all, :conditions => ['invoice_id = ? AND ltrim(rtrim(error)) != ?',invoice_id, ' ']).size
    invoiceitems = Invoiceitem.find_all_by_invoice_id(invoice_id)
    if invoiceitems.size > 0 
      flash[:error] = "Invoice details already exists"  
    end
  end
  
  
  def upload
    # While under development, just respond by rendering some in-line text.
    # Send back the request parameters in JSON (JavaScript Object Notation)
    # format, i.e. something reasonably easy to parse with the human eye.
    
    invoice_id = params[:upload][:invoice_id]
    @invoice = Invoice.find(invoice_id)
    user_id = params[:upload][:user_id]
    invoiceitems = Invoiceitem.find_all_by_invoice_id(invoice_id)
    if invoiceitems.size > 0 
      flash[:error] = "Invoice details already exists"  
    else
      CsvStage.destroy_all(:invoice_id => invoice_id)
      row_index = 0
      data = params[:upload][:csv].read
      i = 0
      CSV.parse(data) do |rows|
        if i > 0 
          table = CsvStage.new 
          table.invoice_id = invoice_id
          
          table.isbn = rows[0]
          table.author = rows[1]
          table.title = rows[2]
          table.publisher = rows[3]
          table.quantity = rows[4].to_i
          table.unit_price = rows[5]
          table.unit_price_inr = rows[6]
          table.currency = rows[7]
          table.conv_rate = rows[8]
          table.discount = rows[9]
          table.net_amount = rows[10]
          if @invoice.nls_invoice?
            table.nls_title = rows[11]
            table.language = rows[12]
            table.nls_author = rows[13]
          end
          table.user_id = user_id
          table.save
        end
        i+=1
      end
    end
    
    #redirect_to invoices_path
    redirect_to :action=> :import, :controller=>:csv ,  :invoice_id => invoice_id
  end
end
