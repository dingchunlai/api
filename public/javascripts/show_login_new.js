function getCookie(c_name){
if (document.cookie.length>0)
  {
  c_start=document.cookie.indexOf(c_name + "=")
  if (c_start!=-1)
    {
    c_start=c_start + c_name.length+1
    c_end=document.cookie.indexOf(";",c_start)
    if (c_end==-1) c_end=document.cookie.length
    return unescape(document.cookie.substring(c_start,c_end))
    }
  }
return ""
}
if (getCookie("ind_id")==""){
  if (getCookie("vendor_id")==""){
    //未登录状态
    document.write("<a href='http://member.51hejia.com/member/reg?forward=" + top.location.href + "' target='_blank' title='免费注册'><img src='http://www.51hejia.com/css/prozhuangxiu/Reg_New.gif' width='60' height='20' border='0' align='absmiddle' /></a>			<a href='#de' id='dl' onclick=\"Divopop('Login');return false;\" title='登录'><img src='http://www.51hejia.com/css/prozhuangxiu/Login_New.gif' width='36' height='20' border='0' align='absmiddle' /></a>");
  }else{
    //以企业用户登录状态
    document.write("<a href='#' target='_self' id='dl'><img src='http://member.51hejia.com/images/myhejia.gif' alt='企业会员' width='64' height='20' border='0' align='absmiddle' /></a>			<a href='http://member.51hejia.com/member/loginout?forward=" + top.location.href + "' target='hideiframe_loginout'><img src='http://member.51hejia.com/images/loginout.gif' width='36' height='20' border='0' align='absmiddle' /></a>");
  }
}else{
  //以个人用户登录状态
  document.write("<a href='http://member.51hejia.com/member/userinfo' target='_blank' id='dl' title='我的和家'><img src='http://www.51hejia.com/css/prozhuangxiu/myhejia.gif' width='60' height='20' border='0' align='absmiddle' /></a>			<a href='http://member.51hejia.com/member/loginout?forward=" + top.location.href + "' target='hideiframe_loginout' title='退出'><img src='http://www.51hejia.com/css/prozhuangxiu/loginout.gif' width='36' height='20' border='0' align='absmiddle' /></a>");
}