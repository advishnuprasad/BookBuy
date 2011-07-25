class PosController < ApplicationController
  def index
    filter = params[:filter]
    filter ||= 'all'
    if filter == 'for_procurement'
      if params[:procurement_id]
        @pos = Po.of_procurement(params[:procurement_id]).paginate(:per_page => 100, :page => params[:page])
      else
        @pos = Po.paginate(:per_page => 100, :page => params[:page])
      end
    else
      @pos = Po.paginate(:per_page => 100, :page => params[:page])
    end
    
    breadcrumbs.add 'POs'
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @procurementitems }
    end    
  end

  def show
    @po = Po.find(params[:id])
    
    breadcrumbs.add 'POs', pos_path
    breadcrumbs.add @po.id

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @po }
    end
  end

  def edit
    @po = Po.find(params[:id])
    
    breadcrumbs.add 'POs', pos_path
    breadcrumbs.add @po.id
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
