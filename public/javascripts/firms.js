jQuery(document).ready(function($) {
  $('#3d-map').attr(
    'href',
    "http://dw.edushi.com/redirect.aspx?" + $.param(eval('(' + $("#3d-map").attr('data-edushi') + ')'))
  );
	
	$('#firm-big-star').click(function(){
		if ($('#ajaxLoginForm').attr("data-current-user") == "") {
		$('#firm-big-star').colorbox({
		  href: '/sessions/pop_login',
			width: 700,
			height: 330,
			scrolling: false,
			opacity: 0.2
		});
		}else{
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
						jQuery.fn.colorbox({
							inline: true,
						  href: '#DecoPraisePopDiv',
							width: 650,
							height: 350,
							scrolling: false,
							opacity: 0.2
						});
					}else{
						alert("对不起，您6个月只能评分一次");
						return false;
					}
				},"json");
		};
	});
	
	
	
	
	
	/**/
	function show_advice_div(fatherid){
    document.getElementById("target_id1").value = fatherid;
    document.getElementById('popDiv').style.display='block';
    document.getElementById('popIframe').style.display='block';
    document.getElementById('bg').style.display='block';

    document.getElementById("is_q_a").value = 3;
    document.getElementById("tar_type2").value = 2;
    var adv = document.getElementById("advice_div"),
    btn = document.getElementById('advice_form_submit');
    if(btn && btn.disabled) btn.disabled = false;

    document.getElementById("ad_context").focus();
  }

  function closeDiv(){
    document.getElementById('popDiv').style.display='none';
    document.getElementById('bg').style.display='none';
    document.getElementById('popIframe').style.display='none';
    document.getElementById("is_q_a").value = 1;
  }
  function isfull(){
    if(document.regis.register_name.value == ""){
      alert( "姓名不能为空 ");
      document.regis.register_name.focus();
      return   false;
    }
    if(document.regis.register_sex.value == ""){
      alert( "请选择性别 ");
      document.regis.register_sex.focus();
      return   false;
    }
    if(document.regis.register_phone.value == ""){
      alert( "电话不能为空 ");
      document.regis.register_phone.focus();
      return   false;
    }
    if(document.regis.register_email.value == ""){
      alert( "E-mail不能为空 ");
      document.regis.register_email.focus();
      return   false;
    }
    return true;
  }

/*  ************ */

});