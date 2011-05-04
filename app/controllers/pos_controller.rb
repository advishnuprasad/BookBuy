class PosController < ApplicationController
  def index
    @pos = Po.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @po = Po.find(params[:id])
  end

  def edit
    @po = Po.find(params[:id])
  end
  
  def update
    @po = Po.new(params[:po])
    if @po.save
        flash[:success] = "Po saved successfully!"
        redirect_to pos_path
      else
        flash[:error] = "Po saving failed!"
      end
  end
  
  def fetch_by_po_no
    @po = Po.like(params[:po_no].to_s.gsub(/_/,'/'))
    respond_to do |format|
      unless @po.empty?
        format.html # show.html.erb
        format.xml  { render :xml => @po }
      else
        flash[:error] = "Could not find PO!"
        format.html { render :index }
        format.xml { render :nothing => true, :status => :not_found }
      end
    end
  end
end
