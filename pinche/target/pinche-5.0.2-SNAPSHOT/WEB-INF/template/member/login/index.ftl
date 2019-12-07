<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>爱帮伴-会员登录</title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
<link href="${base}/newResources/member/css/style.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/newResources/member/js/login.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/statistic/browsestatistical.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $loginForm = $("#loginForm");
	var $username = $("#username");
	var $password = $("#password");
	var $isRememberUsername = $("#isRememberUsername");
	var $submit = $("input:submit");

	
	// 记住用户名
	if (getCookie("memberUsername") != null) {
		$isRememberUsername.prop("checked", true);
		$username.val(getCookie("memberUsername"));
		$password.focus();
	} else {
		$isRememberUsername.prop("checked", false);
		$username.focus();
	}

	// 表单验证、记住用户名
	$loginForm.validate({
        rules: {
            username: {
                required: true,
                pattern: /^1[3|4|5|6|7|8|9]\d{9}$/
            },
            password: {
                required: true
            }
        },
        messages: {
            username: {
                required:"账号不能为空",
                pattern: "手机号格式不正确"
            },
            password:{
                required:"密码不能为空"
			}
        },
		submitHandler: function(form) {
			$.ajax({
				url: $loginForm.attr("action"),
				type: "POST",
				data: $loginForm.serialize(),
				dataType: "json",
				beforeSend: function() {
					$submit.prop("disabled", true);
				},
				success: function(data) {
					$submit.prop("disabled", false);
					if ($isRememberUsername.prop("checked")) {
						addCookie("memberUsername", $username.val(), {expires: 7 * 24 * 60 * 60});
					} else {
						removeCookie("memberUsername");
					}
					[#if redirectUrl?has_content]
						location.href = "${redirectUrl?js_string}";
					[#else]
						if (data.redirectUrl != null) {
							location.href = data.redirectUrl;
						} else {
							location.href = "${base}/";
						}
					[/#if]
				},
				error: function(xhr, textStatus, errorThrown) {
					setTimeout(function() {
						$submit.prop("disabled", false);
					}, 3000);
				}
			});
		}
	});
    var $smsLoginForm = $("#smsLoginForm");
    var $smsLoginButton=$("#smsLoginButton");
    var $issmsRememberUsername=$("#issmsRememberUsername");
    var $mobile=$("#mobile");
    $smsLoginForm.validate({
        rules: {
            mobile: {
                required: true,
                pattern: /^1[3|4|5|6|7|8|9]\d{9}$/
            },
            validateNo: {
                required: true
            }
        },
        messages: {
            mobile: {
                required:"账号不能为空",
                pattern: "手机号格式不正确"
            },
            validateNo:{
                required:"验证码不能为空"
            }
        },
        submitHandler: function(form) {
            $.ajax({
                url: $smsLoginForm.attr("action"),
                type: "POST",
                data: $smsLoginForm.serialize(),
                dataType: "json",
                beforeSend: function() {
                    $smsLoginButton.prop("disabled", true);
                },
                success: function(data) {
                    $smsLoginButton.prop("disabled", false);
                    if ($issmsRememberUsername.prop("checked")) {
                        addCookie("memberUsername", $mobile.val(), {expires: 7 * 24 * 60 * 60});
                    } else {
                        removeCookie("memberUsername");
                    }
                    location.href = "${base}/";

                },
                error: function(xhr, textStatus, errorThrown) {
                    setTimeout(function() {
                        $smsLoginButton.prop("disabled", false);
                    }, 3000);
                }
            });
        }
    });



});
var clock = '';
var nums = 60;
var btn;
function sendCode(thisBtn)
{
    btn = thisBtn;
    var mobile= $("#mobile").val();
    var reg= /^1[3|4|5|6|7|8|9]\d{9}$/;
    if(!reg.exec(mobile)){
        alert("手机号格式不正确！");
        throw SyntaxError();
    }
    $.ajax({
        url: "/member/login/sendLoginValidateNo/"+mobile,
        type: "GET",
        dataType: "json",
        beforeSend: function() {
            btn.disabled = true; //将按钮置为不可点击
        },
        success: function(data) {
            if(data.status =='success'){
                alert(data.msg);
                btn.value = nums+'秒后可重新获取';
                clock = setInterval(doLoop, 1000); //一秒执行一次
            }else{
                alert(data.msg);
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
[#include "/shop/include/aibangbanheader.ftl" /]
<div class="login_content">
    <div class="register">
        <div class="register_tab">
            <span class="active">帐号登录</span>
            <span>快捷登录</span>
        </div>

        <div class="register_div">
            <div class="kj-login login_div">
                <form id="loginForm" action="${base}/member/login" method="post">
                    <input name="socialUserId" type="hidden" value="${socialUserId}" />
                    <input name="uniqueId" type="hidden" value="${uniqueId}" />
                    <ul class="register_form">
                        <li>
                            <div class="td"><input type="text"  placeholder="请输入手机号" id="username" name="username" value="15111111000" class="inputxt" datatype="m" nullmsg="请输入您的手机号码！" errormsg="请输入您的手机号码！" />
                            </div>
                            <div class="td">
                                <div class="info"><span class="Validform_checktip">请输入您的手机号码</span><span class="dec"><s class="dec1">&#9670;</s><s class="dec2">&#9670;</s></span></div>
                            </div>
                        </li>
                        <li>
                            <div class="td"><input type="password" id="password" name="password" placeholder="密码" class="inputxt" value="123456" plugin="passwordStrength"  datatype="*6-18" nullmsg="请输入密码！" errormsg="密码至少6个字符,最多18个字符！"/>
                            </div>
                            <div class="td">
                                <div class="passwordStrength" style="display:none;"><b>密码强度：</b> <span>弱</span><span>中</span><span class="last">强</span></div>
                                <div class="info"><span class="Validform_checktip">密码至少6个字符,最多18个字符</span><span class="dec"><s class="dec1">&#9670;</s><s class="dec2">&#9670;</s></span></div>

                            </div>
                        </li>
                    </ul>

                    <div class="clear"></div>
                    <p class="p1"><label><input type="checkbox" name="" checked="checked"/>下次自动登录</label> <a href="${base}/password/forgot?type=member">忘记密码？</a></p>
                    <button type="submit" class="registerButton">立即登录</button>
                    <p class="p2">还没有帐号？<a href="${base}/member/register">免费注册</a></p>

                    [#--<h5 class="otherlogin"></h5>

                    <ul class="otherList">
                        <li><a href="#"><img src="${base}/newResources/member/images/weixin.png" alt="图片说明" />微信</a></li>

                    </ul>--]
                </form>
            </div>
            <!-- 登录 -->
            <div class="kj-login login_div" style="display:none">
                <form class="registerform" method="post" action="${base}/member/login/smsLogin" id="smsLoginForm">
                    <input name="socialUserId" type="hidden" value="${socialUserId}" />
                    <input name="uniqueId" type="hidden" value="${uniqueId}" />
                    <ul class="register_form">
                        <li>
                            <div class="td">
                                <input type="text" placeholder="请输入手机号" id="mobile" name="mobile" class="inputxt" datatype="m" nullmsg="请输入您的手机号码！" errormsg="请输入您的手机号码！"/>
                            </div>
                        </li>
                             <li style="display: inline-flex">
                               <div style="width: 240px"><input type="text" name="validateNo" placeholder="手机短信验证码" class="yzmtext"/></div>
                                <input type="button" class="span_yzm" value="获取验证码" onclick="sendCode(this)" />
                            </li>
                    </ul>
                    <div class="clear"></div>
                    <p class="p1"><label><input type="checkbox" name="" checked="checked" id="issmsRememberUsername"/>下次自动登录</label> <a href="${base}/password/forgot?type=member">忘记密码？</a></p>
                    <button type="submit" class="registerButton" id="smsLoginButton">立即登录</button>
                    <p class="p2">还没有帐号？<a href="${base}/member/register">免费注册</a></p>
                </form>
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