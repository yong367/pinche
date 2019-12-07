<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>确认参与</title>
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
                        location.href = $("#redirectUrl").val();
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
  /*  $(document).ready(function () {
       /!* var height =$('body')[0].clientHeight;
        $("#mobileCodeInput").css("top",height*1*0.311+"px");
        $("#mobileInput").css("top",height*0.22+"px");
        $("#mobileCode").css("top",height*0.31+"px");
        $("#loginButton").css("top",height*0.41+"px");
        $('body').height(height);
        $("#showDiv").height(height);*!/
    });*/
	</script>
</head>
<body style="display: flex">

[#--<div class="container" id="container" style="height: 100%;width: 100%">
    <form id="loginForm" action="${base}/member/login/saveTaskSmsLogin" method="post">
   --][#-- <div class="logo"><a href="javascript:void(0);"><img src="${base}/newResources/member/images/logo.png"" alt="爱帮伴" /></a></div>--][#--
    <div class="zhuceWarp">
    	<p id="textError"></p>
        <ul style="background-color: #e6e6e6">
            <li style="background-color: #fff;margin-top: 30px;">
                <span class="zhuceLeft">手机号码</span>
                <span class="spanCt"><input type="text" class="" id="mobile" name="mobile" placeholder="请输入手机号"/></span>
            </li>

            <li  style="background-color: #fff;margin-top: 30px;">
                <span class="zhuceLeft">验证码</span>
                <span class="spanCt"><input type="text" class="" id="validateNo" name="validateNo" placeholder="短信验证码"/></span>
                <input type="button" class="hqyzm" value="  获取验证码  " onclick="sendCode(this)" />
            </li>
              [#if shareCode?has_content]
                    <input type="hidden" id="shareCode" name="shareCode" value="${shareCode}"/>
              [/#if]
              [#if redirectUrl?has_content]
                    <input type="hidden" id="redirectUrl" name="redirectUrl" value="${redirectUrl}"/>
              [/#if]
        </ul>
    </div>

    <div class="zhuceBt" style="margin-top: 10px;">
        <button type="submit">确认参与</button>
    </div>
       <div style="margin-top: 60px;width: 96%;position: relative;height: 100px;text-align: center;">
<span style="
    width: 20%;
    position: absolute;
    bottom: 10px;
    left: 15%;
">技术支持</span><span style="
    width: 20%;
    height: 30%;
    position: absolute;
    bottom: 10px;
    left: 35%;
"><img src="/upload/image/tasklogo.png" /></span><span style="
    width: 100px;
    height: 100px;
    position: absolute;
    left: 65%;
    bottom: 10px;
"><img src="/newResources/member/images/gfwx.png" /> </span>
       </div>
	</form>
</div>--]

<div style="width: 100%;height:700px;position: relative" id="showDiv">
    <form id="loginForm" action="${base}/member/login/saveTaskSmsLogin" method="post">
    <img src="/upload/image/taskLoginBg.png" style="width: 100%;height: 100%;touch-action: none" onclick="return false"/>
    <span id="mobileInput" class="spanCt" style="
    position: absolute;
    top: 140px;
    left: 15%;
    width: 70%;
    line-height: 3rem;
    border: 1px solid #e6e6e6;
    border-radius: 0.5rem;
"><input type="text" class="" id="mobile" name="mobile" placeholder="请输入手机号" style="width: 100%;"/></span>
    <span id="mobileCode" class="spanCt" style="position: absolute;
    top: 200px;
    left: 15%;
    width: 70%;
    line-height: 3rem;
    border: 1px solid #e6e6e6;
    border-radius: 0.5rem;
"><input type="text" class="" id="validateNo" name="validateNo" placeholder="短信验证码" style="width: 100%;"/></span>
    <input id="mobileCodeInput" type="button" style="
    position: absolute;
    top: 200px;
    right: 15%;
    line-height: 3rem;
    background-color: #22ace8;
    border-radius:0.5rem;" class="hqyzm" value="  获取验证码  " onclick="sendCode(this)" />
    <input id="shareCode" name="shareCode" type="hidden" value="${shareCode}">
    <input id="redirectUrl" name="redirectUrl" type="hidden" value="${redirectUrl}">
    <button id="loginButton" type="submit" style="background-color: #3498db;
    position: absolute;
    top: 260px;
    left: 15%;
    width: 70%;
    line-height: 3rem;
    border-radius: 1rem;
     background-size: 100% 100%;
     color: white;
">确认参与</button>
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