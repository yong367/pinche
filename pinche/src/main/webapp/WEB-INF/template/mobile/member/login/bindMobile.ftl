<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-绑定手机</title>
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
	<script type="text/javascript">

    function bdBtn(){
        var $loginForm = $("#loginForm");
        var $isRememberUsername = $("#isRememberUsername");
        var username=$("#mobile").val();
        var reg= /^1[3|4|5|6|7|8|9]\d{9}$/;
        if(!reg.exec(username)){
            $.alert("手机号格式不正确！");
            throw SyntaxError();
        }
        var code=$("#validateNo").val();
        if($.trim(code) ==''){
            $.alert("验证码不能为空！");
            throw SyntaxError();
        }
        $.ajax({
            url: $loginForm.attr("action"),
            type: "POST",
            data: $loginForm.serialize(),
            dataType: "json",
            cache: false,
            beforeSend: function() {
                $("#bindBtn").prop("disabled", true);
            },
            success: function(data) {
                if ($isRememberUsername.prop("checked")) {
                    addCookie("memberUsername", $username.val(), {
                        expires: 7 * 24 * 60 * 60
                    });
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

            },
            complete: function() {
                $("#bindBtn").prop("disabled", false);
            }
        });
    }

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
        var uniqueId= $("#uniqueId").val();
        $.ajax({
            url: "/member/login/checkWxBindMobile?mobile="+mobile+"&uniqueId="+uniqueId,
            type: "POST",
            dataType: "json",
            beforeSend: function() {
                btn.disabled = true; //将按钮置为不可点击
            },
            success: function(data) {
                if(data.status =='success'){
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
                }else{
                    $.alert("当前手机号不可用，已经绑定微信");
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
            nums = 180; //重置时间
        }
    }
    </script>
</head>
<body style="background:linear-gradient(#E4E4E4,#F9F9F9);">

<div class="container" id="container" style="height: 100%;width: 100%">
    <div class="headerWarp">
        <div class="header" style="position: relative;width: 100%;height: 100%;display: flex;line-height:4.4rem;align-items: center;background: #22ACE8;">
            <img src="${base}/newResources/member/images/btnBack.png" style="position:absolute;width: 24px;height:24px;left:16px" onclick="javascript: history.back();">
            <div class="btn-back" style="margin: 0 auto;width: 70%;height: 100%;text-align:center;font-size: 16px;color: white;">绑定手机</div>
        </div>
    </div>
    <form id="loginForm" action="${base}/member/login/bingWxLogin" method="post">
        <input name="socialUserId" type="hidden" value="${socialUserId}">
        <input id="uniqueId" name="uniqueId" type="hidden" value="${uniqueId}">
    <div class="logo"><h2 style="color:red;line-height:4rem;">为了保障您的账户安全，请绑定手机号</h2></div>

        <div id="boxone" style="display: block;margin: 0 auto;width:85.3%;height: 80%;">
            [#if nickName?has_content]
                <div style="display: none">
                    <input type="hidden" id="nickName" name="nickName" value="${nickName}"/>
                </div>
            [/#if]
              [#if headImgUrl?has_content]
                <div style="display: none">
                    <input type="hidden" id="headImgUrl" name="headImgUrl" value="${headImgUrl}"/>
                </div>
              [/#if]
            <div style="display: flex;justify-content:space-between;width: 100%;height: 4.8rem;margin-top:28px;border:0;border-radius:5px;background:white;box-shadow:0px 0px 5px 0px rgba(206,206,206,1);">
                <div style="display: flex;align-items:center;width:4.0rem;height: 100%;">
                    <img src="${base}/newResources/member/images/login/u23.png" style="width: 4.0rem;height: 4.0rem">
                </div>
                <div style="width: 80%;height: 100%;">
                    <input type="number" id="mobile" name="mobile" style="width: 100%;height: 100%;font-size: 1.6rem;outline: none;border: none;background: none;"placeholder="&nbsp;请输入手机号">
                </div>
            </div>
            <div style="display: flex;justify-content:space-between;width: 100%;height: 4.8rem;margin-top:20px;border:0;border-radius:5px;background:white;box-shadow:0px 0px 5px 0px rgba(206,206,206,1);">
                <div style="display: flex;align-items:center;justify-content:center;width:4.0rem;height: 100%;">
                    <img src="${base}/newResources/member/images/login/yzm.png" style="width:3.4rem;height: 3.4rem">
                </div>
                <div style="display:flex;align-items:center;width: 80%;height: 100%;">
                    <input type="text" id="validateNo" name="validateNo"  style="width: 53%;height: 100%;outline: none;border: none;background: none;"placeholder="&nbsp;请输入验证码">
                    <input type="button" value="发送验证码" onclick="sendCode(this)" style="width: 45%;height: 4.0rem;font-size:1.4rem;color:white;font-family:ArialMT;border: none;outline: none;border-radius: 5px;background:rgba(29,171,233,1);">
                </div>
            </div>
            <div style="display: flex;justify-content:space-between;width: 100%;height: 4.8rem;margin-top:28px;border:0;border-radius:5px;background:#1DABE9;box-shadow:0px 0px 5px 0px rgba(206,206,206,1);">
                <div style="width: 100%;height: 100%;text-align: center">
                    <input type="button" id="bindBtn" value="立即绑定" onclick="bdBtn()" style="color: white;width: 100%;height: 100%;font-size: 1.6rem;outline: none;border: none;background: none;">
                </div>
            </div>
        </div>
	</form>

</div>
</body>
</html>