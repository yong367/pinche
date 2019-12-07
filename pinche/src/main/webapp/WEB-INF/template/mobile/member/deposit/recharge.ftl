<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-我要充值</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/profile.css" rel="stylesheet">
    <link href="${base}/newResources/member/css/mobilestyle.css" rel="stylesheet" type="text/css" />
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/member/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/member/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/member/js/jquery.js"></script>
    <script src="${base}/resources/mobile/member/js/jquery.form.js"></script>
	<script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
    <script src="${base}/resources/mobile/shop/js/jquery.spinner.js"></script>
	<script src="${base}/resources/mobile/member/js/velocity.js"></script>
	<script src="${base}/resources/mobile/member/js/velocity.ui.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
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
        body div{
            background:white;

        }
        #box{
            width: 100%;
            background: #E7E7EF;
        }
        #box ul{
            width: 100%;
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;

        }
        #box ul li{
            width: 40%;
            height: 40px;
            list-style: none;
            font-size: 14px;
            background: white;
            border-radius: 5px;
            margin-top: 16px;

        }
        #box ul li div{
            width: 100%;
            height: 100%;
            border-radius: 5px;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
        }
        #box ul li img{
            width: 32px;
            height: 32px;
        }
        .active{
            border: 1px solid #52BEED;
        }
        input::-webkit-input-placeholder {
            color:black;
        }
    </style>
	<script type="text/javascript">
        var dingshiqi;
        var oddTime=180;
        var repetFlag=false;
		$().ready(function() {

            var $rechargeForm = $("#rechargeForm");
            var $paymentPluginId = $("#paymentPluginId");
            var $rechargeAmount = $("#rechargeAmount");
            var $feeItem = $("#feeItem");
            var $fee = $("#fee");
            var $paymentPluginItem = $("#paymentPlugin div.list-group-item");

            // 充值金额
            $rechargeAmount.on("input propertychange change", function (event) {
                if (event.type != "propertychange" || event.originalEvent.propertyName == "value") {
                    calculateFee();
                }
            });

            // 支付插件
            $paymentPluginItem.click(function () {
                var $element = $(this);
                $element.addClass("active").siblings().removeClass("active");
                var paymentPluginId = $element.data("payment-plugin-id");
                $paymentPluginId.val(paymentPluginId);
                calculateFee();
            });

            // 计算支付手续费
            var calculateFee = _.debounce(function () {
                if ($rechargeForm.valid()) {
                    $.ajax({
                        url: "calculate_fee",
                        type: "POST",
                        data: {
                            paymentPluginId: $paymentPluginId.val(),
                            rechargeAmount: $rechargeAmount.val()
                        },
                        dataType: "json",
                        success: function (data) {
                            if (data.fee > 0) {
                                $fee.text(currency(data.fee, true));
                                if ($feeItem.is(":hidden")) {
                                    $feeItem.velocity("slideDown");
                                }
                            } else {
                                if ($feeItem.is(":visible")) {
                                    $feeItem.velocity("slideUp");
                                }
                            }
                        }
                    });
                }
            }, 200);

            // 检查余额
            setInterval(function () {
                $.ajax({
                    url: "check_balance",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        if (data.balance > ${currentUser.balance}) {
                            location.href = "log";
                        }
                    }
                });
            }, 10000);

            // 表单验证
            $rechargeForm.validate({
                rules: {
                    "paymentItemList[0].amount": {
                        required: true,
                        positive: true,
                        decimal: {
                            integer: 7,
                            fraction: ${setting.priceScale}
                        }
                    }
                },
                submitHandler: function (form) {
                    form.submit();
                }
            });

            var $spinner = $("div.spinner");

            // 数量
            $spinner.spinner({
                min: 1,
                max: 10000
            });

        });

        // 订单提交
        function payment() {
            var rechargeAmount = $("#rechargeAmount").val();
            if(rechargeAmount =='' ){
                $.alert("充值金额不能为空！");
                throw SyntaxError();
            }
            var url="";
            $.ajax({
                url: "${base}/payment",
                type: "POST",
                data: $("#rechargeForm").serialize(),
                dataType: "json",
                async:false,
                beforeSend: function() {
                    $("#paymentButton").attr("disabled", true);
                    return;
                },
                success: function(data) {
                    $("#paymentModal").modal();
                    url=data.url;
                },
                complete: function() {
                    $("#paymentButton").attr("disabled", false);
                }
            });
            window.open(url,"_blank");
        }

		function selectPayType(type){
		    if(type == 'cash'){
                $("#rechargeForm").show();
                $("#pointRechargeForm").hide();
                $("#unicomRechargeForm").hide();
                $("#paymentPluginId").val("weixinPublicPaymentPlugin");
			}
            if(type == 'alipay'){
                $("#rechargeForm").show();
                $("#pointRechargeForm").hide();
                $("#unicomRechargeForm").hide();
                $("#paymentPluginId").val("alipayDirectPaymentPlugin");
            }
            if(type == 'point'){
                $("#pointRechargeForm").show();
                $("#unicomRechargeForm").hide();
                $("#rechargeForm").hide();
            }
            if(type =='unicom'){
                $("#unicomRechargeForm").show();
                $("#pointRechargeForm").hide();
                $("#rechargeForm").hide();
            }
		}
		
		function unicomrecharge(btn) {
            var mobileId=$.trim($("#unicommobileId").val());
            var unicomAmount = $("#unicomAmount").val();
            var reg= /^1[3|4|5|6|7|8|9]\d{9}$/;
            if(!reg.exec(mobileId)){
                $.alert("手机号格式不正确！");
                throw SyntaxError();
            }
            if(unicomAmount =='' ){
                $.alert("充值金额不能为空！");
                throw SyntaxError();
            }
            var unicomcode=$.trim($("#unicomcode").val());
            if(unicomcode ==''){
                $.alert("联通动态码不能为空！");
                throw SyntaxError();
            }
            $(btn).prop("disabled","disabled");
            $(btn).css("background-color","#eee");//#2cb6f1
            if(repetFlag){
                throw SyntaxError();
            }else{
                repetFlag=true;
            }
            $("#unicomRechargeForm").ajaxSubmit({
                dataType: "json",
                success: function (data) {
                    repetFlag=false;
                    if (data) {
                        if (data.status == "success") {
                           $.alert("充值成功！");
                            window.setTimeout(function () {
                                window.location.href='/member/index'
                            },1500);

                        } else {
                            $.alert(data.msg);
                            $(btn).removeAttr("disabled");
                            $(btn).css("background-color","#2cb6f1");
                        }
                    } else {
                        $.alert("充值发生错误，请稍后再试！");
                        $(btn).removeAttr("disabled");
                        $(btn).css("background-color","#2cb6f1");
                    }
                },
                error: function () {
                    repetFlag=false;
                    $.alert("充值发生错误，请稍后再试！");
                    $(btn).removeAttr("disabled");
                    $(btn).css("background-color","#2cb6f1");
                }
            });
        }
            function recharge(btn){
		    var mobileId=$.trim($("#mobileId").val());
		    var pointAmount = $("#pointAmount").val();
            if(mobileId =='' ){
                $.alert("手机号码不能为空！");
                return;
            }
            if(pointAmount =='' ){
                $.alert("充值金额不能为空！");
                return;
            }
				$(btn).prop("disabled","disabled");
                $("#pointRechargeForm").ajaxSubmit({
                    dataType: "json",
                    success: function (data) {
                        if (data) {
                            if (data.status == "success") {
                                /*$.alert("充值操作完成！静待积分到账。");*/
                                $("#rechargeMain").hide();
                                $("#qrImage").attr("src","/resources/mobile/member/images/rongxu/"+data.amtQr+".png");
                                $("#rongxuMian").show();
                                startdinshi();
                            } else {
                                $(btn).removeAttr("disabled");
                                $.alert(data.msg);
                            }
                        } else {
                            $.alert("充值发生错误，请稍后再试！");
                            $(btn).removeAttr("disabled");
                        }
                    },
                    error: function () {
                        alert("充值发生错误，请稍后再试！");
                        $(btn).removeAttr("disabled");
                    }
                });
            }

            function startdinshi(){
            dingshiqi = setInterval("dingshi()",1000);
            }
            function dingshi() {
            oddTime--;
            if(oddTime <=0){
                window.clearInterval(dingshiqi);
                alert("当前操作时间已到！系统即将跳转到个人中心页面");
                window.location.href="/member/index";
            }else{
                $("#oddTime").html(oddTime);
            }
            }

	</script>
    <script>
        window.onload=function(){
            var cztxt=document.getElementById("cztxt");
            var libtn=document.getElementsByTagName("li");
            var f=document.getElementsByName("f");
            var wxzf=document.getElementById("wxzf");
            var imgdiv=document.getElementById("imgdiv");
            var ydbbox=document.getElementById("ydbbox");
            var ltbbox=document.getElementById("ltbbox");
            for (var i = 0; i < f.length; i++) {
               f[0].className="active";
                f[i].index = i;
                f[0].onclick=function(){
                    wxzf.style.display="block";
                    ydbbox.style.display="none";
                    ltbbox.style.display="none";
                    imgdiv.style.display="none";
                    this.className="active";
                    f[1].className="";
                    f[2].className="";
                    f[3].className="";
                    f[4].className="";
                    f[5].className="";
                    f[6].className="";
                    return;
                }
                f[1].onclick=function(){
                    wxzf.style.display="block";
                    ydbbox.style.display="none";
                    ltbbox.style.display="none";
                    imgdiv.style.display="none";
                    this.className="active";
                    f[0].className="";
                    f[2].className="";
                    f[3].className="";
                    f[4].className="";
                    f[5].className="";
                    f[6].className="";
                    return;
                }
                f[2].onclick=function(){
                    wxzf.style.display="none";
                    ydbbox.style.display="block";
                    ltbbox.style.display="none";
                    imgdiv.style.display="none";
                    this.className="active";
                    f[0].className="";
                    f[1].className="";
                    f[3].className="";
                    f[4].className="";
                    f[5].className="";
                    f[6].className="";
                    return;
                }
                f[3].onclick=function(){
                    this.parentNode.style.display="none"
                    libtn[4].style.display="block";
                    libtn[5].style.display="block";
                    libtn[6].style.display="block";
                    imgdiv.style.display="none";
                    f[0].className="";
                    f[1].className="";
                    f[2].className="";
                    f[4].className="";
                    f[5].className="";
                    f[6].className="";
                    return;
                }
                f[4].onclick=function(){
                    wxzf.style.display="none";
                    ydbbox.style.display="none"
                    ltbbox.style.display="block"
                    imgdiv.style.display="none";
                    this.className="active";
                    f[0].className="";
                    f[1].className="";
                    f[2].className="";
                    f[3].className="";
                    f[5].className="";
                    f[6].className="";
                    return;
                }
                f[5].onclick=function(){
                    wxzf.style.display="none";
                    ydbbox.style.display="none";
                    ltbbox.style.display="none";
                    imgdiv.style.display="block";
                    this.className="active";
                    f[0].className="";
                    f[1].className="";
                    f[2].className="";
                    f[3].className="";
                    f[4].className="";
                    f[6].className="";
                    return;
                }
                f[6].onclick=function(){
                    this.parentNode.style.display="none";
                    libtn[3].style.display="block";
                    libtn[4].style.display="none";
                    libtn[5].style.display="none";
                    return;
                }

            }
        }
    </script>
