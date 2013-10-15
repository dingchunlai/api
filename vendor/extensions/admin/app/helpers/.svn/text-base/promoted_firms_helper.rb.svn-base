module PromotedFirmsHelper
    CITIES_ = {
            11910 => "上海",
            12117 => "苏州",
            12301 => "宁波",
            12306 => "杭州",
            12118 => "无锡",
            12093 => '武汉',
            12122 => "南京",
            12173 => '青岛'
    }
  # 推广公司分类
  def promoted_firm_order promoted_firm

    unless promoted_firm.nil?
      if promoted_firm.category
        category = promoted_firm.category ? " --> 工装" : ''
        CITIES_[promoted_firm.city] + category
      elsif promoted_firm.villa
        villa = promoted_firm.villa ? " --> 别墅" : ''
        CITIES_[promoted_firm.city] + villa
      else
        style = promoted_firm.style.to_i == 0 ? '' : " --> #{STYLES[promoted_firm.style]}"
        model = promoted_firm.model.to_i == 0 ? '' : " --> #{MODELS[promoted_firm.model]}"
        district = promoted_firm.district.to_i == 0 ? '' : " --> #{HejiaTag.find_name(promoted_firm.district)}"
        price = promoted_firm.price.to_i == 0 ? '' : " --> #{DecoFirm.get_city_price_tag_value(promoted_firm.city , promoted_firm.price)}"
        except = promoted_firm.except ? "<span style='color:red;'>(例外)<span> " : ""
        CITIES_[promoted_firm.city] + " --> #{COMPANY_SORT_ORDERS[promoted_firm.order_class][1]}" + style + model + price + district + except
      end
    end
  end
  
end