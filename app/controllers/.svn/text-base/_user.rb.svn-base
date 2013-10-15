#本文件包含用户相关方法
def user_validate    
  unless staff_logged_in?
    session[:rurl] = request.request_uri
    show_validate_error("您还未登录！")
  end
end

# 权限验证
def pvalidate(operate, *roles)
  if staff_logged_in? && roles.any? { |role| current_staff.member_of? role }
    true
  else
    show_validate_error("只有【#{roles.join("、")}】才能执行【#{operate}】操作，您不具备这样的权限。")
    false
  end
end

def show_validate_error(str) #输出验证错误
  if (request.request_uri=="/" || request.request_uri=="/admin")
      render :text => js(top_load("http://radmin.51hejia.com/user/login"))
  else
      render :text => "<div style='line-height:30px; padding:30px'><b>#{str} <a href=\"http://radmin.51hejia.com/user/login\">[点这里登录]</a></b>\
<br /><br />如果您是因长时间未访问页面而使登录信息失效的话，\
请 <a href=\"http://radmin.51hejia.com/user/login\" target=\"_blank\">点这里在新窗口中登录</a> ,<br />\
然后 <a href=\"#\" onclick=\"location.reload();\">点这里刷新本页面</a> 以完成您的操作。<br /><br />\
或者您也可以 <a href=\"#\" onclick=\"history.back();\">点这里返回前一页</a> 。</div>" + js("if (top!=self) alert(\"#{str}\");")
  end
end

def isrole(name)
  staff_logged_in? and current_staff.member_of?(name)
end
