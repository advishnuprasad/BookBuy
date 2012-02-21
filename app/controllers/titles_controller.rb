class TitlesController < ApplicationController
  def index
    @search_text = params[:search_text]
    @search_type = params[:search_type] || "T"
    @use_similarity = params[:use_similarity]
    @similarity_score = params[:similarity_score]

  end
end