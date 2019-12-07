<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.register.title")}[#if showPowered] [/#if]</title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/register.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/member/datePicker/WdatePicker.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $registerForm = $("#registerForm");
	var $areaId = $("#areaId");
	var $submit = $("input:submit");
	
	// 地区选择
	$areaId.lSelect({
		url: "${base}/common/area"
	});
	

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
			},
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
<body>
	[#include "/shop/include/header.ftl" /]
    <div class="container register">
        <div class="row">
            <div class="span12">
                <div class="wrap">
                    <div class="main clearfix">
                        <div class="title">
						[#if socialUserId?has_content && uniqueId?has_content]
                            <strong>${message("member.register.bind")}</strong>REGISTER BIND
						[#else]
                            <strong>${message("member.register.title")}</strong>USER REGISTER
						[/#if]
                        </div>
                        <form id="registerForm" action="${base}/member/register/submit" method="post">
                            <input name="socialUserId" type="hidden" value="${socialUserId}" />
                            <input name="uniqueId" type="hidden" value="${uniqueId}" />
                            <table>
                                <tr>
                                    <th>
                                        <span class="requiredField">*</span>${message("member.register.username")}:
                                    </th>
                                    <td>
                                        <input type="text" name="username" id="username" class="text" maxlength="20" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <span class="requiredField">*</span>${message("member.register.password")}:
                                    </th>
                                    <td>
                                        <input type="password" id="password" name="password" class="text" maxlength="20" autocomplete="off" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <span class="requiredField">*</span>${message("member.register.rePassword")}:
                                    </th>
                                    <td>
                                        <input type="password" name="rePassword" class="text" maxlength="20" autocomplete="off" />
                                    </td>
                                </tr>

							[#--	[#if setting.z?? && setting.captchaTypes?seq_contains("memberRegister")]--]
                                <tr>
                                    <th>
                                        <span class="requiredField">*</span>${message("common.captcha.name")}:
                                    </th>
                                    <td>
											<span class="fieldSet">
												<input type="text" id="validateNo" name="validateNo"  maxlength="6"/> <input type="button" id="validateNoButton" onclick="sendValidateNo()" value='${message("merber.register.sendValidateNo")}'/>
											</span>
                                    </td>
                                </tr>
							[#--[/#if]--]
                                <tr>
                                    <th>
                                        &nbsp;
                                    </th>
                                    <td>
                                        <input type="submit" class="submit" value="${message("member.register.submit")}" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        &nbsp;
                                    </th>
                                    <td>
                                        <a href="${base}/article/detail/1_1" target="_blank">${message("member.register.agreement")}</a>
                                    </td>
                                </tr>
                            </table>
                            <div class="login">
                                <dl>
                                    <dt>${message("member.register.hasAccount")}</dt>
                                    <dd>
									${message("member.register.tips")}
                                        <a href="${base}/member/login">${message("member.register.login")}</a>
                                    </dd>
                                </dl>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>