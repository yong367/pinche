<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>爱帮伴-会员注册</title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
    <link href="${base}/newResources/member/css/style.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/register.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/member/datePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${base}/resources/statistic/browsestatistical.js"></script>
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

    //修改默认提示语  
    $.extend($.validator.messages, {
        rangelength: $.validator.format("邀请码格式不正确"),
    });


    /*   $.validator.addMethod("isExist",
               function(value, element) {
                   $.ajax({
                       url: "${base}/member/register/check_username",
                    type: "GET",
                    data: "username="+value,
                    dataType: "json",
                    success: function(data) {
                        alert(data);
                        return data;
                    }

                });
            },
            "${message("member.register.usernameExist")}"
    );*/
	
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
			},
            password:{
			    required:"密码不能为空！"
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

var clock = '';
var nums = 60;
var btn;
function sendValidateNo(sendButton){
    var mobile=$("#username").val();
    btn = sendButton;
    var reg= /^1[3|4|5|6|7|8|9]\d{9}$/;
    if(!reg.exec(mobile)){
        alert("手机号格式不正确！");
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
                    alert(data.msg);
                    btn.value = nums+'秒后可重新获取';
                    clock = setInterval(doLoop, 1000); //一秒执行一次
                }else{
                    alert(data.msg);
                    btn.disabled = false; //将按钮置为不可点击
                }
            },
            error: function(xhr, textStatus, errorThrown) {
                setTimeout(function() {
                    $("#validateNoButton").prop("disabled", true);
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
            [#--<div class="register_tab">
                <span class="active">注册</span>
             --][#--   <span>快捷登录</span>--][#--
            </div>--]
                <div class="lost-password">
                    注册
                </div>
            <div class="register_div">
                <div class="register_table login_div">
                    <form id="registerForm" class="registerform" method="post" action="${base}/member/register/submit">
                        <input name="socialUserId" type="hidden" value="${socialUserId}" />
                        <input name="uniqueId" type="hidden" value="${uniqueId}" />
                        <ul class="register_form">
                            <li>
                                <div class="td"><input type="text" id="username" placeholder="请输入手机号" name="username" class="inputxt"   />
                                </div>
                            </li>
                            <li style="display: inline-flex">
                                <div style="width: 240px">
                                    <input type="text" id="validateNo" name="validateNo" placeholder="手机短信验证码" class="yzmtext"/></div>
                                <input type="button" id="validateNoButton" class="span_yzm" value="获取验证码" onclick="sendValidateNo(this)" /></li>

                            <li>
                                <div class="td"><input type="password" id="password" name="password" placeholder="密码" class="inputxt"/>
                                </div>
                                <div class="td">
                                    <div class="passwordStrength" style="display:none;"><b>密码强度：</b> <span>弱</span><span>中</span><span class="last">强</span></div>
                                    <div class="info"><span class="Validform_checktip">密码至少6个字符,最多20个字符</span><span class="dec"><s class="dec1">&#9670;</s><s class="dec2">&#9670;</s></span></div>

                                </div>
                            </li>
                            <li>
                                <div class="td"><input type="password"  name="rePassword"  placeholder="再次确认密码"  class="inputxt"/></div>
                                <div class="td">
                                    <div class="info"><span class="Validform_checktip">请确认您的密码</span><span class="dec"><s class="dec1">&#9670;</s><s class="dec2">&#9670;</s></span></div>
                                </div>
                            </li>
                            <li>
                                <div class="td"><input type="text" id="recommendCode" placeholder="请输入邀请码" name="recommendCode" class="inputxt"   />
                                </div>
                            </li>
                        </ul>
                        <div class="clear"></div>
                        <p class="p1"><label><input type="checkbox" name="" checked="checked"/><a href="${base}/articlehtml/hyzcxy.html" target="_blank">我已阅读并接受以下条款</a></label></p>

                        <button type="submit" class="registerButton">立即注册</button>

                    </form>
                    <p class="p2">我已有帐号,<a href="/member/login">点击登录</a></p>

                    <h5 class="otherlogin"></h5>

                    <ul class="otherList">
                        <li><a href="#"><img src="${base}/newResources/member/images/weixin.png" alt="图片说明" />微信</a></li>

                    </ul>

                </div>
                <!-- 登录
                <div class="kj-login login_div" style="display:none">

                    <form class="registerform" method="post" action="/">
                        <ul class="register_form">
                            <li>
                                <div class="td"><input type="text"  placeholder="请输入手机号" name="tel" class="inputxt" datatype="m" nullmsg="请输入您的手机号码！" errormsg="请输入您的手机号码！" />
                                </div>
                                <div class="td">
                                    <div class="info"><span class="Validform_checktip">请输入您的手机号码</span><span class="dec"><s class="dec1">&#9670;</s><s class="dec2">&#9670;</s></span></div>
                                </div>
                            </li>
                            <li><input type="text" name="" placeholder="手机短信验证码" class="yzmtext"/>
                                <input type="button" class="span_yzm" value="获取验证码" onclick="sendCode(this)" /></li>
                        </ul>
                        <div class="clear"></div>
                        <p class="p1"><label><input type="checkbox" name="" checked="checked"/>下次自动登录</label> <a href="#">忘记密码？</a></p>
                        <button type="submit" class="registerButton">立即登录</button>
                    </form>

                    <h5 class="otherlogin"></h5>

                    <ul class="otherList">
                        <li><a href="#"><img src="${base}/newResources/member/images/weixin.png" alt="图片说明" />微信</a></li>

                    </ul>
                </div>-->

            </div>
        </div>
    </div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>