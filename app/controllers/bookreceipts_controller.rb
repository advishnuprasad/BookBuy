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
    @bookreceipt.created_by = current_user.id
    
    respond_to do |format|      
      if @bookreceipt.save
        puts 'Successfully saved!'
        flash[:success] = "Cataloged Successfully!"
        format.html { redirect_to bookreceipts_path}
        format.xml
      else
        if @bookreceipt.errors.count > 0 && @bookreceipt.errors.values.join("").include?("already been used")
          flash[:error] = "Cataloging failure!"
          format.html { render :new }
          format.xml { render :nothing => true, :status => :conflict }
        else
          flash[:error] = "Cataloging failure!"
          format.html { render :new }
          format.xml { render :nothing => true, :status => :precondition_failed }
        end
      end
    end
  end
  
  # DELETE /bookreceipts/1
  # DELETE /bookreceipts/1.xml
  def destroy
    @bookreceipt = Bookreceipt.find(params[:id])
    @bookreceipt.destroy

    respond_to do |format|
      format.html { redirect_to(bookreceipts_url) }
      format.xml  { head :ok }
    end
  end
end
