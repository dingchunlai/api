class DecoFirm < Hejia::Db::Hejia
#  acts_as_readonlyable [:read_only_51hejia]
  has_many :deco_firm_branches
  
  
  has_attached_file :logo, :styles => { :thumb => "95x60>", :medium => "120x120" },
    :path => ":rails_root/public/decos/:class/:attachment/:id/:basename_:style.:extension",
    #:url => "/decos/:class/:attachment/:id/:basename_:style.:extension",
  :url => "http://image.51hejia.com/files/companylogo/:basename.:extension",
    :default_url => "http://www.51hejia.com/css/prozhuangxiu/photoshop.gif"
  has_attached_file :budget,
    :path => ":rails_root/public/decos/:class/:attachment/:id/:basename.:extension",
    :url => "/decos/:class/:attachment/:id/:basename.:extension"
  
  #  include GeoKit::Geocoders
  #  validates_presence_of :lat, :lng
  acts_as_mappable
  
  has_many :diaries, :class_name => "DecoDiary", :foreign_key => "firm_id"
  has_many :factories, :class_name => "CaseFactoryCompany", :conditions => ["ENDENABLE>? or STARTENABLE>?", Time.now.to_s(:db), Time.now.to_s(:db)] , :foreign_key => "COMPANYID"
  
  
  # :resource_type => DecoFirm  :resource_id => firm_id
  
  
  has_and_belongs_to_many :api_events, :class_name => "DecoEvent",
    :conditions => ["ends_at >= ?", Time.now.to_s(:db)],
    :join_table => "deco_events_firms",
    :foreign_key => "firm_id",
    :association_foreign_key => "event_id",
    :uniq => true,
    :order => "LIST_INDEX"
  
  
  belongs_to :areatag,:class_name => "HejiaTag",:foreign_key => "district"
  
  
  SPACE_NAMES = SPACE.inject({}) { |h, (k, v)| h[v] = k; h }
  def total_satisfied
    total = (verysatisfied || 0) + (satisfied || 0) + (unsatisfied || 0)
    total == 0 ? 100 : total
  end
  
  def verysatisfied_percent
    (((verysatisfied || 0).to_f/total_satisfied.to_f)*10000).to_i/100.to_f
  end
  
  def satisfied_percent
    (((satisfied || 0).to_f/total_satisfied.to_f)*10000).to_i/100.to_f
  end
  
  def unsatisfied_percent
    (((unsatisfied || 0).to_f/total_satisfied.to_f)*10000).to_i/100.to_f
  end
  
  def total_photos
    (photos_count || 0) + (cases_count || 0) + (designers_count || 0)
  end
  
  def self.getcase(id)
    key = "photo_case_company3_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
    c= []
    if CACHE.get(key).nil?
      c = Case.find(:all,:select => "ID,NAME",:conditions=>"STATUS != '-100' and ISNEWCASE=1 and TEMPLATE != 'room' and ISZHUANGHUANG='1' and ISCOMMEND='0' and COMPANYID=#{id}",:order=>"ID DESC",:limit=>6)
      CACHE.set(key, c)
    else
      c = CACHE.get(key)
    end
    return c
  end
  
  def self.getdesigner(id)
    key = "photo_designer_company_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
    d = []
    if CACHE.get(key).nil?
      d = CaseDesigner.find(:all,:conditions=>"STATUS != '-100' and COMPANY=#{id}",:limit=>4,:order=>"ID DESC")
      CACHE.set(key, d)
    else
      d = CACHE.get(key)
    end
    return d
  end
  
  def self.getfirm(id)
    CACHE.fetch("firms/id/#{id}", RAILS_ENV == 'production' ? 1.hour : 1) do
      find_by_id(id,:include=>:pictures) 
    end
  end
  
  def self.get_all_firm(id)
    Picture
    CACHE.fetch("firms/id/#{id}", 1.hour) do
      find_all_by_id(id,:include=>:pictures) 
    end
  end
  
  def self.getseofirmphoto(id)
    DecoPhoto
    key = "zhaozhuangxiu_photo_seo_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
    result = nil
    if CACHE.get(key).nil?
      c = find(id)
      result = c.photos
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end
  
  def self.getseocasecompany
    key = "zhaozhuangxiu_case_company_seo_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    if CACHE.get(key).nil?
      result = find(:all, :limit => 10, :order => "cases_count desc")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end  
  
  def self.getseodesigncompany
    key = "zhaozhuangxiu_design_company_seo_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    if CACHE.get(key).nil?
      result = find(:all, :limit => 10, :order => "design_score desc")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end  
  
  def self.getseokoubeicompany
    key = "zhaozhuangxiu_koubei_company_seo3_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    if CACHE.get(key).nil?
      result = find(:all, :limit => 10,:conditions=>"city = 11910" , :order => "praise desc")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end  
  #  
  def self.get_deco_firms(name,city,area)
    key = "zhaozhuangxiu1_get_deco_firms_#{Time.now.strftime('%Y%m%d%H')}_#{name}_#{city}_#{area}_3"
    result = nil
    conditions = []
    conditions << "state is not null and state<>'-100' and state<>'-99'" 
    conditions << "name_zh like '%#{name}%'" if name && name != ''
    conditions << "city=#{city}" if city && city != '0'
    conditions << "district=#{area}" if area && area != '0'
    if CACHE.get(key).nil?
      result = find(:all,:select => "id,name_zh",:conditions=>conditions.join(" and ") ,:order => "is_cooperation desc,total_score desc")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end
  
  def self.get_deco_firm_by_name(name)
    n = name.gsub(" ","")
    key = "zhaozhuangxiu_get_deco_firm_by_name_#{Time.now.strftime('%Y%m%d%H')}_#{n}1"
    result = nil
    conditions = []
    conditions << "state is not null and state <> '-100'" 
    conditions << "name_zh like'%#{name}%'" if name && name != ''
    if CACHE.get(key).nil?
      result = find(:all,:conditions=>conditions.join(" and ") ,:order => "total_score desc")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end
  
  def self.getcase_company(id)
    key = "zhaozhuangxiu_company_case_company3_#{Time.now.strftime('%Y%m%d%H')}_#{id}1"
    c= []
    if CACHE.get(key).nil?
      c = Case.find(:all,:select => "ID,NAME,COMPANYID",:conditions=>"STATUS != '-100' and ISNEWCASE=1 and TEMPLATE != 'room' and ISZHUANGHUANG='1' and ISCOMMEND='0' and COMPANYID=#{id}",:order=>"ID DESC",:limit=>10)
      CACHE.set(key, c)
    else
      c = CACHE.get(key)
    end
    return c
  end
  def self.get_designer_by_compay(companyid)
    dsql = "select d.* from HEJIA_DESIGNERMODEL d,HEJIA_CASE c where d.COMPANY=#{companyid} and c.DESIGNERID=d.ID and c.STATUS != '-100' and c.ISNEWCASE=1 and c.TEMPLATE != 'room' and c.ISZHUANGHUANG='1' and c.ISCOMMEND='0' group by d.ID"
    dsnkey = "zhaozhuangxiu1_dsnkey_#{companyid}_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(dsnkey).nil?
      dsn = CaseDesigner.find_by_sql(dsql)
      CACHE.set(dsnkey, dsn)
    else
      dsn = CACHE.get(dsnkey)
    end
    return dsn
  end

  def increase_pv!
    if defined?(REDIS_DB)
      REDIS_DB.incr pv_cache_key
    else
      self.pv_count += 1
      self.class.update_all({:pv_count => pv_count}, :id => id)
    end
  end
  
  def remarks_count
    read_attribute(:remarks_count).to_i <= 0 ? 0 : read_attribute(:remarks_count).to_i
  end

  def pv_count
    if defined?(REDIS_DB)
      _pv_count = REDIS_DB.get(pv_cache_key).to_i
      if _pv_count < 1
        _pv_count = read_attribute(:pv_count) || 0 if _pv_count < 1
        REDIS_DB.set pv_cache_key, _pv_count
      end
      _pv_count
    else
      read_attribute(:pv_count)
    end
  end

  def pv_cache_key
    @pv_cache_key ||= "test_analytic_zhaozhuangxiu_company_about_key_d_#{id}"
  end
  private :pv_cache_key
  
  
  # memcached_firm_five_diary
  # return DecorationDiary_Array
  def cache_5_diary_master_images
    DecorationDiary
    CACHE.fetch("/deco_firms/#{id}/cache_5_diary_master_images!", 3.hour) do
      decoration_diaries.find(:all, :limit => 5, :order => "created_at desc")
    end
  end

  # TODO 加注释
  def self.find_by_tags(city, tag_name, value, quanlity)
    city = city.to_i
    conditions = ['deco_firms.is_cooperation = 1'] # 只找合作公司的
    params = {}

    if city == 11910
      conditions << 'deco_firms.city = :city'
    else
      conditions << 'deco_firms.district = :city'
    end
    params[:city] = city

    conditions << "deco_firms.state <> '-99'"
    conditions << "deco_firms.state <> '-100'"

    if city == 11910 && tag_name.to_s == "price" && value == 3
      tiao_jian = "deco_firms.#{tag_name} in (:value)"
      params[:value] = [3, 4, 5, 6]
    else
      tiao_jian = "deco_firms.#{tag_name} = :value"
      params[:value] = value
    end
    
    DecoFirm.find(
      :all,
      :conditions => [(conditions + [tiao_jian]).join(' and '), params],
      :order => 'deco_firms.praise desc',
      :limit => quanlity
    )
  end
  
  # index/home/firms_promoted/#{city}/#{price}/top8
  # params[:city] 城市编号
  # params[:price] 公司价位
  # params[:number] 查询公司数量
  # return firms_Array
  def self.index_home_city_price_firms(city, price, number)
    CACHE.fetch("api/index/home/firms/city_price_firms/#{city}/#{price}/#{number}", RAILS_ENV == 'development' ? 1 : 15.minutes) do
      find_by_tags(city, :price, price, number)
    end
  end
  
  # index/home/firms_promoted/#{city}/#{style}/top8
  # params[:city] 城市编号
  # params[:style] 公司风格
  # params[:number] 提起公司数量
  # return firms_Array
  def self.index_home_city_style_firms(city, style, number)
    CACHE.fetch("api/index/home/firms/city_style_firms/#{city}/#{style}/#{number}", RAILS_ENV == 'development' ? 1 : 15.minutes) do
      find_by_tags(city, :style, style, number)
    end
  end
  
  #pv top10
  def self.focus_top_10(city)
    CACHE.fetch("home/top/#{city}/focus_top",10.minutes) do
      DecoFirm.find(:all,:order=>"is_cooperation desc , pv_count desc",
        :conditions=>["city='11910' and id in(select deco_firm_id from decoration_diaries where status = 1 and deco_firm_id is not null) "],:limit=>10)
    end
  end
  
  #查找公司所有日记中pv最高的日记的主图
  def max_pv_diary_master_picture
    CACHE.fetch("api/firms/max_pv_diary_master_picture/#{self.id}",5.minutes) do
      begin_date = 1.days.ago.at_beginning_of_day.to_s(:db)
      end_date = Time.now.at_beginning_of_day.to_s(:db)
      if self.decoration_diaries.count > 0
        diary = self.decoration_diaries.find(:first,:conditions=> ["created_at >= ? and created_at <= ? and is_good = 1" ,begin_date , end_date ] ,:order=>"pv desc")
        if diary.nil?
          diary = self.decoration_diaries.find(:first,:order=>"pv desc")
        end
      end
      diary.master_picture
    end
  end
  
  # yesterday_remarks_tiptop
  # params[:city] 城市编号
  # return firms_Array
  def self.latest_7_days_firms_remarks_top(city)
    CACHE.fetch("/firms/latest_7_days_firms_remark_top/#{city}", 5.minute) do
      begin_date = 7.days.ago.to_s(:db)
      end_date = Time.now.at_beginning_of_day.to_s(:db)
      
      sql = "select a.id, a.name_abbr , b.comments_count, a.city  from deco_firms a inner join "
      sql.concat "(select resource_id,count(resource_id) as comments_count "
      sql.concat "from remarks where created_at >= '#{begin_date}' and user_id is not null and resource_type ='DecoFirm' group by resource_id "
      sql.concat "order by count(resource_id) desc)b on a.id = b.resource_id where "
      sql.concat "a.id in(select deco_firm_id from decoration_diaries where status = 1 and deco_firm_id is not null) and "
      city.to_i == 11910 ? sql.concat("a.city = 11910 ") : sql.concat("a.district = #{city} ")
      sql.concat "limit 10;"
      DecoFirm.find_by_sql(sql)
    end
  end
 
  #一周内发表日记最多的公司
  def self.city_week_firms_diaryies_top10 city
    CACHE.fetch("firms/week_firms_diaryies/top10/#{city}" , 1.hours) do
      begin_date = 7.days.ago.strftime("%Y-%m-%d 00:00:00")
      end_date = Time.now.at_beginning_of_day.to_s(:db)
      sql = ''
      sql.concat("SELECT deco_firms.* FROM decoration_diaries ,deco_firms where deco_firms.id = decoration_diaries.deco_firm_id and ")
      sql.concat(city.to_i == 11910 ? "deco_firms.city = #{city} and " : "deco_firms.district = #{city} and ")
      sql.concat("decoration_diaries.status = 1 and (deco_firms.state <> '-99' or deco_firms.state <> '-100') ")
      sql.concat "and decoration_diaries.created_at > '#{begin_date}' and decoration_diaries.created_at < '#{end_date}' "
      sql.concat("group by decoration_diaries.deco_firm_id ")
      sql.concat "order by count(decoration_diaries.deco_firm_id) desc ,deco_firms.praise asc limit 10"
      DecoFirm.find_by_sql(sql)
    end
  end
 
  
  #昨天发表日记最多的公司(上海地区的条件：is_cooperation=1,rand(),limit 3,还有确保留言>=3）
  def self.city_yesterday_firms_diaries_tiptop city
    CACHE.fetch("/firms/yesterday_firms_diaries/top3/#{city}", RAILS_ENV != 'production' ? 1 : 1.hours) do
      begin_date = 1.days.ago.strftime("%Y-%m-%d 00:00:00")
      end_date = Time.now.at_beginning_of_day.to_s(:db)
      sql_1 =  "SELECT deco_firms.* FROM decoration_diaries ,deco_firms where deco_firms.id = decoration_diaries.deco_firm_id and "
      sql_2 = city.to_i == 11910 ? "deco_firms.city = #{city} and " : "deco_firms.district = #{city} and "
      sql_3 = "decoration_diaries.status = 1 and (deco_firms.state <> '-99' or deco_firms.state <> '-100') "
      sql_4 = "group by decoration_diaries.deco_firm_id "
      sql_5 = city.to_i == 11910 ? "and deco_firms.remarks_count>=3 and deco_firms.is_cooperation=1 " : ""
      sql = ''
      sql.concat(sql_1)
      sql.concat(sql_2)
      sql.concat(sql_3)
      sql.concat(sql_5)
      sql.concat "and decoration_diaries.created_at > '#{begin_date}' and decoration_diaries.created_at < '#{end_date}' "
      sql.concat(sql_4)
      sql.concat city.to_i == 11910 ? "order by rand() limit 3" : "order by count(decoration_diaries.deco_firm_id) desc ,deco_firms.praise asc limit 3"
      firms = DecoFirm.find_by_sql(sql)
      if firms.size < 3 #昨天发表日记的公司不足三条的时候
        supply_sql = ''
        supply_sql.concat(sql_1)
        supply_sql.concat(sql_2)
        supply_sql.concat(sql_3)
        supply_sql.concat(sql_5)
        if firms.size != 0
          firm_id = firms.map{|f| ",#{f["id"]}"}
          firm_id[0] = firm_id[0].gsub(/(,)/,'')
          supply_sql.concat("and deco_firms.id not in (#{firm_id}) ")
        end
        supply_sql.concat(sql_4)
        supply_sql.concat city.to_i == 11910 ? "order by rand() limit #{3 - firms.size}" : "order by deco_firms.is_cooperation desc, count(decoration_diaries.deco_firm_id) desc limit #{3 - firms.size}"
        supply_firms = DecoFirm.find_by_sql(supply_sql)
        firms = firms.concat(supply_firms)
      end
    
      if city.to_i == 11910 #上海第一个为推广，可能只用一个月
        ids = parse_xml(INDEX_PROMOTED["shanghai"]["今日最热网友点评"], ["title"],3)
        tui_firms = []
        for i in (0..2)
          firm = self.getfirm(ids[i]["title"]) unless ids[i].blank?
          tui_firms += firm.to_a
        end
        shanghai_firms = tui_firms.nil? ? firms : (tui_firms + firms).uniq
        firms = shanghai_firms.size == 4 ? shanghai_firms[0,3] : shanghai_firms
      end
      firms
    end
  end
  
  # same_city_same_city_price
  # params[:city] 城市编号
  # params[:price] 公司价位
  # return firms_Array
  def self.same_city_same_price(city, price)
    CACHE.fetch("/firms/shit/same_city_same_price/praise/#{city}/#{price}/", 1.hour) do
      conditions = []
      conditions << "state <> '-99'"
      conditions << "state <> '-100'"
      conditions << "city = #{city}" if city.to_i == 11910
      conditions << "district = #{city}" if city.to_i != 11910
      conditions << "price = '#{price}'" if price.to_i != 0
      DecoFirm.find(:all, :select => "id, name_zh, name_abbr, star, city, district, area, price ,praise", :conditions => conditions.join(' and '), :order => "is_cooperation DESC", :limit =>5)
    end
  end
  
  def self.has_many_deco_firm_number
    CACHE.fetch("deco_firm/has_many_deco_firm_number", 1.hour) do
      DecoFirm.count(:all, :conditions => ["state != -100 and state != -99"])
    end
  end
  
  # 获得当前城市前10名公司(order:1是口碑降序，2是点评数字排序)
  def self.get_city_topten_firm(city, order)
    CACHE.fetch("/firms/topten_firms/praise_firms/#{city}/#{order}", RAILS_ENV == "development" ? 0 : 20.minutes) do
      decofirm = []
      if city.to_i == 11910 && order == 1
        parse_xml(55217, ["title"], 3).each do |id|
          decofirm << id["title"].to_i
        end
      end
      conditions = ["state <> '-100' and state <> '-99'"]
      conditions << (city.to_i == 11910 ? "city = 11910" : "district = #{city}")
      orderstr = order.to_i == 1 ? "is_cooperation desc, praise desc" : "is_cooperation desc, remark_only_count desc"
      conditions << "id not in (#{decofirm.join(',')})" unless decofirm.empty?
      decofirm.concat DecoFirm.find(
        :all,
        :select => "id,name_zh,name_abbr,star,remark_only_count,praise",
        :conditions => conditions.join(' and '),
        :order => orderstr,
        :limit => 10 - decofirm.size
      )
    end
  end
  
  # 用于显示用的设计分，四舍五入取整
  def int_design_score
    adjusted_design_score.round
  end

  # 用于显示用的施工分，四舍五入取整
  def int_construction_score
    adjusted_construction_score.round
  end

  # 用于显示用的服务分，四舍五入取整
  def int_service_score
    adjusted_service_score.round
  end
  
  #公司留言总数
  def remarks_count
    Remark.count(:conditions => ["resource_type = 'DecoFirm' and resource_id = ? ",id])
  end
  
  #根据公司名称找公司
  def self.get_firm_by_name name_zh
    CACHE.fetch("get/firm/by/name/#{name_zh}",1.hours) do
      DecoFirm.find(:first,:conditions => ["name_zh = ? and state <> '-99' and state <> '-100'" , name_zh])
    end
  end
  
  # 根据城市和标签得到城市标签对应的价格
  def self.get_city_price_tag_value(city, key)
    price_name = ""
    if city.to_i == 12301
      price = PRICE#宁波价格更改为同上海一样
      price.select{|k, v| price_name = v if k == key.to_i}
    else
      price = PRICE
      price_name = price[key.to_i]
    end
    price_name
  end

  #合作公司每价位八条显示之后的额外总和
  def self.extra_price_firms(city)
    CACHE.fetch("get/#{city}/extra_price_firms", RAILS_ENV != 'production' ? 0 : 1.hour) do
      firms = []
      if city.to_i== 11910
        [1,2,3].sort.each do |price|
          if price == 3
            array_firms = DecoFirm.find(:all,:conditions => ["city=11910 and is_cooperation=1 and price in (3,4,5,6)"], :order => "praise desc")           
          else
            array_firms = DecoFirm.find(:all,:conditions => ["city=11910 and is_cooperation=1 and price=#{price}"], :order => "praise desc")            
          end
          firms.concat array_firms.slice(8,100) unless array_firms.slice(8,100).nil?
        end
      else
        [1,2,3,4].sort.each do |price|
          if price == 4
            array_firms = DecoFirm.find(:all,:conditions => ["district=#{city} and is_cooperation=1 and price in (4,5,6)"], :order => "praise desc")            
          else
            array_firms = DecoFirm.find(:all,:conditions => ["district=#{city} and is_cooperation=1 and price=#{price}"], :order => "praise desc")
          end
          firms.concat array_firms.slice(8,100) unless array_firms.slice(8,100).nil?
        end
      end
      if firms.size < 40
        if city.to_i == 11910
          firms.concat DecoFirm.find(
            :all,
            :conditions => ["city=11910 and is_cooperation <> 1"],
            :order => "praise desc",
            :limit => (40 - firms.size)
          )
        else
          firms.concat DecoFirm.find(
            :all,
            :conditions => ["district=#{city} and is_cooperation <> 1"],
            :order => "praise desc",
            :limit => (40 - firms.size)
          )
        end        
      end
      firms
    end
  end

  #合作公司每风格八条显示之后的额外总和
  def self.extra_style_firms(city)
    CACHE.fetch("get/#{city}/extra_style_firms", RAILS_ENV != 'production' ? 0 : 1.hour) do
      firms = []
      [1,2,3,4,5,6].sort.each do |style|
        if city.to_i == 11910
          array_firms = DecoFirm.find(:all,:conditions => ["city=11910 and is_cooperation=1 and style=#{style}"], :order => "praise desc")
        else
          array_firms = DecoFirm.find(:all,:conditions => ["district=#{city} and is_cooperation=1 and style=#{style}"], :order => "praise desc")
        end
        firms.concat array_firms.slice(8,100) unless array_firms.slice(8,100).nil?
      end
      if firms.size < 48
        if city.to_i == 11910
          firms.concat DecoFirm.find(
            :all,
            :conditions => ["city=11910 and is_cooperation <> 1 and state='000'"],
            :order => "praise desc",
            :limit => (48 - firms.size)
          )
        else
          firms.concat DecoFirm.find(
            :all,
            :conditions => ["district=#{city} and is_cooperation <> 1 and state='000'"],
            :order => "praise desc",
            :limit => (48 - firms.size)
          )
        end
      end
      firms
    end
  end

   #合作公司每价位5条显示之后的额外总和
  def self.extra_5_price_firms(city)
    CACHE.fetch("get/#{city}/extra_5_price_firms", RAILS_ENV != 'production' ? 0 : 1.hour) do
      firms = []
      if city.to_i== 11910
        [1,2,3].sort.each do |price|
          if price == 3
            array_firms = DecoFirm.find(:all,:conditions => ["city=11910 and is_cooperation=1 and price in (3,4,5,6)"], :order => "praise desc")
          else
            array_firms = DecoFirm.find(:all,:conditions => ["city=11910 and is_cooperation=1 and price=#{price}"], :order => "praise desc")
          end
          firms.concat array_firms.slice(5,100) unless array_firms.slice(5,100).nil?
        end
      else
        [1,2,3,4].sort.each do |price|
          if price == 4
            array_firms = DecoFirm.find(:all,:conditions => ["district=#{city} and is_cooperation=1 and price in (4,5,6)"], :order => "praise desc")
          else
            array_firms = DecoFirm.find(:all,:conditions => ["district=#{city} and is_cooperation=1 and price=#{price}"], :order => "praise desc")
          end
          firms.concat array_firms.slice(5,100) unless array_firms.slice(5,100).nil?
        end
      end
      if firms.size < 30
        if city.to_i == 11910
          firms.concat DecoFirm.find(
            :all,
            :conditions => ["city=11910 and is_cooperation <> 1"],
            :order => "praise desc",
            :limit => (30 - firms.size)
          )
        else
          firms.concat DecoFirm.find(
            :all,
            :conditions => ["district=#{city} and is_cooperation <> 1"],
            :order => "praise desc",
            :limit => (30 - firms.size)
          )
        end
      end
      firms
    end
  end

  #合作公司每风格5条显示之后的额外总和
  def self.extra_5_style_firms(city)
    CACHE.fetch("get/#{city}/extra_5_style_firms", RAILS_ENV != 'production' ? 0 : 1.hour) do
      firms = []
      [1,2,3,4,5,6].sort.each do |style|
        if city.to_i == 11910
          array_firms = DecoFirm.find(:all,:conditions => ["city=11910 and is_cooperation=1 and style=#{style}"], :order => "praise desc")
        else
          array_firms = DecoFirm.find(:all,:conditions => ["district=#{city} and is_cooperation=1 and style=#{style}"], :order => "praise desc")
        end
        firms.concat array_firms.slice(5,100) unless array_firms.slice(5,100).nil?
      end
      if firms.size < 40
        if city.to_i == 11910
          firms.concat DecoFirm.find(
            :all,
            :conditions => ["city=11910 and is_cooperation <> 1 and state='000'"],
            :order => "praise desc",
            :limit => (40 - firms.size)
          )
        else
          firms.concat DecoFirm.find(
            :all,
            :conditions => ["district=#{city} and is_cooperation <> 1 and state='000'"],
            :order => "praise desc",
            :limit => (40 - firms.size)
          )
        end
      end
      firms
    end
  end

  def self.find_other_cooperation_firms(city, option, value, need_size)
    CACHE.fetch("get/#{city}/#{option}/#{value}/find_other_cooperation_firms", RAILS_ENV != 'production' ? 0 : 1.hour) do
      DecoFirm.find(:all, :conditions => ["district=#{city} and #{option}<>#{value} and is_cooperation=1"], :order => 'rand()', :limit => need_size)
    end
  end
end

