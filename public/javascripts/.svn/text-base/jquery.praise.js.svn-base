jQuery(document).ready(function($) {
	//打分评价
	$(".set-praise").html("<p></p><p></p><p></p><p></p><p></p>");
	$(".set-praise p").mouseover(function() {
		$(this).addClass("one").prevAll().addClass("one").end().nextAll().removeClass("one");
		showPraiseTip($('.big-star .one').length*2);
                	}).click(function() {
		var praise = $(this).siblings(".one").length * 2 + 2;
		$(this).parent().attr("data-praise", praise).next().val(praise);
		if ($('#pop_main_praise').length > 0) {
			$('#pop_main_praise').val(praise);
		};
	}).parent().mouseout(function() {
		var star = $(this).attr("data-praise")/2 - 1 ;
		
		if (star == -1 ) {
			$(this).children().removeClass("one");
		}else{
			$(this).children(":lt("+star+")").addClass("one").end().
							children(":eq("+star+")").addClass("one").end().
							children(":gt("+star+")").removeClass("one");
			
		};
		
	});
	function showPraiseTip(star) {
		switch (star.toString()){
			case "2":
				$("#show_key").text("很不满意");
				break;
			case "4":
				$("#show_key").text("不满意");
				break;
			case "6":
				$("#show_key").text("一般");
				break;
			case "8":
				$("#show_key").text("满意");
				break;
			case "10":
				$("#show_key").text("非常满意");
				break;
			default:
				$("#show_key").text("请评分");
		}
	};
	$(".big-star p").click(function() {
		var star = $(this).parent().attr("data-praise") ;
		showPraiseTip(star);
	});

        $("#firm_under_star").click(function() {
		var praise = $(this).siblings(".one").length * 2 + 2;
		$(this).parent().attr("data-praise", praise).next().val(praise);
		if ($('#pop_main_praise').length > 0) {
			$('#pop_main_praise').val(praise);
		}});
	
	///////******************//////
	$("#open_mark").click(function(){
		if(getCookie("ind_id")== ""||getCookie("ind_id").length ==0 ){
			 alert("请先登录")
		}else{
		$("#open_mark").unbind("click");
		$.post("/user/verify_mark",{firm_id : $("#deco_frim_id").val()},
		function(data){
			if(data.result){
				$("#simple_remark").hide()
				$(".pinjbox").show();	
				if(data.is_mobile){
					$("#is_verify").show();
					$("#youhaoma").val(0);
				}else{
					$("#is_verify").hide();
					$("#youhaoma").val(1);
				}	
			}else{
				$("#open_mark").css({"padding-left":"25px","color":"red"}).text("提示：对不起.您6个月只能评分一次");
			}
		},"json");
		}
	}); 
	
	/* 普通留言评分 */
	$("#code_button").click(function(){
		var mobile = $("#mobile").val();
		var patrn=/^0?1(3\d|4\d|5[012356789]|8[056789])\d{8}$/;
		if (!patrn.exec(mobile)) {
			alert("请输入正确的手机号码");
			return false;
		}
		$("#code_button").val("正在发送...");
		$("#code_button").attr("disabled","disabled");
		$.post("/user/send_mobile_code",{mobile : $("#mobile").val()},
		function(data){
			$("#code_button").val("重新发送");
			$("#code_button").removeAttr("disabled");
			if(data.result == 1){
				$(".pinjprompt").text("提示：此手机号码三分钟之内只能验证一次");
				return false;
			}else if(data.result == 2){
				$(".pinjprompt").text("提示：您在三分钟之内只能验证一次");
				return false;
			}else if(data.result == 3){
				$(".pinjprompt").text("提示：发送验证码失败。请稍后再试");
				return false;
			}else if(data.result == 4){
				$(".pinjprompt").text("提示：当前输入的手机号已经被其他账号绑定，请更换号码后重新绑定操作");
				return false;
			}else if(data.result == 0){
				$("#pop_this_mobile").val(mobile);
				alert("验证码已发送至您手机！如果3分钟之内没有收到短信，请重新点击获取验证码");
			}else{
				alert("系统错误");
				return false;
			}
		},"json");
	});
	
	/* 公司终端页弹出留言评分*/
		$("#pop_code_button").click(function(){
		var mobile = $("#pop_mobile").val();
		var patrn=/^0?1(3\d|4\d|5[012356789]|8[056789])\d{8}$/;
		if (!patrn.exec(mobile)) {
			alert("请输入正确的手机号码");
			return false;
		}
		$("#pop_code_button").val("正在发送...");
		$("#pop_code_button").attr("disabled","disabled");
		$.post("/user/send_mobile_code",{mobile : mobile},
		function(data){
			$("#pop_code_button").val("重新发送");
			$("#pop_code_button").removeAttr("disabled");
			if(data.result == 1){
				$(".pinjprompt").text("提示：此手机号码三分钟之内只能验证一次");
				return false;
			}else if(data.result == 2){
				$(".pinjprompt").text("提示：您在三分钟之内只能验证一次");
				return false;
			}else if(data.result == 3){
				$(".pinjprompt").text("提示：发送验证码失败。请稍后再试");
				return false;
			}else if(data.result == 4){
				$(".pinjprompt").text("提示：当前输入的手机号已经被其他账号绑定，请更换号码后重新绑定操作");
				return false;
			}else if(data.result == 0){
				$("#this_mobile").val(mobile);
				alert("验证码已发送至您手机！如果3分钟之内没有收到短信，请重新点击获取验证码");
			}else{
				alert("系统错误");
				return false;
			}
		},"json");
	});
});
