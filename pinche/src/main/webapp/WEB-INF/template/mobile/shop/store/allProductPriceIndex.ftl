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
    <script id="shopListTemplate" type="text/template">
        <%
        function depositText(type) {

        }
        %>
        <%_.each(products, function(product, i) {%>
        <li class="shop_item">
            <a href="<%-product.path%>" class="flex shop_item_a">
                <div class="shop_item_photo">
                    <img src="<%-product.thumbnail%>" class="shop_item_img" />
                </div>
                <div class="flex-1 flex flex-v shop_item_text">
                    <p style="font-size: 12px;color: #333333"><%-product.name%></p>
                    <p class="shop_item_name"><%-product.caption%></p>
                    <div class="flex shop_item_num" style="padding-top: 7px">
                        <p class="shop_item_hot"><%-product.productTag%></p>
                        <p class="flex-1 shop_item_p_buy"><%-product.sales%>人已买</p>
                    </div>
                    <div class="flex shop_item_num" style="padding-top: 2px">
                        <div class="flex flex-align-center hgi_price">
                            <i class="icon_1 icon_1_jf2"></i>
                            <p class="goods_price_num"><span><%-product.pricePartOne%></span><%-product.pricePartTwo%></p>
                        </div>
                        <p class="flex-1 flex flex-align-center shop_item_high_praise" style="text-decoration: line-through;">市场价:<%-product.defaultSku.marketPrice%>元</p>
                    </div>
                </div>
            </a>
        </li>
        <%})%>
    </script>
    <script>
        var orderName='${orderName}';
        var fenLeiId='${fenLeiId}';
        var ajaxFlag=false;
        $(function () {
            $('.close-batton').bind('click', function() {
                $('.fenlei').hide();
            });
            if(orderName =='priceAsc'){
                $("#slt_upDown").css("border-top","4px solid rgb(153, 153, 153)");
                $("#slt_upUp").css("border-bottom","4px solid rgb(245, 112, 28)");
            }else{
                $("#slt_upUp").css("border-bottom"," 4px solid rgb(153, 153, 153)");
                $("#slt_upDown").css("border-top","4px solid rgb(245, 112, 28)");
            }

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
            var $shopList = $("#shopList");
            var shopListTemplate = _.template($("#shopListTemplate").html());

            // 无限滚动加载
            $shopList.infiniteScroll({
                url: function(pageNumber) {
                    if(ajaxFlag){
                        pageNumber=2;
                        alert(1);
                    }
                    return "${base}/store/allProductAjax?pageNumber=" + pageNumber+"&storeId=${store.id}&descName="+orderName+"&fenLeiId="+fenLeiId;
                },
                pageSize: 10,
                template: function(pageNumber, data) {
                    return shopListTemplate({
                        products: data
                    });
                }
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
                        initData(slt[slti].getAttribute("lt"),"down")
                    }else{
                        $(slt[slti].parentNode).find(".slt_up").css("border-bottom"," 4px solid #f5701c");
                        $(slt[slti].parentNode).find(".slt_down").css("border-top"," 4px solid #999");
                        slt[slti].setAttribute("up","1");
                        initData(slt[slti].getAttribute("lt"),"up")
                    }
                }
            }
        }
