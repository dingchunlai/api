namespace :api do
  desc 'Generate decoration stories html fragment by city'
  task :gen_cds_fragment => :environment do
    require 'app/controllers/_generate.rb'
    output = ENV['OUTPUT']
    abort 'please specify the output path' unless output
    output = output + "/" if output[-1].chr != "/"
    
    cities = { "上海" => 55131 , "宁波" => 55132 ,"苏州" => 55133,"杭州" => 55134 , "无锡" => 55135 }
    cities_pinyin = { "上海" => "shanghai", "宁波" => "ningbo" ,"苏州" => "suzhou","杭州" => "hangzhou" , "无锡" => "wuxin" }
    html =<<-_HTML_
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>%s装修故事</title>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="expires" content="0">
<style type="text/css">
*{ margin:0; padding:0;}
body{font-size:12px; font-family:'宋体', Arial, Helvetica, sans-serif; line-height:20px;}
div{ text-align:left;}
a{color:#6d6d6d; text-decoration:none;}
a:hover {color:#f60; text-decoration:underline;}
li {list-style:none;}
h3{font-size:14px;}
.index_gusr_top{ background:url(http://img2.51hejia.com/img/homeimg/home_img_topcity.gif) no-repeat; height:150px; overflow:hidden;}
.index_gusr_top h3{ height:36px; line-height:36px; padding:0 13px 0 23px;}
.index_gusr_top h3 a:link,.index_gusr_top h3 a:visited,.index_gusr_top h3 a:hover,.index_gusr_top h3 a:active{ color:#6d6d6d; text-decoration:none;}
.index_gusr_top span{float:right; font-size:12px; font-weight:normal;}
.index_gusr_top span a{ color:#a9a9a9;}
.index_gusr_top span a:hover{ color:#f60; text-decoration:underline;}
.index_gusr_top ul{ padding:5px; background:url(http://img2.51hejia.com/img/homeimg/home_img_toplist.gif) 10px 8px no-repeat;}
.index_gusr_top li{ height:21px; line-height:21px; padding-left:30px; overflow:hidden;}
.index_gusr_top li a,.index_gusr_top li a:visited{ color:#333;}
.index_gusr_top li a:hover{ color:#f60;}
</style>
</head>
<body>
    <div class="index_gusr_top">
      <h3><span><a href="http://z.%s.51hejia.com/" target="_blank">更多</a></span><a href="http://z.%s.51hejia.com/" target="_blank">%s装修故事</a></h3>
      <ul id="ajax_api">
        %s
      </ul>
    </div>
</body>
</html>
_HTML_
    cities.each do |city, api|
      stories = fetch_api_promotion_data api, ["title","url","image_url"], 0, 5
      stories.collect! { |story| "<li><a href='#{story["url"]}' target='_blank' title='#{story["title"]}'>#{story["title"]}</a></li>" }
      story_html = stories.join("\n")
      city_pinyin = cities_pinyin[city]
      out_html = html % [city, city_pinyin, city_pinyin, city, story_html ]
      File.open(output + city_pinyin + ".html", "w") { |f| f.write out_html }
      puts "#{city} ok."
    end

  end
end