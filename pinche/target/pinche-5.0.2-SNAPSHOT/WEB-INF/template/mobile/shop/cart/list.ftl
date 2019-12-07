<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>爱帮伴-购物车</title>
    <link href="${base}/favicon.ico" rel="icon">
    <link href="${base}/resources/mobile/shop/css/bootstrap.css" rel="stylesheet">
    <link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
    <link rel="stylesheet" href="/newResources/shop/css/xw_style.css">
    [#--<link rel="stylesheet" type="text/css" href="/newResources/shopindex/css/commen.css"/>--]
    <!--[if lt IE 9]>
    <script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
    <script src="${base}/resources/mobile/shop/js/respond.js"></script>
    <![endif]-->
    <script src="${base}/resources/mobile/shop/js/jquery.js"></script>
    <script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
    <script src="${base}/resources/mobile/shop/js/underscore.js"></script>
    <script src="${base}/resources/mobile/shop/js/common.js"></script>
    <style>
        a {
            -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
            text-decoration: none
        }

        .nav {
            width: 100%;
            height: 50px;
            background: #fff;
            position: fixed;
            left: 0;
            bottom: 0;
            z-index: 999;
            border: none;
        }

        .nav .navbar1 {
            width: 100%;
            height: 100%;
        }
        .nav .navbar1 a {
            width: 19%;
        }

        .nav .navbar1 li {
            float: left;
            width: 100%;
            height: 100%;
            text-align: center;
            box-sizing: border-box;
            margin: 0 auto;
            margin-top: 8%;
        }

        .nav .navbar1 img {
            display: block;
            width: 27%;
            margin: 0 auto;
        }

        .nav .navbar1 li .bar-hui {
            /*font-size: 15px;*/
            color: #b9b5ea;
        }

    </style>
</head>
<body class="had_head_body had_foot_body shopcar_body">
<div class="head orange"
     style="background:linear-gradient(-85deg,rgba(169,207,252,1) 0%,rgba(144,164,251,1) 21%,rgba(148,168,254,1) 54%,rgba(148,168,254,1) 71%,rgba(213,190,218,1) 100%);">
    <ul class="flex head_dom">
        <li class="head_back">
            <div class="flex flex-align-center head_back_div">
                <button class="icon_1 icon_1_back" onclick="javascript: history.back();"></button>
            </div>
        </li>
        <li class="flex-1 head_title"><p class="head_title_p">购物车</p></li>
        <li class="head_right"></li>
    </ul>
</div>

<div class="shopcar_main"/>
[#if currentCart?? && currentCart.cartItems?has_content && currentCart.stores?has_content]
    <ul class="shopcar_list">
	[#list currentCart.stores as store]
        <li class="shopcar_item">
            <div class="shopname">
                <div class="flex shop_checkbox">
                    <input type="checkbox" name="shop" id="shop${store_index}" onchange="shop_chick(this)"/>
                    <label for="shop${store_index}" class="flex flex-align-center si_label">
                        <div class="flex flex-pack-center si_checkbox">
                            <i class="icon_1 icon_1_checked"></i>
                            <i class="icon_1 icon_1_unchecked"></i>
                        </div>
                    </label>
                    <p class="flex-1 shopname_p">${abbreviate(store.name, 50, "...")}</p>
                </div>
            </div>
            <ul class="goods">
				[#list currentCart.getCartItems(store) as cartItem]
                    <li class="flex goods_item" price="${currency(cartItem.price, false)}" goodsid="${cartItem.sku.id}"
                        id="li${cartItem.sku.id}">
                        <div class="goods_checkbox">
                            <input type="checkbox" name="goods" id="goods${cartItem_index}"
                                   onchange="goods_chick(this)"/>
                            <label for="goods${cartItem_index}"
                                   class="flex flex-align-center flex-pack-center gd_label">
                                <i class="icon_1 icon_1_checked"></i>
                                <i class="icon_1 icon_1_unchecked"></i>
                            </label>
                        </div>
                        <div class="flex flex-align-center goods_photo">
                            <img src="${cartItem.sku.thumbnail!setting.defaultThumbnailProductImage}" class="goods_img"
                                 alt="${cartItem.sku.name}"/>
                        </div>
                        <div class="flex-1 flex flex-v goods_info">
                            <div class="flex flex-align-center goods_name">
                                <p class="flex-1 goods_name_p" onclick="javascript:window.location.href='${base}${cartItem.sku.path}'">${cartItem.sku.name}</p>
                                <div class="goods_delete">
                                    <i class="icon_1 icon_1_delete"
                                       onclick="removeProduct(this,${cartItem.sku.id})"></i>
                                </div>
                            </div>
                            <div class="flex flex-align-center goods_num">
                                <div class="flex-1 flex flex-pack-justify-around goods_attr"><p
                                        class="flex-1 goods_attr_p" style="background-color: white"></p>
                                </div>
                                <div class="flex goods_counter">
                                    <button type="button" class="gd_c_m" name="minus" onclick="num_minus(this)"
                                            skuId="${cartItem.sku.id}">-
                                    </button>
                                    <input class="flex-1 gd_c_i" type="num" name="num" value="${cartItem.quantity}"
                                           onchange="num_change(this)"/>
                                    <button type="button" class="gd_c_p" name="plus" skuId="${cartItem.sku.id}"
                                            onclick="num_plus(this)">+
                                    </button>
                                </div>
                                <div class="flex flex-pack-center goods_price">
                                    <div class="icon_box goods_icon_box"><i class="icon_1 icon_1_jf1"></i></div>
                                    <p class="goods_price_num">
                                        <span>${newcurrency(cartItem.price,"one")}</span>${newcurrency(cartItem.price,"two")}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </li>
                [/#list]
            </ul>
        </li>
    [/#list]
    </ul>
[/#if]
</div>
<div class="flex flex-align-center shopcar_total" style="bottom: 55px;">
    <input type="checkbox" id="shopcar_all" name="shopcar_all" onchange="checked_all(this);">
    <label for="shopcar_all" class="flex flex-pack-center flex-align-center si_label">
        <div class="flex flex-pack-center si_checkbox">
            <i class="icon_1 icon_1_checked"></i>
            <i class="icon_1 icon_1_unchecked"></i>
        </div>
        <p class="shopcar_all_p">全选</p>
    </label>
    <p class="flex-1 shopcar_total_p" id="total_p">合计:0.00</p>
    <button type="button" class="shopcar_total_settlement" onclick="wind_up();" disabled="disabled" id="checkOutButton"
            style="background: rgb(148,168,254);">结算
    </button>
</div>
<div class="nav">
    <div class="">
        <ul class="navbar1">
            <a href="/" class="">
                <li class="zhuye">
                    <img src="/newResources/shopindex/img/bar1.png"/>
                    <div class="bar-hui">主页</div>
                </li>
            </a>
            <a href="/product_category" class="" >
                <li class="fenlei_bar">
                    <img src="/newResources/shopindex/img/bar2.png"/>
                    <div class="bar-hui">分类</div>
                </li>
            </a>
            <a href="/member/task/list" class="">
                <li class="zlh">
                    <img src="/newResources/shopindex/img/bar3.png"/>
                    <div class="bar-hui">赚零花</div>
                </li>
            </a>
            <a href="/cart/list" class="">
                <li class="gwc">
                    <img src="/newResources/shopindex/img/bar4-4.png" />
                    <div class="bar-hui" style="color:#7d9bed">购物车</div>
                </li>
            </a>
            <a href="/member/index" class=" ">
                <li class="wode">
                    <img src="/newResources/shopindex/img/bar5.png"/>
                    <div class="bar-hui">我的</div>
                </li>
            </a>
        </ul>
    </div>
</div>
</body>
<script type="text/javascript">
    [#if flashMessage?has_content]
		$.alert("${flashMessage}");
    [/#if]
    var goods_info = [];
    var goods_ids = [];
    var skuIds = "";
    // 格式化商品单价
    /* function goods_price_format(){
         var goods_item=$(".goods_item");
         var gi=0;
         goods_item.each(function(){
             gi=parseFloat($(this).attr("price"));
             $(this).find(".goods_price_num").html("<span>"+Math.floor(gi/100)+"</span>."+(gi/100).toFixed(2).split(".")[1]);
         })
         gi=undefined;
     }*/
    //商品数量减法
    function num_minus(btn) {
        var counter = btn.parentNode;
        var num_ipt = "";
        for (var mi = 0; mi < counter.children.length; mi++) {
            if (counter.children[mi].name == "num") {
                num_ipt = counter.children[mi];
            }
        }
        var num = parseInt(num_ipt.value);
        if (num - 1 < 1) {

            $.alert("商品不能再减少了！");
        } else {
            num_ipt.value = num - 1;
            //计算购物车内商品数量和总价
            modify($(btn).attr("skuid"), num_ipt.value, num_ipt);
        }
        // console.log(num_ipt);
    }

    //商品数量加法
    function num_plus(btn) {
        var counter = btn.parentNode;
        var num_ipt = "";
        for (var pi = 0; pi < counter.children.length; pi++) {
            if (counter.children[pi].name == "num") {
                num_ipt = counter.children[pi];
            }
        }
        var num = parseInt(num_ipt.value);
        num_ipt.value = num + 1;
        //计算购物车内商品数量和总价
        modify($(btn).attr("skuid"), num_ipt.value, num_ipt);
        // console.log(num_ipt);
    }

    function removeProduct(obj, skuId) {
        $.ajax({
            url: "remove",
            type: "POST",
            data: {
                skuId: skuId
            },
            dataType: "json",
            success: function (data) {

                var $li = $("#li" + skuId);
                var $ul = $li.parent();
                $li.remove();
                if ($ul.find("li").length == 0) {
                    $ul.parent().remove();
                }
                count_price();
                var goods_all_click = true;
                var shopcar_all = document.getElementById("shopcar_all");
                var goods = document.getElementsByName('goods');
                for (var shpi = 0; shpi < goods.length; shpi++) {
                    goods[shpi].checked ? "" : goods_all_click = false;
                }
                if (goods.length == 0) {
                    shopcar_all.checked = false;
                } else {
                    if (goods_all_click) {
                        shopcar_all.checked = true;
                    } else {
                        shopcar_all.checked = false;
                    }
                }
            },
            error: function () {
            },
            complete: function () {

            }
        });
    }

    function modify(skuId, num, obj) {
        $.ajax({
            url: "modify",
            type: "POST",
            data: {
                skuId: skuId,
                quantity: num
            },
            dataType: "json",
            success: function (data) {
                count_price();
            },
            error: function () {
                obj.value = num - 1
            },
            complete: function () {

            }
        });
    }

    //直接输入商品数量
    function num_change(ipt) {
        var counter = ipt.parentNode;
        var num_ipt = ipt;
        if (isNaN(parseInt(num_ipt.value))) {
            $.alert("输入内容不合规！");
        } else {
            num_ipt.value = parseInt(num_ipt.value);
            if (parseInt(num_ipt.value) < 1) {
                $.alert("至少添加一件商品！");
                num_ipt.value = 1;
            } else {
                //计算购物车内商品数量和总价
                modify($(btn).prop("skuId"), num_ipt.value, num_ipt);
            }
        }
    }

    //计算购物车内商品数量和总价
    function count_price() {
        var goods_item = $(".goods_item");
        var goods_checkbox = $(".goods_checkbox");
        var gd_c_i = $(".gd_c_i");
        var gi = [], gc = [], gnn = [], gids = [], gid = [], ginf = [];
        goods_item.each(function () {
            gi.push(parseFloat($(this).attr("price")));
            gid.push(parseFloat($(this).attr("goodsid")));
        })
        goods_checkbox.each(function () {
            gc.push($(this).find("input")[0].checked);
        })
        gd_c_i.each(function () {
            gnn.push(parseInt($(this).val()));
        })
        var total_price = 0;
        var total_num = 0;
        for (var toi = 0; toi < gi.length; toi++) {
            total_price = total_price + gi[toi] * (gc[toi] ? gnn[toi] : 0);
            total_num = total_num + (gc[toi] ? gnn[toi] : 0);
            gc[toi] ? gids.push(gid[toi]) : "";
            ginf[toi] = {"id": gid[toi], "price": gi[toi], "num": gnn[toi], "check": gc[toi]};
        }
        var total_yuan = (parseFloat(total_price)).toFixed(2) + "";
        goods_info = ginf;
        goods_ids = gids;
        // console.log("合计:"+total_price+"分。");
        // console.log("合计:"+total_yuan+"元。");
        // console.log("合计:"+total_num+"个。");
        // // 当前各商品状态
        // console.log(ginf);
        // //选中的商品id
        console.log(gids);
        skuIds = "";
        for (var si = 0; si < gids.length; si++) {
            skuIds += gids[si] + ",";
        }
        console.log(skuIds);
        if ($.trim(skuIds).length == 0) {
            updateButtonStyle(false);
        } else {
            updateButtonStyle(true);
        }
        document.getElementById('total_p').innerHTML = "合计:" + total_yuan;
    }

    function updateButtonStyle(flag) {
        if (flag) {
            $("#checkOutButton").css("background-color", "#f96d15");
            $("#checkOutButton").removeAttr("disabled");
        } else {
            $("#checkOutButton").css("background-color", "rgb(148,168,254)");
            $("#checkOutButton").attr("disabled", "disabled");
        }
    }

    //选择店铺
    function shop_chick(check) {
        var _checked = check.checked;
        var shops_all_click = true;
        var shops = document.getElementsByName('shop');
        var goods = document.getElementsByName('goods');
        var shopcar_all = document.getElementById("shopcar_all");
        var _goods_list = check.parentNode.parentNode.parentNode.children[1];
        for (var gli = 0; gli < _goods_list.children.length; gli++) {
            if (_goods_list.children[gli].children[0].children[0].name == "goods") {
                _goods_list.children[gli].children[0].children[0].checked = _checked;
            }
        }
        for (var shpi = 0; shpi < goods.length; shpi++) {
            goods[shpi].checked ? "" : shops_all_click = false;
        }
        //计算购物车内商品数量和总价
        count_price();
        if (goods.length == 0) {
            shopcar_all.checked = false;
        } else {
            if (shops_all_click) {
                shopcar_all.checked = true;
            } else {
                shopcar_all.checked = false;
            }
        }
        _goods_list = undefined, shops = undefined;
    }

    //选择商品
    function goods_chick(check) {
        var shopclicked = true;
        var goods_all_click = true;
        var goods = document.getElementsByName('goods');
        var shopcar_all = document.getElementById("shopcar_all");
        var _goods_list = check.parentNode.parentNode.parentNode.parentNode.children[1];
        for (var gli = 0; gli < _goods_list.children.length; gli++) {
            if (_goods_list.children[gli].children[0].children[0].name == "goods") {
                _goods_list.children[gli].children[0].children[0].checked ? "" : shopclicked = false;
            }
        }
        for (var gdsi = 0; gdsi < goods.length; gdsi++) {
            goods[gdsi].checked ? "" : goods_all_click = false;
        }
        _goods_list.parentNode.children[0].children[0].children[0].checked = shopclicked;
        //计算购物车内商品数量和总价
        count_price();
        if (goods.length == 0) {
            shopcar_all.checked = false;
        } else {
            if (goods_all_click) {
                shopcar_all.checked = true;
            } else {
                shopcar_all.checked = false;
            }
        }

        _goods_list = undefined, goods = undefined;
    }

    //全选商品
    function checked_all(dom) {
        var check = $(dom).is(":checked");
        var shops = document.getElementsByName('shop');
        var goods = document.getElementsByName('goods');
        if (check) {
            for (var shopi = 0; shopi < shops.length; shopi++) {
                shops[shopi].checked = true;
            }
            for (var goodsi = 0; goodsi < goods.length; goodsi++) {
                goods[goodsi].checked = true;
            }
        } else {
            for (var shopi = 0; shopi < shops.length; shopi++) {
                shops[shopi].checked = false;
            }
            for (var goodsi = 0; goodsi < goods.length; goodsi++) {
                goods[goodsi].checked = false;
            }
        }
        count_price();
        shops = undefined, goods = undefined;
    }

    //
    function wind_up() {
        // alert(1);
        var allFlag = $("#shopcar_all").is(":checked");
        window.location.href = "${base}/order/checkout?skuids=" + skuIds.substring(0, skuIds.length - 1) + "&allProduct=" + allFlag;
    }

    /* goods_price_format();*/
</script>
</html>