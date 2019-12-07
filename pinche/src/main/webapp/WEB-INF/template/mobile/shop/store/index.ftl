<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="full-screen" content="yes">
    <meta name="x5-fullscreen" content="true">
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
    <link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
    <link rel="stylesheet" href="/newResources/shop/css/xw_style.css">
    <!--[if lt IE 9]>
    <script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
    <script src="${base}/resources/mobile/shop/js/respond.js"></script>
    <![endif]-->
    <script src="${base}/resources/mobile/shop/js/jquery.js"></script>
    <script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
    <script src="${base}/resources/mobile/shop/js/underscore.js"></script>
    <script src="${base}/resources/mobile/shop/js/common.js"></script>

    <script>
        function show(){
            var num=$(".shop_list").find("li").length;
            if(num==0){
                var html='<li style="' +
                        'text-align: center;' +
                        '">～店家偷个小懒儿，暂无推荐哦～' +
                        '</li>';
                $(".shop_list").css("text-align","center");
                $(".shop_list").html(html);
            }
        }
        $(function () {
            show();
            // 店铺收藏
            $("#addStoreFavorite").click(function() {
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
        });
        function shop_list_type_change(ipt) {
            var slt=document.getElementsByName(ipt.name);
            for (var slti = 0; slti < slt.length; slti++) {
                $(slt[slti].parentNode).find(".slt_up").css("border-bottom"," 4px solid #999");
                $(slt[slti].parentNode).find(".slt_down").css("border-top"," 4px solid #999");
                if(slt[slti].checked){
                    if(slt[slti].getAttribute("up")){
                        $(slt[slti].parentNode).find(".slt_up").css("border-bottom"," 4px solid #999");
                        $(slt[slti].parentNode).find(".slt_down").css("border-top"," 4px solid #f5701c");
                        slt[slti].removeAttribute("up");
                        console.log(slt[slti].getAttribute("lt")+":降序")
                    }else{
                        $(slt[slti].parentNode).find(".slt_up").css("border-bottom"," 4px solid #f5701c");
                        $(slt[slti].parentNode).find(".slt_down").css("border-top"," 4px solid #999");
                        slt[slti].setAttribute("up","1");
                        console.log(slt[slti].getAttribute("lt")+":升序")
                    }
                }
            }
        }
        function submitForm() {
            if($.trim($("#keyword").val()).length>0){
                $("#searchForm").submit();
            }
        }
    </script>
</head>
<body class="had_head_body shop_body">
<div class="home_head orange">
    <form class="flex flex-align-center home_head_form" action="/store/search" method="post" id="searchForm">
        <input type="hidden" name="storeId" value="${store.id}"/>
        <a href="/" class="head_back">
            <div class="flex flex-align-center head_back_div"><span class="icon_1 icon_1_back"></span></div>
        </a>
        <div class="flex-1 flex hh_search">
            <input type="text" id="keyword" name="keyword" class="flex-1 hh_search_ipt" placeholder="店内搜索" />
            <button type="button" class="hh_search_sub" onclick="submitForm()"><i class="icon_1 icon_1_search"></i></button>
        </div>
    </form>
    <div class="shop_banner">
        <div class="flex sb_shop">
            <div class="flex flex-align-center sb_shop_logo">
                <img src="${store.logo!setting.defaultStoreLogo}" class="sb_shop_logo_img" />
            </div>
            <div class="flex-1 flex flex-v flex-pack-center sb_shop_text">
                <div class="flex sb_shop_name"><p class="sb_shop_name_p">${store.name}</p><i class="icon_1 icon_1_more_w"></i></div>
                <p class="sb_shop_attention_num">${store.storeFavorites.size()}人关注</p>
            </div>
            <div class="flex flex-align-center sb_shop_attention">
                <button class="sb_shop_attention_btn" id="addStoreFavorite">关注店铺</button>
            </div>
        </div>
        <div class="flex sb_type">
            <a href="/store/${store.id}" class="flex-1 sb_type_a checked">店铺推荐</a>
            <a href="/store/newProduct/${store.id}" class="flex-1 sb_type_a">最近新品</a>
            <a href="/store/allProduct/hot_up/${store.id}/0" class="flex-1 sb_type_a">全部商品</a>
            <a href="/store/task/${store.id}" class="flex-1 sb_type_a">店铺任务</a>
        </div>
    </div>
</div>
<div style="height: 115px;"></div>
<div class="shop_list_div">
    <ul class="shop_list">

        [#if store.storeProductTags?has_content]
            [#list storeProductTags as storeProductTag]
                [@product_list storeId = store.id storeProductTagId = storeProductTag.id count = 10]
                    [#list products as product]
                        [#assign defaultSku = product.defaultSku /]
						 <li class="shop_item">
                             <a href="${product.path}" class="flex shop_item_a">
                                 <div class="shop_item_photo">
                                     <img src="${product.thumbnail!setting.defaultThumbnailProductImage}" class="shop_item_img" />
                                 </div>
                                 <div class="flex-1 flex flex-v shop_item_text">
                                     <p style="font-size: 12px;color: #333333">${product.name}</p>
                                     <p class="shop_item_name">${product.caption}</p>
                                     <div class="flex shop_item_num" style="padding-top: 7px">
                                         <p class="shop_item_hot">${storeProductTag.name}</p>
                                         <p class="flex-1 shop_item_p_buy">${formatProductSals(product.sales,true)}人已买</p>
                                     </div>
                                     <div class="flex shop_item_num" style="padding-top: 2px">
                                         <div class="flex flex-align-center hgi_price">
                                             <i class="icon_1 icon_1_jf2"></i>
                                             <p class="goods_price_num"><span>${newcurrency(defaultSku.price, "one")}</span>${newcurrency(defaultSku.price, "two")}</p>
                                         </div>
                                         <p class="flex-1 flex flex-align-center shop_item_high_praise" style="text-decoration: line-through;">市场价:${currency(defaultSku.marketPrice, false)}元</p>
                                     </div>
                                 </div>
                             </a>
                         </li>
                    [/#list]
                [/@product_list]
            [/#list]
        [/#if]


    </ul>
</div>

</body>

</html>