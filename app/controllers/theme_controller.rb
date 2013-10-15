class ThemeController < ApplicationController
  include Decoration::Validation
  helper :firms
  before_filter :city_validate, :only => [:index]
  before_filter :get_browsed_firms, :only => [:index] 
  before_filter :validate_theme_city,  :only => [:index]  #验证是否为宁波或是无锡
  
  def index
    #专题,专访
    promoted_id = [INDEX_PROMOTED[@city_name]['专题'],INDEX_PROMOTED[@city_name]['专访']]
    page = params[:page]
    @themes = PublishContent.search_theme(promoted_id, page)
  end
  
  private
  def validate_theme_city
    @city = params["city"]
    @city_name = TAGURLS[@city.to_i]
    if @city.to_i != 12301 && @city.to_i != 12118
      page_not_found!
      false
    end
  end
end