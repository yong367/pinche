<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>爱帮伴-我的钱包</title>
    <link href="${base}/favicon.ico" rel="icon">
    <link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
    <link href="${base}/resources/mobile/member/css/font-awesome.css" rel="stylesheet">
    <link href="${base}/resources/mobile/member/css/animate.css" rel="stylesheet">
    <link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
    <link href="${base}/resources/mobile/member/css/profile.css" rel="stylesheet">
    <!--[if lt IE 9]>
    <script src="${base}/resources/mobile/member/js/html5shiv.js"></script>
    <script src="${base}/resources/mobile/member/js/respond.js"></script>
    <![endif]-->
    <script src="${base}/resources/mobile/member/js/jquery.js"></script>
    <script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
    <script src="${base}/resources/mobile/member/js/underscore.js"></script>
    <script src="${base}/resources/mobile/member/js/common.js"></script>
    <script>
        window.onload = function () {
            var wx = document.getElementById("wx");
            var zfb = document.getElementById("zfb");
            var money = document.getElementById("money");
            var clearimg = document.getElementById("clearimg");
            wx.onclick = function () {
                this.style.border = "1px solid #548FF7";
                zfb.style.border = "none";
            }
            zfb.onclick = function () {
                this.style.border = "1px solid #548FF7";
                wx.style.border = "none";
            }
        }
    </script>
</head>
<body class="profile" style="background: #f2f2f2;">
<header class="header-fixed"
        style="background:linear-gradient(126deg,rgba(150,100,111,1) 0%,rgba(107,107,138,1) 34%,rgba(217,124,117,1) 100%);color: #FFFFFF;box-shadow:none">
    <a class="pull-left" href="javascript: history.back();">
        <span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
    </a>
    <span style="margin-left: -20px">我的钱包</span>
</header>

<div style="display: flex;width: 100%;height: 42px;align-items: center;"><img
        src="${base}/newResources/member/images/balance/u297.png" alt="" style="width: 24px;height: 24px;">
    <div style="background:none;margin: 0 auto"><span style="font-size: 16px;color: white;">我的钱包</span></div>
</div>
<div style="width: 100%;height: 121px;background:linear-gradient(126deg,rgba(150,100,111,0.8) 0%,rgba(107,107,138,0.8) 34%,rgba(217,124,117,0.8) 100%);">
    <p style="width: 80%;height: 30px;line-height: 30px;color:white;font-size: 18px;margin-left: 20px;">我的兑伴儿</p>
    <p style="width:80%;height: 91px;line-height: 91px;color:white;font-size: 50px;margin-left: 20px;">${currentUser.balance}</p>
</div>
<div style="width: 100%;height:100px">
    <a href="${base}/member/deposit/recharge">
        <div style="display: flex;justify-content: space-around;align-items: center;width: 100%;height: 45px;background: #fff;">
            <img style="width: 32px;height: 32px;" src="${base}/newResources/member/images/balance/cz.png" alt="">
            <div style="width: 60%;margin-left:-30px;"><span style="font-size: 16px;">充值</span></div>
            <img src="${base}/newResources/member/images/balance/u319.png" alt="">
        </div>
    </a>
    <a href="javascript:isAuth();">
        <div style="display: flex;justify-content: space-around;align-items: center;width: 100%;height:45px; background: #fff;">
            <img style="width: 32px;height: 32px;" src="${base}/newResources/member/images/balance/tx.png" alt="">
            <div style="width: 60%;margin-left:-30px;"><span style="font-size: 16px;">提现</span></div>
            <img src="${base}/newResources/member/images/balance/u319.png" alt="">
        </div>
    </a>
    <a href="/member/deposit/log">
        <div style="display: flex;justify-content: space-around;align-items: center;width: 100%;height:45px;background: #fff;">
            <img style="width: 32px;height: 32px;" src="${base}/newResources/member/images/balance/mx.png" alt="">
            <div style="width: 60%;margin-left:-30px;"><span style="font-size: 16px;">明细</span></div>
            <img src="${base}/newResources/member/images/balance/u319.png" alt="">
        </div>
    </a>
</div>
<script src="${base}/resources/layer_mobile/layer.js"></script>
<script>
    function isAuth() {
    [#if currentUser.authenticationStatus]
        window.location.href = "${base}/member/appliCash/cash/cashApply";
    [#else]
        layer.open({
            content: '您需要完成实名认证才可以提现！',
            btn: ['去认证', '取消'],
            yes: function (index) {
                window.location.href = "${base}/member/authentification/authentification?preActionName=tixian";
            },
            no: function (index) {
                layer.close(index);
            }
        });
    [/#if]
    }
</script>
</body>
</html>