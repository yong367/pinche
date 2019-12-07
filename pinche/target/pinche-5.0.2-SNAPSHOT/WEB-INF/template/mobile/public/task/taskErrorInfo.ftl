<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <link href="${base}/favicon.ico" rel="icon">
    <style>
        html,body{
            width: 100%;
            height: 100%;
        }
        *{
            padding: 0;
            margin: 0;
        }
    </style>
</head>
<body style="background: #F3F2FA;">
<div style="width: 100%;height: 50px;line-height: 50px;z-index:1000;background:linear-gradient(#5685F7,#5487F7,#349FEC);top: 0;color:white;">
    <p style="margin-left: 20px;">${taskInfo.name}</p>
</div>
<div style="width: 100%;height:160px;font-size:15px;text-align:left;background:white;color:black;">
    <div style="width:100%;height: 100px">
        <div style="width: 80px;height: 80px;position: relative;background:white;border-radius: 50%;top: 50%;bottom: 50%;left: 50%;transform: translate(-50%, -50%)">
            <img src="/newResources/member/images/task/u1149.png" alt="" style="width: 80px;height: 80px;position: absolute;top: 50%;bottom: 50%;left: 50%;transform: translate(-50%, -50%)">
        </div>
    </div>
    <p style="text-align:center;margin-left: 25px;margin-right:25px;font-size: 16px;color: #333333;">
        [#if errorCode =='-1000']很抱歉，该活动已结束！您可以关注爱帮伴公众号，这里不仅有优惠，还能赚零花。[/#if]
    </p>
</div>
<div style="width:124px;height: 124px; margin: 0 auto;margin-top: 30px;">
    <img src="/newResources/member/images/task/u1049.png" alt="" style="width: 100%;height: 100%;" alt="图片加载中">
</div>
<div style="margin-top:16px;color: #3498DB;text-align: center;">
    <p>长按识别二维码</p>
    <p>关注爱帮伴!</p>
</div>
</body>
</html>