</head>
<body style="background: #E7E7EF;">
<div class="headerWarp" style="height: 3.4rem;">
    <div class="header" style="position: relative;width: 100%;height: 100%;display: flex;line-height:3.4rem;align-items: center;background:linear-gradient(126deg,rgba(150,100,111,1) 0%,rgba(107,107,138,1) 34%,rgba(217,124,117,1) 100%);">
        <img src="${base}/newResources/member/images/btnBack.png" style="position:absolute;width: 15px;height:16px;left:10px" onclick="javascript: history.back();">
        <div class="btn-back" style="margin: 0 auto;width: 70%;height: 100%;text-align:center;font-size: 16px;color: white;background:none;">
            我要充值
        </div>
    </div>
</div>
<main id="rongxuMian" style="display: none">
    <div class="list-group list-group-flat">
        <div class="list-group-item">
            <div class="list-group-item">

                <div class="form-group" style="text-align: center;">
                    <div style="height: 150px;width: 150px;margin: auto">
                        <img src="/resources/mobile/member/images/rongxu/5.png" id="qrImage" style="width: 100%;height: 100%"/>
                    </div>
                    <div style="font-size:12px;text-align: left;padding-top:10px;text-align: center" id="dingshi">
                        当前剩余兑换时间：<span id="oddTime">180</span>秒
                    </div>
                    <div style="font-size:12px;text-align: left;padding-top:10px;">
                        2步操作完成充值兑换：</br>
                        ①长按识别上方二维码进入短信发送界面，直接发送该短信；</br>
                        ②收到第一条短信后直接将该短信中的数字作为内容回复；</br>
                    </div>
                    <div style="font-size:12px;font-weight: bold;color: red;padding-top: 10px;text-align: left">温馨提示：</br>
                        ①请在3分钟之内完成扫码兑换，超时充值失败。一般情况下3分钟之内充值到账，如遇运营商系统延迟，移动积分兑换充值可能产生影响。充值到账时间可能延迟到5分钟以上，请耐心等待，给您造成的不便尽请谅解。
                    </div>
                </div>
            </div>

        </div>

        <div id="feeItem" class="fee-item list-group-item small">
        ${message("member.memberDeposit.fee")}:
            <strong id="fee"></strong>
        </div>
        <div class="list-group-item small"><img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${message("member.memberDeposit.balance")}: ${currency(currentUser.balance, false)}</div>
        <div class="text-center">
            <button class="btn btn-primary" type="button" >已发送短信</button>
            <a class="btn btn-default" href="${base}/member/index" style="margin: 1px;">${message("member.common.back")}</a>
        </div>
    </div>
