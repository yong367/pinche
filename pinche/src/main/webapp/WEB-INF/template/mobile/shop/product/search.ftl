<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	[@seo type = "productSearch"]
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
	<script src="${base}/resources/mobile/shop/js/underscore.js"></script>
	<script src="${base}/resources/mobile/shop/js/common.js"></script>
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
					<%if (product.type == "general" || product.type == "coupon") {%>
						<strong class="red" style="font-size: 14px;"><img style="width: 14px;height: 14px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/><%-currency(product.price, false)%></strong>
                    <span style="text-decoration: line-through;font-size: 10px;color: #b8b8b8;">市场价:<%-currency(product.marketPrice, false)%>元</span>
					<%} else if (product.type == "exchange") {%>
						<span class="small">${message("Sku.exchangePoint")}:</span>
						<strong class="red"><%-product.defaultSku.exchangePoint%></strong>
					<%}%>
                    <span style="font-size: 10px;color:  #666666;display: block;text-align: right;">已售&nbsp;<%-formatProductSals(product.sales, true)%></span>
					<p>
						<%if (product.store.type == "self") {%>
							<em class="small">${message("Store.Type.self")}</em>
						<%}%>
						<a class="small gray-darker" href="${base}<%-product.store.path%>" title="<%-product.store.name%>"  style="font-size: 10px;"><%-abbreviate(product.store.name, 16, "...")%></a>
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
		
		var $searchForm = $("#searchForm");
		var $keyword = $("#keyword");
		var $order = $("#order");
		var $orderType = $("#order a[data-order-type]");
		var $productItems = $("#list div.row");
		var productTemplate = _.template($("#productTemplate").html());
		var data = {
			keyword: "${productKeyword?js_string}",
			storeId: ${(store.id)!"null"},
			orderType: null
		}
		
		// 搜索
		$searchForm.submit(function() {
			if ($.trim($keyword.val()) == "") {
				return false;
			}
			
			data.keyword = $keyword.val();
			$productItems.infiniteScroll("refresh");
			return false;
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
		
		// 无限滚动加载
		$productItems.infiniteScroll({
			url: function(pageNumber) {
				return "${base}/product/search?pageNumber=" + pageNumber;
			},
			data: data,
			pageSize: 20,
			template: function(pageNumber, data) {
				return productTemplate({
					products: data
				});
			}
		});

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
	<header class="header-fixed" style="padding: 0px;">
		<div class="container-fluid">
			<div class="row" style="background: #2cb6f1;line-height: 4rem;">
				<div class="col-xs-2 text-center">
					<a href="javascript: history.back();">
						<span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF;top: 3px;"></span>
					</a>
				</div>
				<div class="col-xs-8">
					<form id="searchForm" action="${base}/product/search" method="get">
						[#if store??]
							<input name="storeId" type="hidden" value="${store.id}">
						[/#if]
						<div class="input-group" style="border: none">
							<input id="keyword" name="keyword" class="form-control" style="float: none;" type="text" value="${productKeyword}" placeholder="${message("shop.product.search")}">
							<span class="input-group-btn">
								<button class="btn btn-default" type="submit" style="height: 34px;">
									<span class="glyphicon glyphicon-search" style="color: #2cb6f1"></span>
								</button>
							</span>
						</div>
					</form>
				</div>
				<div class="col-xs-2 text-center">
					<div class="menu dropdown">
						<a href="javascript:;" data-toggle="dropdown">
							<span class="glyphicon glyphicon-th-list" style="color: #FFFFFF"></span>
							<span class="caret" style="color: #FFFFFF"></span>
						</a>
						<ul class="dropdown-menu">
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
						<a class="disabled" href="javascript:;">
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
           [#if  stores?? && (stores?size > 0)]
			   <div class="list">
				   [#list stores as store]
                       <div class="row">
                           <div>
                               <div class="thumbnail thumbnail-flat thumbnail-condensed" style="height: 12rem;margin: 1rem;border: 0px;border-bottom:1px solid #d5d5d5;position: relative;">
                                       <img style="max-width: 9rem;float: left;overflow:hidden;display: block;margin: 1rem;" class="img-responsive center-block" src="[#if  store.logo??] ${store.logo}[/#if][#if  store.logo==null ] ${setting.defaultStoreLogo}[/#if]"/>
                                       <h4 class="text-overflow" style="margin-top: 10px;position: absolute;top: 4rem;left: 11rem;font-size: 16px;">${store.name}</h4>
									   <p><a href="${base}/store/${store.id}" style="
    position: absolute;
    right: 10px;
    bottom: 18px;
    background: #2cb6f1;
    color: white;
    width: 70px;
    border-radius: 0.5rem;
    text-align: center;
">进入店铺</a> </p>
                               </div>
                           </div>
					   </div>
				   [/#list]
			   </div>
           [/#if]
            <div id="list" class="list" style="[#if  stores?? && (stores?size > 0)]padding-top: 20px; [#else]padding-top: 80px;[/#if]">
				<div class="row"></div>
			</div>

		</div>
	</main>
    <footer class="footer-fixed" style="padding:0;">
        <div class="footergwc">
            <a href="${base}/cart/list">购物车(<span id="cartSize">0</span>件)<span id="cartAmount" style="font-size: 12px;">0.00</span></a>
        </div>
    </footer>
</body>
</html>