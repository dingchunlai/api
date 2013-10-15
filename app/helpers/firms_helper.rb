module FirmsHelper
  def get_city_name(city)
    HejiaTag
    key = "zhaozhuangxiu_firm_id_page_google_analytics_#{city}_city_name_#{Time.now.strftime('%Y%m%d')}"
    if CACHEZ.get(key).nil?
      result = HejiaTag.find(:first, :select => "TAGNAME", :conditions => "TAGID = #{city}")
      CACHEZ.set(key,result)
    else
      result = CACHEZ.get(key)
    end
    return result
  end
  def get_district_name(district)
    HejiaTag
    key = "zhaozhuangxiu_firm_id_page_google_analytics_#{district}_district_name_#{Time.now.strftime('%Y%m%d')}"
    if CACHEZ.get(key).nil?
      result = HejiaTag.find(:first, :select => "TAGNAME", :conditions => "TAGID = #{district}")
      CACHEZ.set(key,result)
    else
      result = CACHEZ.get(key)
    end
    return result
  end
  
  # same_city_same_price_firms
  def same_city_same_price(city, price)
    DecoFirm.same_city_same_price(city, price)
  end

  #根据设计、施工、服务分数给出相应百分比//张春明 6月7号
  def three_value(firm,praise_quli)
    max_praise = [firm.construction_praise, firm.design_praise, firm.service_praise].max == 0 ? 0 : [firm.construction_praise, firm.design_praise, firm.service_praise].max * 1.0 / 100
    max_praise == 0 ? 0 : (praise_quli / max_praise).round.to_s.concat("%")
  end
  
  # 获得当前城市前10名公司(order:1是星级降序，2是点评数字排序)
  def get_city_topten_firm(city, order)
    DecoFirm.get_city_topten_firm(city, order)
  end
  
  #得到当前留言分页的排序条数
  #per_page 分页数 ; current_page 当前页数 ;  total_pages 总页数 ; total_entries ;总条数
  def this_total(per_page,current_page,total_pages,total_entries)
    if current_page == total_pages
      "#{(current_page - 1) * per_page + 1}-#{total_entries}"  
    elsif total_entries < per_page
      "1-#{total_entries}"
    else
      "#{(current_page - 1) * per_page + 1}-#{current_page * per_page}" 
    end
  end
  
end
