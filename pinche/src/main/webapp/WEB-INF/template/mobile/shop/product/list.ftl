<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	[#if productCategory??]
		[@seo type = "productList"]
			[#if productCategory.resolveSeoKeywords()?has_content]
				<meta name="keywords" content="${productCategory.resolveSeoKeywords()}">
			[#elseif seo.resolveKeywords()?has_content]
				<meta name="keywords" content="${seo.resolveKeywords()}">
			[/#if]
			[#if productCategory.resolveSeoDescription()?has_content]
				<meta name="description" content="${productCategory.resolveSeoDescription()}">
			[#elseif seo.resolveDescription()?has_content]
				<meta name="description" content="${seo.resolveDescription()}">
			[/#if]
			<title>[#if productCategory.resolveSeoTitle()?has_content]${productCategory.resolveSeoTitle()}[#else]${seo.resolveTitle()}[/#if][#if showPowered] [/#if]</title>
		[/@seo]
	[#else]
		<title>${message("shop.product.title")}</title>
	[/#if]
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/shop/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/product.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/shop/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/shop/js/jquery.js"></script>
	<script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/shop/js/velocity.js"></script>
	<script src="${base}/resources/mobile/shop/js/velocity.ui.js"></script>
	<script src="${base}/resources/mobile/shop/js/underscore.js"></script>
	<script src="${base}/resources/mobile/shop/js/common.js"></script>
    <script src="${base}/resources/shop/js/jweixin.js"></script>
    <script type="text/javascript" src="${base}/resources/statistic/browsestatistical.js"></script>
	<style>
        .footergwc{background: #2cb6f1;
            height: 4rem;
            line-height: 4rem;
            color: #fff;
            position: relative;
        }
        .footergwc a{    display: block;
            background: url(/resources/mobile/shop/images/gwc.png) 0 center no-repeat;
            background-size: 2.8rem auto;
            color: #fff;
            padding-left: 3.6rem;
            float: left;
            left:44%;
            margin-left:-3rem;
            position:absolute;
        }
	</style>
	<script id="productTemplate" type="text/template">
		<%_.each(products, function(product, i) {%>
			<div>
				<div class="thumbnail thumbnail-flat thumbnail-condensed" style="height: 14rem;margin: .5rem;border: 0px;border-bottom:1px solid #d5d5d5;">
					<a href="${base}<%-product.path%>">
						<img style="max-width: 11rem;width: 11rem;float: left;overflow:hidden;display: block;margin: 1rem;" class="img-responsive center-block" src="<%-product.thumbnail != null ? product.thumbnail : "${setting.defaultThumbnailProductImage}"%>" alt="<%-product.name%>">
						<h4 class="text-overflow" style="margin-top: 10px;"><%-product.name%></h4>
						<p class="text-overflow text-muted small" style="color: #ff7700"><%-product.caption%></p>
					</a>
					<%if (product.type == "general") {%>
						<strong class="red" style="font-size: 14px"><img style="width: 14px;height: 14px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/><%-currency(product.price, false)%></strong>
                    <span style="text-decoration: line-through;font-size: 10px;color: #b8b8b8;">市场价:<%-currency(product.marketPrice, false)%>元</span>
					<%} else if (product.type == "exchange") {%>
						<span class="small">${message("Sku.exchangePoint")}:</span>
						<strong class="red"><%-product.defaultSku.exchangePoint%></strong>
					<%}%>
                    <span style="font-size: 10px;display: block;color: #666666;text-align: right;">已售&nbsp;<%-formatProductSals(product.sales, true)%></span>
					<p>
						<%if (product.store.type == "self") {%>
							<em class="small">${message("Store.Type.self")}</em>
						<%}%>
						<a class="small gray-darker" href="${base}<%-product.store.path%>" title="<%-product.store.name%>" style="font-size: 10px;"><%-abbreviate(product.store.name, 20, "...")%></a>
					</p>
				</div>
			</div>
		<%})%>
	</script>
	<script type="text/javascript">
		function formatProductSals(num,isFormat){
		    if(!isFormat){
				return (num*1+5)*2;
			}
			return num;
		}
	$().ready(function() {
		
		var $filter = $("#filter");
		var $filterContent = $("#filter div.filter-content");
		var $filterBrand = $("#filter a.brand");
		var $filterAttribute = $("#filter a.attribute");
		var $filterComplete = $("#filter button.filter-complete");
		var $searchForm = $("#searchForm");
		var $keyword = $("#keyword");
		var $order = $("#order");
		var $orderType = $("#order a[data-order-type]");
		var $filterButton = $("#filterButton");
		var $productItems = $("#list div.row");
		var productTemplate = _.template($("#productTemplate").html());
		var data = {
			productCategoryId: ${(productCategory.id)!"null"},
			storeProductCategoryId: ${(storeProductCategory.id)!"null"},
			brandId: ${(brand.id)!"null"},
			promotionId: ${(promotion.id)!"null"},
            productTagId: ${(productTag.id)!"null"},
			orderType: null
		}
		
		// 搜索
		$searchForm.submit(function() {
			if ($.trim($keyword.val()) == "") {
				return false;
			}
		});
		
		// 排序
		$orderType.click(function() {
			var $element = $(this);
			if ($element.hasClass("active")) {
				return;
			}
			
			$order.find(".active").removeClass("active");
			$element.addClass("active");
			var $dropdown = $element.closest(".dropdown");
			if ($dropdown.size() > 0) {
				$dropdown.find("a[data-toggle='dropdown'] strong").text($element.data("title")).addClass("active");
			}
			
			data.orderType = $element.data("order-type");
			$productItems.infiniteScroll("refresh");
		});
		
		// 筛选
		$filterButton.click(function() {
			var $element = $(this);
			if ($element.hasClass("disabled")) {
				return;
			}
			$filter.velocity("transition.slideRightBigIn").parent().velocity("fadeIn");
		});
		
		// 筛选
		$filterComplete.click(function() {
			$filter.velocity("transition.slideRightBigOut").parent().velocity("fadeOut");
		});
		
		// 筛选品牌
		$filterBrand.click(function() {
			var $element = $(this);
			
			if ($element.hasClass("active")) {
				$element.removeClass("active");
				data.brandId = null;
			} else {
				$element.addClass("active").parent().siblings("dd").find("a.active").removeClass("active");
				data.brandId = $element.data("brand-id");
			}
			
			$productItems.infiniteScroll("refresh");
			return false;
		});
		
		// 筛选属性
		$filterAttribute.click(function() {
			var $element = $(this);
			var attributeName = $element.data("attribute-name");
			var attributeOption = $element.data("attribute-option");
			
			if ($element.hasClass("active")) {
				$element.removeClass("active");
				data[attributeName] = null;
			} else {
				$element.addClass("active").parent().siblings("dd").find("a.active").removeClass("active");
				data[attributeName] = attributeOption;
			}
			
			$productItems.infiniteScroll("refresh");
			return false;
		});
		
		// 无限滚动加载
		$productItems.infiniteScroll({
			url: function(pageNumber) {
				return "${base}/product/list?pageNumber=" + pageNumber;
			},
			data: data,
			pageSize: 20,
			template: function(pageNumber, data) {
				return productTemplate({
					products: data
				});
			}
		});


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
                "imgUrl": 'http://www.lifeabb.com/upload/image/shareProductList.jpg',//分享图，默认当相对路径处理，所以使用绝对路径的的话，“http://”协议前缀必须在。
                "desc" : '${productCategory.seoDescription}',//摘要,如果分享到朋友圈的话，不显示摘要。
                "title" : '${productCategory.seoTitle}',//分享卡片标题
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

        var url = window.location.href;
        if(url.indexOf("?from") > 0){
            url = url.substring(0,url.indexOf("?from"));
            console.log(url);
            window.location.href = url;
		}
        getCartSize();
	});
        function getCartSize(){
            $.ajax({
                url: "/cart/size",
                type: "GET",
                dataType: "json",
                cache: false,
                success: function(data) {
                    $("#cartSize").html(data.size);
                    $("#cartAmount").html(data.amount);
                }
            });
        }
	</script>
</head>
<body class="product-list">
	[#if productCategory??]
		[@product_category_children_list productCategoryId = productCategory.id recursive = false]
			[#assign filterProductCategories = productCategories /]
		[/@product_category_children_list]
		[@brand_list productCategoryId = productCategory.id]
			[#assign filterBrands = brands /]
		[/@brand_list]
		[@attribute_list productCategoryId = productCategory.id]
			[#assign filterAttributes = attributes /]
		[/@attribute_list]
		<div class="filter-wrapper">
			<div id="filter" class="filter">
				<div class="filter-content">
					<div class="filter-body">
						[#if filterProductCategories?has_content]
							<dl class="clearfix">
								<dt>${message("shop.product.productCategory")}</dt>
								[#list filterProductCategories as filterProductCategory]
									<dd>
										<a href="${base}${filterProductCategory.path}">${filterProductCategory.name}</a>
									</dd>
								[/#list]
							</dl>
						[/#if]
						[#if filterBrands?has_content]
							<dl class="clearfix">
								<dt>${message("shop.product.brand")}</dt>
								[#list filterBrands as filterBrand]
									<dd>
										<a class="brand[#if filterBrand == brand] active[/#if]" href="javascript:;" data-brand-id="${filterBrand.id}">${filterBrand.name}</a>
									</dd>
								[/#list]
							</dl>
						[/#if]
						[#list filterAttributes as filterAttribute]
							<dl class="clearfix">
								<dt>${abbreviate(filterAttribute.name)}</dt>
								[#list filterAttribute.options as option]
									<dd>
										<a class="attribute[#if attributeValueMap.get(filterAttribute) == option] active[/#if]" href="javascript:;" data-attribute-name="attribute_${filterAttribute.id}" data-attribute-option="${option}">${option}</a>
									</dd>
								[/#list]
							</dl>
						[/#list]
					</div>
					<div class="filter-footer">
						<button style="background: rgb(148,168,254);" class="filter-complete btn btn-lg btn-primary btn-flat btn-block" type="button">${message("shop.product.complete")}</button>
					</div>
				</div>
			</div>
		</div>
	[/#if]
	<header class="header-fixed" style="padding: 0px;">
		<div class="container-fluid">
			<div class="row" style="background:linear-gradient(-85deg,rgba(169,207,252,1) 0%,rgba(144,164,251,1) 21%,rgba(148,168,254,1) 54%,rgba(148,168,254,1) 71%,rgba(213,190,218,1) 100%);line-height: 4rem;">
				[#if storeProductCategory??]
                    <div style="background-size:auto 2rem;background: url(/newResources/member/images/btnBack.png) 0 center no-repeat;text-align:center;margin-left:10px;background-size:auto 2rem;font-size: 1.6rem" onclick="javascript: history.back();">
                        商品列表
					[#--<var class="cityjjj"></var>--]
                    </div>
				    [#else]
                        <div class="col-xs-2 text-center">
                            <a href="javascript: history.back();">
                                <span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF;top: 3px;"></span>
                            </a>
                        </div>
                        <div class="col-xs-8">
                            <form id="searchForm" action="${base}/product/search" method="get">
								[#if storeProductCategory??]
                                    <input name="storeId" type="hidden" value="${storeProductCategory.store.id}">
								[/#if]
                                <div class="input-group" style="border: none">
                                    <input id="keyword" name="keyword" class="form-control" style="float: none;" type="text" placeholder="${message("shop.product.search")}">
                                    <span class="input-group-btn">
								<button class="btn btn-default" type="submit" style="height: 34px;">
									<span class="glyphicon glyphicon-search" style="color: rgb(148,168,254);"></span>
								</button>
							</span>
                                </div>
                            </form>
                        </div>
                        <div class="col-xs-2 text-center">
                            <div class="menu dropdown">
                                <a href="javascript:;" data-toggle="dropdown">
                                    [#--<span class="glyphicon glyphicon-th-list" style="color: #FFFFFF"></span>--]
                                    [#--<span class="caret" style="color: #FFFFFF"></span>--]
										<img style="width: 4px;height: 15px;" src="${base}/newResources/shop/images/caidan.png" alt="">
                                </a>
                                <ul class="dropdown-menu" style="min-width: 120px;">
                                    <li>
                                        <a href="${base}/">
                                            <span class="glyphicon glyphicon-home"></span>
										${message("shop.common.index")}
                                        </a>
                                    </li>
                                    <li>
                                        <a href="${base}/cart/list">
                                            <span class="glyphicon glyphicon-shopping-cart"></span>
										购物车
                                        </a>
                                    </li>
                                    <li>
                                        <a href="${base}/member/index">
                                            <span class="glyphicon glyphicon-user"></span>
										${message("shop.common.member")}
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>
				[/#if]


			</div>
			<div id="order" class="order">
				<div class="row">
					<div class="col-xs-3 text-center">
						<div class="dropdown">
							<a href="javascript:;" data-toggle="dropdown">
								<strong>${message("shop.product.defaultTitle")}</strong>
								<span class="caret"></span>
							</a>
							<ul class="dropdown-menu">
								<li>
									<a href="javascript:;" data-order-type="topDesc" data-title="${message("shop.product.defaultTitle")}">${message("shop.product.default")}</a>
								</li>
								<li>
									<a href="javascript:;" data-order-type="priceAsc" data-title="${message("shop.product.priceAscTitle")}">${message("shop.product.priceAsc")}</a>
								</li>
								<li>
									<a href="javascript:;" data-order-type="priceDesc" data-title="${message("shop.product.priceDescTitle")}">${message("shop.product.priceDesc")}</a>
								</li>
							</ul>
						</div>
					</div>
					<div class="col-xs-3 text-center">
						<a href="javascript:;" data-order-type="salesDesc">
							${message("shop.product.salesDescTitle")}
							<span class="fa fa-long-arrow-down"></span>
						</a>
					</div>
					<div class="col-xs-3 text-center">
						<a href="javascript:;" data-order-type="scoreDesc">
							${message("shop.product.scoreDescTitle")}
							<span class="fa fa-long-arrow-down"></span>
						</a>
					</div>
					<div class="col-xs-3 text-center">
						<a id="filterButton"[#if !filterProductCategories?has_content && !filterBrands?has_content && !filterAttributes?has_content] class="disabled"[/#if] href="javascript:;">
							${message("shop.product.filterTitle")}
							<span class="glyphicon glyphicon-filter"></span>
						</a>
					</div>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<div id="list" class="list">
				<div class="row"></div>
			</div>
		</div>
	</main>
    <footer class="footer-fixed" style="padding:0;">
        <div class="footergwc" style="background: rgb(148,168,254);">
            <a href="${base}/cart/list">购物车(<span id="cartSize">0</span>件)<span id="cartAmount" style="font-size: 12px;"></span></a>
        </div>
    </footer>
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
</body>
</html>