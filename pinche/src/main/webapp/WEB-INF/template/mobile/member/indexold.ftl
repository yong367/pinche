<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-会员中心</title>
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
    <script src="${base}/resources/shop/js/jweixin.js"></script>
    <script type="text/javascript" src="${base}/resources/statistic/browsestatistical.js"></script>
	<script>
		$(function(){
		     [#if flashMessage?has_content]
			    $.alert("${flashMessage}");
			 [/#if]
                wx.config({
                    debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
                    appId: '${appId}', // 必填，公众号的唯一标识
                    timestamp: '${timestamp}' , // 必填，生成签名的时间戳
                    nonceStr: '${nonceStr}', // 必填，生成签名的随机串
                    signature: '${signature}',// 必填，签名，见附录1
                    jsApiList: [
                        'checkJsApi',
                        'scanQRCode'// 微信扫一扫接口
                    ]
                });
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
	<style>
		#area_tip {
			z-index: 10;
			position: fixed;
			/* width: 30.5rem; */
			position: relative;
			height: 100%;
			left: 0;
			top: 0;
			font-family: PingFangSC;
		}

		.mb {
			background-color: black;
			filter: alpha(opacity=45);
			-moz-opacity: 0.45;
			-khtml-opacity: 0.45;
			opacity: 0.45;
			width: 100%;
			height: 100%;
			position: fixed;
			left: 0;
			top: 0;
			z-index: 100;
		}

		.con {
			width: 25.6rem;
			/* position: absolute; */
			/* top: 20.88rem; */
			/* left: 4.96rem; */
			z-index: 101;
			position: absolute;
			left: 50%;
			/* top: -15%; */
			transform: translate(-50%,-200%);
			/* position: absolute; */
			/* margin: auto; */
			top: 60;
			/* left: 0; */
			/* right: 0; */
			/* bottom: 0; */
			height: 14.76rem;
			background: rgba(255, 255, 255, 1);
			border-radius: 0.4rem;

		}

		.cs {
			width: 22.96rem;
			height: 5rem;
			font-size: 1.6rem;
			font-weight: 400;
			color: #333333;
			line-height: 2rem;
			position: absolute;
			top: 4.5rem;
			left: 1.35rem;
			text-align: center;
		}

		.anNiu {
			width: 25.6rem;
			height: 3.94rem;
			border-top: 0.02rem solid #F2F2F2;
			position: absolute;
			top: 10.85rem;
			left: 0;
		}

		.a {
			width: 13.4rem;
			height: 3.9rem;
			border-right: 0.02rem solid #F2F2F2;
		}

		.qr {
			width: 6.74rem;
			height: 2.5rem;
			font-size: 1.6rem;
			font-weight: 400;
			color: rgba(73, 169, 240, 1);
			line-height: 0.5rem;
			position: absolute;
			top: 1.6rem;
			left: 16.54rem;
		}

		.xg {
			width: 6.74rem;
			height: 2.5rem;
			font-size: 1.6rem;
			font-weight: 400;
			color: rgba(73, 169, 240, 1);
			line-height: 0.5rem;
			position: absolute;
			top: 1.6rem;
			left: 4.7rem;
		}

		.sj {
			width: 22.44rem;
			height: 2.56rem;
			font-size: 1.8rem;
			font-family: PingFangSC-Regular, PingFangSC;
			font-weight: 400;
			color: rgba(249, 109, 21, 1);
			line-height: 0.56rem;
			text-align: center;
			position: absolute;
			top: 1.16rem;
			left: 1.58rem;
		}
		.gbImg {
			width: 3.32rem;
			height: 3.321rem;
			position: absolute;
			top: 0.4rem;
			right: 0.12rem;
		}
		.gbImg img{
			width: 2.48rem;
			height: 2.48rem;

		}
	</style>
</head>
<body class="profile" id="mainBody">
	<header class="header-fixed" style="background: #2cb6f1;color: #FFFFFF">
		<a class="pull-left" href="javascript: location.href = '${base}/';">
			<span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
		</a>
		${message("member.index.title")}
		
		<a href="${base}/member/index/setting" class="pull-right shezhi" style="color: #ffffff;">设置</a>
	</header>
	<main>
		<div class="container-fluid">
			<div class="panel panel-flat">
				<div class="user-face-Warp">
					<div class="usr_face">
                        <img src="[#if currentUser.imageUrl?has_content]
                        ${currentUser.imageUrl}
                        [#else]
                        ${setting.defaultMemberLogo}
                        [/#if]
	" onclick="window.location='/member/image/edit'" id="touxiang" style="width: 100%;height: 100%;float: left;"/>
					  </div> 
					
					  <h1>${currentUser.username}</h1>
					  <h2>${currentUser.memberRank.name}&nbsp;&nbsp;<a class="qsj" href='javascript:$("#area_tip").show();'>去升级&gt;</a></h2>
		<img src="${base}/newResources/member/images/saoyisao50.png"  style="position: absolute;right: 15px;top: 50%;transform: translateY(-50%);-webkit-transform: translateY(-50%);width: 3rem;height: 3rem;" onclick="openqr()">
					<span style="position: absolute;right: 13px;top: 75%;transform: translateY(-50%);-webkit-transform: translateY(-50%);font-size: 1.2rem;color: #00A1EA;font-family: "微软雅黑", "SimHei", "Microsoft YaHei", "Helvetica Neue", Helvetica, STHeiTi, sans-serif;">扫一扫</span>
				</div>
				<div class="panel-body small">
					<div class="row memberRow4">
                        <div class="col-xs-3 text-center" style="width: 24%">

                            <a class="icon" href="/member/myDuiBan/balance">
							${currentUser.balance}<br/>
                                我的钱包
                            </a>
                        </div>
                        <div class="col-xs-3 text-center" style="width: 24%">
                            <a class="icon" href="${base}/member/coupon_code/list">
							${couponCodeCount}<br/>
							${message("member.index.couponCodeList")}
                            </a>
                        </div>
                        <div class="col-xs-3 text-center" style="width: 24%">
                            <a class="icon" href="${base}/member/store_favorite/list">
							${storeFavoriteCount}<br/>
							${message("member.index.storeFavoriteList")}
                            </a>
                        </div>
						<div class="col-xs-3 text-center" style="width: 24%">
							<a class="icon" href="${base}/member/product_favorite/list">
								${productFavoriteCount}<br/>
								商品收藏
							</a>
						</div>
						
					</div>

                   
				</div>
			</div>

			<div class="panel panel-flat">
                <div class="panel-heading">
					签到送爱豆
					<span>

						<a id="signInId" class="pull-right blue-darker" href="javascript:signIn();" style="margin-right: 1rem;margin-left: 1rem;">
							点击签到
							[#--                      <span class="glyphicon"></span>--]
						</a>
						<span class="pull-right" style="color: #0090d2;margin-right: 1rem;">${currentUser.point}爱豆</span>
					</span>

                </div>
				<div class="panel-heading">
					我的邀请函
					<a class="pull-right blue-darker" href="${base}/member/share/index">
						邀朋友注册得奖励，点击邀请
						<span class="glyphicon glyphicon-menu-right"></span>
					</a>
				</div>
				<div class="panel-heading">
					砸金蛋赢大奖
					<a class="pull-right blue-darker" href="${base}/member/smashEggs/index">
						更多好礼等您拿
						<span class="glyphicon glyphicon-menu-right"></span>
					</a>
				</div>
				<div class="panel-heading">
					${message("member.index.order")}
					<a class="pull-right blue-darker" href="${base}/member/order/list">
						${message("member.index.orderList")}
						<span class="glyphicon glyphicon-menu-right"></span>
					</a>
				</div>
				<div class="panel-body small">
					<div class="row">
						<div class="col-xs-3 text-center">
							<a class="icon" href="${base}/member/order/list?status=pendingPayment&hasExpired=false">
								<span class="fa fa-credit-card blue"></span>
								${message("member.index.pendingPaymentOrderList")}
							</a>
						</div>
						<div class="col-xs-3 text-center">
							<a class="icon" href="${base}/member/order/list?status=pendingShipment&hasExpired=false">
								<span class="fa fa-calendar-minus-o blue"></span>
								${message("member.index.pendingShipmentOrderList")}
							</a>
						</div>
						<div class="col-xs-3 text-center">
							<a class="icon" href="${base}/member/order/list?status=shipped">
								<span class="fa fa-truck blue"></span>
								${message("member.index.shippedOrderList")}
							</a>
						</div>
						<div class="col-xs-3 text-center">
							<a class="icon" href="${base}/member/order/list?status=completed">

								<span class="fa fa-comment-o blue"></span>
                                已收货
							</a>
						</div>
					</div>
				</div>
			</div>
            <div class="panel panel-flat" style="border-bottom: none;margin-bottom: 0px">
                <div class="panel-heading" style="border-bottom: none">
                    <img src="/newResources/business/images/firstPageImg/u20.png" style="width: 40%;height: 40%;margin-left: 30%"/>
                    <div style="text-align: center;"><p>长按识别二维码关注公众号</p>
						<p><a href="${base}/member/task/list" style="text-decoration: none;color: #0090d2">领任务赚零花</a></p>
                    </div>
                </div>
            </div>
		</div>
		<!--弹框-->
		<div id="area_tip" style="display: none;">
			<div class="mb"></div>
			<div class="con">
				<div class="sj">
					<span>选择升级方式</span>
				</div>
				<div class="gbImg">
					<a href='javascript:$("#area_tip").hide();'><img src="${base}/resources/mobile/member/images/ch.png" /></a>
				</div>

				<div class="cs">
					您有两种方式可以升级会员<br />等级，请选择
				</div>
				<div class="anNiu">
					<div class="a">
						<a href="${base}/product/list/1751" class="xg">购买礼包</a>
					</div>
					<div>
						<a href="${base}/member/point_log/exchangeIndex" class="qr">爱豆兑换</a>
					</div>
				</div>
			</div>
		</div>
	</main>
    <footer class="footer-fixed" style="padding:0;background: #2cb6f1;">
        <div class="call-div" style="color: #FFFFFF">
            消费维权热线：<a href="tel:4009698198" class="call" style="color: #FFFFFF">400-969-8198</a>
        </div>
    </footer>
<script src="${base}/resources/layer_mobile/layer.js"></script>
<script>
	function signIn() {
			$("#signInId").removeAttr("href");
			$.ajax({
				async:false,
				cache:false,
				url:'${base}/member/point_log/signIn',
				type:"POST",
				dataType:"json",
				success:function(data){
					if(data.code==1){
						window.location.reload();
					}
					$("#signInId").attr("href","javascript:signIn();");
				}
			})
	}
</script>
</body>
</html>
