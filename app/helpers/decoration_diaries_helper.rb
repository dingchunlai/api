module DecorationDiariesHelper
  
  
  # 得到本案例公司的别的日记
  def get_firm_other_diaries(firm_id)
    CACHE.fetch("get_firm_other_diaries/DecorationDiary/#{firm_id}",5.hours) do
      DecorationDiary.find(:all,
        :select => "id,title,deco_firm_id" ,
        :conditions => "deco_firm_id = #{firm_id} and status =1",
        :limit => "8" ,
        :order =>"id desc")
    end
  end
  # 得到公司的所有日记数量
  def get_firm_diaries_count(firm_id)
    CACHE.fetch("get_firm_diaries_count/DecorationDiary/#{firm_id}",5.hours) do
      DecorationDiary.count(:conditions => "deco_firm_id = #{firm_id} and status =1")
    end
  end
  
  #得到公司最新三条评论
  def get_firm_remarks_top3(firm_id)
    CACHE.fetch("get_firm_remarks_top3/Remark/#{firm_id}",5.minutes) do
      Remark.find(:all ,
        :conditions => "resource_type = 'DecoFirm' and resource_id = #{firm_id}",
        :order => "created_at desc",
        :limit => 3)
    end  
  end
  
  #相似的商家       -- 调用 规则：|同城（city)，同价位，合作（上海地区） ||合作,同城(district)（无锡，宁波，苏州，杭州地区）
  def get_like_firms(firm)
    if firm.city.to_i == 11910 #上海地区
      conditions = " city = #{firm.city} "
      order = "is_cooperation DESC" 
      key = "get_like_0908_firms/firm/#{firm.city}"
    else #非上海地区
      conditions =  " district = #{firm.district} "
      order = "is_cooperation DESC"
      key = "get_like_0908_firms/firm/#{firm.district}"
    end
    DecoFirm
    @like_firms  = CACHEZ.fetch(key,5.hours) do
      DecoFirm.find(
        :all,
        :select => "id,name_abbr,design_praise,construction_praise,service_praise",
        :conditions => conditions,
        :order => order,
        :limit => 8 )
    end
    
  end

  # 相似网友装修日记         调用规则：同地区，同价位，同风格！
  def get_like_diaries(diary)
    CACHE.fetch("get_like_diaries/diary/#{diary.id}",RAILS_ENV == 'development' ? 0 : 5.hours) do
      DecorationDiary.find(
        :all,
        :select => "id,title,deco_firm_id",
        :conditions => ["price = ? and style = ? and status = ? and EXISTS (select 1 from deco_firms where deco_firms.city=#{diary.deco_firm.city} and deco_firms.id = decoration_diaries.deco_firm_id)", diary.price, diary.style, 1],
        :limit => "8" ,
        :order =>"id desc" )
    end
  end
  

  #得到推广公司信息
  def get_firm_by_id(deco_firm)
    CACHE.fetch("get_firm_by_id/firm/#{deco_firm.district.to_i}",1.day) do
      city = deco_firm.city.to_i == 11910 ? 'shanghai' : TAGURLS[deco_firm.district.to_i]
      firms_title = parse_xml(DECOFIRM_PROMOTED_DIARY['日记终端页'][city], ['title'])
      firms_id = firms_title.map{|f| f["title"].to_i}
      DecoFirm.find(
        :all,
        :conditions => ["id in (?)",firms_id],
        :limit => 5)
    end
  end

  def get_remark_editor(remark)
    if remark.hejia_bbs_user
      if remark.hejia_bbs_user.deco_id == 0
        remark.hejia_bbs_user
      else
        DecoFirm.find(remark.hejia_bbs_user.deco_id)
      end
    end
  end
 
end
