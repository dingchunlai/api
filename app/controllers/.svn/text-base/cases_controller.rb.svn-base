class CasesController < DecoController
  include DecoHelper
  before_filter :domain_validate1,:only => :company
  before_filter :domain_validate2,:only => :zHuangCase
  before_filter FormTokenFilter, :only => [:zHuangCase,:new_diray_remark]

  def domain_validate1
    @firm = validates_firm_with_subdomain do |firm|
      headers["Status"] = "301 Moved Permanently" 
      redirect_to gen_firm_city_cases(firm.id)
    end    
  end
  private :domain_validate1

  def domain_validate2
    @firm = validates_firm_with_subdomain(:cid) do |firm|
      headers["Status"] = "301 Moved Permanently"
      redirect_to gen_firm_city_case_detail(firm.id, params[:id])
    end    
  end
  private :domain_validate2

  $title_id = 'tp'
  #案例列表页
  def list
    @feiyong=params[:feiyong]
    @fengge=params[:fengge]
    @yongtu=params[:yongtu]
    @huxing=params[:huxing]
    
    @feiyong_name=nil
    @fengge_name=nil
    @yongtu_name=nil
    @huxing_name=nil
    
    @name = params[:name]
    @pay = nil
    @style = nil
    @use = nil
    @model = nil
    bianliang = "_"
    puts @feiyong
    if !@feiyong.nil?&&@feiyong.to_s!=''&&@feiyong.to_s!='0'
      if @feiyong.to_s=='8'
        @pay = 11621
      elsif @feiyong.to_s=='5_8'
#        @pay = 11620
        @pay = 11621
      elsif @feiyong.to_s=='8_15'
        @pay = 11623
      elsif @feiyong.to_s=='12_20'