function showFenLei(){
        $('.fenlei').show();
}
        function initData(ordername,upOrDown){
            if(ordername =='monthHits'){
                window.location.href='${base}/store/allProduct/hot_up/${store.id}/0';
            }
            if(ordername =='sales'){
                window.location.href='${base}/store/allProduct/sales_up/${store.id}/0';
            }
            if(ordername =='price'){
                if(upOrDown =="up"){
                    window.location.href="${base}/store/allProduct/price_up/"+${store.id}+"/"+fenLeiId;
                }else{
                    window.location.href='${base}/store/allProduct/price_down/'+${store.id}+"/"+fenLeiId;
                }
            }
           /* $("#shopList").html("");
         var $shopList = $("#shopList");
           var shopListTemplate = _.template($("#shopListTemplate").html());
           // 无限滚动加载
           $shopList.infiniteScroll({
               url: function(pageNumber) {
                   return "${base}/store/allProductAjax?pageNumber="+pageNumber+"&storeId=${store.id}&descName="+orderName;
                },
                pageSize: 10,
                template: function(pageNumber, data) {
                    return shopListTemplate({
                        products: data
                    });
                }
            });*/
            /*ajaxFlag=true;
            $.ajax({
                url :  "${base}/store/allProductAjax?pageNumber=1&storeId=${store.id}&descName="+orderName,
                type : "GET",
                dataType : "json",
                success: function (result) {
                   if(result.length>0){
                       var html="";
                       for (var i=0;i<result.length;i++){
                           var product=result[i];
                            html+=' <li class="shop_item">' +
                                   '            <a href="javascript:;" class="flex shop_item_a">' +
                                   '                <div class="shop_item_photo">' +
                                   '                    <img src="/newResources/shop/images/goods1.jpg" class="shop_item_img" />' +
                                   '                </div>' +
                                   '                <div class="flex-1 flex flex-v shop_item_text">' +
                                   '                    <p style="font-size: 12px;color: #333333">'+product.name+'</p>' +
                                   '                    <p class="shop_item_name">'+product.caption+'</p>' +
                                   '                    <div class="flex shop_item_num" style="padding-top: 7px">' +
                                   '                        <p class="shop_item_hot">'+product.productTag+'</p>' +
                                   '                        <p class="flex-1 shop_item_p_buy">'+product.sales+'人已买</p>' +
                                   '                    </div>' +
                                   '                    <div class="flex shop_item_num" style="padding-top: 2px">' +
                                   '                        <div class="flex flex-align-center hgi_price">' +
                                   '                            <i class="icon_1 icon_1_jf2"></i>' +
                                   '                            <p class="goods_price_num"><span>'+product.defaultSku.price+'</span></p>' +
                                   '                        </div>' +
                                   '                        <p class="flex-1 flex flex-align-center shop_item_high_praise" style="text-decoration: line-through;">市场价:'+product.defaultSku.marketPrice+'元</p>' +
                                   '                    </div>' +
                                   '                </div>' +
                                   '            </a>' +
                                   '        </li>';
                       }
                       if(html!=''){
                           $("#shopList").html(html);
                       }
                   }
                }
            });*/
        }
        function selectFenLei(id) {
            $('.fenlei').hide();
            if(orderName=='priceAsc'){
                window.location.href='${base}/store/allProduct/price_up/'+${store.id}+'/'+id;
            }else{
                window.location.href='${base}/store/allProduct/price_down/'+${store.id}+'/'+id;
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
        <a href="/" class="head_back" style="z-index: 1000">
            <div class="flex flex-align-center head_back_div"><sapn class="icon_1 icon_1_back"></sapn></div>
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
            <a href="/store/${store.id}" class="flex-1 sb_type_a">店铺推荐</a>
            <a href="/store/newProduct/${store.id}" class="flex-1 sb_type_a">最近新品</a>
            <a href="/store/allProduct/${store.id}" class="flex-1 sb_type_a checked">全部商品</a>
            <a href="/store/task/${store.id}" class="flex-1 sb_type_a">店铺任务</a>
        </div>
    </div>
</div>

<div style="height: 106px;"></div>
<div style="width: 100%;height: 2px;position: fixed;z-index: 101;background: #f5f5f5;"></div>
<div class="flex flex-align-center shop_list_type">
    <div class="flex-1 shop_list_type_item">
        <input type="radio" name="shop_list_type" lt="monthHits" id="slt1" onclick="shop_list_type_change(this)">
        <label for="slt1" class="flex flex-align-center flex-pack-center slti_label">
            <p class="shop_list_type_item_p">热度</p>
        </label>
    </div>
    <div class="flex-1 shop_list_type_item">
        <input type="radio" name="shop_list_type" lt="sales" id="slt2" onclick="shop_list_type_change(this)">
        <label for="slt2" class="flex flex-align-center flex-pack-center slti_label">
            <p class="shop_list_type_item_p">销量</p>
            <div class="slt_up_down">
                <i class="slt_up"></i>
                <i class="slt_down"></i>
            </div>
        </label>
    </div>
    <div class="flex-1 shop_list_type_item">
        <input type="radio" name="shop_list_type" lt="price" id="slt3" onclick="shop_list_type_change(this)" checked [#if orderName=="priceAsc"]up="1"[/#if]>
        <label for="slt3" class="flex flex-align-center flex-pack-center slti_label">
            <p class="shop_list_type_item_p">价格</p>
            <div class="slt_up_down">
                <i class="slt_up" id="slt_upUp"></i>
                <i class="slt_down" id="slt_upDown"></i>
            </div>
        </label>
    </div>
    <div class="flex-1 shop_list_type_item">
        <label for="slt4" class="flex flex-align-center flex-pack-center slti_label" onclick="showFenLei()">
            <p class="shop_list_type_item_p">分类</p>
        </label>
    </div>
</div>
<div style="height: 45px;"></div>
<div class="shop_list_div">
    <ul class="shop_list" id="shopList">
    </ul>
</div>
<div class="fenlei" style="display: none;">
    <div class="zuo">
        <img class="close-batton" src="/newResources/shop/images/close-batton.png" />
        <p onclick="selectFenLei(0)">
           全部分类
        </p>
    </div>
    <div class="you">
        <div class="gundong">
        [@store_product_category_root_list storeId = store.id]
            [#if storeProductCategories?has_content]
                [#list storeProductCategories as storeProductCategory]
                                <div class="you_con">
                                    <p class="yiji" onclick="selectFenLei(${storeProductCategory.id})">${abbreviate(storeProductCategory.name, 15)}</p>
                                    [@store_product_category_children_list storeProductCategoryId = storeProductCategory.id storeId = store.id recursive = false]
                                        [#list storeProductCategories as storeProductCategory]
                                         <span class="erji" onclick="selectFenLei(${storeProductCategory.id})">${abbreviate(storeProductCategory.name, 15)}</span>
                                        [/#list]
                                    [/@store_product_category_children_list]
                                </div>
                [/#list]
            [/#if]
        [/@store_product_category_root_list]
        </div>

    </div>
    </div>
</body>

</html>