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
		<link rel="stylesheet" href="${base}/resources/mobile/member/css/exchangeIndex.css"/>
		<title>会员升级</title>

	</head>

	<body>
		<div class="header">
			<a href="javascript:history.back();"><img src="${base}/resources/mobile/member/images/jt.png" alt="" class="img" style="width: 8px;height: 16px;top: 10px;left: 10px;"/></a>
			<div class="text"><span style="font-size: 16px;">会员升级</span></div>
		</div>
		<div style="height: 0.8rem;"></div>
		<div class="top">
			<div class="tx">
				<img src="${imageUrl}" />
			</div>
			<div class="phone">
				${currentUser.mobile}
			</div>
			<div class="con">
				<span class="vip">${memberRankName}</span>
				<span class="aiDou">爱豆:<span class="xq">${currentPoint}</span></span>
			</div>
		</div>
		<div class="dj">
			<img src="${base}/resources/mobile/member/images/sx1.png"/>
			<span>兑换等级</span>
		</div>
		[#list memberLevelList as memberRank]
			[#if memberRank.point!=0]
				<div class="qingtong">
				<div class="qt">${memberRank.name}</div>
				<div class="ad">${memberRank.point}爱豆</div>
				<div class="duihuan" onclick="conversion(${memberRank.id});" value="1">兑换</div>
			</div>
			[/#if]
		[/#list]
	</body>
	<script src="${base}/resources/mobile/member/js/jquery.js"></script>
	<script src="${base}/resources/layui/layui.js"></script>
	<script type="text/javascript">
		//rem单位屏幕自适应代码(必要时放在最前面)-开始
		var screenWid = document.documentElement.offsetWidth || document.body.offsetWidth;
		var nowWid = (screenWid / 750) * 100;
		var oHtml = document.getElementsByTagName("html")[0];
		//		console.log(nowWid);
		oHtml.style.fontSize = nowWid + "px";
		//rem单位屏幕自适应代码(必要时放在最前面)-结束
		layui.use(['layer'], function(){
			let layer=layui.layer;
		})

		function conversion(memberRankId){
			$.ajax({
				async:false,
				cache:false,
				url:'${base}/member/point_log/completePointExchange',
				type:"POST",
				data:{memberRankId:memberRankId},
				dataType:"json",
				success:function(data){
					if(data.status=="y"){
						layer.msg(data.msg, {icon: 1});
						window.location.reload();
					}else {
						layer.msg(data.msg, {icon: 2});
					}
				}
			})
		}
	</script>

</html>