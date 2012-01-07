class EnrichedtitlesController < ApplicationController
  def index
    unless params[:queryISBN].blank?
      @enrichedtitle = Enrichedtitle.find_by_isbn(params[:queryISBN])
      respond_to do |format|
        unless @enrichedtitle.nil?
          format.html {render "show"}
          format.js {render :json => @enrichedtitle}
        else
          format.html {redirect_to :action => 'new', :isbn => params[:queryISBN]}
          format.js {head :not_found}
        end
      end
    end
  end
  
  def edit
    @enrichedtitle = Enrichedtitle.find(params[:id])
  end
  
  def create
    @enrichedtitle = Enrichedtitle.new(params[:enrichedtitle])

    if @enrichedtitle.save
      redirect_to(@enrichedtitle, :notice => 'Title was successfully created.')
    else
      render :action => "new"
    end
  end
  
  def new
    @isbn = params[:isbn]
    @enrichedtitle = Enrichedtitle.new_from_web(@isbn)
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