</main>
<main id="rechargeMain">
<div id="box" style="opacity: 1;">
    <ul>
        <#--<input type="hidden" id="cash" name="cash" value="">-->
        <li onclick="selectPayType('cash')"><div id="wx" name="f" style="width: 100%;height: 100%;"><img src="${base}/newResources/member/images/balance/u358.png" alt="">&nbsp;微信钱包</div></li>
        <li onclick="selectPayType('alipay')"><div name="f"><img src="${base}/newResources/member/images/balance/u361.png" alt="">&nbsp;支付宝钱包</div></li>
        <li onclick="selectPayType('point')"><div name="f"><img src="${base}/newResources/member/images/balance/u702.png" alt="">&nbsp;移动积分</div></li>
        <li><div name="f"><img src="${base}/newResources/member/images/balance/u0317.png" alt="" style="transform: rotate(180deg)">&nbsp;更多支付...</div></li>
        <li onclick="selectPayType('unicom')" style="display: none"><div name="f"><img src="${base}/newResources/member/images/balance/u822.png" alt="">&nbsp;联通积分</div></li>
        <li onclick="selectPayType('point')" style="display: none"><div name="f"><img src="${base}/newResources/member/images/balance/u1917.png" alt="">&nbsp;电信积分</div></li>
        <li style="display: none;" ><div name="f"><img src="${base}/newResources/member/images/balance/u0317.png" alt="">&nbsp;收起</div></li>
    </ul>
