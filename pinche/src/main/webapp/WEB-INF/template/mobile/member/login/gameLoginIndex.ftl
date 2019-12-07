<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>爱帮伴-短信登录</title>
    <link href="${base}/newResources/member/css/mobilestyle.css" rel="stylesheet" type="text/css" />
    <link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
    <link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
    <script src="${base}/resources/mobile/member/js/jquery.js"></script>
    <script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
    <script src="${base}/resources/mobile/member/js/velocity.js"></script>
    <script src="${base}/resources/mobile/member/js/velocity.ui.js"></script>
    <script src="${base}/resources/mobile/member/js/jquery.validate.js"></script>
    <script type="text/javascript" src="${base}/resources/mobile/member/js/jquery.form.js"></script>
    <script src="${base}/resources/mobile/member/js/underscore.js"></script>
    <script src="${base}/resources/mobile/member/js/common.js"></script>
    <script type="text/javascript" src="${base}/resources/statistic/browsestatistical.js"></script>
    <script type="text/javascript">
        $().ready(function() {

            var $loginForm = $("#loginForm");
            var $input = $("input");
            var $username = $("#username");
            var $password = $("#password");

            var $isRememberUsername = $("#isRememberUsername");
            var $submit = $("button:submit");
            var $footer = $("footer");
            // 表单验证、记住用户名
            $loginForm.validate(
                    {	rules: {
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
                        },errorPlacement:function(error,element){
                            $("#textError").html(error);
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
                                    if(data.status === 'success'){
                                        location.href = data.redirectUrl;
                                    }else{
                                        $.alert(result.msg);
                                    }

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
<body>

<div class="container" id="container" style="height: 100%;width: 100%">
    <form id="loginForm" action="${base}/member/login/saveGameLogin" method="post">
        <div class="logo"><a href="javascript:void(0);"><img src="${base}/newResources/member/images/logo.png"" alt="爱帮伴" /></a></div>
        <div class="zhuceWarp">
            <p id="textError"></p>
            <ul>
                <li>
                    <span class="zhuceLeft">手机号码</span>
                    <span class="spanCt"><input type="text" class="" id="mobile" name="mobile" placeholder="请输入手机号"/></span>
                </li>

                <li>
                    <span class="zhuceLeft">验证码</span>
                    <span class="spanCt"><input type="text" class="" id="validateNo" name="validateNo" placeholder="短信验证码"/></span>
                    <input type="button" class="hqyzm" value="获取验证码" onclick="sendCode(this)" />
                </li>
            </ul>
        </div>
        <input type="hidden" id="gamePlateEnum" name="gamePlateEnum" value="${gamePlateEnum}"/>
  [#if shareCode?has_content]
                    <input type="hidden" id="shareCode" name="shareCode" value="${shareCode}"/>
  [/#if]
        <div class="zhuceBt">
            <button type="submit">立即登录</button>
        </div>
    </form>
</div>
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