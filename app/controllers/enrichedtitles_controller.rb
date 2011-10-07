class EnrichedtitlesController < ApplicationController
  def index
    @enrichedtitles = []
    unless params[:queryCrateId].blank?
      boxes = Box.find_all_by_crate_id(params[:queryCrateId])
      
      boxes.each do |box|
        Procurementitem.find_all_by_po_number(box.po_no, :include => :enrichedtitle).each do |item|
          @enrichedtitles << item.enrichedtitle
        end
      end
    end    
  end
  
  def edit
    @enrichedtitle = Enrichedtitle.find(params[:id])
  end
  
  def show
    @enrichedtitle = Enrichedtitle.find(params[:id])
  end
  
  def update
    @enrichedtitle = Enrichedtitle.find(params[:id])

    respond_to do |format|
      if @enrichedtitle.update_attributes(params[:enrichedtitle])
        format.html { redirect_to(@enrichedtitle, :notice => 'Enrichedtitle was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @enrichedtitle.errors, :status => :unprocessable_entity }
      end
    end
  end  
end
