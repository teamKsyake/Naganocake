class SearchController < ApplicationController
  before_action :authenticate_admin!
  
  def search
    @model = params["search"]["model"]
    @content = paramas["search"]["content"]
    @method = params["search"]["method"]
    @datas = search_for(@model, @content, @method).order(:id).page(params[:page])
  end 
end
