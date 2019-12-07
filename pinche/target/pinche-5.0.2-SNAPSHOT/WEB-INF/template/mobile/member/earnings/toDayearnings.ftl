<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
		<meta name=“viewport” content=“width=device-width, viewport-fit=cover”>
		<meta name="format-detection" content="telephone=no">
		<meta name="author" content="技术部">
		<meta name="copyright" content="SHOP">
		<link rel="stylesheet" href="${base}/resources/mobile/member/css/jrsy.css" />
		<title>今日收益</title>
	</head>

	<body>
	<div style="background: url(/newResources/shop/images/home_topbgimg.png) no-repeat;background-size: 100% 100%;">
        <div class="top" style="background: none">
            <a href="javascript:history.back();"><img src="${base}/resources/mobile/member/images/jt.png" alt="" class="img" style="width: 8px;height: 16px;top: 10px;left: 10px;" /></a>
            <div class="text"><span style="font-size: 16px;">今日收益</span></div>
        </div>
        <div class="sy_con" style="background: none">
            <div class="sy_tit">今日收益</div>
            <div class="sy_yuan">${toDayYongJin}</div>
        </div>
	</div>
		<div style="height: 0.18rem;"></div>
        [#list list as memberTask]
            <div class="neirong">
                <div style="height: 0.16rem;"></div>
                <div class="nr">
				<span class="time">
					${memberTask.createdDate}
				</span>
                    <span class="yongJin">
					返佣收入 &nbsp;+${memberTask.rewardAmount}
				</span>
                </div>
                <div style="height: 0.16rem;"></div>
                <div class="renwu">
                    ${memberTask.mobile}完成了1单[${memberTask.name}]任务
                </div>
            </div>
        [/#list]
	</body>
	<script type="text/javascript">
		//rem单位屏幕自适应代码(必要时放在最前面)-开始
		var screenWid = document.documentElement.offsetWidth || document.body.offsetWidth;
		var nowWid = (screenWid / 750) * 100;
		var oHtml = document.getElementsByTagName("html")[0];
		//		console.log(nowWid);
		oHtml.style.fontSize = nowWid + "px";
		//rem单位屏幕自适应代码(必要时放在最前面)-结束
	</script>
</html>