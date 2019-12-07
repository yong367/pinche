<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>${articleTitle}</title>
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
    [#if taskUrl??]
        var taskUrl = '${taskUrl}';
         var qrcode = $("#qrCode").qrcode({
             render:"canvas",
             width:150,
             height:150,
             text: taskUrl.replace(/&amp;/g,'&')
         }).hide();
        var canvas=qrcode.find('canvas').get(0);
        $("#qrCodeImg").attr("src",canvas.toDataURL('image/jpg'));
    [/#if]
        });
    </script>
</head>
<body class="profile">
<header class="header-fixed" style="background: #2cb6f1;color: #FFFFFF">
${articleTitle}
</header>
<main style="background-color: #ffffff">
    <div class="container-fluid">
            <div style="width: 100%;text-align: center;margin-top: 10%">
                
                
                <div style="padding-top: 15px;font: 16px;text-align: left;margin-left: 20px;font-family: "Microsoft YaHei", 微软雅黑">
                <div style="font-size: 12px;color:#2cb6f1;">${articleTitle}</div>
                [#noautoesc ]
                <div style="padding-top: 5px;" id="articleContent">${articleContent}</div>
                [/#noautoesc]
            </div>
         <div id="qrCode"></div>
        <div>
            <img id="qrCodeImg" src="">
        </div>
            </div>
    </div>
</main>
<footer class="footer-fixed" style="padding:0;background: #2cb6f1;">
    [#--<div class="call-div" style="color: #FFFFFF">--]
       [#--<a href="http://www.lifeabb.com/article/detail/151_1" class="call" style="color: #FFFFFF">任务规则 & 操作说明</a>--]
        [#--<button class="btn btn-red btn-flat" style="width: 20%;position: absolute;background: #ffa200;border-color:#2cb6f1;border-radius: 1rem;line-height: 20px;bottom: 10px;right: 5px" type="button" onclick="javascript:window.location.href='/member/cash/cashApply'">提现</button>--]
    [#--</div>--]
</footer>
</body>
</html>