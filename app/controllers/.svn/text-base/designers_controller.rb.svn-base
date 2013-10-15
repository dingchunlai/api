class DesignersController < DecoController
  include DecoHelper
  before_filter :domain_validate,:only => :show
  
  def domain_validate
    @firm = validates_firm_with_subdomain do |firm|
      headers["Status"] = "301 Moved Permanently" 
      redirect_to gen_firm_city_designers(firm.id)
    end    
  end
  private :domain_validate

  def index
    company = params[:id]
    @decofirm = DecoFirm.getfirm(company)
    #    if @decofirm.district.to_i!=0
    #      @area = CaseTag.find(@decofirm.district.to_i)
    #    end
    key = "company_designer_#{company}_#{Time.now.strftime('%Y%m%d')}_#{params[:page]}"
    if CACHE.get(key).nil?
      @designer = CaseDesigner.paginate :page => params[:page], :per_page => 10,:conditions =>"COMPANY=#{company} and STATUS!='-100'"
      CACHE.set(key, @designer)
    else
      @designer = CACHE.get(key)
    end
    @style = {
      '1' => "现代简约",
      '2' => "欧/美式",
      '3' => "田园风格",
      '4' => "中式风格",
      '5' => "地中海"
    }
  end

  # disigner_show
  def show
    companyid = params[:id]
    dsql = "select d.* from HEJIA_DESIGNERMODEL d,HEJIA_CASE c where d.COMPANY=#{companyid} and c.DESIGNERID=d.ID  and c.STATUS != '-100' and c.ISNEWCASE=1 and c.ISZHUANGHUANG='1' and c.ISCOMMEND='0' group by d.ID"
    dsnkey = "zhaozhuangxiu1_dsnkey_#{companyid}_#{Time.now.strftime('%Y%m%d%H')}"
    # find all firm_designer
    if CACHE.get(dsnkey).nil?
      @dsn = CaseDesigner.find_by_sql(dsql)
      CACHE.set(dsnkey, @dsn)
    else
      @dsn = CACHE.get(dsnkey)
    end
    if @dsn.size>0
      # search params[:designer_id]
      unless params[:designer_id].blank?
        @designermodel = @dsn.detect {|dsn| dsn.ID.to_i == params[:designer_id].to_i }
      else
        # get_first_designer
        @designermodel = @dsn[0]
      end
      key="zhaozhuangxiu_DESIGNERS_ID_#{Time.now.strftime('%Y%m%d%H')}_#{@designermodel.ID}"
      if CACHE.get(key).nil?
        # get_first_designer_first_case
        @newcase = Case.find(:first,:conditions => ["DESIGNERID=? and STATUS!='-100'",@designermodel.ID])
        CACHE.set(key, @newcase)
      else
        @newcase = CACHE.get(key)
      end
      @caseid=@newcase.ID
      tagkey = "key_case_show_tag2_#{@caseid}_#{Time.now.strftime('%Y%m%d')}"
      photokey = "key_case121212_show_photo112_#{@caseid}_#{Time.now.strftime('%Y%m%d%H')}"
      taglistkey = "key_case_show_taglist2_#{@caseid}_#{Time.now.strftime('%Y%m%d%H')}"
      decofirmkey = "key_case_show_decofirmkey_#{@caseid}_#{Time.now.strftime('%Y%m%d')}"
      sqltestkey = "sqltestkey_#{@caseid}_#{Time.now.strftime('%Y%m%d')}"
      #获得案例图片CACHE
      if CACHE.get(photokey).nil?
        # get_first_designer_first_case
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
          @cm_about_c_other = get_case_fengge(nil,fengge)
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
      cookieimage(@newcase.ID,@newcase.NAME,"http://image.51hejia.com/files/hekea/case_img/tn/@newcase.ID.jpg")
    else
    end
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
      Case.update_all({:CASEUP => @newcase.CASEUP}, :id => @newcase.ID)
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
      Case.update_all({:CASEDOWN => @newcase.CASEDOWN}, :id => @newcase.ID)
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
    render :layout => false
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
  
  def save_case
    @case_id = params[:case_id]
    key = "key_case_show_casecase_id2_#{Time.now.strftime('%Y%m%d%H')}_#{@case_id}_#{@case_id}"
    if CACHE.get(key).nil?
      @newcase = Case.find(params[:case_id])
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
        if(idscount.length() >= 10 && !user_logged_in?)
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
      sql+=" and  cases.COMPANYID!=#{cmid} and cases.COMPANYID is not null"
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
    designers_all = CaseDesigner.firm_case_designer params[:id]
    @designers = designers_all.paginate :page => params[:page], :per_page => 4
    render :partial => '/firms/designers'
  end
end
