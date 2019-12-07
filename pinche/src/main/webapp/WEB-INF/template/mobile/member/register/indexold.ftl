<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>${message("member.register.title")}[#if showPowered] [/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/bootstrap-datepicker.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/register.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/member/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/member/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/member/js/jquery.js"></script>
	<script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/member/js/bootstrap-datepicker.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.lSelect.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $registerForm = $("#registerForm");
		var $areaId = $("#areaId");
		var $datepicker = $("input.datepicker");
		var $submit = $("button:submit");
		
		// 地区选择
		$areaId.lSelect({
			url: "${base}/common/area"
		});
		
		// 日期选择
		$datepicker.datepicker({
			language: "${locale}",
			format: "yyyy-mm-dd",
			todayHighlight: true,
			autoclose: true
		});
		
		// 验证码图片

		$.validator.addMethod("notAllNumber",
			function(value, element) {
				return this.optional(element) || /^.*[^\d].*$/.test(value);
			},
			"${message("member.register.notAllNumber")}"
		);
		
		// 表单验证
		$registerForm.validate({
			rules: {
				username: {
					required: true,
                    minlength: 11,
                    pattern: /^1[3|4|5|6|7|8|9]\d{9}$/,
					remote: {
						url: "${base}/member/register/check_username",
						cache: false
					}
				},
				password: {
					required: true,
					minlength: 4
				},
				rePassword: {
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
    function sendValidateNo(){
        var mobile=$("#username").val();
        if(mobile){
            $.ajax({
                url: "${base}/member/register/sendValidateNo/"+mobile,
                type: "GET",
                dataType: "json",
                beforeSend: function() {
                    $("#validateNoButton").prop("disabled", true);
                },
                success: function(data) {
                    if(data.status =='success'){
                        alert(data.msg);
                    }
                },
                error: function(xhr, textStatus, errorThrown) {
                    setTimeout(function() {
                        $("#validateNoButton").prop("disabled", true);
                    }, 3000);
                }
            });
        }

    }
</script>
</head>
<body class="register">
	<header class="header-fixed">
		<a class="pull-left" href="javascript: history.back();">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		[#if socialUserId?has_content && uniqueId?has_content]
			${message("member.register.bind")}
		[#else]
			${message("member.register.title")}
		[/#if]
	</header>
    <main>
        <div class="container-fluid">
            <form id="registerForm" action="${base}/member/register/submit" method="post">
          <input name="socialUserId" type="hidden" value="${socialUserId}">
                <input name="uniqueId" type="hidden" value="${uniqueId}">
                <div class="form-group">
                    <label for="username">${message("member.register.username")}</label>
                    <input id="username" name="username" id="username" class="form-control" type="text" maxlength="20">
                </div>
                <div class="form-group">
                    <label for="password">${message("member.register.password")}</label>
                    <input id="password" name="password" class="form-control" type="password" maxlength="20" autocomplete="off">
                </div>
                <div class="form-group">
                    <label for="rePassword">${message("member.register.rePassword")}</label>
                    <input id="rePassword" name="rePassword" class="form-control" type="password" maxlength="20" autocomplete="off">
                </div>



			[#--[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("memberRegister")]--]
                <div class="form-group">
                    <label for="captcha">${message("common.captcha.name")}</label>
                    <div class="input-group">
                        <input type="text" id="validateNo" name="validateNo"  maxlength="6"/> <input type="button" id="validateNoButton" onclick="sendValidateNo()" value='${message("merber.register.sendValidateNo")}'/>
                    </div>
                </div>
			[#--[/#if]--]
                <button class="btn btn-lg btn-primary btn-block" type="submit">${message("member.register.submit")}</button>
            </form>
            <div class="row">
                <div class="col-xs-6 text-left">
                    <a href="${base}/article/detail/1_1">${message("member.register.agreement")}</a>
                </div>
                <div class="col-xs-6 text-right">
                    <a href="${base}/member/login">${message("member.register.login")}</a>
                </div>
            </div>
        </div>
    </main>
</body>
</html>