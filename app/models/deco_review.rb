class DecoReview < ActiveRecord::Base
  self.table_name = "51hejia.radmin_fdatas"
  acts_as_readonlyable [:read_only_51hejia]
  
  alias_attribute :company_id, :c1                #公司id
  alias_attribute :user_id, :c2                   #评论人id
  alias_attribute :design_score, :c3              #设计分
  alias_attribute :budget_score, :c4              #预算分
  alias_attribute :construction_score, :c5        #施工分
  alias_attribute :service_score, :c6             #服务分
  alias_attribute :complex_score, :c7             #综合分
  alias_attribute :title, :c8                     #标题
  alias_attribute :content, :c30                  #评论内容    
  alias_attribute :flower_num, :c10               #鲜花数
  alias_attribute :response_num, :c11             #回应数
  alias_attribute :report_num, :c12               #举报数
  alias_attribute :area, :c13                     #装修小区
  alias_attribute :address, :c14                  #小区地址
  alias_attribute :review_type, :c15              #评论类型 1:普通 2：精华 3：投诉
  alias_attribute :username, :c16                 #后台直接输入用户名
  alias_attribute :userurl, :c17                  #用户头像
  alias_attribute :phone, :c19                    #联系方式
  alias_attribute :photourl, :c20                 #图片路径
  alias_attribute :price, :c23                    #装修价格
  alias_attribute :method, :c21                   #装修方式
  alias_attribute :style, :c22                    #装修风格
  alias_attribute :review_type2, :c24             #评论类型2 0:业主博客 1：编辑抽查 2：小编看公司 3:创作案例
  alias_attribute :main_id, :c25                  #主日记id
  alias_attribute :city_id, :c26                  #城市id
  alias_attribute :district_id, :c27              #地区id
  alias_attribute :stage, :c28                    #装修阶段
  alias_attribute :room, :c29                     #房型   
  alias_attribute :egg, :c31                      #臭鸡蛋
  # alias_attribute :dpv, :c32                    #点评PV # methods dpv and dpv=(val) are defined below
  alias_attribute :back_author_id, :c33           #后台录入人id
  belongs_to :company,
  :class_name => "DecoFirm",
  :foreign_key => "c1"
  
  belongs_to :user,
  :class_name => "HejiaUserBbs",
  :foreign_key => "c2" 
  
  def self.getreviews(authorname) 
    return DecoReview.find(:all,:conditions=>"formid = '#{PINGLUN_ID}' and c16 = '#{authorname}' and status = '1'")
  end 
  
  def self.getgoodreviews()
    key = "zhaozhuangxiu_good_reviews_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    if CACHE.get(key).nil?
      result =  DecoReview.find(:all,:select => "c8,id",:conditions=>"formid = '#{PINGLUN_ID}' and c15 = '2' and status = '1'",:order => "id desc",:limit=>8)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  
  #获得城市下最新点评
  def self.get_top_commonts_by_city(city_id)
    key = "zhaozhuangxiu_commonts_by_city_#{city_id}_#{Time.now.strftime('%Y%m%d%H')}_2"
    
    if CACHE.get(key).nil?
      if city_id.to_i == 11910
        result =  DecoReview.find(:all,:select => "c26,c27,c16,cdate,c8,id",:conditions=>"c26 = '11910' and formid = '#{PINGLUN_ID}' and status = '1' and (c25 is null or c25 = '')",:group => 'c16',:order => "id desc",:limit=>8)
      else
        result =  DecoReview.find(:all,:select => "c26,c27,c16,cdate,c8,id",:conditions=>"c27 = '#{city_id}' and formid = '#{PINGLUN_ID}' and status = '1' and (c25 is null or c25 = '')",:group => 'c16',:order => "id desc",:limit=>8)
      end
      CACHE.set(key,result)
    else
      result = CACHE.get(key,result)
    end
    
    return result
  end  
  
  #获得公司相关评论
  def self.getcompanyreviews(companyid,review_type)
    
    key = "key_firm_review_firmid_#{companyid}_type_#{review_type}_#{Time.now.strftime('%Y%m%d%H')}"
    
    if CACHE.get(key).nil?
      conditions = []
      conditions << "status = '1'"
      conditions << "c15 = '#{review_type}'" if review_type && review_type.to_s != '1'
      conditions << "formid = '#{PINGLUN_ID}'"
      conditions << "c1 = '#{companyid}'"
      
      commonts = DecoReview.find(:all,:conditions => conditions.join(' and '),:order => 'cdate desc',:limit => 5)
      commonts = [] if !commonts || commonts.size == 0
      CACHE.set(key,commonts)
    else
      commonts = CACHE.get(key)
    end
    
    return commonts
  end
  
  #获得公司相关评论
  def self.getcompanyreviews2(companyid,review_type,exceptid)
    
    key = "key_firm_review_firmid_#{companyid}_type_#{review_type}_#{Time.now.strftime('%Y%m%d%H')}_exceptid_#{exceptid}"
    
    commonts = []
    if CACHE.get(key).nil?
      conditions = []
      conditions << "status = '1'"
      conditions << "c15 = '#{review_type}'" if review_type && review_type.to_s != '1'
      conditions << "formid = '#{PINGLUN_ID}'"
      conditions << "c1 = '#{companyid}'"
      conditions << "id <> '#{exceptid}'"
      
      commonts = DecoReview.find(:all,:conditions => conditions.join(' and '),:order => 'cdate desc',:limit => 5)
      CACHE.set(key,commonts)
    else
      commonts = CACHE.get(key)
    end
    
    return commonts
  end
  
  def self.getseoreviews
    key = "zhaozhuangxiu_seo_reviews_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    if CACHE.get(key).nil?
      result =  DecoReview.find(:all,:select => "c8,id",:conditions=>"formid = '#{PINGLUN_ID}' and status = '1'",:order => "id desc",:limit=>10)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result    
  end
  
  def self.get_first_dianping(companyid)
    key = "zhaozhuangxiu_gongsi_zuixin_pinglun_#{Time.now.strftime('%Y%m%d%H')}_#{companyid}"
    result = nil
    if CACHE.get(key).nil?
      result =  DecoReview.find(:first,:conditions=>"formid = '#{PINGLUN_ID}' and status = '1' and c1 = '#{companyid}'",:order => "id desc")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end
  
  def self.get_top_five_dianping
    str = "select a.id as id from (select id,cdate,c1 from radmin_fdatas where formid=77 and status=1 and c15 = '2' order by cdate desc) a group by c1 order by cdate desc limit 5"
    return find_by_sql(str)
  end
  
  def self.get_review_by_id(id)
    key = "zhaozhuangxiu_dianping_detail_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
    if CACHE.get(key).nil?
      result = DecoReview.find(id)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  def self.get_list_by_id(id)
    key = "zhaozhuangxiu_dianping1_list_by_id1_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
    if CACHE.get(key).nil?
      result = DecoReview.find(:all,:select=>"id,c8,c10,c11,udate",:conditions=>"formid = '#{PINGLUN_ID}' and status = '1' and (id = #{id} or c25=#{id})",:order => "id desc",:limit =>6)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  
  def self.get_review_by_user_id(id)
    key = "zhaozhuangxiu_dianping_detail_user_id_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
    if CACHE.get(key).nil?
      result = DecoReview.find(:all,:select=>"id,c8,c10,c11,udate",:conditions=>"formid = '#{PINGLUN_ID}' and status = '1' and c2=#{id}",:order => "id desc",:limit =>6)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  #根据公司查找
  def self.get_review_by_company_id(id)
    key = "zhaozhuangxiu_dianping_detail_company_id1_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
    if CACHE.get(key).nil?
      result = DecoReview.find(:all,:select=>"id,c8,c10,c11,cdate,c3,c4,c5,c6,c7,c30,udate",:conditions=>"formid = '#{PINGLUN_ID}' and status = '1' and c1=#{id}",:order => "id desc",:limit =>3)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  
  def self.get_review_by_user_flower_id(id)
    key = "zhaozhuangxiu_dianping_by_user_id_sum_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
    if CACHE.get(key).nil?
      result = DecoReview.find_by_sql("select sum(c10) as flower,sum(c11) as egg from radmin_fdatas where formid =77 and status = '1' and c2=#{id}")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  
  def self.get_xiaobian_dianping(companyid)
    key = "zhaozhuangxiu_gongsi_xiaobian_pinglun_#{Time.now.strftime('%Y%m%d%H')}_#{companyid}"
    if CACHE.get(key).nil?
      result = DecoReview.find(:first,:conditions=>"formid = '#{PINGLUN_ID}' and status = '1' and c1 = '#{companyid}' and c24 = '2'",:order => "id desc")
      if result && result.id
        CACHE.set(key,result)
      else
        CACHE.set(key,DecoReview.new)
      end
    else
      result = CACHE.get(key)
    end
    return result      
  end
  #下一个点评
  def self.get_next_dianping(id,companyid)
    key = "zhaozhuangxiu_dianping_by_company_id_next_dianping_#{Time.now.strftime('%Y%m%d')}_#{companyid}_#{id}"
    if CACHE.get(key).nil?
      result = DecoReview.find_by_sql("select d.* from radmin_fdatas as d,(select min(c.id) as id from radmin_fdatas  as c where c.id >#{id} and c.formid = '#{PINGLUN_ID}' and c.status = '1' and c.c1='#{companyid}') a where a.id=d.id")
      if result && result.id
        CACHE.set(key,result)
      end
    else
      result = CACHE.get(key)
    end
    return result  
  end
  #第一个点评
  def self.get_start_dianping(companyid)
    key = "zhaozhuangxiu_get_start_dianping_#{Time.now.strftime('%Y%m')}_#{companyid}"
    result = nil
    if CACHE.get(key).nil?
      result =  DecoReview.find(:first,:conditions=>"formid = '#{PINGLUN_ID}' and status = '1' and c1 = '#{companyid}'",:order => "id asc")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end

  def increase_pv!
    if defined?(REDIS_DB)
      REDIS_DB.incr pv_cache_key
    else
      self.c32 += 1
      self.class.update_all({:c32 => c32}, :id => id )
    end
  end

  # To be compatible with the old version, named this method dpv instead of pv.
  def dpv
    if defined?(REDIS_DB)
      _dpv = REDIS_DB.get(pv_cache_key).to_i
      if _dpv < 1
        _dpv = read_attribute(:c32) || 0 if _dpv < 1
        REDIS_DB.set pv_cache_key, _dpv
      end
      _dpv
    else
      read_attribute(:c32)
    end
  end

  def dpv=(val)
    self.c32 = val
  end

  def pv_cache_key
    @pv_cache_key ||= "test_zhaozhuangxiu_key_d_#{id}"
  end
  private :pv_cache_key

  # Get one dianping from cache or db.
  def self.cached_dianping(id)
    if id.is_a?(DecoReview)
      CACHEZ.set "zhuangxiu_dianping/#{id.id}", id, 1.hour
    else
      CACHEZ.fetch("zhuangxiu_dianping/#{id}", 1.hour) { find_by_id id }
    end
  end

end
