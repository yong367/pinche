<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
[#if productCategory??]
	[@seo type = "productList"]
		<title>[#if productCategory.resolveSeoTitle()?has_content]${productCategory.resolveSeoTitle()}[#else]${seo.resolveTitle()}[/#if][#if showPowered] [/#if]</title>
		<meta name="author" content="技术部" />
		<meta name="copyright" content="SHOP" />
		[#if productCategory.resolveSeoKeywords()?has_content]
			<meta name="keywords" content="${productCategory.resolveSeoKeywords()}" />
		[#elseif seo.resolveKeywords()?has_content]
			<meta name="keywords" content="${seo.resolveKeywords()}" />
		[/#if]
		[#if productCategory.resolveSeoDescription()?has_content]
			<meta name="description" content="${productCategory.resolveSeoDescription()}" />
		[#elseif seo.resolveDescription()?has_content]
			<meta name="description" content="${seo.resolveDescription()}" />
		[/#if]
	[/@seo]
[#else]
	<title>${message("shop.product.title")}[#if showPowered] [/#if]</title>
	<meta name="author" content="技术部" />
	<meta name="copyright" content="SHOP" />
[/#if]
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/product.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.lazyload.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
    <script src="${base}/resources/shop/js/jweixin.js"></script>
    <script type="text/javascript" src="${base}/resources/statistic/browsestatistical.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $headerCart = $("#headerCart");
	var $compareBar = $("#compareBar");
	var $compareForm = $("#compareBar form");
	var $compareSubmit = $("#compareBar a.submit");
	var $clearCompare = $("#compareBar a.clear");
	var $productForm = $("#productForm");
	var $brandId = $("#brandId");
    var $productTagId = $("#productTagId");
	var $promotionId = $("#promotionId");
	var $orderType = $("#orderType");
	var $pageNumber = $("#pageNumber");
	var $pageSize = $("#pageSize");
	var $filter = $("#filter dl");
	var $hiddenFilter = $("#filter dl:hidden");
	var $moreOption = $("#filter dd.moreOption");
	var $brand = $("#filter a.brand");
	var $attribute = $("#filter a.attribute");
	var $moreFilter = $("#moreFilter a");
	var $gridType = $("#gridType");
	var $listType = $("#listType");
	var $size = $("#layout a.size");
	var $previousPage = $("#previousPage");
	var $nextPage = $("#nextPage");
	var $sort = $("#sort a, #sort li");
	var $orderMenu = $("#orderMenu");
	var $startPrice = $("#startPrice");
	var $endPrice = $("#endPrice");
	var $result = $("#result");
	var $productImage = $("#result img");
	var $addCart = $("#result a.addCart");
	var $exchange = $("#result a.exchange");
	var $addProductFavorite = $("#result a.addProductFavorite");
	var $addCompare = $("#result a.addCompare");
	
	[#if productCategory??]
		$filter.each(function() {
			var $this = $(this);
			var scrollHeight = this.scrollHeight > 0 ? this.scrollHeight: $.swap(this, {display: "block", position: "absolute", visibility: "hidden"}, function() {
				return this.scrollHeight;
			});
			if (scrollHeight > 50) {
				if ($this.find("a.current").size() > 0) {
					$this.height("auto");
				} else {
					$this.find("dd.moreOption").show();
				}
			}
		});
		
		$moreOption.click(function() {
			var $this = $(this);
			if ($this.hasClass("close")) {
				$this.removeClass("close");
				$this.attr("title", "${message("shop.product.moreOption")}");
				$this.parent().height(50);
			} else {
				$this.addClass("close");
				$this.attr("title", "${message("shop.product.closeOption")}");
				$this.parent().height("auto");
			}
		});
		
		$moreFilter.click(function() {
			var $this = $(this);
			if ($this.hasClass("close")) {
				$this.removeClass("close");
				$this.text("${message("shop.product.moreFilter")}");
				$hiddenFilter.hide();
			} else {
				$this.addClass("close");
				$this.text("${message("shop.product.closeFilter")}");
				$hiddenFilter.show();
			}
			return false;
		});
		
		$brand.click(function() {
			var $this = $(this);
			if ($this.hasClass("current")) {
				$brandId.val("");
			} else {
				$brandId.val($this.attr("brandId"));
			}
			$pageNumber.val(1);
			$productForm.submit();
			return false;
		});
		
		$attribute.click(function() {
			var $this = $(this);
			if ($this.hasClass("current")) {
				$this.closest("dl").find("input").prop("disabled", true);
			} else {
				$this.closest("dl").find("input").prop("disabled", false).val($this.text());
			}
			$pageNumber.val(1);
			$productForm.submit();
			return false;
		});
	[/#if]
	
	var layoutType = getCookie("layoutType");
	if (layoutType == "listType") {
		$listType.addClass("currentList");
		$result.removeClass("grid").addClass("list");
	} else {
		$gridType.addClass("currentGrid");
		$result.removeClass("list").addClass("grid");
	}
	
	$gridType.click(function() {
		var $this = $(this);
		if (!$this.hasClass("currentGrid")) {
			$this.addClass("currentGrid");
			$listType.removeClass("currentList");
			$result.removeClass("list").addClass("grid");
			addCookie("layoutType", "gridType");
		}
		return false;
	});
	
	$listType.click(function() {
		var $this = $(this);
		if (!$this.hasClass("currentList")) {
			$this.addClass("currentList");
			$gridType.removeClass("currentGrid");
			$result.removeClass("grid").addClass("list");
			addCookie("layoutType", "listType");
		}
		return false;
	});
	
	$size.click(function() {
		var $this = $(this);
		$pageNumber.val(1);
		$pageSize.val($this.attr("pageSize"));
		$productForm.submit();
		return false;
	});
	
	$previousPage.click(function() {
		$pageNumber.val(${page.pageNumber - 1});
		$productForm.submit();
		return false;
	});
	
	$nextPage.click(function() {
		$pageNumber.val(${page.pageNumber + 1});
		$productForm.submit();
		return false;
	});
	
	$orderMenu.hover(
		function() {
			$(this).children("ul").show();
		}, function() {
			$(this).children("ul").hide();
		}
	);
	
	$sort.click(function() {
		var $this = $(this);
		if ($this.hasClass("current")) {
			$orderType.val("");
		} else {
			$orderType.val($this.attr("orderType"));
		}
		$pageNumber.val(1);
		$productForm.submit();
		return false;
	});
	
	$startPrice.add($endPrice).focus(function() {
		$(this).siblings("button").show();
	});
	
	$startPrice.add($endPrice).keypress(function(event) {
		return (event.which >= 48 && event.which <= 57) || (event.which == 46 && $(this).val().indexOf(".") < 0) || event.which == 8 || event.which == 13;
	});
	
	$productForm.submit(function() {
		if ($brandId.val() == "") {
			$brandId.prop("disabled", true);
		}
        if ($productTagId.val() == "") {
            $productTagId.prop("disabled", true);
        }
		if ($promotionId.val() == "") {
			$promotionId.prop("disabled", true);
		}
		if ($orderType.val() == "" || $orderType.val() == "topDesc") {
			$orderType.prop("disabled", true);
		}
		if ($pageNumber.val() == "" || $pageNumber.val() == "1") {
			$pageNumber.prop("disabled", true);
		}
		if ($pageSize.val() == "" || $pageSize.val() == "20") {
			$pageSize.prop("disabled", true);
		}
		if ($startPrice.val() == "" || !/^\d+(\.\d+)?$/.test($startPrice.val())) {
			$startPrice.prop("disabled", true);
		}
		if ($endPrice.val() == "" || !/^\d+(\.\d+)?$/.test($endPrice.val())) {
			$endPrice.prop("disabled", true);
		}
		if ($productForm.serializeArray().length < 1) {
			location.href = location.pathname;
			return false;
		}
	});
	
	$productImage.lazyload({
		threshold: 100,
		effect: "fadeIn"
	});
	
	// 加入购物车
	$addCart.click(function() {
		var $this = $(this);
		var skuId = $this.attr("skuId");
		$.ajax({
			url: "${base}/cart/add",
			type: "POST",
			data: {skuId: skuId, quantity: 1},
			dataType: "json",
			success: function() {
				if ($headerCart.size() > 0 && window.XMLHttpRequest) {
					var $image = $this.closest("li").find("img");
					var cartOffset = $headerCart.offset();
					var imageOffset = $image.offset();
					$image.clone().css({
						width: 170,
						height: 170,
						position: "absolute",
						"z-index": 20,
						top: imageOffset.top,
						left: imageOffset.left,
						opacity: 0.8,
						border: "1px solid #dddddd",
						"background-color": "#eeeeee"
					}).appendTo("body").animate({
						width: 30,
						height: 30,
						top: cartOffset.top,
						left: cartOffset.left,
						opacity: 0.2
					}, 1000, function() {
						$(this).remove();
					});
				}
			}
		});
		return false;
	});
	
	// 积分兑换
	$exchange.click(function() {
		var skuId = $(this).attr("skuId");
		$.ajax({
			url: "${base}/order/check_exchange",
			type: "GET",
			data: {skuId: skuId, quantity: 1},
			dataType: "json",
			cache: false,
			success: function() {
				location.href = "${base}/order/checkout?type=exchange&skuId=" + skuId + "&quantity=1";
			}
		});
		return false;
	});
	
	// 添加SKU收藏
	$addProductFavorite.click(function() {
		var productId = $(this).attr("productId");
		$.ajax({
			url: "${base}/member/product_favorite/add",
			type: "POST",
			data: {productId: productId},
			dataType: "json",
		});
		return false;
	});
	
	// 对比栏
	var compareProduct = getCookie("compareProduct");
	var compareProductIds = compareProduct != null ? compareProduct.split(","): [];
	if (compareProductIds.length > 0) {
		$.ajax({
			url: "${base}/product/compare_bar",
			type: "GET",
			data: {productIds: compareProductIds},
			dataType: "json",
			cache: true,
			success: function(data) {
				$.each(data, function (i, item) {
					var thumbnail = item.thumbnail != null ? item.thumbnail: "${setting.defaultThumbnailProductImage}";
					$compareBar.find("dt").after(
						[@compress single_line = true]
							'<dd>
								<input type="hidden" name="productIds" value="' + item.id + '" \/>
								<a href="${base}' + escapeHtml(item.path) + '" target="_blank">
									<img src="' + escapeHtml(thumbnail) + '" \/>
									<span title="' + escapeHtml(item.name) + '">' + escapeHtml(abbreviate(item.name, 50)) + '<\/span>
								<\/a>
								<strong><img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>' + currency(item.price, false) + '[#if setting.isShowMarketPrice]<del><img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>' + currency(item.marketPrice, false) + '<\/del>[/#if]<\/strong>
								<a href="javascript:;" class="remove" productId="' + item.id + '">[${message("shop.common.delete")}]<\/a>
							<\/dd>'
						[/@compress]
					);
				});
				$compareBar.fadeIn();
			}
		});
		
		$.each(compareProductIds, function(i, productId) { 
			$addCompare.filter("[productId='" + productId + "']").addClass("selected");
		});
	}
	
	// 移除对比
	$compareBar.on("click", "a.remove", function() {
		var $this = $(this);
		var productId = $this.attr("productId");
		$this.closest("dd").remove();
		for (var i = 0; i < compareProductIds.length; i ++) {
			if (compareProductIds[i] == productId) {
				compareProductIds.splice(i, 1);
				break;
			}
		}
		$addCompare.filter("[productId='" + productId + "']").removeClass("selected");
		if (compareProductIds.length == 0) {
			$compareBar.fadeOut();
			removeCookie("compareProduct");
		} else {
			addCookie("compareProduct", compareProductIds.join(","));
		}
		return false;
	});
	
	$compareSubmit.click(function() {
		if (compareProductIds.length < 2) {
			$.alert("${message("shop.product.compareNotAllowed")}");
			return false;
		}
		
		$compareForm.submit();
		return false;
	});
	
	// 清除对比
	$clearCompare.click(function() {
		$addCompare.removeClass("selected");
		$compareBar.fadeOut().find("dd:not(.action)").remove();
		compareProductIds = [];
		removeCookie("compareProduct");
		return false;
	});
	
	// 添加对比
	$addCompare.click(function() {
		var $this = $(this);
		var productId = $this.attr("productId");
		if ($.inArray(productId, compareProductIds) >= 0) {
			return false;
		}
		if (compareProductIds.length >= 4) {
			$.alert("${message("shop.product.addCompareNotAllowed")}");
			return false;
		}
		$.ajax({
			url: "${base}/product/add_compare",
			type: "GET",
			data: {productId: productId},
			dataType: "json",
			cache: false,
			success: function(data) {
				$this.addClass("selected");
				var thumbnail = data.thumbnail != null ? data.thumbnail: "${setting.defaultThumbnailProductImage}";
				$compareBar.show().find("dd.action").before(
					[@compress single_line = true]
						'<dd>
							<input type="hidden" name="productIds" value="' + data.id + '" \/>
							<a href="${base}' + escapeHtml(data.path) + '" target="_blank">
								<img src="' + escapeHtml(thumbnail) + '" \/>
								<span title="' + escapeHtml(data.name) + '">' + escapeHtml(abbreviate(data.name, 50)) + '<\/span>
							<\/a>
							<strong><img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>' + currency(data.price, false) + '[#if setting.isShowMarketPrice]<del><img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>' + currency(data.marketPrice, false) + '<\/del>[/#if]<\/strong>
							<a href="javascript:;" class="remove" productId="' + data.id + '">[${message("shop.common.delete")}]<\/a>
						<\/dd>'
					[/@compress]
				);
				compareProductIds.unshift(productId);
				addCookie("compareProduct", compareProductIds.join(","));
			}
		});
		return false;
	});
	
	$.pageSkip = function(pageNumber) {
		$pageNumber.val(pageNumber);
		$productForm.submit();
		return false;
	}
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

});
</script>
</head>
<body>
	[#include "/shop/include/header.ftl" /]
	<div class="container products">
		<div id="compareBar" class="compareBar">
			<form action="${base}/product/compare" method="get">
				<dl>
					<dt>${message("shop.product.compareBar")}</dt>
					<dd class="action">
						<a href="javascript:;" class="submit">${message("shop.product.compareSubmit")}</a>
						<a href="javascript:;" class="clear">${message("shop.product.clearCompare")}</a>
					</dd>
				</dl>
			</form>
		</div>
		<div class="row">
			<div class="span2 list-span2">
				[#include "/shop/include/hot_product_category.ftl" /]
				[#--[#include "/shop/include/hot_brand.ftl" /]--]
				[#include "/shop/include/hot_product.ftl" /]
				[#include "/shop/include/hot_promotion.ftl" /]
			</div>
			<div class="span10 list-span10">
				<div class="breadcrumb">
					<ul>
						<li>
							<a href="${base}/">${message("shop.breadcrumb.home")}</a>
						</li>
						[#if productCategory??]
							[@product_category_parent_list productCategoryId = productCategory.id]
								[#list productCategories as productCategory]
									<li>
										<a href="${base}${productCategory.path}">${productCategory.name}</a>
									</li>
								[/#list]
							[/@product_category_parent_list]
							<li>${productCategory.name}</li>
						[#else]
							<li>${message("shop.product.title")}</li>
						[/#if]
					</ul>
				</div>
				<form id="productForm" action="${base}${(productCategory.path)!"/product/list"}" method="get">
					<input type="hidden" name="storeProductCategoryId" value="${(storeProductCategory.id)!}" />
					<input type="hidden" id="brandId" name="brandId" value="${(brand.id)!}" />
                    <input type="hidden" id="productTagId" name="productTagId" value="${(productTag.id)!}" />
					<input type="hidden" id="promotionId" name="promotionId" value="${(promotion.id)!}" />
					<input type="hidden" id="orderType" name="orderType" value="${orderType}" />
					<input type="hidden" id="type" name="type" value="${type}" />
					<input type="hidden" id="pageNumber" name="pageNumber" value="${page.pageNumber}" />
					<input type="hidden" id="pageSize" name="pageSize" value="${page.pageSize}" />
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
						[#if filterProductCategories?has_content || filterBrands?has_content || filterAttributes?has_content]
							<div id="filter" class="filter">
								<div class="title">${message("shop.product.filter")}</div>
								<div class="content">
									[#assign rows = 0 /]
									[#if filterProductCategories?has_content]
										[#assign rows = rows + 1 /]
										<dl class="clearfix">
											<dt>${message("shop.product.productCategory")}:</dt>
											[#list filterProductCategories as filterProductCategory]
												<dd>
													<a href="${base}${filterProductCategory.path}">${filterProductCategory.name}</a>
												</dd>
											[/#list]
											<dd class="moreOption" title="${message("shop.product.moreOption")}"></dd>
										</dl>
									[/#if]
									[#if filterBrands?has_content]
										[#assign rows = rows + 1 /]
										<dl class="clearfix" style="height: 50px;line-height: 50px;">
											<dt>${message("shop.product.brand")}:</dt>
											[#list filterBrands as filterBrand]
												<dd>
													<a href="javascript:;"[#if filterBrand == brand] class="brand current" title="${message("shop.product.cancel")}"[#else] class="brand"[/#if] brandId="${filterBrand.id}">
                                                        <img src="${filterBrand.logo}" alt="${filterBrand.name}" />
													</a>
												</dd>
											[/#list]
											<dd class="moreOption" title="${message("shop.product.moreOption")}"></dd>
										</dl>
									[/#if]
									[#assign hasHiddenAttribute = false /]
									[#list filterAttributes as filterAttribute]
										[#assign rows = rows + 1 /]
										<dl class="clearfix[#if rows > 3 && !attributeValueMap?keys?seq_contains(filterAttribute)][#assign hasHiddenAttribute = true /] hidden[/#if]">
											<dt>
												<input type="hidden" name="attribute_${filterAttribute.id}"[#if attributeValueMap?keys?seq_contains(filterAttribute)] value="${attributeValueMap.get(filterAttribute)}"[#else] disabled="disabled"[/#if] />
												<span title="${filterAttribute.name}">${abbreviate(filterAttribute.name, 12)}:</span>
											</dt>
											[#list filterAttribute.options as option]
												<dd>
													<a href="javascript:;"[#if attributeValueMap.get(filterAttribute) == option] class="attribute current" title="${message("shop.product.cancel")}"[#else] class="attribute"[/#if]>${option}</a>
												</dd>
											[/#list]
											<dd class="moreOption" title="${message("shop.product.moreOption")}"></dd>
										</dl>
									[/#list]
								</div>
								<div id="moreFilter" class="moreFilter">
									[#if hasHiddenAttribute]
										<a href="javascript:;">${message("shop.product.moreFilter")}</a>
									[#else]
										
									[/#if]
								</div>
							</div>
						[/#if]
					[/#if]
					<div class="bar">
						<div id="layout" class="layout">
							
							<span class="page">
								<label>${message("shop.product.totalCount", page.total)} ${page.pageNumber}/[#if page.totalPages > 0]${page.totalPages}[#else]1[/#if]</label>
								[#if page.totalPages > 0]
									[#if page.pageNumber != 1]
										<a href="javascript:;" id="previousPage" class="previousPage">
											<span>${message("shop.product.previousPage")}</span>
										</a>
									[/#if]
									[#if page.pageNumber != page.totalPages]
										<a href="javascript:;" id="nextPage" class="nextPage">
											<span>${message("shop.product.nextPage")}</span>
										</a>
									[/#if]
								[/#if]
							</span>
						</div>
						<div id="sort" class="sort">
                            <span style="float:left;line-height: 22px;">排序选择：</span>
							<div id="orderMenu" class="orderMenu">
								[#if orderType??]
									<span>${message("Product.OrderType." + orderType)}</span>
								[#else]
									<span>${message("Product.OrderType." + orderTypes[0])}</span>
								[/#if]
                                  <ul>
									[#list orderTypes as type]
										<li[#if type == orderType] class="current"[/#if] orderType="${type}">${message("Product.OrderType." + type)}</li>
									[/#list]
								</ul>
							</div>
							[#--<a href="javascript:;"[#if orderType == "priceAsc"] class="currentAsc current" title="${message("shop.product.cancel")}"[#else] class="asc"[/#if] orderType="priceAsc">${message("shop.product.priceAsc")}</a>
							<a href="javascript:;"[#if orderType == "salesDesc"] class="currentDesc current" title="${message("shop.product.cancel")}"[#else] class="desc"[/#if] orderType="salesDesc">${message("shop.product.salesDesc")}</a>
							<a href="javascript:;"[#if orderType == "scoreDesc"] class="currentDesc current" title="${message("shop.product.cancel")}"[#else] class="desc"[/#if] orderType="scoreDesc">${message("shop.product.scoreDesc")}</a>--]
							[#--<span style="float:left;line-height: 22px;"> 价格区间：</span>
							<input type="text" id="startPrice" name="startPrice" class="startPrice" value="${startPrice}" maxlength="16" title="${message("shop.product.startPrice")}" onpaste="return false" />
							<label>-</label>
							<input type="text" id="endPrice" name="endPrice" class="endPrice" value="${endPrice}" maxlength="16" title="${message("shop.product.endPrice")}" onpaste="return false" />
							<button type="submit">${message("shop.product.submit")}</button>--]
						</div>
					</div>
					<div id="result" class="result grid clearfix">
						[#if page.content?has_content]
							<ul>
								[#list page.content as product]
									[#assign defaultSku = product.defaultSku /]
									<li>
										<a href="${base}${product.path}">
											<img src="${base}/upload/image/blank.gif" data-original="${product.thumbnail!setting.defaultThumbnailProductImage}" />
											
										</a>
										<strong class="text-ellipsis">
											[#if product.type == "general"]
                                                <img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(defaultSku.price, false)}
											[#elseif product.type == "exchange"]
												<em>${message("Sku.exchangePoint")}:</em>
												${defaultSku.exchangePoint}
											[/#if]
										</strong>
										<div class="shopTitle">
												${abbreviate(product.name, 48)}
											</div>
										<div class="listShop">
											<div class="shopName">
												<a class="text-ellipsis" href="${base}${product.store.path}" title="${product.store.name}">${abbreviate(product.store.name, 15)}</a>
												[#if product.store != null && product.store.type == "self"]
													<em>${message("Store.Type.self")}</em>
												[/#if]
											</div>
										</div>
										<div class="action">
											[#if product.type == "general"]
												<a href="javascript:;" class="addCart" skuId="${defaultSku.id}">${message("shop.product.addCart")}</a>
											[#elseif product.type == "exchange"]
												<a href="javascript:;" class="exchange" skuId="${defaultSku.id}">${message("shop.product.exchange")}</a>
											[/#if]
											<a href="javascript:;" class="addProductFavorite" title="${message("shop.product.addProductFavorite")}" productId="${product.id}"></a>
											<a href="javascript:;" class="addCompare" title="${message("shop.product.addCompare")}" productId="${product.id}"></a>
										</div>
									</li>
								[/#list]
							</ul>
						[#else]
							[#noautoesc]
								${message("shop.product.noListResult")}
							[/#noautoesc]
						[/#if]
					</div>
					[@pagination pageNumber = page.pageNumber totalPages = page.totalPages pattern = "javascript: $.pageSkip({pageNumber});"]
						[#if totalPages > 1]
							<div class="pagination">
								[#if isFirst]
									<span class="firstPage">${message("shop.page.firstPage")}</span>
								[#else]
									<a href="[@pattern?replace("{pageNumber}", "${firstPageNumber}")?interpret /]" class="firstPage">${message("shop.page.firstPage")}</a>
								[/#if]
								[#if hasPrevious]
									<a href="[@pattern?replace("{pageNumber}", "${previousPageNumber}")?interpret /]" class="previousPage">${message("shop.page.previousPage")}</a>
								[#else]
									<span class="previousPage">${message("shop.page.previousPage")}</span>
								[/#if]
								[#list segment as segmentPageNumber]
									[#if segmentPageNumber_index == 0 && segmentPageNumber > firstPageNumber + 1]
										<span class="pageBreak">...</span>
									[/#if]
									[#if segmentPageNumber != pageNumber]
										<a href="[@pattern?replace("{pageNumber}", "${segmentPageNumber}")?interpret /]">${segmentPageNumber}</a>
									[#else]
										<span class="currentPage">${segmentPageNumber}</span>
									[/#if]
									[#if !segmentPageNumber_has_next && segmentPageNumber < lastPageNumber - 1]
										<span class="pageBreak">...</span>
									[/#if]
								[/#list]
								[#if hasNext]
									<a href="[@pattern?replace("{pageNumber}", "${nextPageNumber}")?interpret /]" class="nextPage">${message("shop.page.nextPage")}</a>
								[#else]
									<span class="nextPage">${message("shop.page.nextPage")}</span>
								[/#if]
								[#if isLast]
									<span class="lastPage">${message("shop.page.lastPage")}</span>
								[#else]
									<a href="[@pattern?replace("{pageNumber}", "${lastPageNumber}")?interpret /]" class="lastPage">${message("shop.page.lastPage")}</a>
								[/#if]
							</div>
						[/#if]
					[/@pagination]
				</form>
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>