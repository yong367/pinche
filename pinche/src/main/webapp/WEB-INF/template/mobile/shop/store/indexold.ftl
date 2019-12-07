<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	[@seo type = "storeIndex"]
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
	<link href="${base}/resources/mobile/shop/css/store.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/shop/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/shop/js/jquery.js"></script>
	<script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/shop/js/jquery.lazyload.js"></script>
	<script src="${base}/resources/mobile/shop/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/shop/js/velocity.js"></script>
	<script src="${base}/resources/mobile/shop/js/velocity.ui.js"></script>
	<script src="${base}/resources/mobile/shop/js/underscore.js"></script>
	<script src="${base}/resources/mobile/shop/js/hammer.js"></script>
	<script src="${base}/resources/mobile/shop/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $storeProductCategory = $("#storeProductCategory");
		var $storeProductCategoryContent = $("#storeProductCategory div.store-product-category-content");
		var $closeStoreProductCategory = $("#closeStoreProductCategory");
		var $searchForm = $("#searchForm");
		var $keyword = $("#keyword");
		var $addStoreFavorite = $("#addStoreFavorite");
		var $masthead = $("#masthead");
		var $productImage = $("div.thumbnail img");
		var $showStoreProductCategory = $("#showStoreProductCategory");
		
		// 店铺商品分类
		$closeStoreProductCategory.click(function() {
			$storeProductCategory.velocity("transition.slideRightBigOut").parent().velocity("fadeOut");
		});
		
		// 搜索
		$searchForm.submit(function() {
			if ($.trim($keyword.val()) == "") {
				return false;
			}
		});
		
		// 店铺收藏
		$addStoreFavorite.click(function() {
			$.ajax({
				url: "${base}/member/store_favorite/add",
				type: "POST",
				data: {
					storeId: ${store.id}
				},
				dataType: "json",
				cache: false
			});
			return false;
		});
		
		[#if store.storeAdImages?has_content]
			// 店铺广告图片
			new Hammer($masthead.get(0)).on("swipeleft", function() {
				$masthead.carousel("next");
			}).on("swiperight", function() {
				$masthead.carousel("prev");
			});
		[/#if]
		
		// 商品图片
		$productImage.lazyload({
			threshold: 100,
			effect: "fadeIn"
		});
		
		// 店铺商品分类
		$showStoreProductCategory.click(function() {
			$storeProductCategory.velocity("transition.slideRightBigIn").parent().velocity("fadeIn");
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
<body class="store-index">
	[@store_product_category_root_list storeId = store.id]
		[#if storeProductCategories?has_content]
			<div class="store-product-category-wrapper">
				<div id="storeProductCategory" class="store-product-category">
					<div class="store-product-category-content">
						<div class="store-product-category-body">
							[#list storeProductCategories as storeProductCategory]
								<dl class="clearfix">
									<dt>
										<a href="${base}${storeProductCategory.path}">${abbreviate(storeProductCategory.name, 15)}</a>
									</dt>
									[@store_product_category_children_list storeProductCategoryId = storeProductCategory.id storeId = store.id recursive = false]
										[#list storeProductCategories as storeProductCategory]
											<dd>
												<a href="${base}${storeProductCategory.path}">${abbreviate(storeProductCategory.name, 15)}</a>
											</dd>
										[/#list]
									[/@store_product_category_children_list]
								</dl>
							[/#list]
						</div>
						<div class="store-product-category-footer">
							<button id="closeStoreProductCategory" class="btn btn-lg btn-primary btn-flat btn-block" type="button">${message("shop.store.close")}</button>
						</div>
					</div>
				</div>
			</div>
		[/#if]
	[/@store_product_category_root_list]
	<header class="header-fixed" style="padding: 0px;">
		<div class="container-fluid" style="background: #2cb6f1">
			<div class="row">
				<div class="col-xs-2 text-center">
					<a href="javascript: history.back();">
						<span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
					</a>
				</div>
				<div class="col-xs-8">
					<form id="searchForm" action="${base}/product/search" method="get">
						<input name="storeId" type="hidden" value="${store.id}">
						<div class="input-group" style="border: 1px solid #15aeef">
							<input id="keyword" name="keyword" class="form-control" style="border: none;" type="text" placeholder="${message("shop.store.search")}">
							<span class="input-group-btn">
								<button class="btn btn-default" type="submit" style="height: 34px;border: none;">
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
		</div>
	</header>  [#--这是为了应对安徽市场 所以去掉了头部导航。同时为了样式问题。也在main 中加入了style="margin-top: 0px;"--]
	<main>
		<div class="container-fluid">
			<div class="media">
				<div class="media-left media-middle">
					<img src="${store.logo!setting.defaultStoreLogo}" alt="${store.name}">
				</div>
				<div class="media-body media-middle">
					<h4 class="media-heading">${store.name}</h4>
					[#if store.type == "self"]
						<em>${message("Store.Type.self")}</em>
					[/#if]
				[#if store.type != "self"]
					[#if store.address?has_content]
                    <span style="display: block;font-size:10px;text-align:left;">
								店铺地址：${store.address}
							</span>
					[/#if]
					[#if store.phone?has_content]
                    <span style="display: block;font-size:10px;text-align:left;">
								店铺电话：${store.phone}
							</span>
					[/#if]
					[#if store.businessHours?has_content]
                    <span style="display: block;font-size:10px;text-align:left;">
								营业时间：${store.businessHours}
							</span>
					[/#if]

				[/#if]
				</div>
				<div class="media-right media-middle">
					<a id="addStoreFavorite" class="small" href="javascript:;">
						<span class="fa fa-star-o"></span>
						${message("shop.store.addStoreFavorite")}
					</a>
				</div>
			</div>
			[#if store.storeAdImages?has_content]
				<div id="masthead" class="masthead carousel slide" data-ride="carousel">
					<ol class="carousel-indicators">
						[#list store.storeAdImages as storeAdImage]
							<li[#if storeAdImage_index == 0] class="active"[/#if] data-target="#masthead" data-slide-to="${storeAdImage_index}"></li>
						[/#list]
					</ol>
					<ul class="carousel-inner">
						[#list store.storeAdImages as storeAdImage]
							<li class="item[#if storeAdImage_index == 0] active[/#if]">
								[#if storeAdImage.url??]
									<a href="${storeAdImage.url}" title="${storeAdImage.title}">
										<img src="${storeAdImage.image}" alt="${storeAdImage.title}">
									</a>
								[#else]
									<img src="${storeAdImage.image}" alt="${storeAdImage.title}">
								[/#if]
							</li>
						[/#list]
					</ul>
				</div>
			[/#if]
			[#if tasks?has_content][#--任务板块数据展示--]
			<div class="products panel panel-flat panel-condensed">
                <div class="panel-heading">
					任务列表
                </div>
                <div class="panel-body">
                    <div class="row">
									[#list tasks as task]
                                        <div class="col-xs-6" style="width: 98%">
                                            <div class="thumbnail thumbnail-flat thumbnail-condensed" style="height: 14rem;margin: .5rem;border: 0px;border-bottom:1px solid #d5d5d5;">
                                                <a href="${base}/member/task/taskDetail?taskBusinessMappingId=${task.id}">
                                                    <img style="max-width: 11rem;width: 11rem;float: left;overflow:hidden;display: block;margin: 1rem;" class="img-responsive center-block" [#if task.taskInfo.coverPlanUrl ?has_content]src="${task.taskInfo.coverPlanUrl}"[#else ]src="${base}/resources/mobile/member/images/defaukeTaskImg.png"[/#if]>
                                                    <h4  style="margin-top: 10px;" class="text-overflow">${task.taskInfo.name}</h4>
                                                    <p style="color: #ff7700" class="text-overflow text-muted small">${task.taskInfo.taskCaption}</p>
                                                </a>
													<strong class="red" style="font-size: 14px"><img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${task.taskInfo.rewardYongJin}</strong>

                                                <span style="font-size: 10px;display: block;color: #666666;text-align: right;">任务剩余数量&nbsp;${task.taskInfo.oddTaskNumber}</span>
                                                <p>
													[#if store.type == "self"]
														<em class="small">${message("Store.Type.self")}</em>
													[/#if]
                                                    <a class="small gray-darker" style="font-size: 10px;" href="${base}${store.path}" title="${store.name}">${abbreviate(store.name, 16, "...")}</a>
                                                </p>
                                            </div>
                                        </div>
									[/#list]
                    </div>
                </div>
            </div>
			[/#if]
			[#if store.storeProductTags?has_content]
				[#list storeProductTags as storeProductTag]
					[@product_list storeId = store.id storeProductTagId = storeProductTag.id count = 10]
						<div class="products panel panel-flat panel-condensed">
							<div class="panel-heading">
								[#if storeProductTag.icon?has_content]
									<img src="${storeProductTag.icon}" alt="${storeProductTag.name}">
								[/#if]
								${storeProductTag.name}
							</div>
							<div class="panel-body">
								<div class="row">
									[#list products as product]
										[#assign defaultSku = product.defaultSku /]
										<div class="col-xs-6" style="width: 98%">
											<div class="thumbnail thumbnail-flat thumbnail-condensed" style="height: 14rem;margin: .5rem;border: 0px;border-bottom:1px solid #d5d5d5;">
												<a href="${base}${product.path}">
													<img style="max-width: 11rem;width: 11rem;float: left;overflow:hidden;display: block;margin: 1rem;" class="img-responsive center-block" src="${base}/upload/image/blank.gif" alt="${product.name}" data-original="${product.thumbnail!setting.defaultThumbnailProductImage}">
													<h4  style="margin-top: 10px;" class="text-overflow">${product.name}</h4>
													<p style="color: #ff7700" class="text-overflow text-muted small">${product.caption}</p>
												</a>
												[#if product.type == "general"]
													<strong class="red" style="font-size: 14px"><img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(defaultSku.price, false)}</strong>
                                                    <span style="text-decoration: line-through;font-size: 10px;color: #b8b8b8;">市场价:${currency(defaultSku.marketPrice, false)}元</span>
												[#elseif product.type == "exchange"]
													<span class="small">${message("Sku.exchangePoint")}:</span>
													<strong class="red">${defaultSku.exchangePoint}</strong>
												[/#if]
                                                <span style="font-size: 10px;display: block;color: #666666;text-align: right;">已售&nbsp;${formatProductSals(product.sales,true)}</span>
												<p>
													[#if product.store.type == "self"]
														<em class="small">${message("Store.Type.self")}</em>
													[/#if]
													<a class="small gray-darker" style="font-size: 10px;" href="${base}${product.store.path}" title="${product.store.name}">${abbreviate(product.store.name, 16, "...")}</a>
												</p>
											</div>
										</div>
									[/#list]
								</div>
							</div>
						</div>
					[/@product_list]
				[/#list]
			[/#if]
		</div>
	</main>
	<footer class="footer-fixed" style="border-top:1px solid #dddada;background: #2cb6f1;">
		<div class="container-fluid">
			<div class="row">
				
				<div class="col-xs-6 text-center">
					<span class="glyphicon glyphicon-th-list" style="color: #FFFFFF"></span>
					<a id="showStoreProductCategory" href="javascript:;"><span style="color: #FFFFFF">商品${message("shop.store.storeProductCategory")}</span></a>
				</div>
				<div class="col-xs-6 text-center">
					<span class="glyphicon glyphicon-shopping-cart"  style="color: #FFFFFF"></span>
					<a href="${base}/cart/list"><span style="color: #FFFFFF">购物车(<span id="cartSize">0</span>件)</span><span id="cartAmount" style="font-size: 12px;color: #FFFFFF"></span></a>
				</div>
				
			</div>
		</div>
	</footer>
</body>
</html>