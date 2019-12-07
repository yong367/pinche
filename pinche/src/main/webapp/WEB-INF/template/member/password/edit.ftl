<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>爱帮伴-修改密码</title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	 
	[#if flashMessage?has_content]
		$.alert("${flashMessage}");
        location.href = "${base}/member/index";
	[/#if]
	
	$.validator.addMethod("notAllowBlank",
		function(value, element) {
			return this.optional(element) || /^\S*$/.test(value);
		},
		"${message("common.validate.illegal")}"
	);
	
	// 表单验证
	$inputForm.validate({
		rules: {
            validateNo: {
				required: true,
                notAllowBlank: true
			},
			password: {
				required: true,
				notAllowBlank: true,
				minlength: 6
			},
			rePassword: {
				required: true,
				notAllowBlank: true,
				equalTo: "#password"
			}
		}
	});

});
</script>
</head>
<body>
	[#assign current = "passwordEdit" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="input">
					<div class="title">${message("member.password.edit")}</div>
					<form id="inputForm" action="update" method="post">
						<table class="input">
							<tr>
								<th>
									<span class="requiredField"></span>手机号码:
								</th>
								<td>
									${mobile}
									<input type="hidden" id="mobile" value="${mobile}"/>
								</td>
							</tr>
							<tr>
								<th>
									<span class="requiredField">*</span>验证码:
								</th>
								<td>
									<input type="text" id="validateNo" name="validateNo" class="text"/>
									<input type="button" class="span_yzm" value="获取验证码" onclick="sendValidateNo(this)" style="padding:3px;"/>
								</td>
							</tr>
							<tr>
								<th>
									<span class="requiredField">*</span>${message("member.password.newPassword")}:
								</th>
								<td>
									<input type="password" id="password" name="password" class="text" maxlength="20" autocomplete="off" />
								</td>
							</tr>
							<tr>
								<th>
									<span class="requiredField">*</span>${message("member.password.rePassword")}:
								</th>
								<td>
									<input type="password" name="rePassword" class="text" maxlength="20" autocomplete="off" />
								</td>
							</tr>
							<tr>
								<th>
									&nbsp;
								</th>
								<td>
									<input type="submit" class="button" value="${message("member.common.submit")}" />
									<input type="button" class="button" value="${message("member.common.back")}" onclick="history.back(); return false;" />
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
		</div>
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
	[#include "/shop/include/footer.ftl" /]
</body>
</html>