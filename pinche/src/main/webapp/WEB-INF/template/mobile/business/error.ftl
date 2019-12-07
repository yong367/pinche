<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>爱帮伴-网站提示</title>
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
    <script src="${base}/resources/shop/js/jweixin.js"></script>

</head>
<body class="profile">
<header class="header-fixed">
    <a href="javascript:WeixinJSBridge.call('closeWindow');" style="float: right;margin-right: 10px;">
        <span class="glyphicon glyphicon-remove" ></span>
    </a>
警告
</header>
<main>
    <div style="text-align: center;background-color: #FFFFFF;">
            <div style="padding-top: 20px;"> <img style ="width: 100px;height: 100px;" src="/resources/business/images/error.jpg"</div>
			<span style="display: block;padding-top: 20px;font-weight: bold;font-size: 18px;">${msg}</span>
    </div>
</main>
</body>
</html>