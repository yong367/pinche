<link href="${base}/newResources/member/css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
$().ready(function() {

	var $window = $(window);
	var $headerName = $("#headerName");
	var $headerLogin = $("#headerLogin");
	var $headerRegister = $("#headerRegister");
	var $headerLogout = $("#headerLogout");
	var $productSearchForm = $("#productSearchForm");
	var $productSearchKeyword = $("#productSearchForm [name='keyword']");
	var $headerCart = $("#headerCart");
	var $headerCartQuantity = $("#headerCart a.cartButton em");
	var $headerCartDetail = $("#headerCart div.detail");
	var $headerCartItems = $("#headerCart div.items");
	var $headerCartSummary = $("#headerCart div.summary");
	var $broadsideNav = $("#broadsideNav");
	var currentMemberUsername = getCookie("currentMemberUsername");
	var defaultProductSearchKeyword = "${message("shop.header.keyword")}";
	
	if ($.trim(currentMemberUsername) != "") {
		$headerName.text(currentMemberUsername).show();
		$headerLogout.show();
	} else {
		$headerLogin.show();
		$headerRegister.show();
	}
	
	$productSearchKeyword.focus(function() {
		if ($.trim($productSearchKeyword.val()) == defaultProductSearchKeyword) {
			$productSearchKeyword.val("");
		}
	});
	
	$productSearchKeyword.blur(function() {
		if ($.trim($productSearchKeyword.val()) == "") {
			$productSearchKeyword.val(defaultProductSearchKeyword);
		}
	});
	
	$productSearchForm.submit(function() {
		if ($.trim($productSearchKeyword.val()) == "" || $productSearchKeyword.val() == defaultProductSearchKeyword) {
			return false;
		}
	});
	
	// 购物车信息
	$window.on("cartInfoLoad", function(event, cartInfo) {
		var skuQuantity = cartInfo != null && cartInfo.skuQuantity != null ? cartInfo.skuQuantity : 0;
		var effectivePrice = cartInfo != null && cartInfo.effectivePrice != null ? cartInfo.effectivePrice : 0;
		if ($headerCartQuantity.text() != skuQuantity && "opacity" in document.documentElement.style) {
			$headerCartQuantity.fadeOut(function() {
				$headerCartQuantity.text(skuQuantity).fadeIn();
			});
		} else {
			$headerCartQuantity.text(skuQuantity);
		}
		var cartItems = cartInfo.items;
		if(cartItems == null || cartItems.length <= 0){
			$headerCartItems.html(
				[@compress single_line = true]
					'<table>
						<tr>
							<td>${message("shop.header.cartEmpty")}</td>
						</tr>
					</table>'
				[/@compress]
			);
		} else {
			var $headerCartTable = $headerCartItems.html('<table id="cartTable"><\/table>');
			$.each(cartItems, function(i, cartItem) {
				$('#cartTable').append(
					[@compress single_line = true]
						'<tr>
							<td>
								<a href="${base}' + cartItem.skuPath + '">
									<img src="' + cartItem.skuThumbnail + '" \/>
								<\/a>
							<\/td>
							<td>
								<a href="${base}' + cartItem.skuPath + '">' + escapeHtml(abbreviate(cartItem.skuName, 20, "...")) + '<\/a>
							<\/td>
							<td>
								<span><img  style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>' + currency(cartItem.price, false, false) + '<\/span>&nbsp; &nbsp;<em>x' + cartItem.quantity + '<\/em>
							<\/td>
						<\/tr>'
					[/@compress]
				);
			});
		}
		$headerCartSummary.html(message('[#noautoesc]${message("shop.header.totalQuantity")}[/#noautoesc]', skuQuantity) + '&nbsp;&nbsp;&nbsp;&nbsp; <em><img  style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/> &nbsp;' + currency(effectivePrice, false, true) + '<\/em><a href="${base}/cart/list">${message("shop.header.checkout")}<\/a>');
	});
	
	// 购物车详情
	$headerCart.hover(
		function() {
			if ($headerCartDetail.is(":hidden")) {
				$headerCart.addClass("active");
				$headerCartDetail.slideDown("fast");
			}
		},
		function() {
			if ($headerCartDetail.is(":visible")) {
				$headerCart.removeClass("active");
				$headerCartDetail.slideUp("fast");
			}
		}
	);
	
	$broadsideNav.find("li").hover(
		function() {
			$(this).find("em").show();
		},function(){
			$(this).find("em").hide();
		}
	);

});
</script>
<div class="header">
	<div class="top">
		<div class="topNav">
			[#--<ul class="left">
				<li><em class="address-index"></em></li>
			</ul>--]
			<div class="huadong">
				<div class="huabox">
				<div class="hdimg"></div>
				[@article_list articleCategoryId = articleCategory.id count = 10 orderBy = "hits desc"]
					[#if articles?has_content]
                        <div class="notice_active">
                            <ul>
								[#list articles as article]
                                    <li class="notice_active_ch" style="width:100%">
                                        <a href="${base}${article.path}" title="${article.title}">${article.title}</a>
                                    </li>
								[/#list]
                            </ul>
                        </div>
					[/#if]
				[/@article_list]

                   [#-- <div class="notice_active" >
                        <ul>
                            <li class="notice_active_ch">
                                <a href="###">618就等你来，大奖等你赢！</a>
                            </li>
                            <li class="notice_active_ch">
                                <a href="###">618就等你来，大奖等你赢！</a>
                            </li>
                            <li class="notice_active_ch">
                                <a href="###">618就等你来，大奖等你赢！</a>
                            </li>

                        </ul>
                    </div>--]
				</div>
			</div>
			
			<script type="text/javascript">
				function timer(opj){
					$(opj).find('ul').animate({
						marginTop : "-30px"  
						},500,function(){  
						$(this).css({marginTop : "1px"}).find("li:first").appendTo(this);  
					})  
				}
				$(function(){ 
					var num = $('.notice_active').find('li').length;
					if(num > 1){
					   var time=setInterval('timer(".notice_active")',3500);
						
					}
					
				});
			</script>
			<ul class="right">
				<li>
					<span id="headerName" class="headerName">&nbsp;</span>
				</li>
				<li id="headerLogin" class="headerLogin">
					<a href="${base}/member/login">${message("shop.header.login")}</a>|
				</li>
				<li id="headerRegister" class="headerRegister">
					<a href="${base}/member/register">${message("shop.header.register")}</a>
				</li>
				<li id="headerLogout" class="headerLogout">
					<a href="${base}/member/logout">[${message("shop.header.logout")}]</a>
				</li>
			
				[@navigation_list position = "top"]
					[#list navigations as navigation]
						<li>
							<a href="${navigation.url}"[#if navigation.isBlankTarget] target="_blank"[/#if]>${navigation.name}</a>
							[#if navigation_has_next]|[/#if]
						</li>
					[/#list]
				[/@navigation_list]
			</ul>
		</div>
	</div>
	<div class="container">
		<div class="row">
			<div class="span3">
				<a href="${base}/">
					<img style="width: 100%" src="${setting.logo}" alt="${setting.siteName}" />
				</a>
			</div>
			<div class="span6">
				<div class="search">
					<form id="productSearchForm" action="${base}/product/search" method="get">
						[#if store??]
							<input name="storeId" type="hidden" value="${store.id}" />
						[#elseif storeProductCategory??]
							<input name="storeId" type="hidden" value="${storeProductCategory.store.id}" />
						[/#if]
						<input name="keyword" class="keyword" value="${productKeyword!message("shop.header.keyword")}" autocomplete="off" x-webkit-speech="x-webkit-speech" x-webkit-grammar="builtin:search" maxlength="30" />
						<button type="submit">&nbsp;</button>
					</form>
				</div>
				<div class="hotSearch">
					[#if setting.hotSearches?has_content]
						${message("shop.header.hotSearch")}:
						[#list setting.hotSearches as hotSearch]
							<a href="${base}/product/search?keyword=${hotSearch?url}">${hotSearch}</a>
						[/#list]
					[/#if]
				</div>
			</div>
			<div id="headerCart" class="headerCart">
				<a class="cartButton" href="${base}/cart/list"><span>购物车(<em></em>)</span></a>
				<div class="detail">
					<div class="title">购物车商品</div>
					<div class="items"></div>
					<div class="summary"></div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="span12">
				<dl class="mainNav">
					<dt>
						<a href="${base}/product_category">${message("shop.header.allProductCategory")}</a>
					</dt>
					[@navigation_list position = "middle"]
						[#list navigations as navigation]
							<dd[#if navigation.url == url] class="current"[/#if]>
								<a href="${navigation.url}"[#if navigation.isBlankTarget] target="_blank"[/#if]>${navigation.name}</a>
							</dd>
						[/#list]
					[/@navigation_list]
				</dl>
			</div>
		</div>
		<div id="broadsideNav" class="broadsideNav">
			<ul>
				<li class="shoppingCart">
					<a href="${base}/cart/list"><em>${message("shop.header.cart")}</em></a>
				</li>
				<li class="memberCenter">
					<a href="${base}/member/index"><em>${message("shop.header.member")}</em></a>
				</li>
				<li class="myCoupons">
					<a href="${base}/member/coupon_code/exchange"><em>${message("shop.header.couponCode")}</em></a>
				</li>
				<li class="collectCenter">
					<a href="${base}/member/product_favorite/list"><em>${message("shop.header.productFavorite")}</em></a>
				</li>
			</ul>
			<div id="goTop" class="goTop"></div>
		</div>
	</div>
</div>