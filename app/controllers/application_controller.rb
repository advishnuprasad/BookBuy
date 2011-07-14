class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :add_initial_breadcrumbs

  private
  def add_initial_breadcrumbs
    breadcrumbs.add 'Home', root_path
  end
end
