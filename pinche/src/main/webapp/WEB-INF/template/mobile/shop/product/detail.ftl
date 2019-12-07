[#assign defaultSku = product.defaultSku /]
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	[@seo type = "productDetail"]
		<title>${seo.resolveTitle()}[#if showPowered] [/#if]</title>
		[#if seo.resolveKeywords()?has_content]
			<meta name="keywords" content="${seo.resolveKeywords()}">
		[/#if]
		[#if seo.resolveDescription()?has_content]
			<meta name="description" content="${seo.resolveDescription()}">
		[/#if]
	[/@seo]
	<link href="${base}/favicon.ico" rel="icon">
    <link href="${base}/resources/mobile/shop/css/bootstrap.css" rel="stylesheet">
    <link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
    <link rel="stylesheet" href="/newResources/shop/css/swiper-3.4.2.min.css">
    <link rel="stylesheet" href="/newResources/shop/css/xw_style.css?t=1">

    <!--[if lt IE 9]>
    <script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
    <script src="${base}/resources/mobile/shop/js/respond.js"></script>
    <![endif]-->
    <script src="${base}/resources/mobile/shop/js/jquery.js"></script>
    <script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
    <script src="${base}/resources/mobile/shop/js/underscore.js"></script>
    <script src="${base}/resources/mobile/shop/js/common.js"></script>
    <script src="/newResources/shop/js/swiper-3.4.2.min.js"></script>
    <script src="${base}/resources/shop/js/jweixin.js"></script>

    <style type="text/css">
        .sy_yh_tk {
            width: 100px;
            height: 80px;
            position: fixed;
            top: 45px;
            right: 10px;
            background: url(/newResources/shop/images/dh_bg.png) no-repeat;
            background-size: 100% 100%;
            z-index: 1000;
            display: none;
        }

        .sy_hy {
            /*line-height: 40px;*/
            position: fixed;
            top: 5px;
            right: 10px;
            z-index: 1000;
        }

        .sy_hy img {
            width: 5px;
            height: 20px;
            margin-top: 5px;
        }

        .sy_yh_tk a {
            margin-left: 5px;
            margin-top: 5px;
        }

        .sy_yh_tk img {
            width: 20px;
            height: 20px;
            float: left;
        }

        .sy_yh_tk span {
            float: left;
            color: #666666;
            font-size: 15px;
            padding-left: 5px;
        }

        .fh {
            width: 10px;
            height: 20px;
            margin-left: 7px;
        }

        .orange {
            background: url(/newResources/shop/images/goods_detail_top.png) no-repeat;
            background-size: 100% 100%;
            opacity: 0;
        }

        .nav {
            height: 40px;
            width: 80%;
            margin: 0 auto;
        }

        .nav li {
            float: left;
        }

        .head_back_div {
            width: 28px;
            height: 28px;
            position: fixed;
            background: rgba(0, 0, 0, 0.5);
            border-radius: 50%;
            top: 5px;
            left: 10px;
            z-index: 1000;
        }

        .itemlist {
            width: 90%;
            height: 32px;
            float: left;
            list-style: none;
            text-align: center;
            line-height: 40px;
            margin: 0 auto;
            margin: 0 5%;
            transition: background 1s;
            text-align: center;
        }

        .nav li {
            width: 30%;
            height: 32px;
            float: left;
            list-style: none;
            text-align: center;
            line-height: 40px;
            transition: background 1s;
            margin: 0 auto;
        }

        .nav li span {
            float: left;
            width: 40px;
            height: 32px;
            list-style: none;
            text-align: center;
            line-height: 40px;
            transition: background 1s;
            color: #FFFFFF;
            margin: 0 20%;
        }
        .gd_detail img{
			width: 100%;
		}
        .active {
            border-bottom: 2px solid #FFFFFF;
            color: #fff;
            font-size: 18px;
            font-weight: 500;
        }
        .back-top{
            bottom: 60px;
            z-index: 999;
        }
    </style>
<body class="had_head_body had_foot_body goods_detail_body">
<div class="flex flex-align-center head_back_div" id="jt_return">
    <a class="" href="javascript:history.back();">
        <img class="fh" src="/newResources/shop/images/fh.png" />
    </a>
</div>
<div class="sy_hy">
    <div id="caidan_bg" style="background: rgba(0,0,0,0.5);width:30px;height:30px;text-align:center;border-radius: 30px;">
        <img src="/newResources/shop/images/caidan.png" />
    </div>
</div>
<div class="head orange" id="header">
    <ul class="flex head_dom">
        <li class="head_back"></li>
        <li class="flex-1 head_title" id="zj" style="opacity: 0;">
            <ul class="nav">
                <li><span class="itemlist active">商品</span></li>
                <li><span class="itemlist">店铺</span></li>
                <li><span class="itemlist">详情</span></li>
            </ul>
        </li>
        <li class="head_right">
        </li>
    </ul>
</div>
<div class="sy_yh_tk">
    <div style="height: 12px;"></div>
    <a href="/"><img src="/newResources/shop/images/sy.png" /><span>首页</span></a>
    <a href="/member/index"><img src="/newResources/shop/images/yhzx.png" /><span>会员中心</span></a>
</div>
<div class="foot">
    <ul class="flex foot_dom">
        <li class="flex-1 foot_item">
            <a href="/store/${product.store.id}" class="flex flex-v flex-align-center flex-pack-center foot_item_a checked">
                <div class="icon_box" style="height: 20px;"><img style="margin:0 auto;width: 24px;" src="/newResources/shop/images/dianpu.png" /></div>
                <p class="foot_item_p" style="color: #666;">店铺</p>
            </a>
        </li>
        <li class="flex-1 foot_item">
            <a href="/cart/list" class="flex flex-v flex-align-center flex-pack-center foot_item_a checked">
                <div class="icon_box" style="height: 20px;"><img style="margin:0 auto;width: 24px;" src="/newResources/shop/images/gouwuche.png" /></i>
                </div>
                <p class="foot_item_p" style="color: #666;">购物车</p>
            </a>
        </li>
        <div class="flex flex-align-center foot_item_btn_view">
	[#if product.type == "general" || product.type == "coupon"]
            <button type="button" class="foot_item_btn" onclick="goods_pop_show('order')" style="background:linear-gradient(-51deg,rgba(156,147,223,1) 0%,rgba(189,182,231,1) 100%);">添加购物车</button>
            <button type="button" class="foot_item_btn" onclick="goods_pop_show('buy')" style="background:linear-gradient(-54deg,rgba(146,168,251,1) 0%,rgba(167,204,252,1) 100%);">立即购买</button>
    [#elseif product.type == "exchange"]
            <button type="button" class="foot_item_btn" onclick="goods_pop_show('duihuan')" style="background:linear-gradient(-54deg,rgba(146,168,251,1) 0%,rgba(167,204,252,1) 100%);">立即兑换</button>
            [/#if]
        </div>
    </ul>
</div>
<div class="swiper-container goods_banner_container divList" style="margin-top: -40px;">
    <ul class="swiper-wrapper">
		[#if product.productImages?has_content]
			[#list product.productImages as productImage]
			  <li class="swiper-slide goods_banner_item">
                  <img src="${productImage.medium}" class="goods_banner_item_img">
              </li>
			[/#list]
		[#else]
		<li class="item active">
           <img class="img-responsive center-block" src="${setting.defaultMediumProductImage}">
         </li>
		[/#if]
    </ul>
</div>
<div class="gd_info">
    <div class="flex gd_info_price">
        <div class="flex flex-align-center flex-pack-center goods_price" id="xiajia">
        [#if product.type == "general" || product.type == "coupon"]
            <span style='font-size:26px;color:#f96d15;'><img style='width: 20px;' src='/newResources/shop/images/dbb.png'><span style='font-size: 24px;'>${newcurrency(defaultSku.price, "one")}</span><span style='font-size: 18px;'>${newcurrency(defaultSku.price, "two")}</span></span>
        [#elseif product.type == "exchange"]
        <span style='font-size:26px;color:#f96d15;'><img style='width: 20px;' src='/newResources/shop/images/dbb.png'><span style='font-size: 24px;'>${defaultSku.exchangePoint}</span><span style='font-size: 18px;'></span></span>
        [#elseif product.type == "gift"]
        <span style='font-size:26px;color:#f96d15;'><span style='font-size: 24px;'>${message("shop.product.giftNoBuy")}</span><span style='font-size: 18px;'></span></span>
        [/#if]
        </div>
        <div class="flex-1 flex flex-pack-end gd_info_op">
            <a href="javascript:addStoreFavorite()" class="flex flex-v flex-pack-center flex-align-center gd_info_op_a" id="addProductFavorite">
                <img style="width: 24px;" src="/newResources/shop/images/guanzhu.png" />
                <p class="gd_info_op_p">关注</p>
            </a>
            <a href="javascript:;" class="flex flex-v flex-pack-center flex-align-center gd_info_op_a">
                <img style="width: 24px;" src="/newResources/shop/images/zhuanfa.png" />
                <p class="gd_info_op_p">转发</p>
            </a>
        </div>
    </div>
    <p class="gd_info_name">	${product.name}</p>
    <p class="gd_info_text">${product.caption}</p>
</div>
<div class="divList">
    <div class="gd_option_box">
  [#if product.hasSpecification()]
        <a href="javascript:;" class="flex flex-align-center gd_option">
            <p class="gd_option_title">商品选择</p>
            <p class="flex-1 gd_option_value" onclick="goods_pop_show('order')">请选择</p>
            <i class="icon_1 icon_1_more_g"></i>
        </a>
        [/#if]
        [#if product.parameterValues?has_content]
        <a href="javascript:;" class="flex flex-align-center gd_option">
            <p class="gd_option_title">商品参数</p>
            <p class="flex-1 gd_option_value">${product.parameterValues}</p>
            <i class="icon_1 icon_1_more_g"></i>
        </a>
        [/#if]
    </div>
    <div class="gd_option_box">
        <a href="javascript:;" class="flex flex-align-center gd_option">
            <p class="gd_option_title">商品评价</p>
            <p class="flex-1 gd_option_value">99%好评</p>
            <i class="icon_1 icon_1_more_g"></i>
        </a>

    </div>
    <div class="gd_option_box">
        <a href="javascript:;" class="flex flex-align-center gd_option">
            <p class="gd_option_title">店铺名称</p>
            <p class="flex-1 gd_option_value" style="color: #f96d15;">${product.store.name}</p>
            <i class="icon_1 icon_1_more_g"></i>
        </a>
        <a href="javascript:;" class="flex flex-align-center gd_option">
            <p class="gd_option_title">店铺位置</p>
            <p class="flex-1 gd_option_value" style="font-size: 12px;line-height: 14px;">${product.store.detailAddress}</p>
            <i class="icon_1 icon_1_more_g"></i>
        </a>
    </div>
    <div class="gd_option_box">
        <a href="javascript:;" class="flex flex-align-center gd_option">
            <p class="gd_option_title">商品详情</p>
        </a>
    </div>
</div>

<div class="gd_detail divList"/>
	[#noautoesc]
		${product.introduction}
	[/#noautoesc]
</div>
[#if product.type == "general" || product.type == "exchange" || product.type == "coupon"]
<div style="display: none;" id="pop_goods">
    <div class="mask" onclick="goods_pop_hide()"></div>
    <div class="pop_bottom had_foot_body" style="min-height:200px;height:auto; bottom: 0;z-index: 1000">
        <div class="flex gd_pop_info">
            <div class="gd_pop_info_photo">
                <img src="${product.thumbnail!setting.defaultThumbnailProductImage}" alt="${product.name}" class="gd_pop_info_img">
            </div>
            <div class="flex-1 flex flex-v flex-pack-center gd_pop_info_text">
                <p class="gd_pop_info_name">${product.name}</p>
                <div class="flex gd_pop_info_other">
                    <div class="flex flex-align-center flex-pack-center goods_price" price="13900">
                        <div class="icon_box goods_icon_box"><i class="icon_1 icon_1_jf3"></i></div>
                        <p class="goods_price_num" id="skuPrice">
                            [#if product.type == "general" || product.type == "coupon"]
                                ${currency(defaultSku.price, false)}
                            [#elseif product.type == "exchange"]
                                ${defaultSku.exchangePoint}
                            [/#if]

                        </p>
                    </div>
                    <p class="flex-1 gd_pop_info_inventory">库存${defaultSku.stock}</p>
                </div>
            </div>
        </div>
        <div class="gd_pop_change">
            [#if product.hasSpecification()]
            [#list product.specificationItems as specificationItem]
            <p class="gd_pop_change_title">>${abbreviate(specificationItem.name, 8)}:</p>
            <div class="flex flex-w gd_pop_change_list">
                [#list specificationItem.entries as entry]
                <div class="gd_pop_change_item">
                    <input type="radio" name="gd_pop_change" id="gdpc${entry_index}" value="${entry.id}"/>
                    <label for="gdpc1" class="gd_pop_change_label">${entry.value}</label>
                </div>
                [/#list]
            </div>
            [/#list]
            [/#if]
        </div>
        <div class="flex flex-align-center gd_pop_change" style="height: 48px;padding-bottom: 7px;">
            <p class="flex-1 gd_pop_change_title">选择数量</p>
            <div class="flex goods_counter">
                <button type="button" class="gd_c_m" name="minus" onclick="num_minus(this)">-</button>
                <input class="flex-1 gd_c_i" id="quantity" type="num" name="num" value="1" onchange="num_change(this)" />
                <button type="button" class="gd_c_p" name="plus" onclick="num_plus(this)">+</button>
            </div>
        </div>
        <button class="gd_pop_add_shopcar" style="background:linear-gradient(-85deg,rgba(169,207,252,1) 0%,rgba(144,164,251,1) 21%,rgba(148,168,254,1) 54%,rgba(148,168,254,1) 71%,rgba(213,190,218,1) 100%);margin-bottom: 15px;" onclick="add_to_shopcar();" id="addCart">添加购物车</button>
        <button class="gd_pop_add_shopcar" style="display: none;background:linear-gradient(-85deg,rgba(169,207,252,1) 0%,rgba(144,164,251,1) 21%,rgba(148,168,254,1) 54%,rgba(148,168,254,1) 71%,rgba(213,190,218,1) 100%);margin-bottom: 15px;"  id="soonBuyButton">立即购买</button>
        <button class="gd_pop_add_shopcar" style="display: none;background:linear-gradient(-85deg,rgba(169,207,252,1) 0%,rgba(144,164,251,1) 21%,rgba(148,168,254,1) 54%,rgba(148,168,254,1) 71%,rgba(213,190,218,1) 100%);margin-bottom: 15px;"  id="duihuanButton">立即兑换</button>
        <button type="button" class="gd_pop_close" onclick="goods_pop_hide()">
            <span style=""><img style="width: 20px;" src="/newResources/shop/images/gb.png"/></span>
        </button>
    </div>
</div>
[/#if]
</body>
<script>
    var skuId = ${defaultSku.id};
    var skuData = {};
    [#if product.hasSpecification()]
        [#list product.skus as sku]
				skuData["${sku.specificationValueIds?join(",")}"] = {
                    id: ${sku.id},
                    price: ${sku.price},
                    marketPrice: ${sku.marketPrice},
                    rewardPoint: ${sku.rewardPoint},
                    exchangePoint: ${sku.exchangePoint},
                    isOutOfStock: ${sku.isOutOfStock?string("true", "false")}
                };
				skuId=null;
        [/#list]

    [/#if]
    function lockSpecificationValue() {
       var guigeid=$('input[name="gd_pop_change"]:checked').val();
        var sku = skuData[guigeid];
        if (sku != null) {
            skuId = sku.id;
            $("#skuPrice").html(currency(sku.price, false));

        }
    }
    function addStoreFavorite (){
        $.ajax({
            url: "${base}/member/product_favorite/add",
            type: "POST",
            data: {productId: ${product.id}},
            dataType: "json",
            cache: false
        });
        return false;
    }
	$(function () {
        wx.config({
            debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
            appId: '${appId}', // 必填，公众号的唯一标识
            timestamp: '${timestamp}' , // 必填，生成签名的时间戳
            nonceStr: '${nonceStr}', // 必填，生成签名的随机串
            signature: '${signature}',// 必填，签名，见附录1
            jsApiList: [
                'checkJsApi',
                'onMenuShareTimeline',//
                'onMenuShareAppMessage',
                'onMenuShareQQ',
                'onMenuShareWeibo'
            ]
        });
        window.share_config = {
            "share": {
                "imgUrl": '${productImg}',//分享图，默认当相对路径处理，所以使用绝对路径的的话，“http://”协议前缀必须在。
                "desc" : '${product.caption}',//摘要,如果分享到朋友圈的话，不显示摘要。
                "title" : '${product.name}',//分享卡片标题
                "link": window.location.href,//分享出去后的链接，这里可以将链接设置为另一个页面。
                "success":function(){//分享成功后的回调函数
                },
                'cancel': function () {
                    // 用户取消分享后执行的回调函数
                }
            }
        };
        wx.ready(function () {
            wx.onMenuShareAppMessage(share_config.share);//分享给好友
            wx.onMenuShareTimeline(share_config.share);//分享到朋友圈
            wx.onMenuShareQQ(share_config.share);//分享给手机QQ
        });
		$(".gd_detail").find("img").css("width","100%");
        // 添加店铺收藏
        $(".goods_banner_container").height($(document.body).width());
        var mySwiper = new Swiper('.goods_banner_container', {
            autoplay: 5000, //可选选项，自动滑动
            autoplayDisableOnInteraction: false,
        })
        $('.sy_hy').bind('click', function() {
            $('.sy_yh_tk').slideToggle();
        })
        // 加入购物车
        $("#addCart").click(function() {
            if (skuId == null) {
                $.alert("${message("shop.product.specificationTips")}");
                return false;
            }
            $.ajax({
                url: "${base}/cart/add",
                type: "POST",
                data: {
                    skuId: skuId,
                    quantity: $("#quantity").val()
                },
                dataType: "json",
                success: function() {
                    // 隐藏弹窗
                    goods_pop_hide();
                }
            });
        });
        // 立即购买
        $("#soonBuyButton").click(function() {
            if (skuId == null) {
                $.alert("${message("shop.product.specificationTips")}");
                return false;
            }
            $.ajax({
                url: "${base}/cart/add",
                type: "POST",
                data: {
                    skuId: skuId,
                    quantity: $("#quantity").val()
                },
                dataType: "json",
                success: function() {
                    window.location.href = "${base}/order/checkout?skuids="+skuId+"&allProduct=false";
                }
            });
        });
        // 积分兑换
        $("#duihuanButton").click(function() {
            if (skuId == null) {
                $.alert("${message("shop.product.specificationTips")}");
                return false;
            }
            $.ajax({
                url: "${base}/order/check_exchange",
                type: "GET",
                data: {
                    skuId: skuId,
                    quantity: $("#quantity").val()
                },
                dataType: "json",
                success: function() {
                    location.href = "${base}/order/checkout?type=exchange&skuId=" + skuId + "&quantity=" + $("#quantity").val()
                }
            });
        });
    });

    //商品数量减法
    function num_minus(btn) {
        var counter = btn.parentNode;
        var num_ipt = "";
        for(var mi = 0; mi < counter.children.length; mi++) {
            if(counter.children[mi].name == "num") {
                num_ipt = counter.children[mi];
            }
        }
        var num = parseInt(num_ipt.value);
        if(num - 1 < 1) {
            layer.open({
                content: "商品不能再减少了！",
                skin: 'msg',
                time: 2 //2秒后自动关闭
            });
        } else {
            num_ipt.value = num - 1;
            //计算购物车内商品数量和总价
            // count_price();
        }
        // console.log(num_ipt);
    }
    //商品数量加法
    function num_plus(btn) {
        var counter = btn.parentNode;
        var num_ipt = "";
        for(var pi = 0; pi < counter.children.length; pi++) {
            if(counter.children[pi].name == "num") {
                num_ipt = counter.children[pi];
            }
        }
        var num = parseInt(num_ipt.value);
        num_ipt.value = num + 1;
        //计算购物车内商品数量和总价
        // count_price();
        // console.log(num_ipt);
    }
    //直接输入商品数量
    function num_change(ipt) {
        var counter = ipt.parentNode;
        var num_ipt = ipt;
        if(isNaN(parseInt(num_ipt.value))) {
            $.alert("输入内容不合规");
        } else {
            num_ipt.value = parseInt(num_ipt.value);
            if(parseInt(num_ipt.value) < 1) {
                $.alert("至少添加一件商品！");
                num_ipt.value = 1;
            }
        }
    }

    //显示弹窗
    function goods_pop_show(flag) {
        var pop_goods = document.getElementById('pop_goods');
        pop_goods.style.display = "block";
        if(flag=="order"){
            $("#addCart").show();
            $("#soonBuyButton").hide();
            $("#duihuanButton").hide()
        }
        if(flag=="buy"){
            $("#addCart").hide();
            $("#soonBuyButton").show();
            $("#duihuanButton").hide()
        }
        if(flag=="duihuan"){
            $("#addCart").hide();
            $("#soonBuyButton").hide();
            $("#duihuanButton").show()
        }
    }
    // 隐藏弹窗
    function goods_pop_hide() {
        var pop_goods = document.getElementById('pop_goods');
        pop_goods.style.display = "none";
    }
    //添加到购物车
    function add_to_shopcar() {
        goods_pop_hide();
        var gd_pop_change = document.getElementsByName('gd_pop_change');
        var clist = [];
        for(var gpci = 0; gpci < gd_pop_change.length; gpci++) {
            if(gd_pop_change[gpci].checked == true) {
                clist.push(gd_pop_change[gpci]);
            }
        }
        //“选择颜色”被选中的按钮
        console.log(clist);
    }

</script>

<script>
    var newPos = undefined;
    var myReq = undefined;
    var nav = document.querySelector('.nav');
    var navTop = nav.offsetTop;

    var navList = document.getElementsByClassName('itemlist');
    var list = document.getElementsByClassName('divList');

    window.addEventListener('scroll', function() {
        var scrollTop = document.documentElement.scrollTop;
        if(scrollTop >= navTop) {
            if(nav.className.indexOf('fixed') === -1) {
                nav.className += ' fixed';
            }
        } else {
            nav.className = 'nav';
        }

        Array.from(list).forEach(function(itemlist, index) {
            navList[index].className = 'itemlist';
            if(scrollTop >= itemlist.offsetTop && scrollTop < itemlist.offsetTop + itemlist.clientHeight) {
                navList[index].className += ' active';
            }
            if(scrollTop <= list[0].offsetTop) {
                navList[0].className += ' active';
            }
        })
    })

    Array.from(navList).forEach(function(itemlist, index) {
        itemlist.addEventListener('click', function() {
            Array.from(navList).forEach(function(liItem) {
                liItem.className = 'itemlist';
            })
            itemlist.className += ' active';
            newPos = list[index].offsetTop;
            window.cancelAnimationFrame(myReq);
            move();
        })
    })

    function move() {
        if(Math.abs(document.documentElement.scrollTop - newPos) < 20) {
            document.documentElement.scrollTop = newPos;
            return
        }
        if(document.documentElement.scrollTop > newPos) {
            document.documentElement.scrollTop -= 20;
        } else {
            document.documentElement.scrollTop += 20;
        }
        myReq = requestAnimationFrame(move);
    }
</script>
<script type="text/javascript">
    window.onload = function() {
        window.onscroll = function() {
            var h = document.documentElement.scrollTop || document.body.scrollTop;
            var headerTop = document.getElementById("header");
            var jt_return = document.getElementById("jt_return");
            var caidan_bg = document.getElementById("caidan_bg");
            var zj = document.getElementById("zj");
            // console.log(h)
            if(h <= 40) { //header的高度是40px;
                var a = h / 500;
                zj.style.opacity = 0;
                headerTop.style.opacity = 0;
                jt_return.style.background = "rgba(0,0,0,0.5)";
                caidan_bg.style.background = "rgba(0,0,0,0.5)";
                headerTop.style.opacity = "rgba(0,0,0,0)"
                headerTop.style.color = a;
            } else if(h > 40 && h <= 100) {
                headerTop.style.opacity = h / 100;
                headerTop.style.color = "rgba(255,255,255," + h / 100 + ")";
                zj.style.opacity = h / 100;
                if(h > 40 && h <= 100) {
                    var b = 1 - h / 100;
                    //						console.log("b" + b)
                    jt_return.style.background = "rgba(0,0,0," + b + ")";
                    caidan_bg.style.background = "rgba(0,0,0," + b + ")";
                }
            } else {
                jt_return.style.background = "rgba(0,0,0,0)";
                caidan_bg.style.background = "rgba(0,0,0,0)";
                headerTop.style.opacity = 1;
            }
        };
    }
</script>
</html>