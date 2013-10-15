class UserController < ApplicationController
  #判断是否6个月前打过分
  def verify_mark
    verify = PublicModule.remark_mark_verify(current_user.USERBBSID )
    is_mobile = !current_user.mobile_verified
    render :json => {:result => verify,
      :is_mobile => is_mobile
    }.to_json
  end
  # 发送手机验证码
  def send_mobile_code
    mobile = params[:mobile]
    is_verify = HejiaUserBbs.find(:first,:conditions=>["USERBBSMOBELTELEPHONE = ? and mobile_verified = 1" , mobile]) #判断手机 是否绑定过

    mobile_key = "mobile_code:mobile:#{mobile}"
    user_key   = "mobile_code:user:#{current_user.USERBBSID}"

    if is_verify
      render :json => {:result => 4}.to_json #手机已绑定,验证失败
    elsif REDIS_DB.get(mobile_key)  # 手机没过3分钟限制
      logger.info "[Mobile] | #{mobile} | phone 3 miniutes limit hits!"
      render :json => {:result => 1}.to_json
    elsif REDIS_DB.get(user_key) # 用户没过3分钟限制
      logger.info "[Mobile] #{current_user.USERBBSID} | user 3 miniutes limit hits!"
      render :json => {:result => 2}.to_json
    else
      code = rand(8999) + 1000
      verify_code = MobileCodeVerify.new
      verify_code.user_id = current_user.USERBBSID
      verify_code.user_mobile = mobile
      verify_code.resource_type = "FirmRemark"
      verify_code.verify_code = code
      verify_code.verify_status = false
      #判断是否是重发的
      first_verify_code = MobileCodeVerify.find(:first, :conditions => ["user_id=? and user_mobile=?", current_user.USERBBSID, mobile], :order => 'id desc')
      if first_verify_code && first_verify_code.created_at + 900 > Time.now
        a = ",您上次收到的验证码将自动失效."
      else
        a="."
      end
      logger.info "[Mobile] | #{mobile} | #{current_user.USERBBSID} | set limit!"
      REDIS_DB.setex mobile_key, 3.minutes, 1
      REDIS_DB.setex user_key,   3.minutes, 1
      REDIS_DB.setex "mobile_code:#{current_user.USERBBSID}" , 15.minutes , code

      if true === Hejia::SMS.send_text_message("您本次评分的验证码是：#{code}(验证码15分钟后失效)" + a , mobile)
        verify_code.send_status = true
        render :json => {:result => 0}.to_json   #成功发送验证码
      else
        verify_code.send_stauts = false
        render :json => {:result => 3}.to_json   #发送验证码失败
      end
      verify_code.save
    end
  end
  
  def test
    
  end
  
  def validate_username
    username = HejiaUserBbs.find_by_USERNAME(params[:username])
    if username.nil?
      render :json=>{:result => 1}.to_json 
    else
      render :json=>{:result => 0}.to_json 
    end
  end
  
  def validate_email
    email = HejiaUserBbs.find_by_USERBBSEMAIL(params[:email])
    if email.nil?
      render :json=>{:result => 1}.to_json 
    else
      render :json=>{:result => 0}.to_json 
    end
  end
  
  def get_image_code
    validate_image = ValidateImage.new(4)
    session[:image_code] = validate_image.code
    send_data(validate_image.code_image, :type => 'image/jpeg')
  end
  
  def verify_mobile_code
    code = params[:code]
    mobile = params[:mobile]
    verify_code = MobileCodeVerify.find(:first, :conditions => ["user_id=? and verify_code=?", current_user.USERBBSID, code])
    verify = PublicModule.mobile_code_verify(current_user.USERBBSID ,code)
    HejiaUserBbs.update_all("mobile_verified = 1 , USERBBSMOBELTELEPHONE = #{mobile} ",:USERBBSID => current_user.USERBBSID) if verify
    verify_code.update_attribute(:verify_status, verify) if verify && verify_code
    render :json => {:result => verify}.to_json
  end
  
  def reg_save
    callback = params[:callback]
    if params[:image_code].blank? || params[:image_code].to_s.strip != session[:image_code]
      if callback
        return render :text => "#{callback}({'error':'code'})", :content_type => Mime::JS
      else
        return render :json => {:result => 0}.to_json
      end
    end
    hub = HejiaUserBbs.new
    hub.USERNAME = iconv(trim(params[:username]))
    hub.USERBBSEMAIL = trim(params[:userbbsemail])
    hub.BBSID = Time.now.strftime("%Y_%m_%d_%H_%M_%S")
    hub.USERTYPE = 1
    hub.USERBBSSEX = iconv(params[:gender]) unless params[:gender].blank?
    hub.AREA = trim(params[:area]) unless params[:area].blank?
    hub.CITY = trim(params[:city]) unless params[:city].blank?
    hub.USERSPASSWORD = HejiaUserBbs.md5(trim(params[:userpassword]))
    hub.CREATTIME = Time.now
    hub.HEADIMG = "http://member.51hejia.com/images/headimg/default.gif"
    session[:image_code] = nil
    if hub.save
      login_user! hub
      if callback
        render :text => "#{callback}('#{hub.USERBBSID}')", :content_type => Mime::JS
      else
        render :json=>{:result => 1}.to_json
      end
    else
      if callback
        hub.valid?
        render :text => "#{callback}({'error':'#{hub.errors['USERNAME']}'})", :content_type => Mime::JS
      else
        render :json => {:result => 0}.to_json
      end
    end
      
  end
  
end
