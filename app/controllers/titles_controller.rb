class TitlesController < ApplicationController
  def index
    @titles = Title.paginate(:page => params[:page], :per_page => 15)
  end
end