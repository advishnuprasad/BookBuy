class PublishersController < ApplicationController
  respond_to :html, :js
  
  def index
    @publishers = Publisher.paginate(:per_page => 10, :page => params[:page])
  end

  def show
  end

  def new
    @publisher = Publisher.new
    3.times { @publisher.supplierdiscounts.build }
  end

  def create
  end

  def edit
    @publisher = Publisher.find(params[:id])
    3.times {@publisher.supplierdiscounts.build}
  end

  def update
  end

end
