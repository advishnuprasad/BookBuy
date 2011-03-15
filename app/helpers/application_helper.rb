module ApplicationHelper
  def title
    base_title = "Strata Retail - JustBooks - Procurement"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
