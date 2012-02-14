class NoisbntitlesController < ApplicationController
  def index
    @noisbntitles = Noisbntitle.all
  end
  
  def create
    @noisbntitle = Noisbntitle.new(params[:noisbntitle])

    if @noisbntitle.save
      redirect_to(@noisbntitle, :notice => 'Title was successfully created.')
    else
      render :action => "new"
    end
  end
  
  def new
    @noisbntitle = Noisbntitle.new_from_title(params[:title_id])
  end  
  
  def show
    @noisbntitle = Noisbntitle.find(params[:id])
  end
  
  def edit
    @noisbntitle = Noisbntitle.find(params[:id])
  end
  
  def update
    @noisbntitle = Noisbntitle.find(params[:id])

    if @noisbntitle.update_attributes(params[:noisbntitle])
      flash[:success] = 'Successfully updated.'
      redirect_to(@noisbntitle) 
    else
      render :action => "edit"
    end
  end  
end