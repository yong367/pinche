<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>爱帮伴-邀请函</title>
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
    <script src="${base}/resources/mobile/member/js/moment.js"></script>
    <script src="${base}/resources/mobile/member/js/common.js"></script>
    <script src="${base}/resources/mobile/member/js/jquery.qrcode.min.js"></script>

    <script type="text/javascript">
        $().ready(function() {
    [#if visitUrl??]
        $("#qrCode").qrcode({
            render:"canvas",
            width:200,
            height:200,
            text: "${visitUrl}"
        });
    [/#if]
        });
    </script>
    <style>
        *{
            padding: 0;
            margin: 0;
        }
    </style>
</head>
<body class="profile">
<a class="pull-left" href="${base}/member/index" style="position: absolute;top: 0.65rem;left: 0.45rem;">
    <span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
</a>
<div>
     <img style="width: 100%;" src="${currentUser.shareCodeImgUrl}"/>
</div>
[#--<header class="header-fixed" style="background: #2cb6f1;color: #FFFFFF">
    <a class="pull-left" href="${base}/member/index">
        <span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
    </a>
    我的邀请函
</header>
<main style="background-color: #ffffff">
    <div class="container-fluid">
        <div style="width: 100%;text-align: center;">
            <div><img src="${currentUser.shareCodeImgUrl}" style="width: 100%;height: auto"/></div>
            <div style="font-size: 12px;padding-top: 5px;font-family: "微软雅黑", "SimHei", "Microsoft YaHei", "Helvetica Neue", Helvetica, STHeiTi, sans-serif">长按上图并保存，将图片转发给朋友或分享朋友圈，邀请Ta使用您的专属邀请函注册爱帮伴，Ta的每笔消费，您都可以得到奖励哦！</div>
        </div>
    </div>
    </div>
</main>--]
[#--<footer class="footer-fixed" style="padding:0;background: #2cb6f1;">--]
    [#--<div class="call-div" style="color: #FFFFFF">--]
        [#--<a href="http://www.lifeabb.com/article/detail/201_1" class="call" style="color: #FFFFFF">操作说明</a>--]
    [#--</div>--]
[#--</footer>--]

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
<script>
    //rem单位屏幕自适应代码(必要时放在最前面)-开始
    var screenWid = document.documentElement.offsetWidth || document.body.offsetWidth;
    var nowWid = (screenWid / 750) * 100;
    var oHtml = document.getElementsByTagName("html")[0];
    //		console.log(nowWid);
    oHtml.style.fontSize = nowWid + "px";
    //rem单位屏幕自适应代码(必要时放在最前面)-结束
</script>
</body>
</html>