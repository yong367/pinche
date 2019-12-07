<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>爱帮伴-商家登录</title>
    <link href="${base}/favicon.ico" rel="icon">
    <link href="${base}/newResources/business/css/login.css" rel="stylesheet">
    <link href="${base}/resources/business/css/common.css" rel="stylesheet">
    <link href="${base}/resources/business/css/animate.css" rel="stylesheet">

    <script src="${base}/resources/business/js/jquery.js"></script>
    <script src="${base}/resources/business/js/bootstrap.js"></script>
    <script src="${base}/resources/business/js/jquery.validate.js"></script>
    <script src="${base}/resources/business/js/common.js"></script>
    <style>
        a {
            color: white;
            text-decoration: none;
        }
        .alert-dark {
            background-color: #ffffff;
            color: black;
            border: 1px solid lightgrey;
        }
        /*.captcha-image {*/
            /*width: 80px;*/
            /*height: 34px;*/
            /*margin-left: 20px;*/
            /*vertical-align:middle;*/
        /*}*/
    </style>
    <script type="text/javascript">


        $().ready(function() {
            var $captcha = $("#captcha");

            // 验证码图片
            $captcha.captchaImage();
            // var passBtn = $("#passButton").style.display();
            // var smsBtn = $("#smsButton").style.display();
            // alert("aa:" + passBtn + "bb:" + smsBtn);
            $("body").bind('keydown', function (event) {
                if (event.keyCode == 13 && $("#smsLoginForm").css("display")=='none') {
                    $("#smsButton").click();
                }
            });
            $("body").bind('keydown', function (event) {
                if (event.keyCode == 13 && $("#passwordLoginForm").css("display")=='none') {
                    $("#passButton").click();
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

        function passwordSubmit(){
            var mobile=$("#mobile").val();
            var reg= /^1[3|4|5|6|7|8|9]\d{9}$/;
            if(!reg.exec(mobile)){
                $.alert("手机号格式不正确！");
                throw SyntaxError();
            }
            var code=$("#validateNo").val();
            if($.trim(code) ==''){
                $.alert("验证码不能为空！");
                throw SyntaxError();
            }
            $.ajax({
                url: '/business/loginExtend/smsLogin',
                type: "POST",
                data: "validateNo="+code+"&mobile="+mobile,
                dataType: "json",
                beforeSend: function() {
                    $("#passButton").prop("disabled", true);
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
                    $("#passButton").prop("disabled", false);
                }
            });
        }
        function smsSubmit() {
            var $passwordLoginForm = $("#passwordLoginForm");
            var $captcha = $("#captcha");
            var username=$("#username").val();
            if($.trim(username) ==''){
                $.alert("用户名不能为空!");
                throw SyntaxError();
            }
            var password=$("#password").val();
            if($.trim(password) ==''){
                $.alert("密码不能为空!");
                throw SyntaxError();
            }
            var code=$("#captcha").val();
            if($.trim(code) ==''){
                $.alert("验证码不能为空!");
                throw SyntaxError();
            }
            $.ajax({
                url: $passwordLoginForm.attr("action"),
                type: "POST",
                data: $passwordLoginForm.serialize(),
                dataType: "json",
                beforeSend: function() {
                    $("#smsButton").prop("disabled", true);
                },
                success: function(data) {
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
                    $captcha.captchaImage("refresh", true);
                },
                complete: function() {
                    $("#smsButton").prop("disabled", false);
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

        function showPasswordForm(){
            $("#mobile").val("");
            $("#validateNo").val("");
            $("#passwordLoginForm").show();
            $("#smsLoginForm").hide();
        }

        function showSmsForm(){
            $("#username").val("");
            $("#password").val("");
            $("#passwordLoginForm").hide();
            $("#smsLoginForm").show();
        }
    </script>
</head>
<body id="bId">

<div>

<div id="logo">
    <img src="/newResources/business/images/firstPageImg/u5.png" alt="">
</div>
    <div class="alert alert-success" style="width: 200px;height: 48px;line-height:48px;position: fixed;top: 10%;left: 50%;display: none;text-align: center">
    </div>
<form  id="passwordLoginForm" action="${base}/business/login" method="post">
    <div id="loginText">
        <div class="z" style="margin-top: 10px;"><img src="/newResources/business/images/firstPageImg/u30.png" alt=""><input type="text" id="username" name="username" class="inp"  autocomplete="off" placeholder="请输入用户名" value="shopxx_zc" style="width: 245px"></div>
        <div class="z" style="margin-top: 10px"><img src="/newResources/business/images/firstPageImg/u51.png" alt=""><input type="password" id="password" name="password" class="inp"   placeholder="请输入密码" value="123456" style="width: 245px"></div>
        <div class="z" style="margin-top: 10px"><img src="/newResources/business/images/firstPageImg/yzm.png" ><input type="text" id="captcha" name="captcha" class="inp captcha"   maxlength="4" placeholder="${message("common.captcha.name")}" autocomplete="off"></div>
        <div class="text"><a href="${base}/password/forgot?type=business">忘记密码？</a><a href="javascript:void(0);" onclick="showSmsForm()" style="margin-left:53%;">短信登录></a></div>
        <div id="loginSubmit"><button type="button" onclick="smsSubmit()" id="smsButton" style="width: 301px;height: 49px;border-radius:5px;background:white;color:#1B9DD5; border: none;font-size: 16px;font-family: 'Arial Negreta', 'Arial Normal', 'Arial';font-weight: 700;">登录</button></div>
        <p>登录即表示你同意<a href="${base}/business/login/agreement?agreementType=servicepc">用户协议</a>和<a href="${base}/business/login/agreement?agreementType=privacypc">隐私条款</a></p>
    </div>
</form>
<form  id="smsLoginForm" action="${base}/business/loginExtend/smsLogin" style="display: none" method="post">
    <div id="loginText">

        <div class="z" style="margin-top: 10px;"><img src="/newResources/business/images/firstPageImg/u30.png" alt=""><input type="text" id="mobile" name="mobile" class="inp"  autocomplete="off" placeholder="请输入手机号" style="width: 245px"></div>
        <div class="z" style="margin-top: 10px"><img src="/newResources/business/images/firstPageImg/u51.png" alt=""><input type="text"id="validateNo" maxlength="6" name="validateNo" class="inp"   placeholder="验证码"><input type="button" value="获取验证码" id="phoneCode"  onclick="sendCode(this)"></div>
        <div class="text"><a href="${base}/password/forgot?type=business">忘记密码？</a><a href="javascript:void(0);" onclick="showPasswordForm()" style="margin-left:53%;">密码登录></a></div>
        <div id="loginSubmit"><input type="button" onclick="passwordSubmit()" id="passButton" value="登录" ></div>
        <p>登录即表示你同意<a href="${base}/business/login/agreement?agreementType=servicepc">用户协议</a>和<a href="${base}/business/login/agreement?agreementType=privacypc">隐私条款</a></p>
    </div>
</form>
</div>
</body>
</html>