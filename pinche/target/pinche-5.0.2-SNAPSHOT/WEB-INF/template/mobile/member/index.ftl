<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name=“viewport” content=“width=device-width, viewport-fit=cover”>
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <link rel="stylesheet" href="${base}/resources/mobile/member/css/mypage.css"/>
    <title>会员中心</title>
</head>
<body>
<div class="one">
    <div style="height:0.18rem;"></div>
    <div class="top">
        <div class="img">
            <img src="[#if currentUser.imageUrl?has_content]
                            ${currentUser.imageUrl}
                          [#else]
                            ${setting.defaultMemberLogo}
                          [/#if]"/>
        </div>
        <div class="sj">
                <span class="phone">
                ${currentUser.mobile}
                </span>
                [#if currentUser.authenticationStatus]
                    <span class="renZ">已认证</span>
                [#else]
                    <a href="${base}/member/authentification/authentification?preActionName=setting">
                        <span class="renZ">未认证</span>
                        <img src="${base}/resources/mobile/member/images/mypage/error.png"/>
                    </a>
                [/#if]
        </div>
        <a class="members" href='javascript:$("#area_tip").show();'>
            <div>${currentUser.memberRank.name}</div>
            <img src="${base}/resources/mobile/member/images/mypage/right_bai.png"/>
        </a>
        <div class="sz_sm">
            <img id="sm" src="${base}/resources/mobile/member/images/mypage/sm.png" onclick="openqr();"/>
            <a href="${base}/member/index/setting" class="sz">
                <img src="${base}/resources/mobile/member/images/mypage/sz.png"/>
            </a>
        </div>
    </div>
    <div class="bottom">
        <div class="account a1">
            <div class="money">
            ${currentUser.balance}
            </div>
            <a class="qb" href="${base}/member/myDuiBan/balance">
                钱包
                <img src="${base}/resources/mobile/member/images/mypage/right_bai.png"/>
            </a>

        </div>
        <img class="img1" src="${base}/resources/mobile/member/images/mypage/zx.png"/>
        <div class="account a2">
            <div class="adsl">
            ${currentUser.point}
            </div>
            <span class="ad">
                    爱豆
                </span>
        </div>
        <img class="img2" src="${base}/resources/mobile/member/images/mypage/zx.png"/>
        <a class="account a3" href="${base}/member/fans/fans">
            <div class="fssl">
            ${fansCount}
            </div>
            <span class="fs">
                    粉丝 <img src="${base}/resources/mobile/member/images/mypage/right_bai.png"/>
                </span>
        </a>
    </div>
</div>
<div class="two">
    <a class="tit" href="/">
        兑伴儿商城
        <img src="${base}/resources/mobile/member/images/mypage/right_hui.png" alt=""/>
    </a>
    <div class="ban_er">
        <a class="duiBan left" href="${base}/member/coupon_code/list">
            <div class="coupons">
            ${couponCodeCount}
            </div>
            <p class="yh">
                优惠券
            </p>
        </a>
        <div class="db_img left">
            <img src="${base}/resources/mobile/member/images/mypage/szx1.png"/>
        </div>
        <a class="duiBan left" href="${base}/member/product_favorite/list">
            <div class="goods">
            ${productFavoriteCount}
            </div>
            <p class="sp">
                关注商品
            </p>
        </a>
        <div class="db_img left">
            <img src="${base}/resources/mobile/member/images/mypage/szx1.png"/>
        </div>
        <a class="duiBan left" href="${base}/member/store_favorite/list">
            <div class="store">
            ${storeFavoriteCount}
            </div>
            <p class="dp">
                关注店铺
            </p>
        </a>
    </div>
    <div class="hzx">
        <img src="${base}/resources/mobile/member/images/mypage/hzx.png"/>
    </div>
    <a class="tit_dd" href="${base}/member/order/list">
        我的订单
        <img src="${base}/resources/mobile/member/images/mypage/right_hui.png" alt=""/>
    </a>
    <div class="orderDetails">
        <div class="suliang">
            <div>
                 [#if pendingPaymentOrderCount>0]
                     <span class="sl">${pendingPaymentOrderCount}</span>
                 [/#if]
            </div>
            <div>
                [#if pendingShipmentOrderCount>0]
                    <span class="sl">${pendingShipmentOrderCount}</span>
                [/#if]
            </div>
            <div>
                [#if shippedOrderCount>0]
                    <span class="sl">${shippedOrderCount}</span>
                [/#if]
            </div>
            <div>
                [#if accomplishOrderCount>0]
                    <span class="sl">${accomplishOrderCount}</span>
                [/#if]
            </div>
        </div>
        <div>
            <a class="left dfk" href="${base}/member/order/list?status=pendingPayment&hasExpired=false">
                <img src="${base}/resources/mobile/member/images/mypage/dfk.png"/>
                <span>待付款</span>
            </a>
            <a class="left dfh" href="${base}/member/order/list?status=pendingShipment&hasExpired=false">
                <img src="${base}/resources/mobile/member/images/mypage/dfh.png"/>
                <span>待发货</span>
            </a>
            <a class="left dsh" href="${base}/member/order/list?status=shipped">
                <img src="${base}/resources/mobile/member/images/mypage/dsh.png"/>
                <span>待收货</span>
            </a>
            <a class="left ywc" href="${base}/member/order/list?status=completed">
                <img src="${base}/resources/mobile/member/images/mypage/ywc.png"/>
                <span>已完成</span>
            </a>
        </div>
    </div>
</div>
<a class="three" href="${base}/member/share/index">
    <img src="${base}/resources/mobile/member/images/mypage/yq.png"/>
</a>
<div class="four">
    <a class="tit" href="${base}/member/task/list">
        赚零花
        <img src="${base}/resources/mobile/member/images/mypage/right_hui.png" alt=""/>
    </a>
    <div class="zlh">
        <a class="duiBan left" href="${base}/member/earnings/toDayearnings">
            <div class="coupons">
            ${toDayYongJin}
            </div>
            <p class="yh">
                今日收益
            </p>
        </a>
        <div class="db_img left">
            <img src="${base}/resources/mobile/member/images/mypage/szx1.png"/>
        </div>
        <a class="duiBan left" href="${base}/member/task/myTask">
            <div class="goods">
            ${myTaskCount}
            </div>
            <p class="sp">
                我的任务
            </p>
        </a>
        <div class="db_img left">
            <img src="${base}/resources/mobile/member/images/mypage/szx1.png"/>
        </div>
        <a class="duiBan left" href="${base}/member/task/joinTaskList">
            <div class="store">
            ${participateCount}
            </div>
            <p class="dp">
                参与清单
            </p>
        </a>
    </div>
</div>
<div class="five">
        <span class="tit">
            爱豆游戏大厅
        </span>
    <div class="game">
        <a class="youxi left" href="${base}/member/smashEggs/index">
            <img src="${base}/resources/mobile/member/images/mypage/zd.png"/>
            <div class="yh">
                砸金蛋
            </div>
        </a>
        <a class="youxi left" href="${base}/member/roundPlate/index">
            <img src="${base}/resources/mobile/member/images/mypage/dzp.png"/>
            <div class="sp">
                大转盘
            </div>
        </a>

        <div class="youxi left">
            <img src="${base}/resources/mobile/member/images/mypage/qidai.png"/>
            <div class="dp">
                敬请期待
            </div>
        </div>
    </div>
</div>
<div class="six">
        <span class="tit">
            更多
        </span>
    <div class="game">
        <a class="youxi left" href="${base}/member/index/page/about">
            <img src="${base}/resources/mobile/member/images/mypage/gywm.png"/>
            <div class="yh">
                关于我们
            </div>
        </a>
        <a class="youxi left" href="tel:4009698198">
            <img src="${base}/resources/mobile/member/images/mypage/kffw.png"/>
            <div class="sp">
                客服服务
            </div>
        </a>
        <a class="youxi left" href="${base}/member/index/page/commonissue">
            <img src="${base}/resources/mobile/member/images/mypage/cjwt.png"/>
            <div class="dp">
                常见问题
            </div>
        </a>
    </div>
</div>

<!--弹框-->
<div id="area_tip" style="display: none;">
    <div class="mb"></div>
    <div class="con">
        <div class="sj">
            <span>选择升级方式</span>
        </div>
        <div class="gbImg">
            <a href='javascript:$("#area_tip").hide();'><img src="${base}/resources/mobile/member/images/ch.png"/></a>
        </div>

        <div class="cs">
            您有两种方式可以升级会员<br/>等级，请选择
        </div>
        <div class="anNiu">
            <div class="a">
                <a href="${base}/member/gitBag/purchase" class="xg">购买礼包</a>
            </div>
            <div>
                <a href="${base}/member/point_log/exchangeIndex" class="qr">爱豆兑换</a>
            </div>
        </div>
    </div>
</div>
<div class="clear"></div>
</body>
<script src="${base}/resources/mobile/member/js/jquery.js"></script>
<script src="${base}/resources/shop/js/jweixin.js"></script>
<script type="text/javascript">
    //rem单位屏幕自适应代码(必要时放在最前面)-开始
    var screenWid = document.documentElement.offsetWidth || document.body.offsetWidth;
    var nowWid = (screenWid / 750) * 100;
    var oHtml = document.getElementsByTagName("html")[0];
    //		console.log(nowWid);
    oHtml.style.fontSize = nowWid + "px";
    //rem单位屏幕自适应代码(必要时放在最前面)-结束

</script>
<script>
    wx.config({
        debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
        appId: '${appId}', // 必填，公众号的唯一标识
        timestamp: '${timestamp}', // 必填，生成签名的时间戳
        nonceStr: '${nonceStr}', // 必填，生成签名的随机串
        signature: '${signature}',// 必填，签名，见附录1
        jsApiList: [
            'checkJsApi',
            'scanQRCode'// 微信扫一扫接口
        ]
    });

    function openqr() {
        wx.checkJsApi({
            jsApiList: ['scanQRCode'], // 需要检测的JS接口列表，所有JS接口列表见附录2,
            success: function (res) {
                // 以键值对的形式返回，可用的api值true，不可用为false
                // 如：{"checkResult":{"chooseImage":true},"errMsg":"checkJsApi:ok"}
                if (res.checkResult.scanQRCode == true) {
                    wx.scanQRCode({
                        needResult: 0,
                        success: function (res) {
                            var url = res.resultStr;
                            if (url.indexOf(',') != -1) {
                                url = url.split(',')[1];
                            }
                            window.location.href = url;
                        }
                    });
                }
                else {
                    Dialog.alert("提示", "您当前的环境不支持扫码!")
                }
            }
        });
    }
</script>
</html>