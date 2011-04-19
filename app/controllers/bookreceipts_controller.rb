class BookreceiptsController < ApplicationController
  def index
    @bookreceipts = Bookreceipt.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @bookreceipt = Bookreceipt.find(params[:id])
  end
  
  def fetch
    @bookreceipt = Bookreceipt.find_by_book_no(params[:book][:book_no])
    respond_to do |format|
      if @bookreceipt
        flash[:success] = "Fetched Successfully!"
        format.html { redirect_to bookreceipt_path}
        format.xml
      else
        flash[:error] = "Book not Found!"
        format.html { render :index }
        format.xml { render :nothing => true, :status => :not_found }
      end
    end
  end

  def new
    @bookreceipt = Bookreceipt.new
  end

  def create
    @bookreceipt = Bookreceipt.new(params[:bookreceipt])
    respond_to do |format|
      
      if @bookreceipt.save
        puts 'Successfully saved!'
        flash[:success] = "Cataloged Successfully!"
        format.html { redirect_to bookreceipts_path}
        format.xml
      else
        if @bookreceipt.po_no.blank?
          flash[:error] = "Cataloging failure!"
          format.html { render :new }
          format.xml { render :nothing => true, :status => :precondition_failed }
        else
          flash[:error] = "Cataloging failure!"
          format.html { render :new }
          format.xml { render :nothing => true, :status => :conflict }
        end
      end
    end
  end
end
