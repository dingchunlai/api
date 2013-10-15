class StatisticsController < ApplicationController
  
  def index
    @statistic = Statistic.new(:code => params[:code],:style => params[:style], :source => params[:source])
    if @statistic.save
      render :text => "success!"
    else
      render :nothing => true, :status => 204
    end
  end
end
