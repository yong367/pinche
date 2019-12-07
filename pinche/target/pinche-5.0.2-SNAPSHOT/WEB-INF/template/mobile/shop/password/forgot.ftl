<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-忘记密码</title>
	<link href="${base}/favicon.ico" rel="icon">
    <link href="${base}/newResources/member/css/mobilestyle.css" rel="stylesheet" type="text/css" />
	<link href="${base}/resources/mobile/shop/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
	<script src="${base}/resources/mobile/shop/js/jquery.js"></script>
	<script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/shop/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/shop/js/underscore.js"></script>
	<script src="${base}/resources/mobile/shop/js/common.js"></script>
	<script type="text/javascript">
    [#--$().ready(function() {--]
        [#--var $passwordForm = $("#passwordForm");--]
        [#--var $submit = $("input:submit");--]

        [#--// 表单验证--]
        [#--$passwordForm.validate({--]
            [#--rules: {--]
                [#--username: {--]
                    [#--required: true,--]
                    [#--pattern: /^1[3|4|5|6|7|8|9]\d{9}$/--]
                [#--},--]
                [#--validateNo: "required"--]
            [#--},--]
            [#--messages:{--]
                [#--username: {--]
                    [#--required:"手机号不能为空！",--]
                    [#--pattern: "请输入正确的手机号！"--]
                [#--},--]
                [#--validateNo:{--]
                    [#--required:"验证码不能为空！"--]
                [#--}--]
            [#--},--]
            [#--submitHandler: function(form) {--]
                [#--$.ajax({--]
                    [#--url: $passwordForm.attr("action"),--]
                    [#--type: "POST",--]
                    [#--data: $passwordForm.serialize(),--]
                    [#--dataType: "json",--]
                    [#--cache: false,--]
                    [#--beforeSend: function() {--]
                        [#--$submit.prop("disabled", true);--]
                    [#--},--]
                    [#--success: function(data) {--]
                        [#--location.href = "${base}/password/reset?type="+data.type+"&key="+data.safeKey+"&username="+data.username;--]
                    [#--},--]
                    [#--error: function(xhr, textStatus, errorThrown) {--]
                        [#--setTimeout(function() {--]
                            [#--$submit.prop("disabled", false);--]
                        [#--}, 3000);--]
                    [#--}--]
                [#--});--]
            [#--}--]
        [#--});--]

    [#--});--]
    function editPwd(){
        var $passwordForm = $("#passwordForm");
        var username=$("#username").val();
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
            url: $passwordForm.attr("action"),
            type: "POST",
            data: $passwordForm.serialize(),
            dataType: "json",
            cache: false,
            beforeSend: function() {
                $("#pwdBtn").prop("disabled", true);
            },
            success: function(data) {
                location.href = "${base}/password/reset?type="+data.type+"&key="+data.safeKey+"&username="+data.username;
            },
            error: function(xhr, textStatus, errorThrown) {

            },
            complete: function() {
                $("#pwdBtn").prop("disabled", false);
            }
        });
    }

    var clock = '';
    var nums = 60;
    var btn;
    function sendValidateNo(thisBtn){
        btn = thisBtn;
        var mobile=$("#username").val();
        var reg= /^1[3|4|5|6|7|8|9]\d{9}$/;
        if(!reg.exec(mobile)){
            $.alert("手机号格式不正确！");
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
                    $.alert("验证码发送成功！请注意查收");
                    btn.value = nums+'秒后可重新获取';
                    clock = setInterval(doLoop, 1000); //一秒执行一次
                }else if(data.status == "error"){
                    $.alert(data.msg);
                    btn.disabled = false;
                }else{
                    $.alert("该用户不存在，即将跳转到注册页面！");
                    setTimeout(function() {
                        location.href = "${base}/member/register";
                    }, 3000);
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
    <style>
        *{
            padding: 0;
            margin: 0;
        }
        html,body{
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body style="background:linear-gradient(#E4E4E4,#F9F9F9);">
<div class="container" id="container" style="height: 100%;width: 100%">
    <div class="headerWarp">
            <div class="header" style="position: relative;width: 100%;height: 100%;display: flex;line-height:4.4rem;align-items: center;background: #22ACE8;">
                <img src="${base}/newResources/member/images/btnBack.png" style="position:absolute;width: 24px;height:24px;left:16px" onclick="javascript: history.back();">
                <div class="btn-back" style="margin: 0 auto;width: 70%;height: 100%;text-align:center;font-size: 16px;color: white;">验证修改</div>
            </div>
    </div>
    <div id="boxone" style="display: block;margin: 0 auto;width:85.3%;height: 80%;">
    <form action="forgot" method="post" id="passwordForm">
        <input type="hidden" name="type" value="${type}" />

            <div style="display: flex;justify-content:space-between;width: 100%;height: 4.8rem;margin-top:28px;border:0;border-radius:5px;background:white;box-shadow:0px 0px 5px 0px rgba(206,206,206,1);">
                <div style="display: flex;align-items:center;width:4.0rem;height: 100%;">
                    <img src="${base}/newResources/member/images/login/u23.png" alt="" style="width: 4.0rem;height: 4.0rem">
                </div>
                <div style="width: 80%;height: 100%;">
                    <input type="number" id="username" name="username" style="width: 100%;height: 100%;font-size: 1.6rem;outline: none;border: none;background: none;"placeholder="&nbsp;请输入手机号">
                </div>
            </div>
            <div style="display: flex;justify-content:space-between;width: 100%;height: 4.8rem;margin-top:20px;border:0;border-radius:5px;background:white;box-shadow:0px 0px 5px 0px rgba(206,206,206,1);">
                <div style="display: flex;align-items:center;justify-content:center;width:4.0rem;height: 100%;">
                    <img src="${base}/newResources/member/images/login/yzm.png" alt="" style="width:3.4rem;height: 3.4rem">
                </div>
                <div style="display:flex;align-items:center;width: 80%;height: 100%;">
                    <input type="text" id="validateNo" name="validateNo" style="width: 53%;height: 100%;outline: none;border: none;background: none;"placeholder="&nbsp;请输入短信验证码">
                    <input type="button" value="发送验证码" onclick="sendValidateNo(this)" style="width: 45%;height: 4.0rem;font-size:1.4rem;color:white;font-family:ArialMT;border: none;outline: none;border-radius: 5px;background:rgba(29,171,233,1);">
                </div>
            </div>
            <div style="display: flex;justify-content:space-between;width: 100%;height: 4.8rem;margin-top:28px;border:0;border-radius:5px;background:#1DABE9;box-shadow:0px 0px 5px 0px rgba(206,206,206,1);">
                <div style="width: 100%;height: 100%;text-align: center">
                    <input type="button" id="pwdBtn" value="确认" onclick="editPwd()" style="color: white;width: 100%;height: 100%;font-size: 1.6rem;outline: none;border: none;background: none;">
                </div>
            </div>


	</form>
    </div>
    </div>
</body>
</html>