class WorklistsController < ApplicationController
  respond_to :html, :js
  
  def index
    @worklists = Worklist.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @worklist = Worklist.find(params[:id])
    if @worklist.description == "Procurement Items with Invalid ISBN"
      render 'items_with_invalid_isbn'
    elsif @worklist.description == "Procurement Items with Details Not Verified"
      render 'items_with_details_not_enriched'
    elsif @worklist.description == "Procurement Items with No ISBN"
      render 'items_with_no_isbn'
    elsif @worklist.description == "Procurement Items with No Supplier Details"
      render 'items_with_no_supplier_details'
    end
  end
  
  def save_items_with_no_isbn
    #TODO - Cleanup
    data = params[:data]
    id = params[:id]
    
    result = false
    data.each {|key, value|
      procurementitem = Procurementitem.find(value["id"])
      
      unless value["isbn"].nil?
        enrichedtitle = Enrichedtitle.new
        enrichedtitle.isbn = value["isbn"].gsub(/-/,'').gsub(/ /,'')
        enrichedtitle.title_id = procurementitem.title.id unless procurementitem.title.nil?
        enrichedtitle.title = procurementitem.title.title unless procurementitem.title.nil?
        enrichedtitle.author = procurementitem.title.author.name unless procurementitem.title.nil?
        enrichedtitle.language = procurementitem.title.language unless procurementitem.title.nil?
        enrichedtitle.category = procurementitem.title.category.name unless procurementitem.title.nil? || procurementitem.title.category.nil?
        enrichedtitle.isbn10 = procurementitem.title.isbn10 unless procurementitem.title.nil?
        if enrichedtitle.save
          procurementitem.enrichedtitle_id = enrichedtitle.id
          procurementitem.isbn = enrichedtitle.isbn
          if procurementitem.save        
            if Enrichedtitle.validate(procurementitem.enrichedtitle.id, procurementitem.enrichedtitle.isbn)
              result = true
            end
          end
        end
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
  
  def save_items_with_po_not_generated
    data = params[:data]
    id = params[:id]
    items = Array.new
    
    result = true
    data.each {|key, value|
      procurementitem = Procurementitem.find(value["id"])
      procurementitem.quantity = value["quantity"] unless value["quantity"].nil?
      procurementitem.supplier_id = value["supplier_id"] unless value["supplier_id"].nil?
      
      if !procurementitem.save
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
  
  def save_items_with_no_supplier_details
    data = params[:data]
    id = params[:id]
    items = Array.new
    
    result = true
    data.each {|key, value|
      procurementitem = Procurementitem.find(value["id"])
      procurementitem.quantity = value["quantity"] unless value["quantity"].nil?
      procurementitem.supplier_id = value["supplier_id"] unless value["supplier_id"].nil?
      
      if !procurementitem.save
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
  
  def save_items_with_details_not_enriched
    data = params[:data]
    id = params[:id]
    items = Array.new
    
    result = true
    data.each {|key, value|
      procurementitem = Procurementitem.find(value["id"])
      enrichedtitle = procurementitem.enrichedtitle
      enrichedtitle.title = value["title"] unless value["title"].nil?
      enrichedtitle.author = value["author"] unless value["author"].nil?
      enrichedtitle.verified = value["verified"] unless value["verified"].nil?
      enrichedtitle.price = value["price"] unless value["price"].nil?
      if !value["publisher"].nil?
        publisher = Publisher.find_by_code(enrichedtitle.publisher.code)
        publisher.name = value["publisher"]
        publisher.save
      end
      
      if !enrichedtitle.save
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
  
  def save_items_with_invalid_isbn
    data = params[:data]
    id = params[:id]
    items = Array.new
    
    result = true
    data.each {|key, value|
      procurementitem = Procurementitem.find(value["id"])
      unless value["isbn"].nil?
        unless Enrichedtitle.validate(procurementitem.enrichedtitle.id, value["isbn"].gsub(/-/,'').gsub(/ /,''))
          result = false
        end
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
