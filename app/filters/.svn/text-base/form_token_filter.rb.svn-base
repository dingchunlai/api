class FormTokenFilter
  def self.filter(controller)
    if controller.request.post?
      compare_token(controller)
      set_token(controller) if controller.request.xhr?
    else
      set_token(controller)
    end
  end

  def self.set_token(controller)
    token = generate_token
    REDIS_DB.setex token_key(controller, token), 1.day, token
    controller.instance_variable_set '@token', token
  end

  def self.compare_token(controller)
    return controller.render :inline =>"alert('保存失败,可能是在同一个浏览器中同时编辑两篇文章造成的');" unless REDIS_DB.del token_key(controller, controller.params[:token])
  end

  def self.generate_token
    ActiveSupport::SecureRandom.hex(32)
  end

  def self.token_key(controller, token)
    "#{controller.session.session_id}:form_tokens:#{token}"
  end
end
