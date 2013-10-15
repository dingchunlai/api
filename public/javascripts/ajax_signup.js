jQuery(document).ready(function($) {


    // 设置一些初始数据
    var red="#f00" // 红色边框和姿态
    var green="#0c0" // 绿色边框和字体
    var blue="#09f" //蓝色
    //设置通过验证和未通过验证的样式
    jQuery.fn.setBlue=function(){
        tip=$(this).next();
        if(tip.css("color")!=red){
            tip.css("color",blue);
        }
    };
    jQuery.fn.setRed=function(message){
       // $(this).css("border-color",red);
        $tip=$(this).next();
        $tip.css("color",red);
        $tip.text(message);
        $tip.addClass("errorFlag");
    //   alert($("form .errorFlag").length);
    };
    jQuery.fn.setGreen=function(){
        $tip=$(this).next();
     //   $(this).css("border-color",green);
        $tip.css("color",green);
        $tip.html("<img src='/images/right.gif'>");
        $tip.removeClass("errorFlag");
    };
    //开始验证输入的用户名
    $("input").focus(function(){
        $(this).setBlue();
    });
    $('#signup_username').blur(function(){
        var login_length=$(this).val().length;
        if(login_length<=1 || login_length>=14){
            $(this).setRed("用户名为2-14位");
        }
        else{
          $.getJSON("/user/validate_username?username="+$(this).val(),
					function(data) {
						if (data["result"] == 0) {
							$('#signup_username').setRed("已占用");
						}else{
							$('#signup_username').setGreen();;
						}
					});
        };
    });

    //开始验证密码长度
    $("#signup_password").blur(function() {
        var password_length=$(this).val().length;
        if(  password_length <6 ||  password_length>16 ){
            $(this).setRed("密码长度应为6-16");
        }else{
            $(this).setGreen();
        }
    });
    
    //开始验证EMAIL
    $("#user_email").blur(function() {
        if( this.value=="" || this.value!="" && !/.+@.+\.[a-zA-Z]{2,4}$/.test(this.value) ){
            $(this).setRed("格式错误");
        }else{
          $.getJSON("/user/validate_email?email="+$(this).val(),
						function(data) {
							if (data["result"] == 0) {
								$('#user_email').setRed("已占用");
							}else{
								$('#user_email').setGreen();;
							}
					});
        };
    });
    	
    //开始验证密码确认
    $("#signup_password_confirm").blur(function() {
        var password=$("#signup_password").val()
        var password_confirmation=$(this).val()
        if(  password != password_confirmation || password_confirmation.length==0 ){
            $(this).setRed("两次密码不同");
        }else{
            $(this).setGreen();
        }
    });

		$('#signup_form').submit(function() {
	//		$("form :input").trigger('blur');
      var numError=$("form .errorFlag").length;
      if(numError>0){
         
      }else{
				$("#signup_submit").attr("disabled","disabled");
				$.ajax({
				  url: '/user/reg_save',
				  type: 'POST',
				  dataType: 'json',
				  data: $(this).serialize(),
				  success: function(data) {
						
				    if (data["result"] == 1) {
					$('#ajaxLoginForm').attr("data-current-user","xx");
							$.fn.colorbox({
								inline: true,
							  href: '#DecoPraisePopDiv',
								width: 650,
								opacity: 0.2
							});
						}else{
							alert("验证码不正确,请重新输入");
						};
				  },
				  error: function(xhr, textStatus, errorThrown) {
				    //called when there is an error
				  }
				});
			};
			return false;
		});
		
	/**************************************************************************************/
	$('#login_form').submit(function(){
	if($('#user_name').val().length <= 0){
		alert('请输入用户名');
	}else if($('#password').val().length <= 0){
		alert('请输入密码');
	}else{
		$("#login_submit").attr("disabled","disabled");
		$.ajax({
			type: "POST",
			url: "/sessions/user_login",
			dataType: "script",
			data: jQuery(this).serialize(),
			success: function(data){
				$('#login_submit').removeAttr("disabled");
				if(data == 'error'){
					alert('用户名或密码错误!');
					$("#password").val("");
				}else if(data == "freeze"){
					alert("您的帐户已暂被冻结，如有疑问可直接联系客服人员！");
					$("#password").val("");
				}else{
					$("#login").css("display","none");
					$("#open_mark").show();
					$(".gsl_rj").html("<a href='http://member.51hejia.com/member/user_note_list' title='发表日记' target='_blank'>发表日记</a>");
					$("#remark_button").html("<input type='submit' value='留言提交' id='pt_submit'  class='gsl_wyly_btn'  />");
					$('#ajaxLoginForm').attr("data-current-user",data);
				}
			}
		})
	}
	return false;
});



	$('#pop_login_form').submit(function(){
	if($('#pop_user_name').val().length <= 0){
		alert('请输入用户名');
	}else if($('#pop_password').val().length <= 0){
		alert('请输入密码');
	}else{
		$("#pop_login_submit").attr("disabled","disabled");
		$.ajax({
			type: "POST",
			url: "/sessions/user_login",
			dataType: "script",
			data: jQuery(this).serialize(),
			success: function(data){
				$('#pop_login_submit').removeAttr("disabled");
				if(data == 'error'){
					alert('用户名或密码错误!');
					$("#pop_password").val("");
				}else if(data == "freeze"){
					alert("您的帐户已暂被冻结，如有疑问可直接联系客服人员！");
					$("#pop_password").val("");
				}else{
					$('#ajaxLoginForm').attr("data-current-user","data")
					$("#login").css("display","none");
					$(".gsl_rj").html("<a href='http://member.51hejia.com/member/user_note_list' title='发表日记' target='_blank'>发表日记</a>");
					$("#remark_button").html("<input type='submit' value='留言提交' id='pt_submit'  class='gsl_wyly_btn'  />");
			//		$.fn.colorbox.close();
					$.post("/user/verify_mark",
						{firm_id : $("#deco_frim_id").val()},
						function(data){
							if (data.result) {
								if(data.is_mobile){
									$(".dafentit").show();
									$("#pop_youhaoma").val(0);
								}else{
									$(".dafentit").hide();
									$("#pop_youhaoma").val(1);
								}
								$.fn.colorbox({
									inline: true,
								  	href: '#DecoPraisePopDiv',
										width: 650,
										opacity: 0.2
								});
							}else{
								alert("对不起，您6个月只能评分一次");
								$.fn.colorbox.close();
								return false;
							}
						},"json");
				}
			}
		})
	}
	return false;
});

$("#firm_remark").submit(function(){
	if ($("#mark_tj").val() != 1){
		if ($.trim($("#content").val()).length == 0) {
			alert("请填写内容后再发表评论");
			return false;
		}
	}
});
$('#pop_mark_reset').click(function() {
	$('.small-star p').removeClass("one");
});
$("#mark_submit").click(function(){
	if($("#mian_praise").val().length == 0) {
		alert("请评分");
		return false;
	}else if ($("#youhaoma").val().length == 0 || $("#youhaoma").val() != 1) {
	var verify_code = $("#verify_code").val();
	if (verify_code.length != 4 || isNaN(verify_code)) {
		alert("请输入正确的验证码");
		return false;
	}
	$("#mark_submit").attr("disabled","disabled");
	$.post("/user/verify_mobile_code", {
		code: verify_code, mobile : $("#mobile").val()
	}, function(data){
		if (!data.result) {
			alert("验证码验证失败");
			$("#mark_submit").removeAttr("disabled");
		}else{
			$("#mark_tj").val(1);
			$('#firm_remark').submit();
		}
	}, "json");
}else{
	$("#mark_tj").val(1);
	$('#firm_remark').submit();
}
});

$("#pop_mark_button").click(function(){
	if ($("#pop_youhaoma").val().length == 0 || $("#pop_youhaoma").val() != 1) {
	var verify_code = $("#pop_verify_code").val();
	if (verify_code.length != 4 || isNaN(verify_code)) {
		alert("请输入正确的验证码");
		return false;
	}
	$("#pop_mark_button").attr("disabled","disabled");
	$.ajax({
	  url: '/user/verify_mobile_code',
	  type: 'POST',
    dataType: 'json',
    data: {code: verify_code,mobile: $("#pop_mobile").val()},
    success: function(data, textStatus, xhr) {
      if (!data.result) {
  			alert("验证码验证失败");
  			$("#pop_mark_button").removeAttr("disabled");
  		}else{
  			$("#pop_mark_tj").val(1);
  			$('#mark_remark').submit();
  		};
    }
 });
	
}else{
	$("#pop_mark_tj").val(1);
	$('#mark_remark').submit();
}
});
});
