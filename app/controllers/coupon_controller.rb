#优惠券列表页
class CouponController < ApplicationController
  include Decoration::Validation #得到当前的城市
  before_filter :city_validate, :only => [:index]
  
  def index
    
    @page = params[:page] ||= 1
    @city = params[:city]
    @city_name = CITIES[@city.to_i]
    @firm = params[:firm]
    @title = params[:title]
    @date = params[:date]
    
    #暂时不做缓存
#		DecoEvent	
#    @coupons = CACHE.fetch("coupon/list/#{@city}/#{@firm}/#{@title}/#{@date}/#{@page}",1.hours) do
      city_condition = @city.to_i == 11910 ? "select id from deco_firms where city = #{@city}" : "select id from deco_firms where district = #{@city}" 
      firm_condition = @firm.nil? ? city_condition : "#{city_condition} and deco_firms.name_abbr like '%#{@firm}%'" 
      conditions = []
      conditions << "deco_events_firms.firm_id in (#{firm_condition})"
      conditions << "deco_events.title like '%#{@title}%'" if !@title.nil?
      case @date.to_i
      when 1 #前三天
        conditions << "deco_events.created_at > '#{3.days.ago.to_s(:db)}'"
      when 2 #前一周
        conditions << "deco_events.created_at > '#{1.weeks.ago.to_s(:db)}'"
      when 3 #前一个月
        conditions << "deco_events.created_at > '#{1.month.ago.to_s(:db)}'"
      when 4 #前三个月
        conditions << "deco_events.created_at > '#{3.month.ago.to_s(:db)}'"
      end
      conditions << "deco_events.ends_at > '#{Time.now.strftime('%Y-%m-%d')}'"
      
      @coupons = DecoEvent.paginate(:all,
       :joins => "deco_events join deco_events_firms on deco_events.id = deco_events_firms.event_id",
       :conditions => conditions.join(' and '),
       :page => @page,
       :per_page => 6,
       :order => 'deco_events.created_at desc'
     )
#    end  
  end

end