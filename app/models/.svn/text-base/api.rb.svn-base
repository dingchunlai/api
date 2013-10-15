class Api < ActiveRecord::Base

  class << self

    #API调用
    def get(api_id, limit = 10, parameters = 'title,url,image-url', completion = true)
      rs = fetch_api_promotion_data "http://api.51hejia.com/rest/build/xml/#{api_id}.xml", parameters.split(','), 0, limit, false
      if RAILS_ENV == 'development' && completion
        limit.times do |i|
          break if rs.length >= limit
          rs << {'title' => "API测试标题#{api_id}测试标题",
            'url' => "http://api.51hejia.com/rest/build/xml/#{api_id}.xml",
            'image-url' => 'http://image.51hejia.com/images/binary/0014/2309/0d94dd50b1b759dbe7db6a345e6bee0c.jpg',
            'description' => ("API测试内容#{api_id}" * 40)}
        end
      end
      rs
    end

  end

end
