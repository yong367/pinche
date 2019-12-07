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
    <script src="${base}/resources/shop/js/jweixin.js"></script>
    <script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
    <script type="application/javascript">
        $(function(){
            /*wx.config({
                debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
                appId: '${appId}', // 必填，公众号的唯一标识
                timestamp: '${timestamp}' , // 必填，生成签名的时间戳
                nonceStr: '${nonceStr}', // 必填，生成签名的随机串
                signature: '${signature}',// 必填，签名，见附录1
                jsApiList: [
                    'checkJsApi',
                    'scanQRCode'// 微信扫一扫接口
                ]
            });*/
        });
        function openqr(){
            wx.checkJsApi({
                jsApiList: ['scanQRCode'], // 需要检测的JS接口列表，所有JS接口列表见附录2,
                success: function(res) {
                    // 以键值对的形式返回，可用的api值true，不可用为false
                    // 如：{"checkResult":{"chooseImage":true},"errMsg":"checkJsApi:ok"}
                    if (res.checkResult.scanQRCode==true){
                        wx.scanQRCode({
                            needResult:0,
                            success:function (res) {
                                var url = res.resultStr;
                                if(url.indexOf(',') != -1){
                                    url = url.split(',')[1];
                                }
                                window.location.href=url;
                            }
                        });
                    }
                    else{
                        Dialog.alert("提示","您当前的环境不支持扫码!")
                    }
                }
            });
        }

    </script>

</head>
<body class="profile">
<header class="header-fixed">
    <a href="javascript:WeixinJSBridge.call('closeWindow');" style="float: right;margin-right: 10px;">
        <span class="glyphicon glyphicon-remove" ></span>
    </a>
提示
</header>
<main>
    <div style="text-align: center;background-color: #FFFFFF;">
            <div style="padding-top: 20px;"> <img style ="width: 100px;height: 100px;" src="/resources/business/images/success.jpg"</div>
			<span style="display: block;padding-top: 20px;font-weight: bold;font-size: 18px;padding-bottom: 20px;">${msg}</span>
        <#--<button style="display: block;font-size: 16px;margin: auto;" onclick="openqr()" id="continueButton">继续操作</button>-->
    </div>
</main>
</body>
</html>