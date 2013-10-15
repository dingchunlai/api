require 'rexml/document'
require 'rexml/element'
require 'ip_address'

# 原来程序是使用mmseg这个包的。但是在某些服务器上，
# mmseg会出错（原因没仔细分析）。所以现在改为优先
# 使用rmmseg(纯ruby的mmseg）。
# 下面的get_segments方法也根据所使用的gem来生成不同的代码。
begin
  require 'rmmseg'
  puts "Using rmmseg."
rescue
  begin
    require "mmseg"
    puts "Using mmseg"
  rescue
    puts "mmseg is not available"
  end
end

class RestController < ApplicationController

  #生成xml
  def build
    id = params[:column_id].to_i
    method = params[:method]
    now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    @publish_contents = PublishContent.find(:all,
      :select => "title,left(description,200) as description,url,image_url,entity_created_at,entity_updated_at,entity_type_id,media_type_id,text_style_id,order_id,publish_time,expire_time",
      :conditions => ["publish_column_id = ? and is_valid = ? and is_del = #{false} and publish_time < ? and expire_time > ?", id, 2, now, now],
      :order => "order_id DESC, entity_created_at DESC")
    respond_to do |articles|
      if method == "xml"
        articles.xml{
          render :xml => @publish_contents.to_xml
        }
      elsif method == "json"
        articles.html{
          render :text => @publish_contents.to_json
        }
      end
    end
  end

  #创建xml文件
  def build_xml_file()
    id = params[:column_id]
    now = Time.now.strftime("%Y-%m-%d %H:%M:%S") 
    if File.exist?("public/rest/build/xml/#{id}.xml")
      File.rename("public/rest/build/xml/#{id}.xml", "public/rest/build/xml/bak/#{id}.xml")
    end
    @publish_contents = PublishContent.find(:all,
      :select => "title,left(description,200) as description,url,image_url,entity_created_at,entity_updated_at,entity_type_id,media_type_id,text_style_id,order_id,publish_time,expire_time,price_ago,price_now",
      :conditions => ["publish_column_id = ? and is_valid = ? and is_del = #{false} and publish_time < ? and expire_time > ?", id, 2, now, now],
      :order => "order_id DESC, entity_created_at DESC")
    file = File.new("public/rest/build/xml/#{id}.xml","w+")
    doc = REXML::Document.new
    publish_contents = REXML::Element.new "publish_contents"
    for pc in @publish_contents
      publish_content = publish_contents.add_element "publish_content"
      t_node = publish_content.add_element "title"
      t_node.text  = pc.title
      d_node = publish_content.add_element "description"
      d_node.text  = pc.description == "" ? "暂无描述" : pc.description
      u_node = publish_content.add_element "url"
      u_node.text  = pc.url == "" ? "http://www.51hejia.com" : pc.url
      iu_node = publish_content.add_element "image-url"
      iu_node.text  = pc.image_url.nil? ? "http://www.51hejia.com/api/images/none.gif" : pc.image_url
      pt_node = publish_content.add_element "publish-time"
      pt_node.text  = pc.publish_time
      et_node = publish_content.add_element "expire-time"
      et_node.text  = pc.expire_time
      oi_node = publish_content.add_element "order-id"
      oi_node.text  = pc.order_id
      tsi_node = publish_content.add_element "text-style-id"
      tsi_node.text  = pc.text_style_id
      mti_node = publish_content.add_element "media-type-id"
      mti_node.text  = pc.media_type_id
      eti_node = publish_content.add_element "entity-type-id"
      eti_node.text  = pc.entity_type_id
      eua_node = publish_content.add_element "entity-updated-at"
      eua_node.text  = pc.entity_updated_at
      eca_node = publish_content.add_element "entity-created-at"
      eca_node.text  = pc.entity_created_at
      oi_node = publish_content.add_element "price_ago"
      oi_node.text  = pc.price_ago
      oi_node = publish_content.add_element "price_now"
      oi_node.text  = pc.price_now
    end
    doc.add_element publish_contents
    file.puts doc
    file.close

    render :text => "1111"
  end

  def clear_cached
    key = params[:key] 
    logger.info CACHE.get(key).nil?.to_s + "******************"
    if !CACHE.get(key).nil?
      log_dir = "public/"
      logger = Logger.new("#{log_dir}#{Time.now.strftime("%Y-%m-%d")}.log")
      logger.info("#{key}")
      logger.close
      CACHE.set(key, nil)
    end
  end

  def format
    #@keyword = iconv_gb2312(params[:kw])
    @keyword = params[:kw]
    @result = get_segments @keyword, params[:format]
  end

  if defined?(RMMSeg)
    include RMMSeg

    def get_segments(keywords, separator)
      segment(keywords.to_s).join(separator || ' ')
    end
  elsif defined?(Mmseg)
    def get_segments(keywords, separator)
      keywords ||= ''
      seg = Mmseg.createSeg('dict', keywords)
      segments = []
      while seg.next
        segments << keywords[seg.start...seg.end]
      end
      segments.join(separator || ' ')
    end
  else
    def get_segments(keywords, separator)
      keywords.to_s.split(' ').join(separator || ' ')
    end
  end

  def ip_to_string(ip)
    ip_new = ip.to_ip
    return ip_new
  end

  def ip_to_integer(ip)
    ip_new = IpAddress.new(ip).to_i
    return ip_new
  end

  def analytics
    #    key = "a090924-2130706433-378463-2119438"
    #    host = "192.168.1.12"  #测试
    host = "192.168.1.250"  #正式
    key = "#{params[:type]}#{Time.now.strftime("%y%m%d")}-#{ip_to_integer(request.remote_ip)}-#{params[:key]}"
    record_article_visit(host, key)
    render :nothing => true
    #    render :text => key
  end

  def analytic_zhuangxiu
    host = "192.168.1.12"
    key = "test_zhaozhuangxiu_key"
    record_article_visit(host, key)
    render :nothing => true
  end
  
  def analytic_dianping
    host = SERVER_ID
    key = "test_zhaozhuangxiu_key_d_#{params[:key]}"
    record_article_visit(host, key)
    count = record_visit_test(host,key)
    logger.info("===========================#{key}==============")
    logger.info("===========================#{count}==============")
    render :nothing => true
  end
  
  def analytic_zhaozhuangxiu_company_about
#    host = "192.168.1.12"
    host = SERVER_ID  #正式
    key = "test_analytic_zhaozhuangxiu_company_about_key_d_#{params[:key]}"
    record_article_visit(host, key)
    count = record_visit_test(host,key)
    logger.info("===========================#{key}==============")
    logger.info("===========================#{count}==============")
    render :nothing => true
  end
end
