<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-会员登录</title>
    <link href="${base}/newResources/member/css/mobilestyle.css" rel="stylesheet" type="text/css" />
    <link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
    <link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
	<script src="${base}/resources/mobile/member/js/jquery.js"></script>
	<script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/member/js/velocity.js"></script>
	<script src="${base}/resources/mobile/member/js/velocity.ui.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.validate.js"></script>
    <script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
    <script type="text/javascript" src="${base}/resources/statistic/browsestatistical.js"></script>
    <style>
        .alert-dark {
            background-color: #ffffff;
            color: black;
            border: 1px solid lightgrey;
            font-size: 15px;
        }
    </style>
	<script type="text/javascript">

    var clock = '';
    var nums = 180;
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
            url: "/member/login/sendLoginValidateNo/"+mobile,
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

    function smsSubmit(){
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
            url: '/member/login/smsLogin',
            type: "POST",
            data: "validateNo="+code+"&mobile="+mobile,
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

            },
            complete: function() {
                $("#smsButton").prop("disabled", false);
            }
        });
    }
    function passwordSubmit() {
        var $loginForm = $("#loginForm");
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
        $.ajax({
            url: $loginForm.attr("action"),
            type: "POST",
            data: $loginForm.serialize(),
            dataType: "json",
            beforeSend: function() {
                $("#putongButton").prop("disabled", true);
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
            },
            complete: function() {
                $("#putongButton").prop("disabled", false);
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
            nums = 180; //重置时间
        }
    }
    function showPutongForm(){
        $("#mobile").val("");
        $("#validateNo").val("");
        $("#loginForm").show();
        $("#smsloginForm").hide();
	}

    function showSmsForm(){
        $("#username").val("");
        $("#password").val("");
        $("#loginForm").hide();
        $("#smsloginForm").show();
    }

	</script>
    <style>
        *{
            padding: 0;
            margin: 0;
        }
        html,body{
            width: 100%;
            height: 100%;
            font-size: 62.5%;
        }
    </style>
</head>
<body style="background:linear-gradient(360deg,rgba(228,228,228,1) 0%,rgba(249,249,249,1) 100%);">
<div id="boxone" style="display: block;margin: 0 auto;width:85.3%;height: 80%;">
    <div style="margin:0 auto;padding-top:40px;width: 14.2rem;height: 5.0rem;">
        <img src="${base}/newResources/member/images/login/u5.png" alt="" style="width:100%;height: 60px">
    </div>
    <form id="smsloginForm" action="${base}/member/login/smsLogin" method="post" style="display: none;">
        <input name="socialUserId" type="hidden" value="${socialUserId}">
        <input name="uniqueId" type="hidden" value="${uniqueId}">
    <div style="display: flex;justify-content:space-between;width: 100%;height: 4.8rem;margin-top:60px;border:0;border-radius:5px;background:white;box-shadow:0px 0px 5px 0px rgba(206,206,206,1);">
        <div style="display: flex;align-items:center;width:4.0rem;height: 100%;">
            <img src="${base}/newResources/member/images/login/u23.png" alt="" style="width: 4.0rem;height: 4.0rem">
        </div>
        <div style="width: 80%;height: 100%;">
            <input type="number" id="mobile" name="mobile" style="width: 100%;height: 100%;font-size:1.6rem;outline: none;border: none;background: none;"placeholder="&nbsp;请输入手机号">
        </div>
    </div>
    <div style="display: flex;justify-content:space-between;width: 100%;height: 4.8rem;margin-top:20px;border:0;border-radius:5px;background:white;box-shadow:0px 0px 5px 0px rgba(206,206,206,1);">
        <div style="display: flex;align-items:center;justify-content:center;width:4.0rem;height: 100%;">
            <img src="${base}/newResources/member/images/login/yzm.png" alt="" style="width:3.4rem;height: 3.4rem">
        </div>
        <div style="display:flex;align-items:center;width: 80%;height: 100%;">
            <input type="text" id="validateNo" name="validateNo"  style="width: 53%;height: 100%;font-size:1.6rem;outline: none;border: none;background: none;"placeholder="&nbsp;请输入验证码">
            <input type="button" value="发送验证码" id="codeButton" onclick="sendCode(this)" style="width: 45%;height: 4.0rem;font-size:1.4rem;color:white;font-family:ArialMT;border: none;outline: none;border-radius: 5px;background:rgba(29,171,233,1);">
        </div>
    </div>
    <div style="display: flex;justify-content:space-between;width: 100%;height: 4.8rem;margin-top:20px;border:0;border-radius:5px;  box-shadow:0px 0px 5px 0px rgba(206,206,206,1);">
        <input type="button" value="登录" onclick="smsSubmit()" id="smsButton" style="width: 100%;height: 100%;color:white;font-family:ArialMT;font-size:1.6rem;border: none;outline: none;border-radius: 5px;background:rgba(29,171,233,1);">
    </div>
    <div style="width: 100%;height: 2.2rem;text-align: right;margin-top: 10px">
        <a id="btnone" href="javascript:void(0);" onclick="showPutongForm()" style="text-decoration:none;color:rgba(153,153,153,1);font-size:1.4rem;">账号密码登录></a>
    </div>
    </form>

    <form id="loginForm" action="${base}/member/login" method="post"">
        <input name="socialUserId" type="hidden" value="${socialUserId}">
        <input name="uniqueId" type="hidden" value="${uniqueId}">
        <p id="textError"></p>
        <div style="display: flex;justify-content:space-between;width: 100%;height: 4.8rem;margin-top:60px;border:0;border-radius:5px;background:white;box-shadow:0px 0px 5px 0px rgba(206,206,206,1);">
            <div style="display: flex;align-items:center;width:4.0rem;height: 100%;">
                <img src="${base}/newResources/member/images/login/u23.png" alt="" style="width: 4.0rem;height: 4.0rem">
            </div>
            <div style="width: 80%;height: 100%;">
                <input type="number" id="username" name="username" value="15111111000" style="width: 100%;height: 100%;font-size:1.6rem;outline: none;border: none;background: none;"placeholder="&nbsp;请输入手机号">
            </div>
        </div>
        <div style="display: flex;justify-content:space-between;width: 100%;height: 4.8rem;margin-top:20px;border:0;border-radius:5px;background:white;box-shadow:0px 0px 5px 0px rgba(206,206,206,1);">
            <div style="display: flex;align-items:center;justify-content:center;width:4rem;height: 100%;">
                <img src="${base}/newResources/member/images/login/u24.png" alt="" style="width:3.4rem;height: 3.4rem">
            </div>
            <div style="display:flex;align-items:center;width: 80%;height: 100%;">
                <input type="password" id="password" name="password" value="123456" style="width: 90%;height: 100%;font-size:1.6rem;outline: none;border: none;background: none;"placeholder="6-20位字母、数字和符号组成">
            </div>
        </div>
        <div style="display: flex;justify-content:space-between;width: 100%;height: 4.8rem;margin-top:20px;border:0;border-radius:5px;  box-shadow:0px 0px 5px 0px rgba(206,206,206,1);">
            <input type="button" value="登录" id="putongButton" onclick="passwordSubmit()" style="width: 100%;height: 100%;color:white;font-family:ArialMT;font-size:1.6rem;border: none;outline: none;border-radius: 5px;background:rgba(29,171,233,1);">
        </div>
        <div  style="display: flex;justify-content:space-between;width: 100%;height: 2.2rem;margin-top: 10px">
            <a href="${base}/password/forgot?type=member" style="text-decoration:none;color:rgba(153,153,153,1);font-size:1.5rem;">忘记密码</a>
            <a href="javascript:void(0);" style="text-decoration:none;color:rgba(153,153,153,1);font-size:1.5rem;" onclick="showSmsForm()">短信快捷登录></a>
        </div>
    </form>

    <div style="display: flex;justify-content: space-around;align-items: center;margin-top: 16px;">
        <hr style="background-color:#BEBEBE;height: 1px;width:25%;border: none;"/>
        <span style="font-size:1.6rem;font-weight:400;color:rgba(124,124,124,1);">快速登录</span>
        <hr style="background-color:#BEBEBE;height: 1px;width:25%;border: none;"/>
    </div>
    <div class="otherLogin">
	[#if loginPlugins?has_content && !socialUserId?has_content && !uniqueId?has_content]
        <ul>
			[#list loginPlugins as loginPlugin]
                <li>
                    <a href="${base}/social_user_login?loginPluginId=${loginPlugin.id}"[#if loginPlugin.description??] title="${loginPlugin.description}"[/#if]>
					[#if loginPlugin.logo?has_content]
                        <img src="${loginPlugin.logo}" alt="${loginPlugin.loginMethodName}">
                    [#else]
                        ${loginPlugin.loginMethodName}
                    [/#if]
                    </a>
                </li>
            [/#list]
        </ul>
    [/#if]
    </div>

</div>
<div style="width:100%;text-align: center;margin-bottom: 3rem;font-size: 1.6rem;color: #999999"> 点击查看 <a href="${base}/member/login/agreement?agreementType=agreement" style="text-decoration: underline;">用户服务协议</a> 与 <a href="${base}/member/login/agreement?agreementType=privacy" style="text-decoration: underline;">隐私政策</a></div>
[#--数据监控--]
<script>
    var _mtac = {};
    (function() {
        var mta = document.createElement("script");
        mta.src = "//pingjs.qq.com/h5/stats.js?v2.0.4";
        mta.setAttribute("name", "MTAH5");
        mta.setAttribute("sid", "500660889");

        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(mta, s);
    })();
</script>

</body>
</html>