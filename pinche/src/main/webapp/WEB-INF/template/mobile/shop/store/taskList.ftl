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
            var num=$(".shop_list_div").find("li").length;
            if(num==0){
                var  htm='<ul class="shop_list" style="background-color: transparent;text-align: center">' +
                        '        <li style="text-align: center">暂无更多任务数据</li>' +
                        '                </ul>';
                $(".shop_list_div").html(htm);
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
            <a href="/store/${store.id}" class="flex-1 sb_type_a">店铺推荐</a>
            <a href="/store/newProduct/${store.id}" class="flex-1 sb_type_a">最近新品</a>
            <a href="/store/allProduct/hot_up/${store.id}/0" class="flex-1 sb_type_a">全部商品</a>
            <a href="/store/task/${store.id}" class="flex-1 sb_type_a checked">店铺任务</a>
        </div>
    </div>
</div>
<div style="height: 115px;"></div>
<div class="shop_list_div"/>
        [#if tasks?size>0]
            <ul class="shop_list" style="background-color: transparent;">
          [#list tasks as task]
        <li class="shop_item_blue">
            <a href="javascript:;" class="flex flex-align-center sib_a">
                <div class="sib_goods_photo"><img [#if task.taskInfo.coverPlanUrl ?has_content]src="${task.taskInfo.coverPlanUrl}"[#else ]src="${base}/resources/mobile/member/images/defaukeTaskImg.png"[/#if] class="sib_goods_photo_img" /></div>
                <div class="sib_text">
                    <p class="sib_t_name">${task.taskInfo.name}</p>
                    <div class="flex sib_to">
                        <div class="flex-1 flex flex-v flex-pack-center sib_tl">
                            <p class="sib_tl_p">任务剩余:${task.taskInfo.oddTaskNumber}件</p>
                            <p class="sib_tl_p"<p style="font-size:12px;color:#999999"p>${task.taskInfo.residueDays}天后结束</p>
                        </div>
                        <div class="flex flex-align-center sib_tr">
                            <p class="sib_tr_p">奖：<span>${newcurrency(task.taskInfo.rewardYongJin, "one")}</span>
                                ${newcurrency(task.taskInfo.rewardYongJin, "two")}
                            </p>
                        </div>
                    </div>
                </div>
            </a>
            <div class="flex flex-align-center sib_btns">
                <a href="javascript:;" class="flex-1 sib_btns_shop">兑伴儿自营</a>
                <a href="${base}/member/task/taskDetail?taskBusinessMappingId=${task.id}" class="sib_btns_accept">接受任务</a>
                <a href="${base}/member/task/taskDetail?taskBusinessMappingId=${task.id}" class="sib_btns_detail">查看详情</a>
            </div>
        </li>
          [/#list]
             </ul>
            [#else ]
                <ul class="shop_list" style="background-color: transparent;text-align: center">
        <li style="text-align: center">暂无数据</li>
                </ul>
        [/#if]

</div>

</body>

</html>