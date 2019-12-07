<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>爱帮伴-重置密码</title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
    <link href="${base}/newResources/member/css/style.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/password.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $passwordForm = $("#passwordForm");
	var $password = $("#password");
	var $submit = $("input:submit");
	
	// 表单验证
	$passwordForm.validate({
		rules: {
			newPassword: {
				required: true,
				minlength: 4
			},
			rePassword: {
				required: true,
				equalTo: "#newPassword"
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
				success: function(message) {
					setTimeout(function() {
						$submit.prop("disabled", false);
						location.href = "${base}/";
					}, 3000);
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
</script>
</head>
<body>
	[#include "/shop/include/aibangbanheader.ftl" /]
    <div class="login_content">
        <div class="register">
            <div class="lost-password">
                设置密码
            </div>

            <div class="register_div">
                <form id="passwordForm" action="reset" method="post">
                    <input type="hidden" name="username" value="${user.username}" />
                    <input type="hidden" name="key" value="${key}" />
                    <input type="hidden" name="type" value="${type}" />
                <div class="kj-login zhLogin">
                    <ul class="register_form">
                        <li><input type="password" id="newPassword" name="newPassword" placeholder="请输入新密码"/></li>
                        <li><input type="password" name="rePassword" placeholder="请确认新密码"/></li>
                    </ul>
                    <div class="clear"></div>
                    <p class="p1"></p>
                    <button type="submit" class="registerButton">确认</button>
                    <p class="p2">我已有帐号？<a href="/member/login">立即登录</a></p>

                    <h5 class="otherlogin"></h5>

                    <ul class="otherList">
                        <li><a href="#"><img src="${base}/newResources/member/images/weixin.png" alt="图片说明" />微信</a></li>

                    </ul>
                </div>
				</form>

            </div>
        </div>
    </div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>