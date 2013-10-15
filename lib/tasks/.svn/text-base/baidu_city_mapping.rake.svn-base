require 'uri'
require 'yajl/http_stream'
gem 'rack' , '1.0.1'
require 'rack/utils'
require 'typhoeus'
require 'iconv'
 
desc "百度地图城市编码MAPPING"
task :baidu_city_mapping=>:environment do
 
  url = "http://map.baidu.com/?newmap=1&qt=s&c=#{city_code}&wd=#{keywords}&pn=#{i}&db=0sug=0&on_gel=1&src=7&gr=3&l=12&addr=0&tn=B_NORMAL_MAP&ie=utf-8"
  json = Typhoeus::Request.get(url).body
  json_u = Iconv.conv("UTF-8","GBK",json)
  parser = Yajl::Parser.new
  hash = parser.parse(json_u)
  p hash
  
  
end
