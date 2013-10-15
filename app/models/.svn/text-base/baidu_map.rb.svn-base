gem 'rack' , '1.0.1'
require 'rack/utils'
require 'typhoeus'
require 'iconv'

class BaiduMap < ActiveRecord::Base

attr_accessor :name, :addr, :tel, :lat, :lng


  def self.get(city, area, keywords)
    CACHE.fetch("api:baidu_map:#{city}:#{area}:#{keywords}", (RAILS_ENV == 'production' ? 1.hour : 0)) do
      results = []
      keywords = (area + keywords) unless area.blank?
      keywords = URI.encode keywords
      city_code = REDIS_DB.hget "baidu_map_city_code_mapping" , city.gsub(/市/,"")+"市"
      return results if city_code.nil?
      0.upto(5000) do |i|
        url = "http://map.baidu.com/?newmap=1&qt=s&c=#{city_code}&wd=#{keywords}&pn=#{i}&db=0&wd2=&sug=0&on_gel=1&src=7&gr=3&l=12&addr=0&tn=B_NORMAL_MAP&ie=utf-8&t=#{Time.now.to_i}"
#url = "http://map.baidu.com/?newmap=1&qt=s&c=#{city_code}&wd=#{keywords}&pn=#{i}&db=0sug=0&on_gel=1&src=7&gr=3&l=12&addr=0&tn=B_NORMAL_MAP&ie=utf-8"
        json = Typhoeus::Request.get(url).body
        json_u = Iconv.conv("UTF-8","GBK",json)
        parser = Yajl::Parser.new
        hash = parser.parse(json_u)
        break if hash["content"].nil?
        hash["content"].each do |firm|
          result = Hash.new
          result["name"] =  firm["name"]
          result["addr"] = firm["addr"]
          result["tel"] = firm["tel"]
          geo = firm["geo"].split(/\|/).last.split(/,/)
          result["lat"] = geo.last.to_f/100000
          result["lng"] = geo.first.to_f/100000
#     puts "#{i}: "  + result["name"] + result["addr"]
          results << result
        end
      end
      results
    end
  end

end
