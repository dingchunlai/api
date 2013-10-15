require_dependency "#{RAILS_ROOT}/app/models/baidu_map"
class BaiduMapController < ApplicationController
  layout false
  
  def index
    city = params[:city]
    keywords =  params[:keywords]
    area =  params[:area]
    @results = city.blank? ? [] : BaiduMap.get(city, area, keywords)
    logger.debug "[BAIDU MAP] #{@results}"
  end

  def to_excel
    headers['Content-Type'] = "application/vnd.ms-excel"  
    headers['Content-Disposition'] = 'attachment; filename="report.xls"'  
    headers['Cache-Control'] = ''
    city = params[:city]
    area = params[:area]
    keywords =  params[:keywords]  
    @results = BaiduMap.get(city, area, keywords)
    render :partial => 'table' , :locals => {:results => @results }
  end

end
