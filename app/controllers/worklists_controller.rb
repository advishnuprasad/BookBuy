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
      #publishers = @worklist.workitems.collect {|workitem| workitem.referenceitem.enrichedtitle.publisher.publishername}.uniq
      #@pubsupp = Array.new(publishers.count)[Hash.new]
      #@pubsupp.each do |pub|
        #@worklist.workitems.collect {|workitem| workitem.referenceitem.supplier_id}
      #end
      #render 'items_with_no_supplier_details_publisher_wise'
    end
  end
  
  def save_items_with_no_isbn
    #TODO - Cleanup
    data = params[:data]
    id = params[:id]
    
    result = false
    data.each {|key, value|
      procurementitem = Procurementitem.find(value["id"])
      
      if !value["cancel_reason"].nil? || !value["deferred_by"].nil?
        procurementitem.cancel_reason = value["cancel_reason"] unless value["cancel_reason"].nil?
        procurementitem.deferred_by = value["deferred_by"] unless value["deferred_by"].nil?
        
        if !procurementitem.cancel_reason.nil?
          procurementitem.status = 'Cancelled'
        elsif !procurementitem.deferred_by.nil?
          procurementitem.status = 'Deferred'
        end
        
        if procurementitem.save
          result = true
        end
      else
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
      procurementitem.availability = value["availability"] unless value["availability"].nil?
      procurementitem.cancel_reason = value["cancel_reason"] unless value["cancel_reason"].nil?
      procurementitem.deferred_by = value["deferred_by"] unless value["deferred_by"].nil?
      
      if !procurementitem.cancel_reason.nil?
        procurementitem.status = 'Cancelled'
      elsif !procurementitem.deferred_by.nil?
        procurementitem.status = 'Deferred'
      end
      
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
  
  def save_items_with_no_supplier_details_publisher_wise
    data = params[:data]
    id = params[:id]
    items = Array.new
    
    result = true
    data.each {|key, value|
      procurementitem = Procurementitem.find(value["id"])
      procurementitem.quantity = value["quantity"] unless value["quantity"].nil?
      procurementitem.supplier_id = value["supplier_id"] unless value["supplier_id"].nil?
      procurementitem.availability = value["availability"] unless value["availability"].nil?
      procurementitem.cancel_reason = value["cancel_reason"] unless value["cancel_reason"].nil?
      procurementitem.deferred_by = value["deferred_by"] unless value["deferred_by"].nil?
      
      if !procurementitem.cancel_reason.nil?
        procurementitem.status = 'Cancelled'
      elsif !procurementitem.deferred_by.nil?
        procurementitem.status = 'Deferred'
      end
      
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
      
      procurementitem.cancel_reason = value["cancel_reason"] unless value["cancel_reason"].nil?
      procurementitem.deferred_by = value["deferred_by"] unless value["deferred_by"].nil?
      
      if !procurementitem.cancel_reason.nil?
        procurementitem.status = 'Cancelled'
      elsif !procurementitem.deferred_by.nil?
        procurementitem.status = 'Deferred'
      end
      
      if !procurementitem.save
        result = false
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
      
      procurementitem.cancel_reason = value["cancel_reason"] unless value["cancel_reason"].nil?
      procurementitem.deferred_by = value["deferred_by"] unless value["deferred_by"].nil?
      
      if !procurementitem.cancel_reason.nil?
        procurementitem.status = 'Cancelled'
      elsif !procurementitem.deferred_by.nil?
        procurementitem.status = 'Deferred'
      end
      
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
end
