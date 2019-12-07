<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>爱帮伴-忘记密码</title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
    <link href="${base}/newResources/member/css/style.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/password.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $passwordForm = $("#passwordForm");
	var $submit = $("input:submit");
	
	// 表单验证
	$passwordForm.validate({
		rules: {
            username: {
                required: true,
                pattern: /^1[3|4|5|6|7|8|9]\d{9}$/
            },
            validateNo: "required"
		},
        messages:{
            username: {
                required:"手机号不能为空！",
                pattern: "请输入正确的手机号！",
            },
            validateNo:{
                required:"验证码不能为空！"
            }
        },
		submitHandler: function(form) {
			$.ajax({
				url: $passwordForm.attr("action"),
				type: "POST",
				data: $passwordForm.serialize(),
				dataType: "json",
				cache: false,
				beforeSend: function() {
					$submit.prop("disabled", true);
				},
				success: function(data) {
                    location.href = "${base}/password/reset?type="+data.type+"&key="+data.safeKey+"&username="+data.username;
				},
				error: function(xhr, textStatus, errorThrown) {
					setTimeout(function() {
						$submit.prop("disabled", false);
					}, 3000);
				}
			});
		}
	});

});
var clock = '';
var nums = 60;
var btn;
function sendValidateNo(thisBtn){
    btn = thisBtn;
    var mobile=$("#username").val();
    var reg= /^1[3|4|5|6|7|8|9]\d{9}$/;
    if(!reg.exec(mobile)){
        alert("手机号格式不正确！");
        throw SyntaxError();
    }

        $.ajax({
            url: "${base}/password/forgot/sendValidateNo/"+mobile,
            type: "GET",
            dataType: "json",
            beforeSend: function() {
                btn.disabled = true; //将按钮置为不可点击
            },
            success: function(data) {
                if(data.status == "success"){
                alert("验证码发送成功！请注意查收");
                btn.value = nums+'秒后可重新获取';
                clock = setInterval(doLoop, 1000); //一秒执行一次
                }else if(data.status == "error"){
                    alert(data.msg);
                    btn.disabled = false;
                }else{
                    var r=confirm("该用户不存在，是否跳转到注册页面！");
                    if (r==true)
                    {
                        location.href = "${base}/member/register";
                    }else{
                        btn.disabled = false;
                    }
                }
            },
            error: function(xhr, textStatus, errorThrown) {
                setTimeout(function() {
                    btn.disabled = false;
                }, 3000);
            }
        });

}
function doLoop()
{
    nums--;
    if(nums > 0){
        btn.value = nums+'秒后可重新获取';
    }else{
        clearInterval(clock); //清除js定时器
        btn.disabled = false;
        btn.value = '重新获取验证码';
        nums = 60; //重置时间
    }
}
</script>
</head>
<body>
[#include "/shop/include/aibangbanheader.ftl" /]
<div class="login_content">
    <div class="register">
        <div class="lost-password">
            找回密码
        </div>
<form action="forgot" method="post" id="passwordForm">
    <input type="hidden" name="type" value="${type}" />
        <div class="register_div">
            <div class="kj-login zhLogin">
                <ul class="register_form">
                    <li><input type="text" id="username" name="username" placeholder="请输入手机号码"/></li>
                    <li style="display: inline-flex">
                        <div style="width: 240px"><input type="text" name="validateNo" placeholder="手机短信验证码" class="yzmtext"/></div>
                        <input type="button" class="span_yzm" value="获取验证码" onclick="sendValidateNo(this)" /></li>
                </ul>
                <div class="clear"></div>
                <p class="p1"></p>
               <input type="submit" class="registerButton" value="下一步">
</form>
                <p class="p2">我已有帐号？<a href="/member/login">立即登录</a></p>

                <h5 class="otherlogin"></h5>

                <ul class="otherList">
                    <li><a href="#"><img src="${base}/newResources/member/images/weixin.png" alt="图片说明" />微信</a></li>

                </ul>
            </div>


        </div>
    </div>
</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>