</div>
<!--充值兑伴儿-->
<div style="display:flex;width: 100%;height: 40px;font-size:14px;align-items:center;margin-top: 16px;border-bottom: 1px solid #EEEEEE"><p style="margin-left: 20px;color:#999999;">充值兑伴儿</p></div>
<!--输入金额-->
<div id="wxzf" >
    <div style="display: flex;justify-content: space-around;align-items: center;width: 100%;height: 60px;border-bottom: 1px solid #EEEEEE">
        <form id="rechargeForm" action="${base}/payment" method="post" target="_blank" style="width: 100%;height: 60px;">
            <div style="display: flex;justify-content: space-around;align-items: center;width: 100%;height: 60px;border-bottom: 1px solid #EEEEEE">
            <input name="paymentItemList[0].type" type="hidden" value="DEPOSIT_RECHARGE">
            <input id="paymentPluginId" name="paymentPluginId" type="hidden" value="weixinPublicPaymentPlugin">
        <span style="font-size: 30px;color: #333333;"><img src="${base}/newResources/member/images/balance/u371.png" alt="" style="width: 40px;height: 34px;"></span>
        <input id="rechargeAmount" name="paymentItemList[0].amount" type="number" value="" placeholder="请输入金额" style="width:210px;height: 40px;font-size: 18px;font-weight: 300;border: none;outline: none;">
        <div style="width: 5%;"></div>
            </div>
            <div style="width: 100%;height:45px;display: flex;margin-top:16px;justify-content: space-around;align-items:center;background: #E7E7EF;">
                <button class="btn btn-primary" type="button" id="paymentButton" onclick="payment()" style="width:50%;height: 100%;background:linear-gradient(297deg,rgba(147,114,133,1) 0%,rgba(148,114,132,1) 100%);
box-shadow:0px 6px 10px 0px rgba(206,206,206,1);border: 0;color:white;border-radius: 25px;outline: none;font-size: 20px">立即充值</button>
            </div>
        </form>
    </div>
