class AnalogCodesController < ApplicationController
  # 如果当前模拟点击数小于等于最大点击数且当前时间段还可以模拟点击
  def index
    analog_code = AnalogCode.find_by_code(params[:code])
    urls = analog_code.analog_code_urls.map{|u|u.url}
    counts = analog_code.today_analog_urls.count
    if counts < analog_code.max_hits
      if analog_code.current_hour_can_hit?
        js_code = js_code(analog_code.code, analog_code.analog_code_urls[rand(urls.size)])
        render :text => js_code, :content_type => Mime::JS
      else
        render :nothing => true
      end
    else
      render :nothing => true
    end
=begin
    render :nothing => true, :status => 204
=end
  end

  ## 创建ClickUrl记录
  def create_analog_url
    analog_code_url = AnalogCodeUrl.find(params[:acu_id])
    AnalogUrl.create(:url => analog_code_url.url, :code => params[:code], :created_at => Time.now.to_s(:db))
    render :text => "success!"
  end

  private

  def not_found!
    render :nothing => true, :status => 204
  end

  def js_code(code,analog_code_url)
    rails_env = RAILS_ENV == "development" ? ":3000" : ""
    <<-_JS_
    if("#{code}" == "SYVE5vGqkRtWvrJMd6HZ")
    {
      if(document.getElementById("test_framelink") != null)
      {
          var myLink = document.getElementById("test_framelink");
          myLink.src = "#{analog_code_url.url}";
	  myLink.click;
      }
    }
    else
    {
      if(document.getElementById("framelink") == null)
      {
          var img = new Image;
          img.onerror = img.onload = function() { try { delete img } catch(e) {} }
          img.src = "#{analog_code_url.url}";
	  img.click;
      }
      else
      {
          var myLink = document.getElementById("framelink");
          myLink.src = "#{analog_code_url.url}";
	  myLink.click;
      }
    }

        var url_img = new Image();
        url_img.onerror = url_img.onload = function() { try { delete url_img } catch(e) {} }
        url_img.src = "http://api.51hejia.com#{rails_env}/analog_codes/create_analog_url?acu_id=#{analog_code_url.id}&code=#{code}"
    _JS_
  end
end
