<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-修改密码</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/profile.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/member/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/member/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/member/js/jquery.js"></script>
	<script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script type="text/javascript">
		$().ready(function() {
			var $inputForm = $("#inputForm");
			
			[#if flashMessage?has_content]
                $.alert("${flashMessage}");
                location.href = "${base}/member/index";
			[/#if]
			
			// 表单验证
			$inputForm.validate({
				rules: {
                    validateNo: {
                        required: true,
                        notAllowBlank: true
                    },
					password: {
						required: true,
						minlength: 4
					},
					rePassword: {
						required: true,
						equalTo: "#password"
					}
				}
			});
		
		});
	</script>
</head>
<body class="profile">
	<header class="header-fixed" style="background:linear-gradient(126deg,rgba(150,100,111,1) 0%,rgba(107,107,138,1) 34%,rgba(217,124,117,1) 100%);color: #FFFFFF">
		<a class="pull-left" href="${base}/member/index">
			<span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
		</a>
		${message("member.password.edit")}
	</header>
	<main>
		<div class="container-fluid">
			<form id="inputForm" action="update" method="post">
				<div class="">
					<div class="panel-body">
						<div class="form-group form-group12">
                            <img src="${base}/resources/mobile/member/images/phone.png"/>
							[#--<label for="currentPassword">手机号</label>--]
							<var>${mobile}
                                <input type="hidden" id="mobile" value="${mobile}"/></var>
						</div>
						<div class="form-group form-group12">
                            <img src="${base}/resources/mobile/member/images/yzm.png"/>
							[#--<label for="password">验证码</label>--]
							<var>
								<input id="validateNo" name="validateNo" placeholder="验证码" class="form-control" type="text" style="margin: 5px;float: left;width: 60%;"/>
								<input type="button" class="span_yzm" value="获取验证码" onclick="sendValidateNo(this)" style="color: #FFFFFF ;float: right; width: 30%;height: 35px;line-height: 35px;margin: 4px 0;margin-right: 5px; border-radius: 22px;background:linear-gradient(270deg,rgba(147,114,133,1) 0%,rgba(148,114,132,1) 100%);box-shadow:0px 6px 10px 0px rgba(206,206,206,1);"/>
							</var>
						</div>
						<div class="form-group form-group12">
                            <img src="${base}/resources/mobile/member/images/pwd%20.png"/>
							[#--<label for="password">${message("member.password.newPassword")}</label>--]
							<var><input id="password" name="password" class="form-control" type="password" placeholder="新密码" maxlength="20" autocomplete="off"></var>
						</div>
						<div class="form-group form-group12">
                            <img src="${base}/resources/mobile/member/images/pwd%20.png"/>
							[#--<label for="rePassword">${message("member.password.rePassword")}</label>--]
							<var><input id="rePassword" name="rePassword" class="form-control" placeholder="重复新密码" type="password" maxlength="20" autocomplete="off"></var>
						</div>
					</div>
					<div class="text-center">
						<button class="btn btn-primary" type="submit" style="background: linear-gradient(126deg,rgba(150,100,111,1) 0%,rgba(107,107,138,1) 34%,rgba(217,124,117,1) 100%); outline: none; border: 0;width: 50%; height: 40px;border-radius: 20px;margin: 0px;">${message("member.common.submit")}</button>
					</div>
				</div>
			</form>
		</div>
		
		<script type="text/javascript">
            var clock = '';
            var nums = 60;
            var btn;
            function sendValidateNo(thisBtn){
                btn = thisBtn;
                var mobile=$("#mobile").val();
                var reg= /^1[3|4|5|6|7|8|9]\d{9}$/;
                if(!reg.exec(mobile)){
                    $.alert("手机号格式不正确！");
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
                            $.alert("验证码发送成功！请注意查收");
                            btn.value = nums+'秒后可重新获取';
                            clock = setInterval(doLoop, 1000); //一秒执行一次
                        }else{
                            $.alert(data.msg);
                            btn.disabled = false;
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
	</main>
</body>
</html>