#        @pay = 11619
        @pay = 11622
      elsif @feiyong.to_s=='15_30'
        @pay = 11622
      elsif @feiyong.to_s=='30'
        @pay = 11624
      elsif @feiyong.to_s=='100'
        @pay = 41733
      elsif @feiyong.to_s=='jingji'
        @pay = 4370
      elsif @feiyong.to_s=='fuyu'
        @pay = 4372
      elsif @feiyong.to_s=='haohua'
        @pay = 4373
      else
      end
    end
    puts @pay
    if !@fengge.nil?&&@fengge.to_s!='' && @fengge.to_s!='0'
      if @fengge.to_s=='xiandaijianyue'
        @style = 4361
      elsif @fengge.to_s=='zhongshi'
        @style = 4362
      elsif @fengge.to_s=='"oumei'
        @style = 4363
      elsif @fengge.to_s=='hunda'
        @style = 4360
      elsif @fengge.to_s=='dizhonghai'
        @style = 6680
      elsif @fengge.to_s=='tianyuan'
        @style = 4367
      elsif @fengge.to_s=='qita'
        @style = 6681
      else
      end
    end
    if !@yongtu.nil? && @yongtu.to_s!='' && @yongtu.to_s!='0'
      if @yongtu.to_s=='jiufang'
        @use = 4378
      elsif @yongtu.to_s=='hunfang'
        @use = 4380
      elsif @yongtu.to_s=='danshen'
        @use = 4381
      elsif @yongtu.to_s=='sankou'
        @use = 4382
      elsif @yongtu.to_s=='laoren'
        @use = 4383
      elsif @yongtu.to_s=='shejishi'
        @use = 4385
      elsif @yongtu.to_s=='chuzufang'
        @use = 6682
      elsif @yongtu.to_s=='zhongruanfang'
        @use = 6683
      elsif @yongtu.to_s=='chongwu'
        @use = 6684
      elsif @yongtu.to_s=='ertong'
        @use = 6685
      elsif @yongtu.to_s=='qita'
        @use = 6686
      elsif @yongtu.to_s=='fanxin'
        @use = FANXINTAG
      else
      end
    end
    if !@huxing.nil? && @huxing.to_s!='' && @huxing.to_s!='0'
      if @huxing.to_s=='xiaohu'
        @model = 4355
      elsif @huxing.to_s=='gongyu'
        @model = 4356
      elsif @huxing.to_s=='bieshu'
        @model = 4354
      else
      end
    end
    @feiyong_name=nil
    @fengge_name=nil
    @yongtu_name=nil
    @huxing_name=nil
    
    sql = "select  cases.ID,cases.NAME,cases.ischeck,cases.COMPANYID from HEJIA_CASE as cases where cases.STATUS!='-100' and cases.ISNEWCASE=1 and cases.TEMPLATE != 'room' and cases.ISZHUANGHUANG='1' and cases.DESIGNERID!=2291 and cases.COMPANYID is not null and cases.COMPANYID!=4"
    sql +=" and EXISTS (select * FROM photo_photos as p WHERE p.case_id = cases.ID) "
    @city_id = get_and_save_city(nil,request.remote_ip)
     bianliang += @city_id.to_s+"_"
    if @city_id.to_i==11910
        sql += "and EXISTS (select 1 from deco_firms where deco_firms.city=#{@city_id} and deco_firms.id = cases.COMPANYID)"
    else
        sql += "and EXISTS (select 1 from deco_firms where deco_firms.district=#{@city_id} and deco_firms.id = cases.COMPANYID)"
    end
    if !@pay.nil?&&@pay.to_s!=''
      bianliang += @pay.to_s+"_"
      sql+=" and EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = #{@pay} and link2.LINKTYPE='case' and link2.ENTITYID = cases.ID)"
      @feiyong_name = CaseTag.find(@pay)
    end
    if !@style.nil?&&@style.to_s!=''
      bianliang += @style.to_s
      sql+=" and EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = #{@style} and link2.LINKTYPE='case' and link2.ENTITYID = cases.ID)"
      @fengge_name = CaseTag.find(@style)
    end
    if !@use.nil?&&@use.to_s!=''
      bianliang += @use.to_s
      sql+=" and EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = #{@use} and link2.LINKTYPE='case' and link2.ENTITYID = cases.ID)"
      @yongtu_name = CaseTag.find(@use)
    end
    if !@model.nil?&&@model.to_s!=''
      bianliang += @model.to_s
      sql+=" and EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = #{@model} and link2.LINKTYPE='case' and link2.ENTITYID = cases.ID)"
      @huxing_name = CaseTag.find(@model)
    end
    if !@name.nil? && @name != ''
      bianliang += @name.strip
      sql+=" and cases.NAME like '%#{@name.strip}%' "
    end
    sql+=" and cases.COMPANYID!=7 "
    sql+=" order by cases.CREATEDATE desc"
    key = "1key_caselt_show_casel_#{Time.now.strftime('%Y%m%d%H')}_7_1_1_1_12"
    key = bianliang+"_"+key
    if !params[:page].nil?
      key+= bianliang+"_"+params[:page]
    end
    if CACHE.get(key).nil?
      @casel = Case.find_by_sql(sql)
      CACHE.set(key, @casel)
    else
      @casel = CACHE.get(key)
    end
  
    @caselist = @casel.paginate :page => params[:page], :per_page => 24
    
    @fav_cases = [cookies[:hejia_case_id], cookies[:hejia_case_name], cookies[:hejia_case_image_url]]
    @look_cases = [cookies[:zhuangzhuangxiu_case_id], cookies[:zhuangzhuangxiu_case_name], cookies[:zhuangzhuangxiu_case_image_url]]
  end
  #公司案例列表
  def company
    bianliang = "_"
    @id = params[:id]
    @area = nil
    @decofirm = DecoFirm.find(@id)
    #    if @decofirm.district.to_i!=0
    #    @area = CaseTag.find(@decofirm.district.to_i)
    #    end
    sql = "select * from HEJIA_CASE as cases where cases.STATUS!='-100' and cases.ISNEWCASE=1 and cases.ISZHUANGHUANG='1' and ISCOMMEND='0'"
    if !@id.nil?
      bianliang += @id.to_s+"_"
      sql+=" and cases.COMPANYID=#{@id} "
    end
    
    sql+=" order by cases.CREATEDATE desc"
    key = "key_company_caselist_#{Time.now.strftime('%Y%m%d%H')}"
    key+= bianliang
    if !params[:page].nil?
      key+= bianliang+"_"+params[:page]
    end
    if CACHE.get(key).nil?
      @casel = Case.find_by_sql(sql)
      CACHE.set(key, @casel)
    else
      @casel = CACHE.get(key)
    end
    @caselist = @casel.paginate :page => params[:page], :per_page => 20
  end
  
  def show
    @caseid=params[:id]
    key = "key_case_show_casecase_id2_#{Time.now.strftime('%Y%m%d%H')}_#{@caseid}_#{@caseid}"
    if CACHE.get(key).nil?
      @newcase = Case.find(params[:id])
      CACHE.set(key, @newcase)
    else
      @newcase = CACHE.get(key)
    end
    if @newcase.COMPANYID.to_i!=0
      redirect_to "/gs-#{@newcase.COMPANYID}/cases-#{@caseid}"
    else
      redirect_to "/gs-0/cases-#{@caseid}"
    end
  end
  
  # 案例终端
  def zHuangCase
    @caseid=params[:id]
    key = "key_case_show_casecase_id2_#{Time.now.strftime('%Y%m%d%H')}_#{@caseid}_#{@caseid}"
    #获得案例基本信息CACHE
    if CACHE.get(key).nil?
      @newcase = Case.find(params[:id])
      CACHE.set(key, @newcase)
    else
      @newcase = CACHE.get(key)
    end
    if params[:cid].to_i!=0
      companyid = params[:cid]
    else
      companyid = @newcase.COMPANYID
    end
    # 在缓存中取当前城市下的优惠券信息
    @promoted_events = DecoEvent.promoted_events(params[:city])
    dsql = "select d.* from HEJIA_DESIGNERMODEL d,HEJIA_CASE c where d.COMPANY=#{companyid} and c.DESIGNERID=d.ID  and c.STATUS != '-100' and c.ISNEWCASE=1 and c.TEMPLATE != 'room' and c.ISZHUANGHUANG='1' and c.ISCOMMEND='0' group by d.ID"
    dsnkey = "zhaozhuangxiu1_dsnkey_#{companyid}_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(dsnkey).nil?
      @dsn = CaseDesigner.find_by_sql(dsql)
      CACHE.set(dsnkey, @dsn)
    else
      @dsn = CACHE.get(dsnkey)
    end
      if @newcase.DESIGNERID.to_i!=0
        @designermodel = CaseDesigner.find_by_ID(@newcase.DESIGNERID)
      else
        @designermodel = nil
      end
      tagkey = "key_case_show_tag2_#{@caseid}_#{Time.now.strftime('%Y%m%d')}"
      photokey = "key_case121212_show_photo112_#{@caseid}_#{Time.now.strftime('%Y%m%d%H')}"
      taglistkey = "key_case_show_taglist2_#{@caseid}_#{Time.now.strftime('%Y%m%d%H')}"
      decofirmkey = "key_case_show_decofirmkey_#{@caseid}_#{Time.now.strftime('%Y%m%d')}"
      sqltestkey = "sqltestkey_#{@caseid}_#{Time.now.strftime('%Y%m%d')}"
      #获得案例图片CACHE
      if CACHE.get(photokey).nil?
        @decophoto = PhotoPhoto.find(:all,:conditions=>"case_id=#{@caseid}")
        CACHE.set(photokey, @decophoto)
      else
        @decophoto = CACHE.get(photokey)
      end
      #获得产品区域的图片标签查询条件CACHE
      if CACHE.get(sqltestkey).nil?
        sqltest = @decophoto.collect{|t| t.id}.join(',')
        CACHE.set(sqltestkey, sqltest)
      else
        sqltest = CACHE.get(sqltestkey)
      end
      sql=""
      sql+="SELECT tag.*, count(t.photo_id) FROM photo_tags as tag,photo_photos_tags  as t where t.photo_id in (0"
      if !sqltest.nil?&&sqltest.to_s!=""
        sql+=","+  sqltest.to_s
      end 
      sql+=") and t.type_id = 1 and tag.id=t.tag_id group by t.tag_id"
      #获得产品区域的图片标签CACHE
      if CACHE.get(taglistkey).nil?
        @taglist = PothoTag.find_by_sql(sql) 
        CACHE.set(taglistkey, @taglist)
      else
        @taglist = CACHE.get(taglistkey)
      end
      fenggekey = "key_case_show__fengge_key_#{Time.now.strftime('%Y%m%d')}"
      if CACHE.get(fenggekey).nil?
        fengge = CaseTag.find(:all,:conditions=>"TAGFATHERID in (4348,4349) and TAGESTATE!='-1'").collect{|t| t.TAGID}.join(',')
        CACHE.set(fenggekey, fengge)
      else
        fengge = CACHE.get(fenggekey)
      end
      #获得案例公司的CACHE
      if !@newcase.COMPANYID.nil?&&@newcase.COMPANYID.to_s!=''
        @cm_about_c = get_case_fengge(@newcase.COMPANYID,fengge)
        @tuijian = get_case_fengge_not_com(@newcase.COMPANYID,fengge)
        if @cm_about_c.size<5
          @cm_about_c_other = get_case_fengge_not_com(@newcase.COMPANYID,fengge)
        else
        end
        if CACHE.get(decofirmkey).nil?
          begin
            @decofirm = DecoFirm.find(@newcase.COMPANYID)
          rescue Exception => e
            @decofirm=nil
          end
          CACHE.set(decofirmkey, @decofirm)
        else
          @decofirm = CACHE.get(decofirmkey)
        end
      else
        get_case_fengge(nil,fengge)
        @tuijian = get_case_fengge_not_com(nil,fengge)
      end
      @style = {
        '1' => "现代简约",
        '2' => "欧/美式",
        '3' => "田园风格",
        '4' => "中式风格",
        '5' => "地中海"
      }
      @fav_cases = [cookies[:hejia_case_id], cookies[:hejia_case_name], cookies[:hejia_case_image_url]]
      @look_cases = [cookies[:zhuangzhuangxiu_case_id], cookies[:zhuangzhuangxiu_case_name], cookies[:zhuangzhuangxiu_case_image_url]]
      @number = @newcase.CASEUP
      if cookies[:hejia_case_id]
        if cookies[:hejia_case_id].split(",").include?(@newcase.ID.to_s)
          @fav_info = ["取消收藏本套案例","","delete"]
        else
          @fav_info = ["收藏本套案例","","save"]
        end
      else
        @fav_info = ["收藏本套案例","","save"]
      end
      @remarks = Case.case_remarks_paginator(@newcase.id,1)
      cookieimage(@newcase.ID,@newcase.NAME,"http://image.51hejia.com/files/hekea/case_img/tn/@newcase.ID.jpg")
  end
  def up
    id = params[:id]
    @newcase = Case.find(:first, :conditions => ["ID = ?", id])
    key = "key_case_show_casecase_id2_#{Time.now.strftime('%Y%m%d%H')}_#{id}_#{id}"
    @mark = 0
    CACHE.set(key,nil)
    if is_up_or_down(id)
      @is_up_or_down = 0
      @mark = 1
    else
      @newcase.CASEUP += 1
      Case.update_all({:CASEUP => @newcase.CASEUP}, :ID => @newcase.ID)
      @is_up_or_down = 1
      if cookies[:hejia_case_is_up_or_down].blank?
        ids = id
      else
        ids = cookies[:hejia_case_is_up_or_down] << ",#{id}"
      end
      cookies[:hejia_case_is_up_or_down] = { :value => ids,
        :expires => 1.year.from_now, :domain => '51hejia.com' }
    end
    @number = @newcase.CASEUP
    render :partial => "up"
  end
  
  def down
    id = params[:id]
    @newcase = Case.find(:first, :conditions => ["ID = ?", id])
    key = "key_case_show_casecase_id2_#{Time.now.strftime('%Y%m%d%H')}_#{id}_#{id}"
    CACHE.set(key,nil)
    @mark = 0
    if is_up_or_down(id)
      @is_up_or_down = 0
      @mark = 1
    else
      @newcase.CASEDOWN += 1
      Case.update_all({:CASEDOWN => @newcase.CASEDOWN}, :ID => @newcase.ID)
      @is_up_or_down = 1
      if cookies[:hejia_case_is_up_or_down].blank?
        ids = id
      else
        ids = cookies[:hejia_case_is_up_or_down] << ",#{id}"
      end
      cookies[:hejia_case_is_up_or_down] = { :value => ids,
        :expires => 1.year.from_now, :domain => '51hejia.com' }
    end
    render :partial => "down"
  end
  
  def down_case
    @case_id = params[:case_id]
    @tag_id = params[:tag_id]
    @case_name = HejiaCase.find(:first, :conditions => ["ID = ? ", @case_id]).NAME
    photos = PhotoPhoto.find(:all,
                             :conditions => ["case_id = ?", @case_id])
    if photos
      if @tag_id
        a = []
        for p in photos
          a << p.id
        end
        sql = "SELECT photo_id FROM photo_photos_tags where photo_id in (#{a.join(",")}) and tag_id = #{@tag_id}"
        photo_tags = PhotoPhotosTag.find_by_sql(sql)
        @b = []
        if photo_tags
          for t in photo_tags
            photo = PhotoPhoto.find(:first,
                                  :conditions => ["id = ?", t.photo_id])
            @b << photo
          end
        end
      else
        @b = photos
      end
    end
  end
  def save_case
    @case_id = params[:case_id]
    key = "key_case_show_casecase_id2_#{Time.now.strftime('%Y%m%d%H')}_#{@case_id}_#{@case_id}"
    if CACHE.get(key).nil?
      @newcase = Case.find(params[@case_id])
      CACHE.set(key, @newcase)
    else
      @newcase = CACHE.get(key)
    end
    @case_name = params[:case_name]
    @case_photo=query_tn_image_url(@case_id)
    @method = params[:method]
    @mark = 0
    if @method.to_s == "delete"
      @mark = 2
      m = "save"
      case_ids = cookies[:hejia_case_id].split(",")
      case_images = cookies[:hejia_case_image_url].split(",")
      case_names = cookies[:hejia_case_name].split(",")
      case_ids.delete(@case_id)
      case_images.delete(@case_photo)
      case_names.delete(@case_name)
      ids = case_ids.empty? ? nil : case_ids.join(",")
      images = case_images.empty? ? nil : case_images.join(",")
      names = case_names.empty? ? nil : case_names.join(",")
      @fav_info = ["收藏本套案例","",m]
    elsif @method.to_s == "save"
      @mark = 1
      m = "delete"
      
      bo = 1
      if !cookies[:hejia_case_id].blank?
        idscount = cookies[:hejia_case_id].split(",")
        if(idscount.length() >=10 && !user_logged_in?)
          @method = "savefull"
          bo = 0
        end
      end
      
      if !cookies[:hejia_case_id].blank?
        if bo!=0
          ids  = cookies[:hejia_case_id] << ",#{@case_id}"
        else
          ids  = cookies[:hejia_case_id]
        end
      else
        ids = @case_id
      end
      if !cookies[:hejia_case_image_url].blank?
        if bo!=0
          images = cookies[:hejia_case_image_url] << ",#{@case_photo}"
        else
          images = cookies[:hejia_case_image_url]
        end
      else
        images = @case_photo
      end
      if !cookies[:hejia_case_name].blank?
        if bo!=0
          names = cookies[:hejia_case_name] << ",#{@case_name}"
        else
          names = cookies[:hejia_case_name]
        end
      else
        names = @case_name
      end
      if bo!=0
        @fav_info = ["取消收藏本套案例","",m]
      else
        m = "save"
        @fav_info = ["收藏本套案例","",m]
      end
    end
    cookies[:hejia_case_id] = { :value => ids,
      :expires => 1.year.from_now, :domain => '51hejia.com' }
    
    cookies[:hejia_case_image_url] = { :value => images,
      :expires => 1.year.from_now, :domain => '51hejia.com' }
    
    cookies[:hejia_case_name] = { :value => names,
      :expires => 1.year.from_now, :domain => '51hejia.com' }
    @fav_cases = [ids, names, images]
  end
  def is_up_or_down(id)
    if cookies[:hejia_case_is_up_or_down].blank?
      return false
    else
      if cookies[:hejia_case_is_up_or_down].split(",").include?(id)
        return true
      else
        return false
      end
    end
  end
  
  def cookieimage(id,name,image)
    if !cookies[:zhuangzhuangxiu_case_id].blank?
      case_ids = cookies[:zhuangzhuangxiu_case_id].split(",")
    else
      case_ids = Array.new
    end
    if !cookies[:zhuangzhuangxiu_case_name].blank?
      case_names = cookies[:zhuangzhuangxiu_case_name].split(",")
    else
      case_names = Array.new
    end
    bo=0
    if case_ids.size<10
      case_ids.each do |cid|
        if (cid.to_i!=id.to_i)
          bo=1
        else
          bo=0
        end
      end
      case_names.each do |cname|
        if (cname.to_s!=name.to_s)
          bo=1
        else
          bo=0
        end
      end
      if !cookies[:zhuangzhuangxiu_case_id].blank?
        if bo!=0
          ids  = cookies[:zhuangzhuangxiu_case_id] << ",#{id}"
        else
          ids  = cookies[:zhuangzhuangxiu_case_id]
        end
      else
        ids = id.to_s
      end
      if !cookies[:zhuangzhuangxiu_case_image_url].blank?
        if bo!=0
          images = cookies[:zhuangzhuangxiu_case_image_url] << ",#{image}"
        else
          images = cookies[:zhuangzhuangxiu_case_image_url]
        end
      else
        images = image
      end
      if !cookies[:zhuangzhuangxiu_case_name].blank?
        if bo!=0
          names = cookies[:zhuangzhuangxiu_case_name] << ",#{name}"
        else
          names = cookies[:zhuangzhuangxiu_case_name]
        end
      else
        names = name
      end
    end
    cookies[:zhuangzhuangxiu_case_id] = { :value => ids,
      :expires => 1.year.from_now, :domain => '51hejia.com' }
    
    cookies[:zhuangzhuangxiu_case_image_url] = { :value => images,
      :expires => 1.year.from_now, :domain => '51hejia.com' }
    
    cookies[:zhuangzhuangxiu_case_name] = { :value => names,
      :expires => 1.year.from_now, :domain => '51hejia.com' }
  end
  
  def query_tn_image_url(id)
    #图库“我的收藏”小图       
    if !id.blank?      
      image_url = "http://image.51hejia.com/files/hekea/case_img/tn/#{id}"+".jpg"
    else
      image_url = "http://d.51hejia.com/api/images/none.gif"
    end
    return image_url
  end
  def get_case_fengge(cmid,fengge)
    sql = "select  cases.ID,cases.NAME,cases.ischeck,cases.COMPANYID from HEJIA_CASE as cases where cases.STATUS!='-100' and cases.ISNEWCASE=1 and cases.TEMPLATE != 'room' and cases.ISZHUANGHUANG='1'"
    if !cmid.nil?
      sql+=" and  cases.COMPANYID=#{cmid}"
    end
    
    if !fengge.nil?&&fengge.to_s!=''
      sql+=" and EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID in( #{fengge}) and link2.LINKTYPE='case' and link2.ENTITYID = cases.ID)"
    end
    sql+=" limit 5"
    key = "key_zhaozhuangxiu_get_case_fengge_#{Time.now.strftime('%Y%m%d%H')}_#{cmid}_1555"
    if CACHE.get(key).nil?
      result = Case.find_by_sql(sql)
      CACHE.set(key, result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  
  def get_case_fengge_not_com(cmid,fengge)
    sql = "select  cases.ID,cases.NAME,cases.ischeck,cases.COMPANYID from HEJIA_CASE as cases where cases.STATUS!='-100' and cases.ISNEWCASE=1 and cases.TEMPLATE != 'room' and cases.ISZHUANGHUANG='1'"
    if !cmid.nil?
      firm = DecoFirm.find(cmid)
      if firm.city == 11910
        sql+= "and cases.PROVINCE1=11910"
      else
      sql+=" and  cases.PROVINCE2= #{firm.district}"
      end
    end
    
    if !fengge.nil?&&fengge.to_s!=''
      sql+=" and EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID in( #{fengge}) and link2.LINKTYPE='case' and link2.ENTITYID = cases.ID)"
    end
    sql+=" limit 4"
    key = "key_zhaozhuangxiu_get_case_fengge_not_com_#{Time.now.strftime('%Y%m%d%H')}_#{cmid}_1233"
    if CACHE.get(key).nil?
      result = Case.find_by_sql(sql)
      CACHE.set(key, result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  
  def paginator
    firm_case_all = Case.firm_case params[:id]
    @firm_case = firm_case_all.paginate :page => params[:page], :per_page => 12
    render :partial => "/firms/cases"
  end
  
  #提交案例留言
  def new_diray_remark
      @remark = Remark.new(params[:remark])
      @remark.created_at = Time.now
      @remark.resource_type = 'Case'
      @remark.ip = request.remote_ip
      if @remark.save
        @case_id = @remark.resource_id
        render :json => {
           :remark_created_at => @remark.created_at.to_s(:db),
           :remark_user_name => @remark.user_name,
           :remark_content => @remark.content,
           :set_token => @token
        }.to_json
      else
        render :json => {
            :result => true,
            :set_token => @token
          }.to_json
      end
  end
  
  #案例留言分页
  def remaks_page
    @case_id = params[:id]
    page = params[:page]
    page = 1 if page.nil?
    @remarks = Case.case_remarks_paginator(@case_id,page)
    render :partial => "/cases/remarks"
  end
  
end
