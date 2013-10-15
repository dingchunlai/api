module DecoHelper
  
  def page_title
    if controller.controller_name == "deco" && controller.action_name == "index"
      "找装修频道 和家网"
    elsif controller.controller_name == 'index'
      "#{CITIES[params[:city].to_i]}装修公司,装修效果图案例,#{CITIES[params[:city].to_i]}装饰公司排行,#{CITIES[params[:city].to_i]}装修日记,#{CITIES[params[:city].to_i]}装潢公司点评,#{CITIES[params[:city].to_i]}装修网,#{CITIES[params[:city].to_i]}装饰网,#{CITIES[params[:city].to_i]}装潢网,#{CITIES[params[:city].to_i]}装修,装修公司,#{CITIES[params[:city].to_i]}家装-和家网#{CITIES[params[:city].to_i]}站"
    elsif controller.controller_name == "firms" 
      if controller.action_name == "index" || controller.action_name == "gongzhuang" || controller.action_name == "bieshu"
        "#{CITIES[params[:city].to_i]}装修公司,#{CITIES[params[:city].to_i]}装潢公司,#{CITIES[params[:city].to_i]}家装公司,#{CITIES[params[:city].to_i]}装饰公司-和家网#{CITIES[params[:city].to_i]}装修公司"
      elsif controller.action_name == 'show'
        "装修公司-#{@firm.name_zh}，装修案例，装修图片，装修日记，施工现场-和家网装修公司"
      elsif controller.action_name == "detail"
        "【公司简介】#{@firm.name_zh} 装修案例 #{CITIES[params[:city].to_i]}装饰效果图 #{CITIES[params[:city].to_i]}装修公司|装饰公司简介"
      elsif controller.action_name == "service"
        "【服务流程】#{@firm.name_zh} 装修案例 #{CITIES[params[:city].to_i]}装饰效果图 #{CITIES[params[:city].to_i]}装修公司|装饰公司服务流程"
      elsif controller.action_name == "promotion"
        "【优惠促销活动】#{@firm.offer_title} #{@firm.name_zh} 装修案例 #{CITIES[params[:city].to_i]}装饰效果图 #{CITIES[params[:city].to_i]}装修公司|装饰公司优惠活动"
      end
    elsif controller.controller_name == "events"
      case controller.action_name
      when "index"
        "【优惠促销活动】#{CITIES[params[:city].to_i]}装修优惠活动大全 装潢公司活动|装饰公司优惠活动#{params[:page]}"
      when "show"
        "【优惠促销活动】#{@firm.name_zh if @firm}#{@event.title}促销活动 #{CITIES[params[:city].to_i]}装修优惠促销活动大全 #{CITIES[params[:city].to_i]}装潢公司优惠促销活动|装饰公司优惠促销活动"
      when "coupon"
        "#{@event.firms[0].name_zh if @event}-装修公司优惠，装饰公司优惠，装潢公司优惠，家装公司优惠"
      when "coupon_show"
        "【优惠促销活动公司列表】促销活动 #{CITIES[params[:city].to_i]}装修优惠促销活动大全 #{CITIES[params[:city].to_i]}装潢公司优惠促销活动|装饰公司优惠促销活动"
      when "quotation"
        "【优惠促销活动公司报价单】#{@quotation.firms[0].name_zh if @quotation}#{@quotation.title} 报价单 #{CITIES[params[:city].to_i]}装潢公司优惠促销报价单 #{CITIES[params[:city].to_i]}装潢公司优惠促销报价单|装饰公司优惠促销报价单"
      end
    elsif controller.controller_name == "diaries"
      "【装修日记】#{@firm.name_zh if @firm} 装修案例 #{CITIES[params[:city].to_i]}装饰效果图 #{CITIES[params[:city].to_i]}装修公司|装饰公司装修日记"
    elsif controller.controller_name == "photos"
      if controller.action_name == "index" || "slide"
        "【施工图片】#{@firm.name_zh if @firm} 装修案例 #{CITIES[params[:city].to_i]}装饰效果图 #{CITIES[params[:city].to_i]}装修公司|装饰公司施工图片"
      elsif controller.action_name == "show"
        @photo.title || "图片"
      end
    elsif controller.controller_name == "ranking"
      "【热评|口碑】装修点评榜 #{CITIES[params[:city].to_i]}装潢公司口碑排榜 #{CITIES[params[:city].to_i]}装饰公司设计|施工|预算点评排行榜"
    elsif controller.controller_name == "worksites"
      "#{@company.name_zh}装修工地"
    elsif controller.controller_name == "dianping"
      case controller.action_name 
      when "index"
        "【口碑|装潢】装修评论 #{CITIES[params[:city].to_i]}装潢公司评论 #{CITIES[params[:city].to_i]}装修公司|装饰公司评论-和家网 #{params[:page] ||= 1}"
      when 'indexnew'
        "#{ROOM[params[:room].to_i]} #{PRICE[params[:price].to_i]} #{STYLES[params[:style].to_i]} 装修点评论，#{CITIES[params[:city].to_i]}装修案例-装修网#{params[:page]}"
      when "companycomment"
        "【热评|口碑】#{@company.name_zh} 装修评论 #{CITIES[params[:city].to_i]}装饰公司评论 #{CITIES[params[:city].to_i]}装修公司|装饰公司评论"
      when "show"
        "【热评|口碑】#{@commont.title} #{@company.name_zh}装修评论 #{CITIES[params[:city].to_i]}装饰公司评论 #{CITIES[params[:city].to_i]}装修公司|装饰公司评论"
      when "shownew"
        "#{@reviewlist[0].title},#{@company.name_zh}装修案例—装修网"
      when "shownew1"
        "#{@reviewlist[0].title},#{@company.name_zh}装修案例—装修网"
      when "newdp"
        str=""
        if !@company.nil?
          str+=@company.name_zh +","
        end
        str+="装修案例—装修网"
      when "editnew"
        "#{@company.name_zh}装修案例—装修网"
      when "continuenew"
        "#{@company.name_zh}装修案例—装修网"
      when "dianping_list"
        "#{CITIES[params[:city].to_i]}小户型装修点评,#{CITIES[params[:city].to_i]}装修案例大全-装修网"
      end
    elsif controller.controller_name == "cases"
      case controller.action_name 
      when "list"
        "装修图片，装潢图片，装饰图片，家装图片，装修效果图"
      when "company"
        "【多图】#{@decofirm.name_zh} 装修案例 #{CITIES[params[:city].to_i]}装饰效果图 #{CITIES[params[:city].to_i]}装修公司|装饰公司案例精选"
      when "zHuangCase"
        name = @decofirm.nil? ? "" : @decofirm.name_zh
        "#{name}-装修图片，装潢图片，装饰图片，家装图片"
      when "show"
        name = @decofirm.nil? ? "" : @decofirm.name_zh
        "【多图】#{@newcase.NAME} #{name} #{CITIES[params[:city].to_i]}装饰案例大全#{CITIES[params[:city].to_i]}装修公司|装饰公司案例精选"
      end
    elsif controller.controller_name == "designers"  
      case controller.action_name
      when "index"
        "【设计师】#{@decofirm.name_zh} 装修案例 #{CITIES[params[:city].to_i]}装饰效果图 #{CITIES[params[:city].to_i]}装修公司|装饰公司设计师"
      end
      
    elsif controller.controller_name == "vedio"
      if controller.action_name == "show"
        "【视频】#{@vedio.title} 装修视频 #{CITIES[params[:city].to_i]}装饰效果图 #{CITIES[params[:city].to_i]}装修公司|装饰公司视频"
      end
    elsif controller.controller_name == "note"
      if controller.action_name == "list"
        str = "装修点评，装修故事，装修日记，装修案例-和家网装修点评"
      end
    elsif controller.controller_name == "index"
      "装修公司大全，装修案例分享，装修效果图，装修促销活动-装修网"
    elsif controller.controller_name == "decoration_diaries"
      if controller.action_name == "index"
        "装修日记-#{@city.TAGNAME}装修日记，#{@city.TAGNAME}装修故事，#{@city.TAGNAME}装修点评，#{@city.TAGNAME}装修案例"
      end
    end
    
  end
  
  def location
    location = ""
    controller.controller_name == "deco" ? home = "找装修频道" : home = "#{link_to '找装修频道', '/'}&nbsp;>&nbsp;"
    location << home
    if controller.controller_name == "firms"
      if controller.action_name == "index"
        location << "装潢公司"
      elsif controller.action_name == "show"
        location << "<a href='/zhuangxiugongsi'>装修公司</a>"
        location << "&nbsp;>&nbsp;#{@firm.name_zh}"
      elsif controller.action_name == "detail"
        location << "<a href='/zhuangxiugongsi'>装修公司</a>"
        location << "&nbsp;>&nbsp;<a href='/firms-#{@firm.id}'>#{@firm.name_zh}</a>"
        location << "&nbsp;>&nbsp;公司介绍"
      elsif controller.action_name == "service"
        location << "<a href='/zhuangxiugongsi'>装修公司</a>"
        location << "&nbsp;>&nbsp;<a href='/firms-#{@firm.id}'>#{@firm.name_zh}</a>"
        location << "&nbsp;>&nbsp;服务流程"
      elsif controller.action_name == "promotion"
        location << "<a href='/zhuangxiugongsi'>装修公司</a>"
        location << "&nbsp;>&nbsp;<a href='/firms-#{@firm.id}'>#{@firm.name_zh}</a>"
        location << "&nbsp;>&nbsp;最新促销"
      end
    elsif controller.controller_name == "diaries"
      location << "<a href='/zhuangxiugongsi'>装修公司</a>"
      location << "&nbsp;>&nbsp;<a href='/firms-#{@firm.id}'>#{@firm.name_zh}</a>"
      location << "&nbsp;>&nbsp;装修日记"
    elsif controller.controller_name == "events"
      if controller.action_name == "show"
        location << "#{link_to '装修活动', events_path}"
        location << "&nbsp;>&nbsp;#{@event.title}"
      elsif controller.action_name == "coupon"
        location << "#{link_to '装修活动', events_path}"
        location << "&nbsp;>&nbsp;#{@event.title}"
      elsif controller.action_name == "coupon_show"
        location << "#{link_to '装修活动', events_path}"
        location << "&nbsp;>&nbsp;#{@event.title}"
      elsif controller.action_name == "quotation"
        location << "#{link_to '装修活动', events_path}"
        location << "&nbsp;>&nbsp;#{@quotation.title}"
      elsif
        location << "装修活动"
      end
    elsif controller.controller_name == "photos"
      location << "<a href='/zhuangxiugongsi'>装修公司</a>"
      location << "&nbsp;>&nbsp;<a href='/firms-#{@firm.id}'>#{@firm.name_zh}</a>"
      location << "&nbsp;>&nbsp;施工图片"
    elsif controller.controller_name == "ranking"
      location << "排行榜"
    elsif controller.controller_name == "worksites"
      location << "<a href='/zhuangxiugongsi'>装修公司</a>"
      location << "&nbsp;>&nbsp;<a href='/firms-#{@company.id}'>#{@company.name_zh}</a>"
      location << "&nbsp;>&nbsp;在建工地"
    elsif controller.controller_name == "dianping"
      if controller.action_name == "index"
        location << "最新评论"
      elsif controller.action_name == "companycomment"
        location << "<a href='/zhuangxiugongsi'>装修公司</a>"
        location << "&nbsp;>&nbsp;<a href='/firms-#{@company.id}'>#{@company.name_zh}</a>"
        location << "&nbsp;>&nbsp;网友点评"
      elsif controller.action_name == "show"
        location << "#{link_to @company.name_zh, firm_path(@company)}"
        location << "&nbsp;>&nbsp;#{@commont.title}"        
      end
    elsif controller.controller_name == "cases"  
      if controller.action_name == "list"
        location << "装修案例"
      elsif controller.action_name == "company"
        location << "<a href='/zhuangxiugongsi'>装修公司</a>"
        location << "&nbsp;>&nbsp;<a href='/firms-#{@decofirm.id}'>#{@decofirm.name_zh}</a>"
        location << "&nbsp;>&nbsp;案例"
      elsif controller.action_name == "zHuangCase"
        location << "<a href='/zhuangxiuanli'>装修案例</a>"
        if !@decofirm.nil?
          location << "&nbsp;>&nbsp;<a href='/firms-#{@decofirm.id}'>#{@decofirm.name_zh}</a>"
        end
        location << "&nbsp;>&nbsp;"+@newcase.NAME
      elsif controller.action_name == "show"
        location << "<a href='/zhuangxiuanli'>装修案例</a>"
        if !@decofirm.nil?
          location << "&nbsp;>&nbsp;<a href='/gs-#{@decofirm.id}'>#{@decofirm.name_zh}</a>"
        end
        location << "&nbsp;>&nbsp;"+@newcase.NAME
      end
    elsif controller.controller_name == "designers"  
      if controller.action_name == "index"
        location << ""
        location << "&nbsp;>&nbsp;<a href='/firms-#{@decofirm.id}'>#{@decofirm.name_zh}</a>"
        location << "&nbsp;>&nbsp;设计师"
      end
    elsif controller.controller_name == "vedio"
      if controller.action_name == "show"
        location << "<a href='/zhuangxiugongsi'>装修公司</a>"
        location << "&nbsp;>&nbsp;#{@vedio.title}"
      end
    end
    
  end
  
  def page_keywords
    if controller.controller_name == "dianping"
      if controller.action_name == "show"
        "#{@company.name_zh} #{CITIES[params[:city].to_i]}装修评论 装饰公司评论 #{CITIES[params[:city].to_i]}装修点评 设计师评论 装修公司评分"
      elsif controller.action_name == 'indexnew'
        "#{ROOM[params[:room].to_i]} #{PRICE[params[:price].to_i]} #{STYLES[params[:style].to_i]} #{CITIES[params[:city].to_i]}装修案例，装修点评，装修，装潢#{params[:page]}"
      elsif controller.action_name == "companycomment"
        "#{@company.name_zh} #{CITIES[params[:city].to_i]}装修评论 装饰公司评论 #{CITIES[params[:city].to_i]}装修点评 设计师评论 装修公司评分"
      elsif controller.action_name == "shownew"
        "#{@reviewlist[0].title},#{@company.name_zh},装修案例,装修评论,装修,装潢"
      elsif controller.action_name == "shownew1"
        "#{@reviewlist[0].title},#{@company.name_zh},装修案例,装修评论,装修,装潢"
      elsif controller.action_name == "newdp"
        str=""
        if !@company.nil?
          str+=@company.name_zh.to_s+","
        end
        str+="装修案例,装修评论,装修,装潢"
      elsif controller.action_name == "editnew"
        "#{@company.name_zh},装修案例,装修评论,装修,装潢"
      elsif controller.action_name == "continuenew"
        "#{@company.name_zh},装修案例,装修评论,装修,装潢"
      elsif controller.action_name == "dianping_list"
        "#{CITIES[params[:city].to_i]}小户型,#{CITIES[params[:city].to_i]}装修案例,装修点评,装修,装潢"
      else
        "#{CITIES[params[:city].to_i]}装修评论 装饰公司评论 #{CITIES[params[:city].to_i]}装修点评 设计师评论 装修公司评分"
      end
    elsif controller.controller_name == 'index'
      "#{CITIES[params[:city].to_i]}装修公司推荐,#{CITIES[params[:city].to_i]}装饰公司,装饰设计,装饰公司,室内装修,家居装饰,装修家居,装修设计,装饰设计,装潢设计,#{CITIES[params[:city].to_i]}装修论坛,#{CITIES[params[:city].to_i]}业主论坛,#{CITIES[params[:city].to_i]}装修公司报价"
    elsif controller.controller_name == "firms"
      if controller.action_name ==  "show"
        "#{@firm.name_zh}，装修公司，装潢公司，装饰公司，家装公司，装修案例，装修图片，装修日记，施工现场"
      elsif controller.action_name == 'index'
        "#{CITIES[params[:city].to_i]}装修公司,#{CITIES[params[:city].to_i]}装潢公司,#{CITIES[params[:city].to_i]}家装公司,#{CITIES[params[:city].to_i]}装饰公司,装修图片,装修效果图"
      elsif controller.action_name == 'gongzhuang'|| controller.action_name == 'bieshu'
        "#{CITIES[params[:city].to_i]}装修公司,#{CITIES[params[:city].to_i]}装饰公司,#{CITIES[params[:city].to_i]}装潢公司,#{CITIES[params[:city].to_i]}装修公司内幕,#{CITIES[params[:city].to_i]}室内装修,#{CITIES[params[:city].to_i]}家居装饰,#{CITIES[params[:city].to_i]}装修设计,#{CITIES[params[:city].to_i]}装饰设计,#{CITIES[params[:city].to_i]}装修公司排名,#{CITIES[params[:city].to_i]}装修公司报价,#{CITIES[params[:city].to_i]}装修案例"
      elsif controller.action_name == "show" || "detail" || "service" || "promotion"
        "#{@firm.name_zh},#{CITIES[params[:city].to_i]}装修,#{CITIES[params[:city].to_i]}装饰,#{CITIES[params[:city].to_i]}装饰案例,#{CITIES[params[:city].to_i]}装饰设计师,装修公司,装饰公司"
      end
    elsif controller.controller_name == "photos"
      "#{@firm.name_zh if @firm},#{CITIES[params[:city].to_i]}装潢,#{CITIES[params[:city].to_i]}装饰,#{CITIES[params[:city].to_i]}装饰案例,#{CITIES[params[:city].to_i]}装饰设计师,装修公司,装饰公司"
    elsif controller.controller_name == "diaries"
      "#{@firm.name_zh if @firm},#{CITIES[params[:city].to_i]}装潢,#{CITIES[params[:city].to_i]}装饰,#{CITIES[params[:city].to_i]}装饰案例,#{CITIES[params[:city].to_i]}装饰设计师,装修公司,装饰公司"
    elsif controller.controller_name == "events"
      if controller.action_name == "index"
        "#{CITIES[params[:city].to_i]}装修优惠活动,装饰公司活动,#{CITIES[params[:city].to_i]}装潢活动,装潢优惠活动,装饰优惠"
      elsif controller.action_name == "show"
        "@event.title,#{CITIES[params[:city].to_i]}装修公司优惠活动,#{CITIES[params[:city].to_i]}装饰公司促销优惠活动,#{CITIES[params[:city].to_i]}装潢促销优惠活动,#{CITIES[params[:city].to_i]}装修优惠促销活动,#{CITIES[params[:city].to_i]}装饰优惠促销活动"
      elsif controller.action_name == "coupon"
        "装修公司优惠，装饰公司优惠，装潢公司优惠，家装公司优惠"
      elsif controller.action_name == "coupon_show"
        "#{CITIES[params[:city].to_i]}装修优惠活动,装饰公司活动,#{CITIES[params[:city].to_i]}装潢活动,装潢优惠活动,装饰优惠"
      elsif controller.action_name == "quotation"
        "@quotation.title,#{CITIES[params[:city].to_i]}装修公司优惠报价单,#{CITIES[params[:city].to_i]}装饰公司促销优惠报价单,#{CITIES[params[:city].to_i]}装潢促销优惠报价单,#{CITIES[params[:city].to_i]}装修优惠促销报价单,#{CITIES[params[:city].to_i]}装饰优惠促销报价单"
      end
    elsif controller.controller_name == "cases"
      if controller.action_name == "list"
        "装修图片，装潢图片，装饰图片，家装图片，装修效果图，装潢效果图，装饰效果图，家装效果图，室内装修设计图，室内装潢设计图，室内装饰设计图，室内家装设计图"
      elsif controller.action_name == "company"
        "#{@decofirm.name_zh} #{CITIES[params[:city].to_i]}装潢 #{CITIES[params[:city].to_i]}装饰 #{CITIES[params[:city].to_i]}装饰案例 #{CITIES[params[:city].to_i]}装饰设计师 装修公司 装饰公司 "
      elsif controller.action_name == "zHuangCase"
        "#{DecoFirm.find(@newcase.COMPANYID).name_zh}-装修图片，装潢图片，装饰图片，家装图片"
      elsif controller.action_name == "show"
        "#{@newcase.NAME} #{CITIES[params[:city].to_i]}装修 #{CITIES[params[:city].to_i]}装饰 #{CITIES[params[:city].to_i]}装饰案例 #{CITIES[params[:city].to_i]}装饰设计师 装修公司 装饰公司"
      end
    elsif controller.controller_name == "designers"
      if controller.action_name == "index"
        "#{@decofirm.name_zh} #{CITIES[params[:city].to_i]}装潢 #{CITIES[params[:city].to_i]}装饰 #{CITIES[params[:city].to_i]}装饰案例 #{CITIES[params[:city].to_i]}装饰设计师 装修公司 装饰公司 "
      end
    elsif controller.controller_name == "decoration_diaries"
      if controller.action_name == "index"
        "#{@city.TAGNAME}装修日记，#{@city.TAGNAME}装修故事，#{@city.TAGNAME}装修点评，#{@city.TAGNAME}装修案例"
      end
    elsif controller.controller_name == "ranking"
      "装修点评榜,#{CITIES[params[:city].to_i]}装修口碑,装饰评价,#{CITIES[params[:city].to_i]}装饰排行,#{CITIES[params[:city].to_i]}装饰评论,装修点评,装潢评论"
    elsif controller.controller_name == "vedio"
      if controller.action_name == "show"
        "#{@vedio.title} #{CITIES[params[:city].to_i]}装潢 #{CITIES[params[:city].to_i]}装饰 #{CITIES[params[:city].to_i]}装饰案例 #{CITIES[params[:city].to_i]}装饰设计师 装修公司 装饰公司"
      end
    elsif controller.controller_name == "index"
      "装修公司，装修案例，装修效果图，促销活动，装修，装潢"
    elsif controller.controller_name == "note"
      if controller.action_name == "list"
        str=""
        if !@city.nil?
          str+="#{@city.TAGNAME}装修日记，#{@city.TAGNAME}装修故事，#{@city.TAGNAME}装修点评，#{@city.TAGNAME}装修案例"
        else
          str+="#{CITIES[params[:city].to_i]}装修日记，#{CITIES[params[:city].to_i]}装修故事，#{CITIES[params[:city].to_i]}装修点评，#{CITIES[params[:city].to_i]}装修案例"
        end
      end
    end
  end
  
  def page_description
    if controller.controller_name == "dianping"
      if controller.action_name == "show"
        "#{@company.name_zh}是#{CITIES[params[:city].to_i]}装修装饰行业知名的装修公司,专业提供室内装修,室内装饰设计,豪宅装修装饰等一条龙服务的专业公司。"
      elsif controller.action_name == 'indexnew'
        "#{CITIES[params[:city].to_i]}装修案例点评是#{CITIES[params[:city].to_i]}装修业主在#{CITIES[params[:city].to_i]}装修公司为其提供#{ROOM[params[:room].to_i]} #{PRICE[params[:price].to_i]} #{STYLES[params[:style].to_i]}装修服务后，根据装修效果图，装潢施工质量和装修服务态度等写出真实的装修日记和装修评论，方便#{CITIES[params[:city].to_i]}居家消费者挑选合适的#{CITIES[params[:city].to_i]}装修公司作出参考#{params[:page]}"
      elsif controller.action_name == "companycomment"
        "#{@company.name_zh}是#{CITIES[params[:city].to_i]}装修装饰行业知名的装修公司,专业提供室内装修,室内装饰设计,豪宅装修装饰等一条龙服务的专业公司。"
      elsif controller.action_name == "shownew"
        "装修案例真实反映#{@company.name_zh}的现状,看装修业主对公司名称的装修日记、专业人士的点评和网友的装修评论了解公司名称的服务质量。最新装修案例日记：评论标题，快来看看吧！"
      elsif controller.action_name == "shownew1"
        "装修案例真实反映#{@company.name_zh}的现状,看装修业主对公司名称的装修日记、专业人士的点评和网友的装修评论了解公司名称的服务质量。最新装修案例日记：评论标题，快来看看吧！"
      elsif controller.action_name == "newdp"
        str=""
        if !@company.nil?
          str+=@company.name_zh.to_s+","
        end
        str+="装修案例,装修评论,装修,装潢"
      elsif controller.action_name == "editnew"
        "#{@company.name_zh},装修案例,装修评论,装修,装潢"
      elsif controller.action_name == "continuenew"
        "#{@company.name_zh},装修案例,装修评论,装修,装潢"
      elsif controller.action_name == "dianping_list"
        "#{CITIES[params[:city].to_i]}装修案例点评时#{CITIES[params[:city].to_i]}装修业主在#{CITIES[params[:city].to_i]}装修公司为其提供#{CITIES[params[:city].to_i]}小户型装修服务后,根据装修效果图\装潢施工质量和装修服务态度等写出真实得装修日记和装修评论,方便#{CITIES[params[:city].to_i]}居家消费者挑选合适得#{CITIES[params[:city].to_i]}装修公司作为参考"
      else
        "选装修是和家网集中网友对装潢公司的设计|预算|施工|服务等项目的评论和评分的频道,可以看到网友对装潢公司的评论,包括装修投诉和装潢公司满意程度。"
      end
    elsif controller.controller_name == 'index'
      "看网友点评,选#{CITIES[params[:city].to_i]}装修公司,请查看装修公司大全,真实的装修案例,各种装修风格及装修效果图反映装修公司现状,大量网友装修日记与装修故事,为您装修提供参考。最新装修促销活动及时把握,方便居家消费者挑选合适的装修公司。和家网装修点评是为装修装饰行业以及居家消费者打造的服务平台,内容包括(装饰公司点评,装修公司排行,装修效果图案例,网友装修日记,室内装饰,装饰设计,#{CITIES[params[:city].to_i]}装修,#{CITIES[params[:city].to_i]}装饰,装修招标等装修内容)"
    elsif controller.controller_name == "firms"
      if controller.action_name == "index" 
        "囊括#{CITIES[params[:city].to_i]}所有装修公司,各种装修案例，装修风格，装修效果图，真实反应装修公司综合水平。最新装修促销活动及时把握，让您装修顺时而动。"
      elsif controller.action_name ==  "detail" 
        "#{@firm.name_zh}#{get_firm_city(@firm)}是装修装饰行业知名的装修公司,专业提供室内装修,室内装饰设计,豪宅装修装饰等一条龙服务的专业公司。"
      elsif controller.action_name ==  "service"
        "#{@firm.name_zh}#{get_firm_city(@firm)}是装修装饰行业知名的装修公司,专业提供室内装修,室内装饰设计,豪宅装修装饰等一条龙服务的专业公司。"
      elsif controller.action_name ==  "promotion" 
        "#{@firm.name_zh}#{get_firm_city(@firm)}是装修装饰行业知名的装修公司,专业提供室内装修,室内装饰设计,豪宅装修装饰等一条龙服务的专业公司。"
      elsif controller.action_name ==  "show"
        "和家网#{get_firm_city(@firm)}站#{@firm.name_zh}是#{get_firm_city(@firm)}修装饰行业知名的装修公司,专业提供室内装修,室内装饰设计等装修装潢全套服务的专业装修公司。"
      end
    elsif controller.controller_name == "photos"
      "#{@firm.name_zh if @firm}是#{CITIES[params[:city].to_i]}装修装饰行业知名的装修公司,专业提供室内装修,室内装饰设计,豪宅装修装饰等一条龙服务的专业公司。"
    elsif controller.controller_name == "diaries"
      "#{@firm.name_zh if @firm}是#{CITIES[params[:city].to_i]}装修装饰行业知名的装修公司,专业提供室内装修,室内装饰设计,豪宅装修装饰等一条龙服务的专业公司。"
    elsif controller.controller_name == "events"
      if controller.action_name == "index"
        "装修活动是发布和家网组织的家装活动发布平台，网友可以看到#{CITIES[params[:city].to_i]}装修公司、设计公司、装饰公司、装潢公司、监理公司的最新优惠活动。"
      elsif controller.action_name == "show"
        "#{@event.title} 是发布和家网组织的家装活动发布平台,及时发布最新#{CITIES[params[:city].to_i]}装修公司、设计公司、装饰公司、装潢公司的最新优惠活动。"
      elsif controller.action_name == "coupon"
        "和家网会员专享#{DecoFirm.find(@firm_id).name_zh}装修优惠信息，装潢装饰更省钱。还有更多最新其他装修公司、设计公司、装饰公司、装潢公司的最新优惠活动。"
      elsif controller.action_name == "coupon_show"
        "装修活动是发布和家网组织的家装活动发布平台，网友可以看到#{CITIES[params[:city].to_i]}装修公司、设计公司、装饰公司、装潢公司、监理公司的最新优惠活动。"
      elsif controller.action_name == "quotation"
        "#{@quotation.title} 是发布和家网组织的家装活动发布平台,及时发布最新#{CITIES[params[:city].to_i]}装修公司、设计公司、装饰公司、装潢公司的最新优惠报价单。"  
      end
    elsif controller.controller_name == "ranking"
      "点评榜是和家网集中网友对装潢公司的口碑|设计|预算|施工|服务|案例|在建工地等项目的评论和评分的排行，可以看到网友对装潢公司的评分。"
    elsif controller.controller_name == "cases"
      if controller.action_name == "list"
        "装修案例是和家网#{CITIES[params[:city].to_i]}装修公司提供的装修图片,其中包括装修效果图和实景图,透过此类家装图片提高家装业主对装修公司选择的参考价值,装修图片以装修风格|装修户型|装修价格和装修用途分类,尽可能使所有的装修图片更帖近生活。"
      elsif controller.action_name == "company"
        "#{@decofirm.name_zh}是#{CITIES[params[:city].to_i]}装修装饰行业知名的装修公司,专业提供室内装修,室内装饰设计,豪宅装修装饰等一条龙服务的专业公司。"
      elsif controller.action_name == "zHuangCase"
        if !@decofirm.nil?
          name = @decofirm.name_zh
        else
          name=""
        end
        "和家网#{CITIES[params[:city].to_i]}站#{name}是#{CITIES[params[:city].to_i]}修装饰行业知名的装修公司,专业提供室内装修,室内装饰设计等装修装潢全套服务的专业装修公司。"
      elsif controller.action_name == "show"
        if !@decofirm.nil?
          name = @decofirm.name_zh
        else
          name=""
        end
        "#{@newcase.NAME} #{name}是#{CITIES[params[:city].to_i]}装修装饰行业知名的装修公司,专业提供室内装修,室内装饰设计,豪宅装修装饰等一条龙服务的专业公司。"
      end
    elsif controller.controller_name == "designers"
      if controller.action_name == "index"
        "#{@decofirm.name_zh} 是#{CITIES[params[:city].to_i]}装修装饰行业知名的装修公司,专业提供室内装修,室内装饰设计,豪宅装修装饰等一条龙服务的专业公司。 "
      end
    elsif controller.controller_name == "vedio"
      if controller.action_name == "show"
        "#{@vedio.title}"
      end
    elsif controller.controller_name == "index"
      "选装修请查看装修公司大全，真实的装修案例反映装修公司现状，大量房屋装修效果图全面分享，最新装修促销活动及时把握，方便居家消费者挑选合适的装修公司作出参考"
    elsif controller.controller_name == "note"
      if controller.action_name == "list"
        str="和家网汇集#{TAGURLS[@city_id.to_i]}网友亲身装修经历，记录最真实的完整装修故事。装修日记，包括完成装修过程和配套的装修案例图片与装修施工图，让您不在现场也身临其境。"
      end
    elsif controller.controller_name == "decoration_diaries"
      if controller.action_name == "index"
        "#{@city.TAGNAME}市网友提供的最新装修日记，完整的装修过程，还提供了多套现场图片，还有和家网装修案例图库和装修施工图库。"
      end
    end
  end
  
  def countdown_string(count)
    if count == "-"
      "<strong>长期有效</strong>"
    elsif count < 0
      "<strong>已结束</strong>"
    elsif count == 0
      "<strong>最后一天</strong>"
    else
      "报名还有 <strong>#{count}</strong> 天"
    end
  end
  
  def districts_hash
    key = "zhuangxiu_area_key"
    if CACHE.get(key).nil?
      districts = DecoFirm.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 11910")
      CACHE.set(key, districts)
    else
      districts = CACHE.get(key)
    end
    hash = Hash.new
    districts.each do |d|
      hash[d.tagid] = d.tagname
    end
    return hash
  end
  
  def get_district id
    CACHE.fetch("zhuangxiu_district_key_#{id}", 1.day) do
      CaseTag.find_by_TAGID id 
    end
  end
  #日记总数
  def diaries_count
    CACHE.fetch("diaries_count/diary/",5.hours) do
      DecorationDiary.count(:conditions => "status = 1")
    end
  end
  
  def designer_count
    key = "disigner_count_key2_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      count = CaseDesigner.count(:conditions => "STATUS = '100'")
      CACHE.set(key,count)
    else
      count = CACHE.get(key)
    end
    return count    
  end
  
  def model_count(p)
    count_key = "model_count_key_#{p}"
    if CACHE.get(count_key).nil?
      count = DecoFirm.count(:conditions => ["model = ?", p])
      CACHE.set(count_key, count)
    else
      count = CACHE.get(count_key)
    end
    return count
  end
  
  def style_count(p)
    count_key = "style_count_key_#{p}"
    if CACHE.get(count_key).nil?
      count = DecoFirm.count(:conditions => ["style = ?", p])
      CACHE.set(count_key, count)
    else
      count = CACHE.get(count_key)
    end
    return count
  end
  
  def district_count(p)
    count_key = "district_count_key_#{p}"
    if CACHE.get(count_key).nil?
      count = DecoFirm.count(:conditions => ["district = ?", p])
      CACHE.set(count_key, count)
    else
      count = CACHE.get(count_key)
    end
    return count
  end
  
  def firms_count
    count_key = "firms_count_key_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(count_key).nil?
      count = DecoFirm.count(:all, :conditions => ["state <> ? and city = ?", "-100", 11910])
      CACHE.set(count_key, count)
    else
      count = CACHE.get(count_key)
    end
    return count
  end
  
  def firms_count_all
    count_key = "firms_count_all_key_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(count_key).nil?
      count = DecoFirm.count(:all, :conditions => "state <> '-100' ")
      CACHE.set(count_key, count)
    else
      count = CACHE.get(count_key)
    end
    return count
  end
  
  def users_count
    count_key = "users_count_key"
    if CACHE.get(count_key).nil?
      count = HejiaUserBbs.count
      CACHE.set(count_key, count)
    else
      count = CACHE.get(count_key)
    end
    return count
  end
  
  def register_name(name)
    if name.match(/[0-9a-zA-Z-_]+/)
      n = name[0,2]
    else
      n = name[0,3]
    end
    return n + "**"
  end
  
  #导航上:点评公司的人数， 日记改版后不用。新日记页面上线后删除此方法
  def commonts_count
    count_key = "commonts_count_key_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(count_key).nil?
      count = DecoReview.count('id',:conditions => "formid = '#{PINGLUN_ID}' and status=1")
      CACHE.set(count_key, count)
    else
      count = CACHE.get(count_key)
    end
    return count
  end
  #导航上:  对公司留言的人数
  def remarks_count
    CACHE.fetch("remarks_count/remark/",5.hours) do
      Remark.count(:conditions => "resource_type ='DecoFirm'")
    end
  end
  
  #解析api对应栏目的xml输出
  def parse_xml(xml, parameters, end_num = nil)
    fetch_api_promotion_data xml, parameters, 0, end_num
  end
  def case_count
    count_key = "case_count_key_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(count_key).nil?
      count = Case.count(:all, :conditions => "STATUS!='-100' and ISNEWCASE=1 and TEMPLATE != 'room' and ISZHUANGHUANG='1' and COMPANYID!=7")
      CACHE.set(count_key, count)
    else
      count = CACHE.get(count_key)
    end
    return count
  end
  
  def case_count_company
    count_key = "case_count_key_company_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(count_key).nil?
      count = Case.count("distinct(COMPANYID)", :conditions => "STATUS!='-100' and ISNEWCASE=1 and TEMPLATE != 'room' and ISZHUANGHUANG='1'")
      CACHE.set(count_key, count)
    else
      count = CACHE.get(count_key)
    end
    return count  
  end
  
  def factory_count
    count_key = "factory_count_key_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(count_key).nil?
      count = CaseFactoryCompany.count(:all, :conditions => "COMPANYID is not null")
      CACHE.set(count_key, count)
    else
      count = CACHE.get(count_key)
    end
    return count
  end 
  
  def getstar(score)
    if score.to_i>=3
      "<img src='http://www.51hejia.com/images/zhuangxiu805/star.gif'/><img src='http://www.51hejia.com/images/zhuangxiu805/star.gif'/><img src='http://www.51hejia.com/images/zhuangxiu805/star.gif'/>"
    elsif score.to_i>=2
      "<img src='http://www.51hejia.com/images/zhuangxiu805/star.gif'/><img src='http://www.51hejia.com/images/zhuangxiu805/star.gif'/>"
    elsif score.to_i>=1
      "<img src='http://www.51hejia.com/images/zhuangxiu805/star.gif'/>"
    elsif score.to_i>=0
      ""
    elsif score.to_i>=-1
      "<img src='http://www.51hejia.com/images/zhuangxiu805/blackstar.jpg'>"
    elsif score.to_i>=-2
      "<img src='http://www.51hejia.com/images/zhuangxiu805/blackstar.jpg '><img src='http://www.51hejia.com/images/zhuangxiu805/blackstar.jpg '>"
    else 
      "<img src='http://www.51hejia.com/images/zhuangxiu805/blackstar.jpg '><img src='http://www.51hejia.com/images/zhuangxiu805/blackstar.jpg '><img src='http://www.51hejia.com/images/zhuangxiu805/blackstar.jpg '>"      
    end  
  end
  
  def getseoevents
    key = "zhaozhuangxiu_seo_events_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    
    if CACHEZ.get(key).nil?
      result =  DecoEvent.find(:all,:select => "title,id,starts_at",:order => "id desc",:limit=>10)
      CACHEZ.set(key,result)
    else
      result = CACHEZ.get(key)
    end
    return result    
  end
  
  
  
  def getseoworksites
    key = "zhaozhuangxiu_worksites_index_seo_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    
    if CACHE.get(key).nil?
      result = CaseFactoryCompany.find(:all,:select => "PROVINCE2,COMPANYID,NAME,MONEY",:conditions => "ENDENABLE > #{Time.now.strftime('%Y-%m-%d')}",:group => "COMPANYID", :limit => 10, :order => "id desc")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end  
  
  def getseoreviews
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
  
  def get_index_new_5_reviews
    key = "zhaozhuangxiu_index_new_5_reviews_#{Time.now.strftime('%Y%m%d%H%M')}"
    result = nil
    
    if CACHE.get(key).nil?
      result =  DecoReview.find(:all,:select => "c16,c8,id,cdate",:conditions=>"formid = '#{PINGLUN_ID}' and status = '1'",:order => "cdate desc",:limit=>5)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result    
  end
  
  def get_index_new_n_reviews(num)
    key = "zhaozhuangxiu_index_new_5_reviews_#{Time.now.strftime('%Y%m%d%H%M')}"
    result = nil
    
    if CACHE.get(key).nil?
      result =  DecoReview.find(:all,:select => "c16,c8,id,cdate",:conditions=>"formid = '#{PINGLUN_ID}' and status = '1'",:order => "cdate desc",:limit=>num.to_i)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result    
  end  
  
  def get_first_dianping(companyid)
    key = "zhaozhuangxiu_gongsi_zuixin_pinglun_#{Time.now.strftime('%Y%m%d%H')}_#{companyid}"
    result = nil
    
    if CACHE.get(key).nil?
      result =  DecoReview.find(:first,:conditions=>"formid = '#{PINGLUN_ID}' and status = '1' and c1 = '#{companyid}'",:order => "id desc")
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
  
  def get_xiaobian_dianping(companyid)
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
  
  def getgoodreviews
    key = "zhaozhuangxiu_good_reviews_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    if CACHEZ.get(key).nil?
      result =  DecoReview.find(:all,:select => "c8,id",:conditions=>"formid = '#{PINGLUN_ID}' and c15 = '2' and status = '1'",:order => "id desc",:limit=>8)
      CACHEZ.set(key,result)
    else
      result = CACHEZ.get(key)
    end
    return result
  end
  
  def gettopnewcase
    key = "zhaozhuangxiu_top_new2_case_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      result = Case.find(:all,:select=>"NAME,ID,COMPANYID",:conditions => "STATUS!='-100' and ISNEWCASE=1 and TEMPLATE != 'room' and ISZHUANGHUANG='1'",:order => "ID desc",:limit => 15)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end 
  
  def gettopnewgoodcase
    key = "zhaozhuangxiu_top_new2_good_case_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      result = Case.find(:all,:select=>"NAME,ID,COMPANYID",:conditions => "STATUS!='-100' and ISNEWCASE=1 and TEMPLATE != 'room' and ISZHUANGHUANG='1' and ISGOOD = '1'",:order => "ID desc",:limit => 6)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end   
  
  def getseofirmphoto(id)
    
    key = "zhaozhuangxiu_photo_seo_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
    result = nil
    if CACHE.get(key).nil?
      c = DecoFirm.getfirm(id)
      result = c.photos
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end
  
  def getseocasecompany
    key = "zhaozhuangxiu_case_company_seo_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    if CACHE.get(key).nil?
      result = DecoFirm.find(:all,:select => "id,name_zh,name_abbr,cases_count,total_score" ,:limit => 10, :order => "cases_count desc")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end  
  
  def getseodesigncompany
    key = "zhaozhuangxiu_design_company_seo_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    if CACHE.get(key).nil?
      result = DecoFirm.find(:all, :limit => 10, :order => "design_score desc")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end  
  
  def getseokoubeicompany
    key = "zhaozhuangxiu_koubei_company_seo_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    if CACHEZ.get(key).nil?
      result = DecoFirm.find(:all,:select=>"id,name_zh,name_abbr,total_score" ,:limit => 10, :order => "total_score desc")
      CACHEZ.set(key,result)
    else
      result = CACHEZ.get(key)
    end
    return result 
  end  
  
  def getcase(id)
    key = "photo_case_company_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
    c= []
    if CACHE.get(key).nil?
      c = Case.find(:all,:conditions=>"STATUS != '-100' and ISNEWCASE=1 and TEMPLATE != 'room' and ISZHUANGHUANG='1' and ISCOMMEND='0' and COMPANYID=#{id}",:order=>"ID DESC",:limit=>4)
      CACHE.set(key, c)
    else
      c = CACHE.get(key)
    end
    return c
  end
  
  def getdesigner(id)
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
  
  def getfirm id
    DecoFirm.getfirm id
  end  
  
  def get_vedio_by_companyid(companyid)
    key = "zhaozhuangxiu_gongsishipin_#{Time.now.strftime('%Y%m%d%H')}_#{companyid}"
    if CACHE.get(key).nil?
      result = DecoVedio.find(:first,:conditions => "firm_id = '#{companyid}' and tuijian = '1'",:select => "id")
      if result && result.id
        CACHE.set(key,result)
      else
        CACHE.set(key,DecoVedio.new)
      end
    else
      result = CACHE.get(key)
    end
    return result  
  end
  
  def getcompanyreviews(companyid,review_type)
    
    key = "key_firm_review_firmid_#{companyid}_type_#{review_type}_#{Time.now.strftime('%Y%m%d%H')}_1"
    
    commonts = []
    if CACHE.get(key).nil?
      conditions = []
      conditions << "formid = '#{PINGLUN_ID}'"
      conditions << "status = '1'"
      conditions << "c15 = '#{review_type}'" if review_type && review_type.to_s != '1'
      conditions << "c1 = '#{companyid}'"
      
      commonts = DecoReview.find(:all,:conditions => conditions.join(' and '),:order => 'cdate desc',:group => 'c16',:limit => 7)
      CACHE.set(key,commonts)
    else
      commonts = CACHE.get(key)
    end
    
    return commonts
  end
  
  def getcompanyreviews2(companyid,review_type,exceptid)
    
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
  
  
  
  def getzhuangxiuarticle
    key = "zhuangxiu_article_pinglun_right_#{Time.now.strftime('%Y%m%d%H')}"
    result = []
    HejiaArticle
    if CACHE.get(key).nil?
      result = HejiaArticle.find(:all ,:select => "ID,TITLE,CREATETIME" ,
        :conditions => "FIRSTCATEGORY='12394' and STATE='0'",
        :order => "CREATETIME desc",
        :limit => 15)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    
    return result
  end
  
  def get_firm_name_abbr(id)
    company_show_name = ''
    company = getfirm(id)
    if company.name_abbr && company.name_abbr != '' && company.name_abbr != '装饰公司'
      company_show_name = company.name_abbr
    else
      company_show_name = company.name_zh.chars[0,4]
    end
    return company_show_name
  end
  
  def get_zhuangxiu_case
    key = "zhaozhuangxiu_get_zhuangxiu_case_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      result = DecoReview.find(:all,:select=>"id,c8,c10,c11,udate",:conditions=>"formid = '#{PINGLUN_ID}' and status = '1'",:order => "id desc",:limit =>10)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  
  def get_firm_name_abbr2(company)
    company_show_name = ''
    if company.name_abbr && company.name_abbr != ''
      company_show_name = company.name_abbr.chars[0,6]
    else
      company_show_name = company.name_zh.chars[0,4]
    end
    return company_show_name
  end
  #专为公司列表页显示的公司名称为12位
  def get_list_firm_name_abbr2(company)
    if company.name_abbr && company.name_abbr != ''
      company.name_abbr.chars[0,12]
    else
      company.name_zh.chars[0,4]
    end
  end
  
  def get_firm_city(firm)
    city = ''
    if firm.city == 11910
      city = '上海'
    else
      city = CITIES[firm.district]
    end
    return city
  end
  
  def truncate_u(text, length = 30, truncate_string = "")
    l = 0
    char_array = text.unpack("U*")
    char_array.each_with_index do |c,i|
      l = l + (c<127 ? 0.5 : 1)
      if l >= length
        return char_array[0..i].pack("U*") + (i < char_array.length - 1 ? truncate_string : "")
      end
    end
    return text
  end
  
  def caculater_img_num(str)
    result = 0
    while i = str=~ /img/
      str = str.chars[i+3,str.size]
      result = result + 1
    end
    return result
  end
  
  #生成公司地址
  def gen_firm_city_path(firm_id)
    #    return "/firms-#{firm_id}"
    
    key = "zhaozhuangxiu_firm_path_#{firm_id}_5_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      firm = getfirm(firm_id)
      if firm.city.to_i == 11910
        result = get_domain(11910) 
      else  
        result = get_domain(firm.district)   
      end
      result = result + "/gs-#{firm.id}/"  
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    
    return result
  end  
  
  #公司案例地址
  def gen_firm_city_cases(firm_id)
    return gen_firm_city_path(firm_id)+'cases/'
  end
  
  #公司优惠地址
  def gen_firm_city_event(firm_id,event_id)
    return gen_firm_city_path(firm_id)+"y-#{event_id}"
  end
  
  #公司优惠详细地址(绝对路径)
  def coupon_absolute_url(firm_id,event_id)
    "#{generate_firm_path(firm_id)}y-#{event_id}"
  end
  
  #公司案例详细地址(绝对路径)
  def case_absolute_url(firm_id,case_id)
    "#{generate_firm_path(firm_id)}cases-#{case_id}"
  end
  
  #案例详细地址
  def gen_firm_city_case_detail(firm_id,case_id)
    return gen_firm_city_path(firm_id)+"cases-#{case_id}"
  end
  
  #公司图片地址
  def gen_firm_city_photos(firm_id)
    return gen_firm_city_path(firm_id)+'photos/'
  end
  
  #公司设计师地址
  def gen_firm_city_designers(firm_id)
    return gen_firm_city_path(firm_id)+'designers/'
  end  
  
  #公司促销地址
  def gen_firm_city_promotion(firm_id)
    return gen_firm_city_path(firm_id)+'promotion/'
  end
  
  #点评地址
  def gen_firm_city_dianping(firm_id,dianping_id)
    return gen_firm_city_path(firm_id)+"dianping/#{dianping_id}"
  end
  
  
  def gen_firm_commonts_path(firm)
    return "/dianping/companycomment/#{firm.id}/1/1"
  end
  
  def gen_dianping_path(commont)
    return "/dianping-#{commont.id}"
  end
  
  #获得活动关联的公司id
  def get_event_firm(event)
    key = "zhaozhuangxiu_firm_path_#{event.id}_7"
    if CACHE.get(key).nil? || true
      begin
        result = event.firms[0]["id"].to_i
      rescue
        result = 0
      end
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    
    return result
  end
  
  
  
  def get_gushi_dianping(gushi)
    key = "zhaozhuangxiu_gushi_dianping_username_#{gushi.id}"
    if CACHE.get(key).nil?
      if gushi.dianping_id.to_i == 0
        result = ' '
      else
        review = DecoReview.find(:first,:select => 'id,c16',:conditions => "id = #{gushi.dianping_id}")
        result = review.username
      end
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  
  #获得地区内点评多的公司
  def get_firms_by_city(city, district, area)
    key = "company/#{city}/#{district}/#{area}/top5"
    CACHE.fetch(key, 1.hour) do
      if city.to_i == 11910
        DecoFirm.find(
          :all,
          :select => "id, name_zh, name_abbr, comments_count, city,district, pv_count",
          :conditions => "city = #{city} and district = #{district} and is_cooperation=1 and state <> '-99' and state <> '-100'",
          :order => 'comments_count desc',
          :limit => 5)
      else
        DecoFirm.find(
          :all, :select => "id,name_zh, name_abbr, comments_count, city, district, pv_count",
          :conditions => "district = #{district} and area = #{area} and state <> '-99' and state <> '-100'",
          :order => 'is_cooperation desc, comments_count desc',
          :limit => 5)
      end
    end
  end
  
  #获得地区内分数多的公司
  def get_firms_by_city_score(city,district,area)
    key = "zhaozhuangxiu_firm_city_top_dianping_score_#{city}_#{district}_#{area}_#{Time.now.strftime('%Y%m%d%H')}_1"
    if CACHE.get(key).nil?
      if city.to_i == 11910
        result = DecoFirm.find(:all,:select => "id,name_zh,name_abbr,comments_count,city,district",:conditions => "city = #{city} and district = #{district} and is_cooperation=1 and state <> '-99' and state <> '-100'",:order => 'praise desc',:limit => 5)
      else
        result = DecoFirm.find(:all,:select => "id,name_zh,name_abbr,comments_count,city,district",:conditions => "district = #{district} and area = #{area} and state <> '-99' and state <> '-100'",:order => 'is_cooperation desc,praise desc',:limit => 5)
      end
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    
    return result
  end  
  
  #获得城市内点评多的公司
  def get_firms_by_city2(city)
    key = "zhaozhuangxiu_firm_city_top_dianping_20100311_#{city}_#{Time.now.strftime('%Y%m%d%H')}_1"
    if CACHE.get(key).nil?
      if city.to_i == 11910
        result = DecoFirm.find(:all,:select => "id,name_zh,name_abbr,comments_count,city,district",:conditions => "city = #{city} and state <> '-99' and state <> '-100'",:order => 'is_cooperation desc,praise desc',:limit => 8)
      else
        result = DecoFirm.find(:all,:select => "id,name_zh,name_abbr,comments_count,city,district",:conditions => "district = #{city} and state <> '-99' and state <> '-100'",:order => 'is_cooperation desc,praise desc',:limit => 8)
      end
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    
    return result
  end  
  
  #new
  def tag_id(case_id)
    case_tags = HejiaTagEntityLink.find(:all,
      :select => "distinct TAGID",
      :conditions => ["LINKTYPE = 'case' and ENTITYID = ?", case_id])
    if case_tags
      case_tag_ids = []
      style_tag_ids = [4361,4362,4363,4367,4360,6680,6681]
      for tag in case_tags
        case_tag_ids << tag.TAGID
      end
      result = case_tag_ids & style_tag_ids
      style_tag_id = result[0] || 4361
      style_tag_id
    else
      style_tag_id = 4361
    end
  end  
  def query_hot_image2(case_id)
    style_tag_id = tag_id(case_id)
    key = "key_zhaozhuangxiu_show_about_image_style_#{style_tag_id}_four_#{Time.now.strftime("%Y-%m-%d")}1"
    if CACHE.get(key).nil?
      sql = "SELECT c.ID, c.NAME, c.MAINPHOTO, c.DESIGNERID, c.TYPE_ID,c.COMPANYID FROM HEJIA_CASE c, HEJIA_COMPANY hc, HEJIA_TAG_ENTITY_LINK ht " +
        "where c.COMPANYID = hc.ID and hc.SPECIAL = 1 and c.STATUS != -100 and c.ID = ht.ENTITYID and ht.LINKTYPE = 'case' and ht.TAGID = #{style_tag_id} order by ht.ENTITYID DESC limit 10;"
      cases = Case.find_by_sql sql
      if cases.size < 4
        sql = "SELECT c.ID, c.NAME, c.MAINPHOTO, c.DESIGNERID, c.TYPE_ID,c.COMPANYID FROM HEJIA_CASE c, HEJIA_COMPANY hc, HEJIA_TAG_ENTITY_LINK ht " +
          "where c.STATUS != -100 and c.ID = ht.ENTITYID and c.ISZHUANGHUANG = 1 and ht.LINKTYPE = 'case' and ht.TAGID = #{style_tag_id} order by ht.ENTITYID DESC limit #{10 - cases.size};"
        hcases = Case.find_by_sql sql
        hcases.each { |e| cases << e }
      end
      CACHE.set(key, cases)
      return cases
    else
      cases = CACHE.get(key)
      return cases
    end
  end

  def query_tag_name(tag_id)
    tag = PothoTag.find(:first, :conditions => ["id = ?", tag_id])
    return tag.name if tag
  end
  def query_case_tags(case_id)
    key = "zhaozhuangxiu_query_case_tags_by_case_id_#{case_id}_#{Time.now.strftime('%Y%m%d')}"
    if CACHEZ.get(key).nil?
      sql = "select t.tagid as tid,t.tagname as tname,t.tagurl as turl,t1.tagid as tfid,t1.tagname as tfname,t1.tagurl as tfurl" +
        " from HEJIA_TAG_ENTITY_LINK l,HEJIA_TAG t,HEJIA_TAG t1 where l.linktype='case' and l.entityid=#{case_id}" +
        " and l.tagid=t.tagid and t.tagfatherid<>4401 and t1.TAGID = t.TAGFATHERID and t.TAGFATHERID != 31262 and t.TAGFATHERID != 4350"
      results = HejiaTag.find_by_sql(sql)
      CACHEZ.set(key,results)
    else
      results = CACHEZ.get(key)
    end
    return results
  end

  def query_tags(photo_id)
    key = "zhaozhuangxiu_query_tags_by_photo_id_#{photo_id}_#{Time.now.strftime('%Y%m%d')}"
    if CACHEZ.get(key).nil?
      tags = PhotoPhotosTag.find(:all, :conditions => ["photo_id = ?", photo_id])
      CACHEZ.set(key,tags)
    else
      tags = CACHEZ.get(key)
    end
    return tags
  end

  #城市下区域，不带统计数
  def get_area_without_number(cityid)
    HejiaTag
    cityid = '11910' if cityid.to_i == 0
    key = "zhaozhuangxiu_200911_19_6_area_1_without_number_#{cityid}_#{Time.now.strftime('%Y%m%d')}"
    if CACHE.get(key).nil?
      result = HejiaTag.find(:all, :select => "TAGID,TAGNAME", :conditions => "TAGFATHERID = '#{cityid}' and TAGID <> 12749", :order => "TAGTAXIS asc")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end

  #同区域公司
  #20100426毛秋云修改
  def get_same_area_company(city,district,area)

    if city.to_i ==0
      return []
    else
      #修改KEY标识 area是区域值。 除上海地区外的其它城市同一区域内公司较少，所以暂不按区域划分。此值保留
      #上海地区因为其特殊性区域用district 替代，area值为O
      key = "companies/#{city}/#{district}"

      CACHE.fetch(key, 1.day) do
        conditions = []
        conditions << "city = #{city}"
        conditions << "district = #{district}"  if district.to_i > 0
        #     conditions << "area = #{area}" if area.to_i > 0 暂时不用
        DecoFirm.find(
          :all,
          :select => "id,name_zh,name_abbr,verysatisfied,comments_count,praise,star",
          :conditions => conditions.join(' and '),
          :order => "praise desc",
          :limit => 10
        )
      end
    end
  end

  #新排行
  def get_new_order_companys(order)
    key = "zhaozhuangxiu_20091119_companys_10_#{Time.now.strftime('%Y%m%d%H')}_#{order}"
    if CACHE.get(key).nil?
      orderby = ORDERS[order.to_i][0]
      result = DecoFirm.find(:all,:select => "id,name_zh,design_score,design_praise,budget_score,budget_praise,construction_score,construction_praise,service_score,service_praise,total_score,praise,name_abbr,pv_count",:order => "#{orderby} desc",:limit => 10 )
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end


  #新价位排行2
  def get_new_companys_by_price2(priceid)
    key = "zhaozhuangxiu_20091209_2_price_#{priceid}_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      result = DecoFirm.find(:all,:select => "id,name_zh,name_abbr,total_score,praise,budget_praise,budget_score",:conditions => "price = '#{priceid}'",:order => "budget_praise desc",:limit => 10)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end

  #获得上海区域排名靠前公司
  def get_top_companys_by_district(district)
    key = "zhaozhuangxiu_20091120_8_district_top_company_#{Time.now.strftime('%Y%m%d%H')}_#{district}_1"
    if CACHE.get(key).nil?
      #上海特殊处理
      result = DecoFirm.find(:all,:select => "id,name_zh,name_abbr,district,total_score,praise",:conditions => "district = '#{district}' and praise > 0 ",:order => "praise desc",:limit => 10)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end

  #获得郊区下区域排名靠前公司
  def get_top_companys_by_district_jiaoqu
    key = "zhaozhuangxiu_20091120_8_district_top_company_#{Time.now.strftime('%Y%m%d%H')}_2"
    if CACHE.get(key).nil?
      cond = "praise > 0 and district in (12211,12215,12216,12218,12221,12223,12226)"
      result = DecoFirm.find(:all,:select => "id,name_zh,name_abbr,district,total_score,praise",:conditions => cond,:order => "praise desc",:limit => 10)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end

  #根据城市编号和tagvalue值得到标签对象
  def get_object_tags_by_cityvalue_and_tagvalue(cityvalue,tagvalue)
    result = Array.new
    HejiaTag
    tag_value = "zhaozhuangxiu_20091203_tags_tagvalue2_#{Time.now.strftime('%Y%m%d')}_#{cityvalue}_#{tagvalue}"
    if CACHE.get(tag_value).nil?
      result = HejiaTag.find(:all, :select => "TAGID,TAGNAME", :conditions => ["tagfatherid = ? and tagvalue = ?",cityvalue.to_i,tagvalue.to_i], :order => "TAGID desc")
      CACHE.set(tag_value,result,24*60*60)
    else
      result = CACHE.get(tag_value)
    end
    return result
  end
  
  #根据城市编号得到标签对象
  def get_all_tags_by_cityvalue(fatherid)
    HejiaTag
    CACHE.fetch("/hejia_tag/by_father_id/#{fatherid}",  1.day) do
      HejiaTag.find(:all, :select => "TAGID, TAGNAME", :conditions => ["tagfatherid = ?", fatherid.to_i], :order => "TAGTAXIS asc")
    end
  end

  #获得某个公司的最新活动
  def get_company_new_coupon(firm_id)
    DecoEvent
    CACHE.fetch("firm/coupon/#{firm_id}", 1.hour) do
      firm = getfirm(firm_id)
      unless firm.blank? && firm.api_events.blank?
        firm.api_events[0]
      end
    end
  end

  #获得某个公司的最新报价单
  def get_new_quotation_by_company_id(firm_id)
    result = DecoQuotation.new
    key = "zhaozhuangxiu_2009_11_27_company_new_quotations_#{Time.now.strftime('%Y%m%d%H')}_#{firm_id}"
    if CACHE.get(key).nil?
      firm = getfirm(firm_id)
      if firm
        if firm.quotations
          count= firm.quotations.size
          if count > 0
            result = firm.quotations[count - 1]
          end
        end
      end
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end

  #6个最新的活动
  def get_six_new_events
    result = Array.new
    key = "zhaozhuangxiu_2009_11_27_88_88_six_new_coupon_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      result = DecoEvent.find(:all, :order => "id desc",:limit => 6)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end

  #根据公司编号查找该公司所有优惠活动
  def by_company_id_get_all_coupon(firm_id)
    result = Array.new
    key = "zhaozhuangxiu_2009_11_27_88_88_by_company_id_find_all_coupon_#{Time.now.strftime('%Y%m%d%H')}_#{firm_id}"
    if CACHE.get(key).nil?
      firm = getfirm(firm_id)
      if firm
        if firm.api_events.size > 0
          firm.api_events.each do |coupon|
            result << coupon
          end
        end
      end
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end

  def get_comment_score(str,score)
    if score.to_i == 0
      return ''
    elsif score.to_i == 1
      result = "#{str}：<img src='http://js.51hejia.com/img/sdeco/handup.gif' /> "
    elsif score.to_i == -1
      result = "#{str}：<img src='http://js.51hejia.com/img/sdeco/handdown.gif' /> "
    end
    return result
  end

  def get_company_manyidu(firm)
    if firm.comments_count.to_i > 0
      return firm.verysatisfied * 100 / firm.comments_count
    else
      return ''
    end
  end

  def max_5_view_comments
    key = "zhaozhuangxiu_2009_11_276_max_5_view_comments_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      result = DecoReview.find(:all,:conditions => "formid = '#{PINGLUN_ID}' and status=1 and DATEDIFF('#{Time.now.strftime('%Y-%m-%d')}',DATE_FORMAT(cdate,'%Y-%m-%e'))<4 ",:order => "c32 desc",:limit => 6)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end

  def max_5_reply_comments
    key = "zhaozhuangxiu_2009_11_271_max_5_reply_comments_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      result = DecoReview.find(:all,:conditions => "formid = '#{PINGLUN_ID}' and status=1",:order => "(c11+0) desc",:limit => 6)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end

  #解析api对应栏目的xml输出
  def parse_xml2(xml, parameters, begin_num = nil, end_num = nil)
    fetch_api_promotion_data xml, parameters, begin_num, end_num
  end

  def get_and_save_pagenum(pagenum)
    if pagenum.to_i > 0
      cookies[:pagenum] = {:value => page.to_s, :domain=>".51hejia.com",:expires => 1.years.from_now}
      return pagenum.to_i       
    elsif cookies[:pagenum] && cookies[:pagenum].length > 0
      return cookie[:pagenum].to_i    
    else
      cookies[:pagenum] = {:value => '20', :domain=>".51hejia.com",:expires => 1.years.from_now}
      return 20    
    end
  end
  def get_zhaozhuangxiu_tag_url(fatherid,tagid)
    
    if fatherid.to_i==4349
      s = get_tag_en_name(tagid)
      result="/zhuangxiuanli/#{s}.0.0.0.1.html"
    elsif fatherid.to_i==4348
      s = get_tag_en_name(tagid)
      result="/zhuangxiuanli/0.#{s}.0.0.1.html"
    elsif fatherid.to_i==4352
      s = get_tag_en_name(tagid)
      result="/zhuangxiuanli/0.0.#{s}.0.1.html"
    elsif fatherid.to_i==4347
      s = get_tag_en_name(tagid)
      result="/zhuangxiuanli/0.0.0.#{s}.1.html"
    else
      result="/zhuangxiuanli/0.0.0.0.1.html"
    end
    return result
  end
  def get_tag_en_name(tag)
    result = case tag.to_i
    when 11621 ; 8
    when 11623 ; '8_15'
    when 11622 ; '15_30'
    when 11624 ; '30'
    when 41733 ; '100'
    when 4370  ; 'jingji'
    when 4372  ; 'fuyu'
    when 4373  ; 'haohua'
    when 4361  ; 'xiandaijianyue'
    when 4362  ; 'zhongshi'
    when 4363  ; 'oumei'
    when 4360  ; 'hunda'
    when 6680  ; 'dizhonghai'
    when 4367  ; 'tianyuan'
    when 6681  ; 'qita'
    when 4378  ; 'jiufang'
    when 4380  ; 'hunfang'
    when 4381  ; 'danshen'
    when 4382  ; 'sankou'
    when 4383  ; 'laoren'
    when 6682  ; 'chuzufang'
    when 6683  ; 'zhongruanfang'
    when 6684  ; 'chongwu'
    when 6685  ; 'ertong'
    when 6686  ; 'qita'
    when 4355  ; 'xiaohu'
    when 4356  ; 'gongyu'
    when 4354  ; 'bieshu'
    else ; '0'
    end
  end
  
  # error_path
  def gen_gushi_path(gushi)
    return "/story-#{gushi.id}"
  end
  
  
  def return_city(city)
    city_url =""
    TAGURLS.sort.each do |k, v|
      if k.to_i == city.to_i
        city_url = v.to_s
      end
    end
    city_url
  end
  
  
  #根据日记编号得到对应的url
  def get_note_url_helper(note_id)
    note = cache_note_by_id(note_id)
    firm = cache_firm_by_firm_id(note.firm_id)
    if firm.city.to_i == 11910
      city = firm.city
    else
      city = firm.district
    end
    city_url = get_city_url(city)
    
    key = "zhaozhuangxiu_2009_11_15_note_path_#{city_url}_#{firm.id}_#{note_id}_1"
    if CACHE.get(key).nil?
      if city_url.blank?
        if IS_PRODUCT.to_i == 0
          result = "/gs-#{note.firm_id}/zhuangxiugushi/#{note.id}"
        else
          result = "http://z.51hejia.com/gs-#{note.firm_id}/zhuangxiugushi/#{note.id}/all/1"
        end
      else
        if IS_PRODUCT.to_i == 0
          result = "/gs-#{note.firm_id}/zhuangxiugushi/#{note.id}"
        else
          result = "http://z.#{city_url}.51hejia.com/gs-#{note.firm_id}/zhuangxiugushi/#{note.id}/all/1"
        end
      end
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  
  #取得城市拼音名称作为连接URL
  def get_city_url(city)
    key = "zhaozhuangxiu_get_city_url_#{city}"
    city_url = ""
    if CACHEZ.get(key).nil?
      TAGURLS.sort.each do |k, v|
        if k.to_i == city.to_i
          city_url = v.to_s
        end
      end
      CACHEZ.set(key,city_url)
    else
      city_url = CACHEZ.get(key)
    end
    return city_url
  end
  #缓存公司信息
  def cache_firm_by_firm_id(firm_id)
    key = "zhaozhuangxiu_get_company_info_by_note_firm_id_#{firm_id}#{Time.now.strftime('%Y%m%d')}"
    if CACHEZ.get(key).nil?
      firm = DecoFirm.find(firm_id)
      CACHEZ.set(key,firm)
    else
      firm = CACHEZ.get(key)
    end
    return firm
  end

  # 得到故事小图
  def get_zhuangxiugushi_small_image(path)
    reslut="http://img.51hejia.com"
    key = "zhaozhuangxiu_image_#{path}#{Time.now.strftime('%Y%m%d')}"
    if CACHEZ.get(key).nil?
      if !path.nil? && path.include?("/files/hekea/article_img/sourceImage/")
        map = Array.new
        map = path.split(".")
        if map.size>0
          reslut += map[0].to_s + "_thumb"
          reslut += "." + map[1].to_s
        end
      elsif !path.nil? && path.include?("/images/binary/")
        reslut.concat path
      else
        reslut = path
      end
      CACHEZ.set(key,reslut)
    else
      reslut = CACHEZ.get(key)
    end
    return reslut
  end
  
  
  #根据日记对象得到对应的主键编号集合
  def get_all_user_ids(note)
    ids =note.collect{|t| t.id}.join(',')
    return ids
  end
  #根据ID拿案例
  def get_case_by_id_id(id)  
    begin
      key = "key_case_show_casecase_id2_#{Time.now.strftime('%Y%m%d%H')}_#{id}_#{id}"
      if CACHE.get(key).nil?
        result = Case.find(id)
        CACHE.set(key,result)
      else
        result = CACHE.get(key)
      end
    rescue
      result = nil
    end
    return result
  end

  #根据日记编号得到对应的url以及page
  def get_note_url_page(note_id,page)
    note = cache_note_by_id(note_id)
    firm = cache_firm_by_firm_id(note.firm_id)
    if firm.city.to_i == 11910
      city = firm.city
    else
      city = firm.district
    end
    city_url = get_city_url(city)
    
    key = "zhaozhuangxiu_2009_11_15_note_path_#{city_url}_#{firm.id}_#{note_id}_1_#{page.to_i}"
    if CACHE.get(key).nil?
      if city_url.blank?
        if IS_PRODUCT.to_i == 0
          result = "/gs-#{note.firm_id}/zhuangxiugushi/#{note.id}/all/#{page.to_i}"
        else
          result = "http://z.51hejia.com/gs-#{note.firm_id}/zhuangxiugushi/#{note.id}/all/#{page.to_i}"
        end
      else
        if IS_PRODUCT.to_i == 0
          result = "/gs-#{note.firm_id}/zhuangxiugushi/#{note.id}/all/#{page.to_i}"
        else
          result = "http://z.#{city_url}.51hejia.com/gs-#{note.firm_id}/zhuangxiugushi/#{note.id}/all/#{page.to_i}"
        end
      end
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  
  # 生成当前城市下优惠券的地址
  def event_url(firm_id, event_id)
    "/gs-#{firm_id}/y-#{event_id}"
  end
  
  # 首页以及其他页面日记的生成链接
  def note_url note
    "/gs-#{note.deco_firm_id}/zhuangxiugushi/#{note.id}"
  end


  #给标题加上自定义样式
  def get_style_by_text_style_id(title,text_style_id)
    
    if text_style_id.nil?
      text_style_id = 0
    end
    PublishTextStyle
    style = CACHE.fetch("deco_firm/title_style/#{text_style_id}",1.hour) do
      PublishTextStyle.find(:first, :select =>"style_value", :conditions => ["style_key = ?", text_style_id])
    end
    style.style_value.gsub("@title", title)
    
  end

  # 
  def increase_deco_firm_pv_image_tag firm_id
    image_tag "http://api.51hejia.com/stat/deco_firm/#{firm_id}.gif?#{Time.now.to_i}", :style => 'display: none;'
  end

  # 日记PV
  def increase_dairy_pv_image_tag dairy_id
    image_tag "http://api.51hejia.com/stat/dairy/#{dairy_id}.gif?#{Time.now.to_i}", :style => 'display: none;'
  end

  def increase_dairy_review_counts diary_id
    key="decoration_diaries/#{diary_id}/pv"
    REDIS_DB.set key, (REDIS_DB.get key).to_i + 1
  end
  #根据城市获得主打价位
  def get_pricetese_by_city(city)
    if city.to_i == 12301
      return {1 => '6万以下',2 => '6-10万',3 => '10-15万',4 => '30万-50万',5 => '50万以上'}
    else
      return PRICE
    end
  end
  
  #得到推广日记信息
  def get_diaries_index(diary_title)
    #     CACHEZ.fetch("get_diaries_index/diary/#{diary_title}",1.day) do
    diaries_id = diary_title.map{|f| f["title"].to_i}
    DecorationDiary.find(
      :all,
      :conditions => ["id in (?)",diaries_id],
      :limit => 3)
    #     end
  end

  #根据城市、主打价位，获得公司排行
  def get_firms_by_city_and_pricetese(city,district,jiawei)
    key = "company/#{city}/#{district}/#{jiawei}/top5"
    if city.to_i == 11910
      DecoFirm.find(
        :all,
        :select => "id, name_zh, name_abbr, comments_count, city,district, pv_count",
        :conditions => "city = #{city} and pricetese = #{jiawei} and state <> '-99' and state <> '-100'",
        :order => 'is_cooperation desc , praise desc',
        :limit => 5)
    else
      DecoFirm.find(
        :all, :select => "id,name_zh, name_abbr, comments_count, city, district, pv_count",
        :conditions => "district = #{district} and pricetese = #{jiawei} and state <> '-99' and state <> '-100'",
        :order => 'is_cooperation desc , praise desc',
        :limit => 5)
    end
  end

  # find hejia_bbs_user 
  # params[:user_id] = HEJIA_BBS_USER.USERBBSID
  # return hejia_bbs_user
  def hejia_bbs_user user_id
    CACHE.fetch("/hejia_bbs_user/#{user_id}", 1.day) do
      HejiaUserBbs.find_by_USERBBSID user_id
    end
  end
  
  # about deco_firm.star
  # params[:firm_star] = firm.star
  # return page.style [star]
  def firm_star star
    star.to_i == 0 ?  0 : 15 * star.to_i
  end
  
  # about firm.construction_score, firm.design_score, firm.service_score
  # params[:firm] => DecoFirm
  # return array
  # array[0] = page.style [construction_praise]
  # array[1] = page.style [design_praise]
  # array[2] = page.style [service_praise]
  def firm_praise firm
    grade_max = [firm.construction_praise, firm.design_praise, firm.service_praise].max
    [firm.construction_praise, firm.design_praise, firm.service_praise].map do |praise|
      grade_max == 0 ? 0 : praise * 1.0 / grade_max * 108.0
    end
  end 
  

  # According to diary number generated link address specific diary
  # params[:diary_id] = diary_id
  # return diary_url
  def genration_diary_path diary_id
    CACHE.fetch("/genration_decoration_diary_path/#{diary_id}", 1.day) do
      diary = DecorationDiary.find diary_id
      city_area = generate_firm_city_area diary.deco_firm_id
      city = TAGURLS[city_area[0]]
      "http://z.#{city}.51hejia.com/gs-#{diary.deco_firm_id}/zhuangxiugushi/#{diary.id}"
    end
  end
end
