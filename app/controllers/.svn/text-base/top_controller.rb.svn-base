class TopController < ApplicationController
  include Decoration::Validation
  require "redis"
  before_filter :city_validate, :only => [:index]
  #  caches_action :index ,:expires_in => 1.minute
  before_filter :validate_top_city,  :only => [:index]  #验证是否为上海

  def index
    #8万以下
    promoted_8_ids = PromotedFirm.find_by_sql("SELECT * FROM promoted_firms where city=11910 and price=1 and model=0 and style=0 and order_class=1")
    @firms_top_8 = REDIS_DB.zrange("top_ten:firms:8万以下", 0, 9, :with_scores => true)
    @firms_top_8 = type_interact(@firms_top_8.reverse)
    @promoted_8 = []
    if promoted_8_ids.size > 0
      promoted_8_ids[0].firms_id.each do |id|
        @promoted_8 << DecoFirm.find_by_sql("select id, name_abbr, praise from deco_firms where id=#{id}")
      end     
      @firms_top_8.each_with_index do |firm, index|
        @firms_top_8.delete_at(index) if promoted_8_ids[0].firms_id.include?(firm[1])
      end
    end
    @firms_top_8 = @firms_top_8[0, 10-@promoted_8.size]
    #8-15万
    promoted_8_15_ids = PromotedFirm.find_by_sql("SELECT * FROM promoted_firms where city=11910 and price=2 and model=0 and style=0 and order_class=1")
    @firms_top_8_15 = REDIS_DB.zrange("top_ten:firms:8-15万", 0, 9, :with_scores => true)
    @firms_top_8_15 = type_interact(@firms_top_8_15.reverse)
    @promoted_8_15 = []
    if promoted_8_15_ids.size > 0
      promoted_8_15_ids[0].firms_id.each do |id|
        @promoted_8_15 << DecoFirm.find_by_sql("select id, name_abbr, praise from deco_firms where id=#{id}")
      end
      @firms_top_8_15.each_with_index do |firm, index|
        @firms_top_8_15.delete_at(index) if promoted_8_15_ids[0].firms_id.include?(firm[1])
      end
    end
    @firms_top_8_15 = @firms_top_8_15[0, 10-@promoted_8_15.size]
    #15万以上
    promoted_15_ids = PromotedFirm.find_by_sql("SELECT * FROM promoted_firms where city=11910 and price in (3,4,5) and model=0 and style=0 and order_class=1")
    @firms_top_15 = REDIS_DB.zrange("top_ten:firms:15万以上", 0, 9, :with_scores => true)
    @firms_top_15 = type_interact(@firms_top_15.reverse)
    @promoted_15 = []
    if promoted_15_ids.size > 0
      promoted_15_ids.each do |promoted_15_id|
        promoted_15_id.firms_id.each do |id|
          @promoted_15 << DecoFirm.find_by_sql("select id, name_abbr, praise from deco_firms where id=#{id}")
        end
      end
      @promoted_15.uniq!
      @firms_top_15.each_with_index do |firm, index|
        @firms_top_15.delete_at(index) if promoted_8_15_ids[0].firms_id.include?(firm[1])
      end
    end
    @firms_top_15 = @firms_top_15[0, 10-@promoted_15.size]
    #网友关注最多
    @firms_top_attention = REDIS_DB.zrange("top_ten:firms:网友关注最多", 0, 9, :with_scores => true)
    @firms_top_attention = type_interact(@firms_top_attention.reverse)
    #上升最快
    @firms_top_rise = parse_xml(TOP_PROMOTED[@city_name]["上升最快"], ["title"], 10)
    #一周评论最多
    @firms_top_remarks = REDIS_DB.zrange("top_ten:firms:一周评论最多", 0, 9, :with_scores => true)
    @firms_top_remarks = type_interact(@firms_top_remarks.reverse)
    #施工排行
    promoted_construction_ids = PromotedFirm.find_by_sql("SELECT * FROM promoted_firms where except = 0 AND district = 0 AND model = 0 AND style = 0 AND price = 0  AND order_class = 3 AND city = 11910")
    @firms_top_construction_praise = REDIS_DB.zrange("top_ten:firms:施工排行", 0, 9, :with_scores => true)
    @firms_top_construction_praise = type_interact(@firms_top_construction_praise.reverse)
    @promoted_construction = []
    if promoted_construction_ids.size > 0
      promoted_construction_ids[0].firms_id.each do |id|
        @promoted_construction << DecoFirm.find_by_sql("select id, name_abbr, praise from deco_firms where id=#{id}")
      end
      @firms_top_construction_praise.each_with_index do |firm, index|
        @firms_top_construction_praise.delete_at(index) if promoted_construction_ids[0].firms_id.include?(firm[1])
      end
    end
    @firms_top_construction_praise = @firms_top_construction_praise[0, 10-@promoted_construction.size]
    #地区排行榜
    @firms_top_areas = []
    @promoted_top_areas = []
    ["徐汇","普陀","黄浦","闵行","静安","杨浦","长宁","卢湾","浦东"].each do |area|
      promoted_area_ids = PromotedFirm.find_by_sql("SELECT * FROM promoted_firms where city=11910 and district=#{DISTRICTS.index(area)} and price=0 and model=0 and style=0 and order_class=1")
      @firms_top_area_pv = REDIS_DB.zrange("top_ten:firms:区域:#{area}", 0, 9, :with_scores => true)
      @firms_top_area_pv = type_interact(@firms_top_area_pv.reverse)
      @promoted_area = []
      if promoted_area_ids.size > 0
        promoted_area_ids[0].firms_id.each do |id|
          @promoted_area << DecoFirm.find_by_sql("select id, name_abbr, pv_count from deco_firms where id=#{id}")
        end
        @firms_top_area_pv.each_with_index do |firm, index|
          @firms_top_area_pv.delete_at(index) if promoted_area_ids[0].firms_id.include?(firm[1])
        end
      end
      @firms_top_area_pv = @firms_top_area_pv[0, 10-@promoted_area.size]
      @promoted_top_areas << @promoted_area
      @firms_top_areas << @firms_top_area_pv
    end
  end

  def type_interact(array)
    new_array = Array.new
    n = 0
    while array[n]
      new_array << array[n,2]
      n += 2
    end
    return new_array
  end

  private
  def validate_top_city
    @city = params["city"]
    @city_name = TAGURLS[@city.to_i]
    if @city.to_i != 11910
      page_not_found!
      false
    end
  end
end