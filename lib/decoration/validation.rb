module Decoration
  module Validation
    def city_validate
      @subdomain = request.subdomains.to_s
      if @subdomain.include?("shanghai")
        @city_code = 'UA-12518263-1'
        @user_city_code = '11910'
      elsif @subdomain.include?("suzhou")
        @city_code = 'UA-12518279-2'
        @user_city_code = '12117'
      elsif @subdomain.include?("ningbo")
        @city_code = 'UA-12518326-3'
        @user_city_code = '12301'
      elsif @subdomain.include?("hangzhou")
        @city_code = 'UA-12518326-2'
        @user_city_code = '12306'
      elsif @subdomain.include?("wuxi")
        @city_code = 'UA-12518279-3'
        @user_city_code = '12118'
      else
        #      @city_code = 'UA-12518263-1'
        #      @user_city_code = '11910'
      end
      params[:city] = @user_city_code # 兼容旧版本，原有逻辑是通过params[:city]来判断当前访问的城市
      cookies[:user_city] = {:value => @user_city_code, :domain=>".51hejia.com",:expires => 1.years.from_now}
    end
  end
end