class MatchingtitlesController < ApplicationController
  def index
    @matchingtitles = Matchingtitle.paginate(:per_page => 1, :page => params[:page])
  end
  
  def edit
    @matchingtitle = Matchingtitle.find(params[:id])
  end
  
  def update
    @matchingtitle = Matchingtitle.find(params[:id])

    respond_to do |format|
      if @matchingtitle.update_attributes(params[:matchingtitle])
        flash.now[:notice] = 'Successfully Updated'
        format.js   { render }
      else
        flash.now[:notice] = 'Error while updating!'
        format.js   { render }
      end
    end
  end    
end