</div>
<!--移动积分-->
<div id="ydbbox" style="display: none;">
    <!--输入手机号-->
    <form id="pointRechargeForm" action="${base}/member/recharge/saveRecharge" method="post">
    <div  style="display: flex;justify-content: space-around;align-items: center;width: 100%;height: 60px;border-bottom: 1px solid #EEEEEE">
        <span style="font-size: 30px;color: #333333;"><img src="${base}/newResources/member/images/balance/uphone.png" alt="" style="width: 40px;height:34px;"></span>
        <input type="number" name="mobile" id="mobileId" value="" placeholder="请输入移动手机号" style="width:210px;height: 40px;font-size: 18px;font-weight: 300;border: none;outline: none;">
        <div style="width: 5%;"></div>
    </div>

    <!--选择金额-->
    <div id="yddiv" style="display: flex;justify-content: space-around;align-items: center;width: 100%;height: 60px;border-bottom: 1px solid #EEEEEE">
        <span style="font-size: 30px;color: #333333;"><img src="${base}/newResources/member/images/balance/u371.png" alt="" style="width: 40px;height: 34px;"></span>
        <select name="amount" id="pointAmount" style="width:210px;height: 40px;background: none;border: 0;outline: none;color: black;font-size: 18px">
            <option value="">请选择金额</option>
           <option value="1">1</option>
            <option value="3">3</option>
            <option value="6">6</option>
            <option value="7">7</option>
            <option value="12">12</option>
            <option value="20">20</option>
            <option value="40">40</option>
            <option value="75">75</option>
        </select>
        <div style="width: 5%;height: 100%;"></div>
    </div>
        <div style="width: 100%;height: 45px;display: flex;margin-top:16px;justify-content: space-around;align-items:center;background: #E7E7EF;">
            <button class="btn btn-primary" type="button" id="paymentButton" onclick="recharge(this)" style="width:50%;height: 100%;background:linear-gradient(297deg,rgba(147,114,133,1) 0%,rgba(148,114,132,1) 100%);
box-shadow:0px 6px 10px 0px rgba(206,206,206,1);border: 0;color:white;border-radius: 25px;outline: none;font-size: 20px">立即充值</button>
        </div>
    </form>
</div>
<!--联通积分-->
<div id="ltbbox" style="display:none;">
    <!--输入手机号-->
    <form id="unicomRechargeForm" action="${base}/member/recharge/saveUnicomRecharge" method="post" >
    <div  style="display: flex;justify-content: space-around;align-items: center;width: 100%;height: 60px;border-bottom: 1px solid #EEEEEE">
        <span style="font-size: 30px;color: #333333;"><img src="${base}/newResources/member/images/balance/uphone.png" alt="" style="width: 40px;height:34px;"></span>
        <input type="number" name="mobile" id="unicommobileId" value="" placeholder="请输入联通手机号" style="width:210px;height: 40px;font-size: 18px;font-weight: 300;border: none;outline: none;">
        <div style="width: 5%;"></div>
    </div>


    <!--选择金额-->
    <div id="yddiv" style="display: flex;justify-content: space-around;align-items: center;width: 100%;height: 60px;border-bottom: 1px solid #EEEEEE">
        <span style="font-size: 30px;color: #333333;"><img src="${base}/newResources/member/images/balance/u371.png" alt="" style="width: 40px;height: 34px;"></span>
        <select name="amount" id="unicomAmount" style="width:210px;height: 40px;background: none;border: 0;outline: none;color: black;font-size: 18px">
            <option value="">请选择金额</option>
            <option value="3">3</option>
            <option value="5">5</option>
            <option value="10">10</option>
            <option value="30">30</option>
        </select>
        <div style="width: 5%;height: 100%;"></div>
    </div>
    <!--输入动态码-->
    <div style="display: flex;justify-content: space-around;align-items: center;width: 100%;height: 60px;border-bottom: 1px solid #EEEEEE">
        <span style="font-size: 30px;color: #333333;"><img src="${base}/newResources/member/images/login/yzm.png" alt="" style="width: 40px;height: 34px;"></span>
        <input name="code" id="unicomcode" type="number" value="" placeholder="请输入动态码" style="width:210px;height: 40px;font-size: 18px;font-weight: 300;border: none;outline: none;">
        <div style="width: 5%;"></div>
    </div>
        <div style="margin-left: 1.3rem;margin-top:6px;font-size: 14px;text-align:left;">
        <p>动态码获取流程：</p>
        <p>1. 下载“沃钱包”APP，登录后点击电子券按钮</p>
        <p>2. 进入电子券页面点击右下角“我的”-付款密码</p>
        </div>
        <div style="width: 100%;height: 45px;display: flex;margin-top:16px;justify-content: space-around;align-items:center;background: #E7E7EF;">
            <button class="btn btn-primary" type="button" id="paymentButton" onclick="unicomrecharge(this)" style="width:50%;height: 100%;background:linear-gradient(297deg,rgba(147,114,133,1) 0%,rgba(148,114,132,1) 100%);
box-shadow:0px 6px 10px 0px rgba(206,206,206,1);border: 0;color:white;border-radius: 25px;outline: none;font-size: 20px">立即充值</button>
        </div>
    </form>
</div>
<!--功能开发中-->
<div id="imgdiv" style="width: 100%;height: 300px;display: none">
    <img src="${base}/newResources/member/images/balance/1901.png" alt="" style="width: 100%;height: 100%">
</div>

</main>
</body>
</html>