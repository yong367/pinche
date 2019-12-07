<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	[@seo type = "index"]
		<title>${seo.resolveTitle()}[#if showPowered] [/#if]</title>
		[#if seo.resolveKeywords()?has_content]
			<meta name="keywords" content="${seo.resolveKeywords()}">
		[/#if]
		[#if seo.resolveDescription()?has_content]
			<meta name="description" content="${seo.resolveDescription()}">
		[/#if]
	[/@seo]
	<link href="${base}/favicon.ico" rel="icon">
    <link rel="stylesheet" type="text/css" href="/newResources/shopindex/css/swiper.min.css" />
    <link rel="stylesheet" type="text/css" href="/newResources/shopindex/css/index.css" />
    <link rel="stylesheet" type="text/css" href="/newResources/shopindex/css/commen.css" />
    <script src="/newResources/shopindex/js/jquery-1.9.1.min.js"></script>
    <script src="/newResources/shopindex/js/swiper.min.js"></script>
    <!--px转换为rem的js-->
    <script src="/newResources/shopindex/js/adaptive.js"></script>
    [#--<script src="/newResources/shopindex/js/navbar.js"></script>--]
    <script src="${base}/resources/shop/js/jweixin.js"></script>
    <script src="http://api.map.baidu.com/api?v=2.0&ak=a11AwgBlRakmOOF4366YhKN3HhlRpjO6"></script>
    <script>
        $(function () {
            var swiper = new Swiper('.swiper-container', {
                slidesPerView: 1,
                spaceBetween: 0,
                slidesPerGroup: 1,
                loop: true,
                loopFillGroupWithBlank: true,
                autoplay: {
                    delay: 3000,
                    disableOnInteraction: false,
                },
                pagination: {
                    el: '.swiper-pagination',
                    clickable: true,
                },
                navigation: {
                    nextEl: '.swiper-button-next',
                    prevEl: '.swiper-button-prev',
                },
            });
        });

    </script>

    <style type="text/css">
        .swiper-slide {
            text-align: center;
        }

        .swiper-slide img {
            width: 7.06rem;
            height: 3.18rem;
            border-radius: 0.1rem;
        }
    </style>
	<script type="text/javascript">
	$().ready(function() {
		var ua = navigator.userAgent.toLowerCase();
		if (ua.match(/MicroMessenger/i) == "micromessenger") {
			wx.config({
				debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
				appId: '${appId}', // 必填，公众号的唯一标识
				timestamp: '${timestamp}' , // 必填，生成签名的时间戳
				nonceStr: '${nonceStr}', // 必填，生成签名的随机串
				signature: '${signature}',// 必填，签名，见附录1
				jsApiList: [
					'checkJsApi',
					'getLocation',
					'scanQRCode'// 微信扫一扫接口
				]
			});
		}else{
			var geolocation = new BMap.Geolocation();
			geolocation.enableSDKLocation();
			geolocation.getCurrentPosition(function(r){
				if(this.getStatus() == BMAP_STATUS_SUCCESS){
					var pt = new BMap.Point(r.point.lng,r.point.lat);
					var geoc = new BMap.Geocoder();
					geoc.getLocation(pt, function(rs){	//解析格式：城市，区县，街道
						var addComp = rs.addressComponents;
						$(".shiqu").html(addComp.city);
					});
				}else{
                    $(".shiqu").html("全国");
                }
			});
		}

	});

	wx.ready(function (){
		wx.getLocation({
			type: 'wgs84', // 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
			success: function (res) {
				var latitude = res.latitude; // 纬度，浮点数，范围为90 ~ -90
				var longitude = res.longitude; // 经度，浮点数，范围为180 ~ -180。
				var point = new BMap.Point(longitude,latitude);
				var gc = new BMap.Geocoder();
				gc.getLocation(point, function(rs){
					var addComp = rs.addressComponents;
					$(".shiqu").text(addComp.city);
				});
			},
			cancel:function (res) {	//用户点击取消时的回调函数，仅部分有用户取消操作的api才会用到。
				$(".shiqu").html("全国");
			}
		});
	});

	</script>
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
</head>
<body>
<div class="top">
    <form id="searchForm" action="${base}/product/search" method="get" >
        <div class="dlwz left">
            <span class="shiqu">全国</span>
            <img class="" src="/newResources/shopindex/img/diqu.png" />
        </div>
        <div class="sousuo left">
            <img class="left" src="/newResources/shopindex/img/ss.png" onclick="javascript:$('#searchForm').submit()"/>
            <input type="text" id="keyword" name="keyword" class="flex-1 hh_search_ipt" placeholder="${message("shop.index.keyword")}" />
        </div>
        <div class="log left">
            <a href="/member/index">
                <img src="/newResources/shopindex/img/log.png" />
            </a>
        </div>
    </form>
</div>
<div style="height: 1.09rem;"></div>
<div class="one">
    <div class="lb">
        <div class="swiper-container swiper-no-swiping">
            <div class="swiper-wrapper">
                <div class="swiper-slide"><img src="${base}/upload/image/index_slider1.jpg" onclick="javascript:window.location.href='http://www.lifeabb.com/product/search?keyword=%E6%B5%B7%E9%A3%9E%E4%B8%9D'"/></div>
                <div class="swiper-slide"><img src="${base}/upload/image/index_slider3.jpg" onclick="javascript:window.location.href='http://www.lifeabb.com/product/search?keyword=%E6%B8%85%E6%89%AC'"/></div>
            </div>
            <div class="swiper-pagination"></div>
        </div>
    </div>
    <div class="daohang">
        <ul>
            <li>
                <a href="/product/list/556">
                    <img src="/newResources/shopindex/img/dbzy.png" alt="" />
                    <span>兑伴自营</span>
                </a>
            </li>
            <li>
                <a href="/product/list/556">
                    <img src="/newResources/shopindex/img/flzc.png" alt="" />
                    <span>返利专场</span>
                </a>
            </li>

            <li>
                <a href="/product/list/556">
                    <img src="/newResources/shopindex/img/shdj.png" alt="" />
                    <span>实惠到家</span>
                </a>
            </li>
            <li>
                <a href="/product/list/556"><img src="/newResources/shopindex/img/cyyx.png" alt="" />
                    <span>创意优选</span>
                </a>
            </li>
            <li>
                <a href="/member/mobileRecharge/index"><img src="/newResources/shopindex/img/hfcz.png" alt="" />
                    <span>话费充值</span>
                </a>
            </li>
            <li>
                <a href="/member/task/list"><img src="/newResources/shopindex/img/rmrw.png" alt="" />
                    <span>热门任务</span>
                </a>
            </li>
            <li>
                <a href="/member/share/index">
                    <img src="/newResources/shopindex/img/yqhy.png" alt="" />
                    <span>邀请好友</span>
                </a>
            </li>
            <li>
                <a href="javascript:void(0);">
                    <img src="/newResources/shopindex/img/jqqd.png" alt="" />
                    <span>敬请期待</span>
                </a>
            </li>
        </ul>
    </div>
</div>
<div class="qb_con">
    <!--会员礼包-->
    <div id="hylb_con">
        <div class="hylb">
            <img src="/newResources/shopindex/img/hylb.png" />
        </div>
        <div class="sp_con">
            <div style="height: 0.5rem;"></div>
            <ul>
[@product_gift_bag]
    [#list memberGiftBags as memberGiftBag]
                <li style="background:#A1A0FF">
                    <a href="/product/detail/${memberGiftBag.id}">
                        <img src="${memberGiftBag.image}" alt="" />
                        <span>${memberGiftBag.name}</span>
                    </a>
                </li>
    [/#list]
[/@product_gift_bag]
            </ul>
            <div class="tonglan">
				玩游戏赢大奖 好礼享不停
            </div>
        </div>
    </div>
    <div class="jpyx_con">
        <div class="jpyx">
            <img src="/newResources/shopindex/img/jpyx.png" />
        </div>
        <div class="jp_con">
            <ul>
                [@product_list productCategoryId = 851 count = 6]
                    [#list products as product]
                        [#assign defaultSku = product.defaultSku /]
                <li>
                    <a href="${base}${product.path}">
                        <img src="${product.image!setting.defaultThumbnailProductImage}" />
                        <span class="jp_con_tit"  style="text-align: left">${product.name}</span>
                        <span class="jp_con_sm"  style="text-align: left">${product.caption}</span>
                    </a>
                    <div class="jiage">
                        <img class="left" src="/newResources/shopindex/img/dbb.png" />
                        <span class="zs_jg left">
                            ${currency(defaultSku.price, false)}
								</span>
                        <span class="sc_jg left">
									市场价<span class="scjg">￥${currency(defaultSku.marketPrice, false)}</span>
								</span>
                    </div>
                    <div class="jp_con_bottom">
                   [#--  <div class="by left">
							包邮
                        </div>--]
                        <div class="zk left">
							折扣
                        </div>
                        <div class="ys left">
                            已售<span>${formatProductSals(product.sales,true)}</span>
                        </div>
                        <a href="">
                            <img class="right" src="/newResources/shopindex/img/gwc.png" />
                        </a>
                    </div>
                </li>
                    [/#list]
                [/@product_list]
            </ul>
            <div class="tonglan">
				玩游戏赢大奖 好礼享不停
            </div>
        </div>
    </div>
    <!--实惠到家-->
    <div class="shdj_con">
        <div class="shdj">
            <img src="/newResources/shopindex/img/shdj_tit.png" />
        </div>
        <div class="sh_con">
            <ul>
                [@product_list productCategoryId = 851 count = 6]
                    [#list products as product]
                        [#assign defaultSku = product.defaultSku /]
                <li>
                    <a href="${base}${product.path}">
                        <img src="${product.image!setting.defaultThumbnailProductImage}" />
                        <span class="sh_con_tit" style="text-align: left">${product.name}</span>
                        <span class="sh_con_sm" style="text-align: left">${product.caption}</span>
                    </a>
                    <div class="jiage">
                        <img class="left" src="/newResources/shopindex/img/dbb.png" />
                        <span class="zs_jg left">
                            ${currency(defaultSku.price, false)}
								</span>
                        <span class="sc_jg left">
									市场价<span class="scjg">￥${currency(defaultSku.marketPrice, false)}</span>
								</span>
                    </div>
                    <div class="sh_con_bottom">
                        <div class="by left">
							包邮
                        </div>
                       [#-- <div class="zk left">
							折扣
                        </div>--]
                        <div class="ys left">
                            已售<span>${formatProductSals(product.sales,true)}</span>
                        </div>
                        <a href="">
                            <img class="right" src="/newResources/shopindex/img/gwc.png" />
                        </a>
                    </div>
                </li>
                    [/#list]
                [/@product_list]
            </ul>
        </div>
    </div>
</div>
<div class="dixian">
    <span class="span1 left"></span>
    <span class="wz left">人家也是有底线的</span>
    <span class="span1 left"></span>
</div>
<div style="height: 1rem;"></div>
<div class="nav">
    <div class="">
        <ul class="navbar">
            <a href="/" class="">
                <li class="zhuye">
                    <img src="/newResources/shopindex/img/bar1-1.png"/>
                    <div class="bar-hui" style="color:#7d9bed">主页</div>
                </li>
            </a>
            <a href="/product_category" class="">
                <li class="fenlei">
                    <img src="/newResources/shopindex/img/bar2.png"/>
                    <div class="bar-hui">分类</div>
                </li>
            </a>
            <a href="/member/task/list" class="">
                <li class="zlh">
                    <img src="/newResources/shopindex/img/bar3.png"/>
                    <div class="bar-hui">赚零花</div>
                </li>
            </a>
            <a href="/cart/list" class="">
                <li class="gwc">
                    <img src="/newResources/shopindex/img/bar4.png"/>
                    <div class="bar-hui">购物车</div>
                </li>
            </a>
            <a href="/member/index" class=" ">
                <li class="wode">
                    <img src="/newResources/shopindex/img/bar5.png"/>
                    <div class="bar-hui">我的</div>
                </li>
            </a>
        </ul>
    </div>
</div>
<div class="clear" style="clear: both;"></div>
</body>
</html>