class WorklistsController < ApplicationController
  respond_to :html, :js
  
  def index
    @worklists = Worklist.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @worklist = Worklist.find(params[:id])
  end
  
  def save_items
    data = params[:data]
    id = params[:id]
    items = Array.new
    
    result = true
    puts data.to_s
    data.each {|key, value|
      procurementitem = Procurementitem.find(value["id"])
      if !procurementitem.update_attributes(:avl_quantity => value["quantity"])
        result = false
      end
    }
    
    if result == true
      flash[:success] = "Items have been Successfully Updated!"
    else
      flash[:error] = "Items updation failed!"
    end
    
    respond_to do |format|
      format.js
    end
  end
end
