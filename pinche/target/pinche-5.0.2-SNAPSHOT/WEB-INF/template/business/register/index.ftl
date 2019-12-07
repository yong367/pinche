<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>爱帮伴-商家注册</title>
    <link href="${base}/favicon.ico" rel="icon">
    <link href="${base}/newResources/business/css/login.css" rel="stylesheet">
    <link href="${base}/resources/business/css/common.css" rel="stylesheet">
    <script src="${base}/resources/business/js/jquery.js"></script>
    <script src="${base}/resources/business/js/bootstrap.js"></script>
    <script src="${base}/resources/business/js/jquery.validate.js"></script>
    <script src="${base}/resources/business/js/common.js"></script>
    <script>
        $().ready(function() {
            var $submit = $("#registerButton");
            var $registerForm = $("#registerForm");
            // 表单验证、记住用户名
            $registerForm.validate({
                rules: {
                    mobile: {
                        pattern: /^1[3|4|5|6|7|8|9]\d{9}$/,
                        remote: {
                            url: "${base}/business/register/check_mobile",
                            cache: false
                        }
                    },
                    password: {
                        required: true,
                    }
                [@business_attribute_list]
                    [#list businessAttributes as businessAttribute]
                        [#if businessAttribute.isRequired || businessAttribute.pattern?has_content]
							,businessAttribute_${businessAttribute.id}: {
								[#if businessAttribute.isRequired]
									required: true
                                    [#if businessAttribute.pattern?has_content],[/#if]
                                [/#if]
								[#if businessAttribute.pattern?has_content]
									pattern: /${businessAttribute.pattern}/
                                [/#if]
                            }
                        [/#if]
                    [/#list]
                [/@business_attribute_list]
                },
                messages:{
                    mobile:{
                        required:"账号不能为空！",
                        pattern: "${message("common.validate.pattern")}",
                        remote: "${message("common.validate.exist")}"
                    },
                    password:{
                        required:"密码不能为空！"
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
                        success: function(data) {

						[#if redirectUrl?has_content]
							location.href = "${redirectUrl?js_string}";
                        [#else]
							if (data.redirectUrl != null) {
                                location.href = data.redirectUrl;
                            } else {
                                location.href = "${base}/business/index";
                            }
                        [/#if]
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

        //发送验证码
        var clock = '';
        var nums = 60;
        var btn;
        function sendCode(thisBtn)
        {
            btn = thisBtn;
            var mobile= $("#mobile").val();
            var reg= /^1[3|4|5|6|7|8|9]\d{9}$/;
            if(!reg.exec(mobile)){
                $.alert("手机号格式不正确！");
                throw SyntaxError();
            }
            $.ajax({
                url: "/business/loginExtend/sendLoginValidateNo/"+mobile,
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
<div id="logo">
    <img src="/newResources/business/images/firstPageImg/u5.png" alt="">
</div>
<p id="textError" style="color: red"></p>
<form  id="registerForm" action="${base}/business/register/submit" method="post">
    <div id="loginText">

        <div class="z" style="margin-top: 10px;"><img src="/newResources/business/images/firstPageImg/u30.png" alt=""><input type="text" id="mobile" name="mobile" class="inp" autocomplete="off" placeholder="请输入手机号"></div>
        <div class="z" style="margin-top: 10px"><img src="/newResources/business/images/firstPageImg/u51.png" alt=""><input type="text" id="validateNo" maxlength="6" name="validateNo" class="inp" placeholder="验证码"><input type="button" value="获取验证码" id="phoneCode"  onclick="sendCode(this)"></div>
        <div class="z" style="margin-top: 10px;"><img src="/newResources/business/images/firstPageImg/u35.png" alt=""><input type="password" id="password" name="password" class="inp" autocomplete="off" placeholder="请输入密码"><img src="/newResources/business/images/firstPageImg/u65.png" name="eye" class="exe" ></div>
        <p><input type="checkbox" name="book" value="xy" checked="checked"/>&nbsp;登录即表示你同意<a href="${base}/business/login/agreement?agreementType=servicepc">用户协议</a>和<a href="${base}/business/login/agreement?agreementType=privacypc">隐私条款</a></p>
        <div id="loginRegister"><button type="submit" id="registerButton" style="width: 301px;height: 49px;border-radius:5px;background:white;color:#1B9DD5; border: none;font-size: 16px;font-family: 'Arial Negreta', 'Arial Normal', 'Arial';font-weight: 700;">注册</button></div>
        
    </div>
</form>

</body>
</html>