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
		<link rel="stylesheet" href="css/wdmx.css" />
		<!--<link rel="stylesheet" type="text/css" href="css/layui.css" />-->
		<link rel="stylesheet" type="text/css" href="css/laydate.css" />
		<title>我的明细</title>
	</head>

	<body>
		<div class="top">
			<img src="img/jt.png" alt="" class="img" />
			<div class="text"><span>我的明细</span></div>
		</div>
		<div class="sy_con">
			<div class="jysj">
				交易时间
				<img src="img/xia.png" />
				<img src="img/shang.png" style="display: none;" />
			</div>
			<div class="jylx">
				交易类型
				<img src="img/xia.png" />
				<img src="img/shang.png" style="display: none;" />
			</div>
			<div class="xuanzeriqi" style="display: none;">
				<div class="ks">
					<span class="left">开始时间</span>
					<img class="right" src="img/right_hui.png" />
					<input class="right" type="text" class="layui-input" id="test23" placeholder="请选择">
				</div>
				<div class="end">
					<span class="left">结束时间</span>
					<img class="right" src="img/right_hui.png" />
					<input class="right" type="text" class="layui-input" id="test24" placeholder="请选择">
				</div>
				
				<div class="qrqx">
					<div class="quxiao left">
						取消
					</div>
					<div class="queren left">
						确认
					</div>
				</div>
			</div>
			<div class="jy_leixing" style="display: none;">
				<div class="leixing">
					<span class="left">选择类型</span>
					<select class="left" name="">
						<option value="0">请选择</option>
						<option value="1">全部</option>
						<option value="2">返回佣金</option>
						<option value="3">商品收入</option>
						<option value="4">充值</option>
						<option value="5">提现</option>
						<option value="6">游戏奖励</option>
					</select>
				</div>
				<div class="lxqrqx">
						<div style="height: 0.3rem;"></div>
						<div class="quxiao left">
							取消
						</div>
						<div class="queren left">
							确认
						</div>
					</div>
			</div>
		</div>
		<div style="height: 0.18rem;"></div>
		<div class="one">
			<div class="mx_time">今天</div>
			<div class="neirong">
				<div style="height: 0.16rem;"></div>
				<div class="nr">
					<span class="time">
					2019-10-20 &nbsp;12:30:12
				</span>
					<span class="yongJin">
					返佣收入 &nbsp;+300000.00
				</span>
				</div>
				<div style="height: 0.16rem;"></div>
				<div class="renwu">
					13366668888完成了1单[乔斯 Joyskid线上...]任务
				</div>
			</div>
			<div class="neirong">
				<div style="height: 0.16rem;"></div>
				<div class="nr">
					<span class="time">
					2019-10-20 &nbsp;12:30:12
				</span>
					<span class="yongJin">
					提现 &nbsp;-5.00
				</span>
				</div>
				<div style="height: 0.16rem;"></div>
				<div class="renwu">
					提现
				</div>
			</div>
			<div class="neirong">
				<div style="height: 0.16rem;"></div>
				<div class="nr">
					<span class="time">
					2019-10-20 &nbsp;12:30:12
				</span>
					<span class="yongJin">
					返佣收入 &nbsp;+300000.00
				</span>
				</div>
				<div style="height: 0.16rem;"></div>
				<div class="renwu">
					13366668888完成了1单[乔斯 Joyskid线上...]任务
				</div>
			</div>
		</div>
		<div class="one">
			<div class="mx_time">2019-10-30</div>
			<div class="neirong">
				<div style="height: 0.16rem;"></div>
				<div class="nr">
					<span class="time">
					2019-10-20 &nbsp;12:30:12
				</span>
					<span class="yongJin">
					返佣收入 &nbsp;+300000.00
				</span>
				</div>
				<div style="height: 0.16rem;"></div>
				<div class="renwu">
					13366668888完成了1单[乔斯 Joyskid线上...]任务
				</div>
			</div>
			<div class="neirong">
				<div style="height: 0.16rem;"></div>
				<div class="nr">
					<span class="time">
					2019-10-20 &nbsp;12:30:12
				</span>
					<span class="yongJin">
					返佣收入 &nbsp;+300000.00
				</span>
				</div>
				<div style="height: 0.16rem;"></div>
				<div class="renwu">
					13366668888完成了1单[乔斯 Joyskid线上...]任务
				</div>
			</div>
		</div>

	</body>
	<script src="js/jquery-1.9.1.min.js"></script>
	<!--<script src="js/layui.js"></script>-->
	<script src="js/laydate.js"></script>
	<script type="text/javascript">
		//rem单位屏幕自适应代码(必要时放在最前面)-开始
		var screenWid = document.documentElement.offsetWidth || document.body.offsetWidth;
		var nowWid = (screenWid / 750) * 100;
		var oHtml = document.getElementsByTagName("html")[0];
		//		console.log(nowWid);
		oHtml.style.fontSize = nowWid + "px";
		//rem单位屏幕自适应代码(必要时放在最前面)-结束
	</script>
	<script type="text/javascript">
		$('.jysj').click(function() {
			$(".xuanzeriqi").show();
		});
		$('.quxiao').click(function() {
			$(".xuanzeriqi").hide();
		});
		$('.jylx').click(function() {
			$(".jy_leixing").show();
		});
		//只出现确定按钮
		laydate.render({
			elem: '#test23',
			btns: ['confirm']
		});
		laydate.render({
			elem: '#test24',
			btns: ['confirm']
		});
	</script>

</html>