<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-会员注册</title>
    <link href="${base}/newResources/member/css/mobilestyle.css" rel="stylesheet" type="text/css" />
	<link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
	<script src="${base}/resources/mobile/member/js/jquery.js"></script>
	<script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/member/js/bootstrap-datepicker.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.lSelect.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
    <script type="text/javascript" src="${base}/resources/statistic/browsestatistical.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $registerForm = $("#registerForm");
		var $areaId = $("#areaId");
		var $submit = $("button:submit");
		
		
        //修改默认提示语  
        // $.extend($.validator.messages, {
        //     rangelength: $.validator.format("邀请码格式不正确"),
        // });


        // 表单验证
		$registerForm.validate({
			rules: {
				username: {
					required: true,
                    minlength: 11,
                    pattern: /^1[3|4|5|6|7|8|9]\d{9}$/,
					remote: {
						url: "${base}/member/register/check_username",
						cache: false,
                        dataFilter: function(data, type) {
                            if (data == "true"){
                                $("#validateNoButton").prop("disabled", false);
                                return "true";
                            }else{
                                $("#validateNoButton").prop("disabled", true);
                                return "false";
                            }
                        }
					}
				},
				password: {
					required: true,
					minlength: 4
				},recommendCode: {
                    required: false,
                    rangelength:[6,6]
                },rePassword: {
					required: true,
					equalTo: "#password"
				},
                validateNo:"required"
			},
			messages: {
				username: {
					pattern: "${message("member.register.usernameIllegal")}",
					remote: "${message("member.register.usernameExist")}"
				}


			},
			errorPlacement:function(error,element){
   		 	$("#textError").html(error);
   		 },
			submitHandler: function(form) {
				$.ajax({
                    url: $registerForm.attr("action"),
                    type: "POST",
                    data: $registerForm.serialize(),
                    dataType: "json",
                    beforeSend: function() {
                        $submit.prop("disabled", true);
                    },
                    success: function() {
                        setTimeout(function() {
                            location.href = "${base}/";
                        }, 3000);
                    },
                    error: function(xhr, textStatus, errorThrown) {

                    },
                    complete: function() {
                        $submit.prop("disabled", false);
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
            $.alert("手机号格式不正确！");
            throw SyntaxError();
        }
            $.ajax({
                url: "${base}/member/register/sendValidateNo/"+mobile,
                type: "GET",
                dataType: "json",
                beforeSend: function() {
                    btn.disabled = true; //将按钮置为不可点击
                },
                success: function(data) {
                    if(data.status =='success'){
                        $.alert(data.msg);
                        btn.value = nums+'秒后可重新获取';
                        clock = setInterval(doLoop, 1000); //一秒执行一次
                    }else{
                        $.alert(data.msg);
                        btn.disabled = false; //将按钮置为不可点击
                    }
                },
                error: function(xhr, textStatus, errorThrown) {
                    btn.disabled = false;
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
<div class="container" id="container" style="height: 100%;width: 100%;">
    <form id="registerForm" action="${base}/member/register/submit" method="post">
    <div class="logo"><a href="javascript: void(0);"><img src="${base}/newResources/member/images/logo.png" alt="爱帮伴" /></a></div>
    <div class="zhuceWarp">
		 <p id="textError"></p>
        <ul>
            <li>
                <span class="zhuceLeft">手机号码</span>
                <span class="spanCt"><input type="text" id="username" name="username" class=""  placeholder="请输入手机号"/></span>
            </li>
            <li>
                <span class="zhuceLeft">验证码</span>
                <span class="spanCt"><input type="text"  id="validateNo" name="validateNo" class=""  maxlength="6" placeholder="短信验证码"/></span>
                <input type="button" class="hqyzm" id="validateNoButton" onclick="sendValidateNo(this)" value="获取验证码">
            </li>

            <li>
                <span class="zhuceLeft">设置密码</span>
                <span class="spanCt"><input type="password" id="password" name="password" class="" placeholder="6-20位字母、数字和符号组成"/></span>
            </li>
            <li>
                <span class="zhuceLeft">确认密码</span>
                <span class="spanCt"><input type="password"id="rePassword" name="rePassword" class="" placeholder="再次确认密码"/></span>
            </li>
            <#--<li>-->
                <#--<span class="zhuceLeft">邀请码</span>-->
                <#--<span class="spanCt"><input type="text" id="recommendCode" name="recommendCode" class=""  placeholder="请输入邀请码"/></span>-->
            <#--</li>-->
        </ul>
    </div>

    <div class="zhuceBt">
        <button type="submit">注册</button>
    </div>
	</form>
    <div class="kjlogin">
        <a href="${base}/member/login/goToSmsLogin">短信验证码快捷登录</a>
    </div>

    <div class="yyzh">
        已有帐号？<a href="${base}/member/login">立即登录</a>
    </div>
</div>
</body>
</html>