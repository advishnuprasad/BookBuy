class DashboardController < ApplicationController
  def show
    if params[:current_branch].blank?
      user_session['current_branch'] = Branch.branch_from_subdomain(current_user.subdomain)
    else
      user_session['current_branch'] = Branch.find(params[:current_branch].to_i)
    end
    @associate_branches = Branch.associate_branches(current_user.subdomain)
  end
end
