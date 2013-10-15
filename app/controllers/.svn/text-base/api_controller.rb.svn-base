require 'open-uri'

class ApiController < ApplicationController


  def get_coupon_download_by_city
    city = remote_city[:name]
    cities = {"上海" => 1, "宁波" => 214, "杭州" => 223, "苏州" => 132, "南京" => 2, "无锡" => 131}
    coupon_city = cities[city] || 1
    city_tags = {
        1   => [["橱柜", 42103], ["洁具", 42100], ["地板", 42099], ["瓷砖", 44578], ["家具", 42891], ["橱电", 42096], ["门窗", 44579]],
        223 => [["橱柜", 42103], ["洁具", 42100], ["地板", 42099], ["瓷砖", 44578], ["家具", 42891], ["橱电", 42096], ["门窗", 44579]],
        2   => [["橱柜", 42103], ["洁具", 42100], ["地板", 42099], ["瓷砖", 44578], ["家具", 42891], ["橱电", 42096], ["门窗", 44579]],
        214 => [["地板", 42099], ["瓷砖", 44578], ["卫浴", 42100], ["橱柜", 42103], ["家具", 42891], ["门窗", 44579], ["吊顶", 43230]],
        132 => [["地板", 42099], ["洁具", 42100], ["瓷砖", 42100], ["橱柜", 42103], ["吊顶", 43230], ["橱电", 42096], ["家具", 42891]],
        131 => [["地板", 42099],  ["卫浴", 42100], ["橱柜", 42103], ["家具", 42891], ["门窗", 44579]]
    }

    coupon_city = 1 if [1,223,2].include? coupon_city


    tag_names = city_tags[coupon_city].collect { |tag| tag[0] }
    tag_ids = city_tags[coupon_city].collect { |tag| tag[1] }
    tag_names_html = tag_names.each_with_index.collect do |tag,index|
      if index == 0
        "<li class=\"active\">#{tag}</li>"
      else
        "<li>#{tag}</li>"
      end
    end

    tag_id_coupons_html = tag_ids.collect do |tag_id|
      coupons_html = Coupon.with_tagid_and_city_id_limit(coupon_city, tag_id, 7).each_with_index.collect do |coupon, index|
        <<COUPON_HTML
      <tr>
        <td class="tit"><div>#{index+1}.<a href="#{coupon.url}" target="_blank">#{coupon.title}</a></div></td>
        <td align="right" class="num"><span>#{coupon.def_value}</span>次</td>
        <td width="32"><a href="#{coupon.url}" target="_blank"><img src="http://img2.51hejia.net/img/homeimg/icon1.gif" alt="详情" /></a></td>
      </tr>
COUPON_HTML
      end
      <<HTML
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
      #{coupons_html.join("\n")}
      </table>
HTML
    end

    js =<<-JS
      $("#coupon_download_tags").html('');
      $("#coupon_downloads_by_tag").html('');
      $("#coupon_download_tags").html(#{tag_names_html.join("\n").to_json});
      $("#coupon_downloads_by_tag").html(#{tag_id_coupons_html.join("\n").to_json});

//      $(function(){
        $(".index_cscxxx div.txt table:gt(0)").hide();
        $(".index_cscxxx div.tab li:first").addClass("active");
        $(".index_cscxxx div.tab li").mouseover(
          function(){
            $(this).addClass("active")
              .siblings().removeClass("active");
            $(".index_cscxxx div.txt table").eq($(this).index())
              .siblings().hide().end().show();
                }
                  )
//            }
//      )
    JS
    render :text => js, :content_type => Mime::JS
  end


  def get_user_city
    city_api_mapping = { "上海" => 55131 , "宁波" => 55132 , "苏州" => 55133, "杭州" => 55134 , "无锡" => 55135, "武汉" => 55503, "南京" => 55504, "青岛" => 55505, "长沙" => 55506, "合肥" => 55507, "郑州" => 55508, "北京" => 55509, "深圳" => 55510, "广州" => 55511, "成都" => 55512, "海口" => 55513, "厦门" => 55514 }
    promotion_api_mapping = {"上海" => 55253 , "宁波" => 55255 ,"苏州" => 55257,"杭州" => 55254 , "无锡" => 55256}
    city =  remote_city[:name]
    @xml = parse_xml(city_api_mapping[city],["title","url","image_url"],5).to_xml.to_json
    @promotion_xml = parse_xml(promotion_api_mapping[city],["title","url","image_url"],5).to_xml.to_json
    render :text => <<_JS_, :content_type => Mime::JS

      //大首页城市促销信息
      jQuery.fn.wwwCityPromotion = function(xml) {
    			$(xml).find("record").each(function(){
    		  var title = $(this).children("title").text();
    			var url = $(this).children("url").text();
    			li = '<li><a href='+ url +' target="_blank" title='+ title +'>' + title + '</a></li>';
    			$("#www_city_promotion").append(li);
    		});  //END each
    	};

    	jQuery.fn.getAjaxTextAPI = function(xml) {
    			$("#api_ajax_loader").remove();
    			$(xml).find("record").each(function(){ 
    		  var title = $(this).children("title").text();
    			var url = $(this).children("url").text();
    			li = '<li><a href='+ url +' target="_blank" title='+ title +'>' + title + '</a></li>';
    			$("#ajax_api").append(li);
    		});  //END each
    	};

    		jQuery.fn.getAjaxImgAPI = function(xml) {
    				$("#img_ajax_loader").remove();
    				var titles = "", images_url = "", urls = "";
    				$(xml).find("record").each(function(){ 
    				var $content = $(this); //从xml中提取需要的内容
    				var title = $content.children("title").text();
    				var url = $content.children("url").text();
    				var image_url = $content.children("image-url").text();
    				titles += (title.substring(0,10) + '|');
    				images_url += (image_url + '|');
    				urls += (url + '|');
    			}); //END each
    			$(this).showDairyPic(titles,images_url,urls);
    		};

    	//显示图片
    	jQuery.fn.showDairyPic = function(titles,images_url,urls) {
    		var swf = new sinaFlash("http://js.51hejia.com/img/homeimg/lifeflash.swf", "", "213", "146", "8", "#F4FAFA", true,"high");
    		swf.addParam("allowScriptAccess", "always");
    		swf.addParam("wmode", "opaque");
    		swf.addVariable("p_array", images_url);
    		swf.addVariable("txt_array", titles);
    		swf.addVariable("link_array", urls);
    		swf.write("imager_div");
    		

        $("#imager_div").show();
        
    	}; 

			if (window.DOMParser)
			  {
			  parser=new DOMParser();
			  xmlDoc=parser.parseFromString(#{@xml},"text/xml");
        xmlPromotion=parser.parseFromString(#{@promotion_xml},"text/xml");

			  }
			else // Internet Explorer
			  {
			  xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
			  xmlDoc.async="false";
			  xmlDoc.loadXML(#{@xml});
        xmlPromotion=new ActiveXObject("Microsoft.XMLDOM");
			  xmlPromotion.async="false";
			  xmlPromotion.loadXML(#{@promotion_xml});
			  }

     $(this).wwwCityPromotion(xmlPromotion);
		 $(this).getAjaxTextAPI(xmlDoc);
   	 //$(this).getAjaxImgAPI(xmlDoc);
   	 $(".index_gusr_top h3").children("a").text("#{city}装修故事");
     if (#{city.to_json}=="XX"){
       $("#hangzhou_ads").show();
     };
_JS_
  end
  
  # www Top
  def index_firm
    city = remote_city[:name]
    @user_city_code = CITIES.invert[city]
    render :layout => 'none'
  end
  
end
