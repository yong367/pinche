<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
[@seo type = "index"]
	<title>爱帮伴</title>
	[#if seo.resolveKeywords()?has_content]
		<meta name="keywords" content="${seo.resolveKeywords()}" />
	[/#if]
	[#if seo.resolveDescription()?has_content]
		<meta name="description" content="${seo.resolveDescription()}" />
	[/#if]
[/@seo]
<link href="${base}/favicon.ico" rel="icon" type="image/x-icon" />
<link href="${base}/resources/shop/jslides/jslides.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/index.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.lazyload.js"></script>
<script type="text/javascript" src="${base}/resources/shop/jslides/jslides.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
    <script type="text/javascript" src="${base}/resources/statistic/browsestatistical.js"></script>
<style type="text/css">
.header {
	margin-bottom: 0px;
}
</style>
<script type="text/javascript">
$().ready(function() {

	var $productCategoryMenuItem = $("#productCategoryMenu li");
	var $newArticleTab = $("#newArticle ul.tab");
	var $hotProductImage = $("div.hotProduct img");
	$productCategoryMenuItem.hover(
		function() {
			$(this).children("div.menu").show();
		}, function() {
			$(this).children("div.menu").hide();
		}
	);

	$newArticleTab.tabs("ul.tabContent", {
		tabs: "li",
		event: "mouseover"
	});
	
	$hotProductImage.lazyload({
		threshold: 100,
		effect: "fadeIn",
		skip_invisible: false
	});
    //左右消息浮动
    initNotife();
    
});
function initNotife() {
    $.ajax({
        url : "/article/notify/list/101",
        type : "GET",
        dataType : "json",
        contentType : 'application/json',
        success : function (data) {
            var list = data.content;
            var leftHtml = "";
            var rightHtml = "";
            for(var i = 0;i < list.length;i++){    //遍历data数组
                var d = list[i];
                var path = d.path;//获取文章路径
                var newTitle = d.title;//获取文章标题
                newTitle = newTitle.length >10  ? newTitle.substring(0,10)+"...":newTitle;
                if(i<15){
                    leftHtml += "<li class='notice_active_ch' style='font-size: 14px'><a href=" + path + " title="+d.title+"><img src='/resources/shop/images/rumen.png'><span>" + newTitle + "</span></a></li>";
                }else{
                    rightHtml += "<li class='notice_active_ch' style='font-size: 14px'><a href= " + path +" title="+d.title+"><img src='/resources/shop/images/rumen.png'><span>"+newTitle+"</span></a></li>";
                }

                $("#leftUl").html(leftHtml); //左边显示15
                $("#rightUl").html(rightHtml); //右边显示15
            }


        }
    })
}
    
</script>
   
    
    
</head>
[#assign current = "indexMember" /]
<body class="shouye">
	[#include "/shop/include/header.ftl" /]
	<div class="containerIndex index">
		[@ad_position id = 1]
			[#noautoesc]
				${adPosition.resolveTemplate()}
			[/#noautoesc]
		[/@ad_position]
	</div>
	
    
    [#--<div style="position: fixed;width: 180px;height: 390px;top: 40%;left: 1%;z-index:9999;background-color: #f6f6f6">--]
        [#--<div style="width: 180px;height: 30px;overflow: hidden;color: #ddaa00;text-align:center;font-size:18px;font-weight: bold;border:1px solid #D3D3D3">--]
           [#--小爱快报--]
        [#--</div>--]
        [#--<div id="left"  class="notice_active" style="width: 180px;height: 360px;overflow: hidden;line-height: 30px; border:1px solid #D3D3D3">--]
            [#--<ul id="leftUl"></ul>--]
        [#--</div>--]
    [#--</div>--]
    [#--<div style="position: fixed;width: 180px;height: 390px;top: 40%;right: 2.2%;z-index:9999;background-color: #f6f6f6">--]
        [#--<div style="width: 180px;height: 30px;overflow: hidden;color: #ddaa00;text-align:center;font-size:18px;font-weight: bold;border:1px solid #D3D3D3">--]
            [#--小爱快报--]
        [#--</div>--]
        [#--<div id="right" class="notice_active" style="width: 180px;height: 360px;overflow: hidden;line-height: 30px; border: 1px solid #D3D3D3">--]
            [#--<ul id="rightUl"></ul>--]
        [#--</div>--]
    [#--</div>--]
    
	<div class="clear">&nbsp</div>
	<div class="container index">
		[#--<div class="row">
			<div class="span2">
				--][#--[@product_category_root_list count = 6]
					<div id="productCategoryMenu" class="productCategoryMenu">
						<ul>
							[#list productCategories as productCategory]
								<li>
									[@product_category_children_list productCategoryId = productCategory.id recursive = false count = 3]
										<div class="item[#if !productCategory_has_next] last[/#if]">
											<div>
												[#list productCategories as productCategory]
													<a href="${base}${productCategory.path}">
														<strong>${productCategory.name}</strong>
													</a>
												[/#list]
											</div>
											<div>
												[@brand_list productCategoryId = productCategory.id count = 4]
													[#list brands as brand]
														<a href="${base}${brand.path}">${brand.name}</a>
													[/#list]
												[/@brand_list]
											</div>
										</div>
									[/@product_category_children_list]
									[@product_category_children_list productCategoryId = productCategory.id recursive = false count = 8]
										<div class="menu">
											[#list productCategories as productCategory]
												<dl class="clearfix[#if !productCategory_has_next] last[/#if]">
													<dt>
														<a href="${base}${productCategory.path}">${productCategory.name}</a>
													</dt>
													[@product_category_children_list productCategoryId = productCategory.id recursive = false]
														[#list productCategories as productCategory]
															<dd>
																<a href="${base}${productCategory.path}">${productCategory.name}</a>[#if productCategory_has_next]|[/#if]
															</dd>
														[/#list]
													[/@product_category_children_list]
												</dl>
											[/#list]
											<div class="auxiliary">
												[@brand_list productCategoryId = productCategory.id count = 8]
													[#if brands?has_content]
														<div>
															<strong>${message("shop.index.recommendBrand")}</strong>
															[#list brands as brand]
																<a href="${base}${brand.path}">${brand.name}</a>
															[/#list]
														</div>
													[/#if]
												[/@brand_list]
												[@promotion_list productCategoryId = productCategory.id hasEnded = false count = 4]
													[#if promotions?has_content]
														<div>
															<strong>${message("shop.index.hotPromotion")}</strong>
															[#list promotions as promotion]
																[#if promotion.image?has_content]
																	<a href="${base}${promotion.path}" title="${promotion.title}">
																		<img src="${promotion.image}" alt="${promotion.title}" />
																	</a>
																[/#if]
															[/#list]
														</div>
													[/#if]
												[/@promotion_list]
											</div>
										</div>
									[/@product_category_children_list]
								</li>
							[/#list]
						</ul>
					</div>
					
			 [/@product_category_root_list]--][#--
			</div>
		</div>--]
		<div class="row">
			<div class="span9">
				<h2 class="title"><a href="###">更多></a></h2>
				[@ad_position id = 2]
					[#noautoesc]
						${adPosition.resolveTemplate()}
					[/#noautoesc]
				[/@ad_position]
			</div>

			[#--<div class="span3">
				[@article_category_root_list count = 2]
					[#if articleCategories?has_content]
						<div id="newArticle" class="newArticle">
							<ul class="tab">
								[#list articleCategories as articleCategory]
									<li>
										<a href="${base}${articleCategory.path}" target="_blank">${articleCategory.name}</a>
									</li>
								[/#list]
							</ul>
							[#list articleCategories as articleCategory]
								[@article_list articleCategoryId = articleCategory.id count = 6]
									<ul class="tabContent[#if articleCategory_index > 0] hidden[/#if]">
										[#list articles as article]
											<li>
												<a href="${base}${article.path}" title="${article.title}" target="_blank">${abbreviate(article.title, 40)}</a>
											</li>
										[/#list]
									</ul>
								[/@article_list]
							[/#list]
						</div>
					[/#if]
				[/@article_category_root_list]
			</div>--]
			

		</div>
		[#--<div class="row">
			<div class="span12">
				[@ad_position id = 3]
					[#noautoesc]
						${adPosition.resolveTemplate()}
					[/#noautoesc]
				[/@ad_position]
			</div>
		</div>--]
		[@product_category_root_list count = 3]
			[@ad_position id = 4]
				[#if adPosition??]
					[#assign adIterator = adPosition.ads.iterator() /]
				[/#if]
			[/@ad_position]
			[@ad_position id = 7]
				[#if adPosition??]
					[#assign adIterators = adPosition.ads.iterator() /]
				[/#if]
			[/@ad_position]
			[#list productCategories as productCategory]
				[@product_list productCategoryId = productCategory.id productTagId = 1 count =7]
					<div class="row">
						<div class="span12">
							<div class="hotProduct">
                                <h2 class="span-title${productCategory_index + 1}"><a href="${base}${productCategory.path}">更多></a></h2>
								<dl class="title${productCategory_index + 1}"></dl>
								[#-- 这个目前没有作用 所以删除掉了
								[@product_category_children_list productCategoryId = productCategory.id recursive = false count = 8]
									<h2 class="span-title${productCategory_index + 1}"><a href="###">更多></a></h2>
									
									<dl class="title${productCategory_index + 1}">
										[#--<dt>
											<a href="${base}${productCategory.path}">${productCategory.name}</a>
										</dt>
										[#list productCategories as productCategory]
											<dd>
												<a href="${base}${productCategory.path}">${productCategory.name}</a>
											</dd>
										[/#list]
									</dl>
						[/@product_category_children_list]--]
								<div>
									[#if adIterator?? && adIterator.hasNext()]
										[#assign ad = adIterator.next() /]
										[#if ad.type == "image" && ad.hasBegun() && !ad.hasEnded()]
											[#if ad.url??]
												<a href="${ad.url}">
													<img class="leftggtp" src="${ad.path}" alt="${ad.title}" title="${ad.title}" />
												</a>
											[#else]
												<img class="leftggtp" src="${ad.path}" alt="${ad.title}" title="${ad.title}" />
											[/#if]
										[/#if]
									[/#if]
								</div>
								<ul>
									[#list products as product]

											<li>
												<a href="${base}${product.path}" title="${product.name}" target="_blank">
													
													<img src="${base}/upload/image/blank.gif" data-original="${product.image!setting.defaultThumbnailProductImage}" width="225px" height="170px"/>
													<div>
														[#if product.caption?has_content]
															<span title="${product.name}">${abbreviate(product.name, 24)}</span>
															<em title="${product.caption}">${abbreviate(product.caption, 24)}</em>
														[#else]
															${abbreviate(product.name, 48)}
														[/#if]
													</div>
													[#if productCategory_index ==1]
                                                        <strong class="mjhdicon">包&nbsp;邮</strong>
													[/#if]
													[#if productCategory_index ==2]
                                                       		<span class="xatjicon"></span>
													[/#if]
													<strong class="jiage">
														<img  style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(product.price, false)}
													</strong>
													[#if productCategory_index ==0]
                                                    <strong class="zhekouicon">
                                                        	限&nbsp;量
                                                    </strong>
													[/#if]
												</a>
											</li>

											[#--<li class="low">
												<a href="${base}${product.path}" title="${product.name}" target="_blank">
													<img src="${base}/upload/image/blank.gif" data-original="${product.image!setting.defaultThumbnailProductImage}" />
													<span title="${product.name}">${abbreviate(product.name, 24)}</span>
													<strong>${currency(product.price, true)}</strong>
												</a>
											</li>--]
										[#if product_index ==6]
										<li>
											[#if adIterators?? && adIterators.hasNext()]
												[#assign ads = adIterators.next() /]
												[#if ads.type == "image" && ads.hasBegun() && !ads.hasEnded()]
													[#if ads.url??]
                                                        <a href="${ads.url}">
                                                            <img class="rightggtp" src="${ads.path}" alt="${ads.title}" title="${ads.title}" />
                                                        </a>
													[#else]
                                                        <img class="rightggtp" src="${ads.path}" alt="${ads.title}" title="${ads.title}" />
													[/#if]
												[/#if]
											[/#if]
										</li>
										[/#if]
									[/#list]
								</ul>
							</div>
						</div>
					</div>
				[/@product_list]
			[/#list]
		[/@product_category_root_list]
		[#-- 底部广告去掉
		<div class="row">
			<div class="span12">
				[@ad_position id = 5]
					[#noautoesc]
						${adPosition.resolveTemplate()}
					[/#noautoesc]
				[/@ad_position]
			</div>
		</div>
		<div class="row">
			<div class="span12">
				[@brand_list type = "image" count = 10]
					[#if brands?has_content]
						<div class="hotBrand">
							<ul class="clearfix">
								[#list brands as brand]
									<li>
										<a href="${base}${brand.path}" title="${brand.name}">
											<img src="${brand.logo}" alt="${brand.name}" />
										</a>
									</li>
								[/#list]
							</ul>
						</div>
					[/#if]
				[/@brand_list]
			</div>
		</div>--]
	</div>
	[#include "/shop/include/footer.ftl" /]
		
<div class="warpLogin" style="display:none;"></div>

<div class="loginSucess" style="display:none;">
	<dl>
		<dt>欢迎加入爱帮伴家庭！</dt>
		<dd>小爱 双手奉上<strong>50</strong>积分，聊表寸心</dd>
		<dd></dd>
	</dl>

	<p>去&nbsp;<a href="#">兑伴儿积分</a>&nbsp;兑好料</p>
	<p>或者看看身边的&nbsp;<a href="#">精品活动</a></p>
</div>
</body>
</html>