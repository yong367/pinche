<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>爱帮伴-我的订单</title>
    <link href="${base}/favicon.ico" rel="icon">
    <link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
    <link href="${base}/resources/mobile/member/css/font-awesome.css" rel="stylesheet">
    <link href="${base}/resources/mobile/member/css/animate.css" rel="stylesheet">
    <link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
    <link href="${base}/resources/mobile/member/css/profile.css" rel="stylesheet">
    <!--[if lt IE 9]>
    <script src="${base}/resources/mobile/member/js/html5shiv.js"></script>
    <script src="${base}/resources/mobile/member/js/respond.js"></script>
    <![endif]-->
    <script src="${base}/resources/mobile/member/js/jquery.js"></script>
    <script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
    <script src="${base}/resources/mobile/member/js/underscore.js"></script>
    <script src="${base}/resources/mobile/member/js/common.js"></script>
    <script id="orderTemplate" type="text/template">
        <%
        function statusText(status) {
        switch(status) {
        case "pendingPayment":
        return "${message("Order.Status.pendingPayment")}";
        case "pendingReview":
        return "${message("Order.Status.pendingReview")}";
        case "pendingShipment":
        return "${message("Order.Status.pendingShipment")}";
        case "shipped":
        return "${message("Order.Status.shipped")}";
        case "received":
        return "${message("Order.Status.received")}";
        case "completed":
        return "${message("Order.Status.completed")}";
        case "failed":
        return "${message("Order.Status.failed")}";
        case "canceled":
        return "${message("Order.Status.canceled")}";
        case "denied":
        return "${message("Order.Status.denied")}";
        }
        }

        function productType(type) {
        switch(type) {
        case "exchange":
        return "${message("Product.Type.exchange")}";
        case "gift":
        return "${message("Product.Type.gift")}";
        }
        }
        %>
        <%_.each(orders, function(order, i) {%>
        <div class="panel panel-flat">
            <div class="panel-heading">
                <span class="small">${message("OrderItem.sn")}: <%-order.sn%></span>
                <%if (order.hasExpired) {%>
                <em class="pull-right gray-darker">${message("member.order.hasExpired")}</em>
                <%} else {%>
                <em class="pull-right orange">
                    <%-statusText(order.status)%>
                </em>
                <%}%>
            </div>
            <div class="panel-body">
                <div class="list-group list-group-flat">
                    <%_.each(order.orderItems, function(orderItem, i) {%>
                    <div class="list-group-item">
                        <div class="media">
                            <div class="media-left media-middle">
                                <a href="view?orderSn=<%-order.sn%>">
                                    <img src="<%-orderItem.thumbnail != null ? orderItem.thumbnail : "${setting.defaultThumbnailProductImage}
                                    "%>" alt="<%-orderItem.name%>">
                                </a>
                            </div>
                            <div class="media-body media-middle">
                                <h4 class="media-heading">
                                    <a href="view?orderSn=<%-order.sn%>"><%-orderItem.name%></a>
                                </h4>
                                <%if (orderItem.specifications.length > 0) {%>
                                <span class="small gray-darker"><%-orderItem.specifications.join(", ")%></span>
                                <%}%>
                                <%if (order.type != "general") {%>
                                <strong class="small red">[<%-productType(order.type)%>]</strong>
                                <%}%>
                            </div>
                        </div>
                    </div>
                    <%})%>
                </div>
            </div>
            <div class="panel-footer text-right">
					[#if isKuaidi100Enabled]
						<%var orderShipping = !_.isEmpty(order.orderShippings) ? order.orderShippings[0] : null;%>
						<%if (orderShipping != null && orderShipping.deliveryCorp != null && orderShipping.trackingNo !=
                        null) {%>
							<button class="transit-step btn btn-sm btn-default" type="button"
                                    data-order-shipping-sn="<%-orderShipping.sn%>">${message("member.order.transitStep")}</button>
						<%}%>
                    [/#if]
                <a class="btn btn-sm btn-default" href="view?orderSn=<%-order.sn%>">${message("member.order.view")}</a>
            </div>
        </div>
        <%})%>
    </script>
    <script id="transitStepTemplate" type="text/template">
        <%if (_.isEmpty(data.transitSteps)) {%>
        <p class="gray-darker">${message("member.common.noResult")}</p>
        <%} else {%>
        <div class="list-group list-group-flat">
            <%_.each(data.transitSteps, function(transitStep, i) {%>
            <div class="list-group-item">
                <p class="small gray-darker"><%-transitStep.time%></p>
                <p class="small"><%-transitStep.context%></p>
            </div>
            <%})%>
        </div>
        <%}%>
    </script>
    <script type="text/javascript">
        $().ready(function () {

            var $transitStepModal = $("#transitStepModal");
            var $transitStepModalBody = $("#transitStepModal div.modal-body");
            var $orderItems = $("#orderItems");
            var orderTemplate = _.template($("#orderTemplate").html());
            var transitStepTemplate = _.template($("#transitStepTemplate").html());

            // 无限滚动加载
            $orderItems.infiniteScroll({
                url: function (pageNumber) {
                    return "${base}/member/order/list?pageNumber=" + pageNumber + "&status=${status}" + "&hasExpired=${(hasExpired?string("true", "false"))!}";
                },
                pageSize: 10,
                template: function (pageNumber, data) {
                    return orderTemplate({
                        orders: data
                    });
                }
            });

            // 物流动态
            $orderItems.on("click", "button.transit-step", function () {
                var $element = $(this);
                $.ajax({
                    url: "${base}/member/order/transit_step",
                    type: "GET",
                    data: {
                        orderShippingSn: $element.data("order-shipping-sn")
                    },
                    dataType: "json",
                    beforeSend: function () {
                        $transitStepModalBody.empty();
                        $transitStepModal.modal();
                    },
                    success: function (data) {
                        $transitStepModalBody.html(transitStepTemplate({
                            data: data
                        }));
                    }
                });
                return false;
            });

        });
    </script>
</head>
<body class="profile" style="background: #F2F2F2">
<div id="transitStepModal" class="transit-step-modal modal fade" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button class="close" type="button" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">${message("member.order.transitStep")}</h4>
            </div>
            <div class="modal-body"></div>
            <div class="modal-footer">
                <button class="btn btn-sm btn-default" type="button"
                        data-dismiss="modal">${message("member.order.close")}</button>
            </div>
        </div>
    </div>
</div>
<header class="header-fixed"
        style="background:linear-gradient(86deg,rgba(150,100,111,1) 0%,rgba(107,107,138,1) 50%,rgba(217,124,117,1) 100%);color: #FFFFFF">
    <a class="pull-left" href="${base}/member/index" style="color: #FFFFFF">
        <span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
    </a>
${message("member.order.list")}
</header>
<div class="orderNav">
    <ul>
        <li [#if status== null]class="active"[/#if]><a href="${base}/member/order/list">全部订单</a></li>
        <li [#if status== "pendingPayment"]class="active"[/#if]><a
                href="${base}/member/order/list?status=pendingPayment">待付款</a></li>
        <li [#if status== "pendingShipment"]class="active"[/#if]><a
                href="${base}/member/order/list?status=pendingShipment">待发货</a></li>
        <li [#if status== "shipped"]class="active"[/#if]><a href="${base}/member/order/list?status=shipped">待收货</a></li>
        <li [#if status== "completed"]class="active"[/#if]><a href="${base}/member/order/list?status=completed">已收货</a>
        </li>
    </ul>
</div>
<div style="height: 10px"></div>
<main style="margin-top:80px; background: none">
    <div class="container-fluid">
        <div id="orderItems">
            <div style="width: 95%;margin: 0 auto;background: #ffffff;border-radius: 20px; margin-bottom: 20px">
                <div class="" style="width: 95%; margin: 0 auto;padding-top: 1rem;">
                    <div class="">
                        <a class="small"
                           style="font-size:15px;font-family:PingFang SC;font-weight:500;color:rgba(23,23,23,1);">兑伴自营&gt;</a>
                        <em class="orange"
                            style="font-size: 15px; font-family: PingFang SC;font-weight: 500;color: rgba(211,40,31,1);float: right">代付款</em>
                    </div>
                </div>
                <div class="">
                    <div class="media-left media-middle">
                        <div class="media" style="width: 30%;float: left;height: 8rem;;">
                            <a href="view?orderSn=2019110134946" style="display: block;float: left;width: 100%;height: 100%;">
                                <img src="http://www.lifeabb.com/upload/image/201903/d3733367-1e3b-4410-8bc2-6735c41198d0_thumbnail.jpg"
                                     alt="水母灯" style="margin:10%;display: block;width: 7rem; height: 7rem;max-width: 100%;">
                            </a>
                    </div>
                        <div class="media-body media-middle">
                            <div class="media-heading"
                                 style="width: 100%; height: 3rem;line-height: 1.5rem;font-size: 1.5rem;">
                                <a href="view?orderSn=2019110134946">魅力红魅力红没拿手机壳好的吧刷卡机顿饭很贵吧开始的</a>
                            </div>
                        </div>
                        <div style="font-size: 14px;float: right;margin-right: -4rem;text-align: right">
                            <span style="width: 4rem;display: inline-block;">魅力红</span>
                            <span style="width: 4rem;display: inline-block;">数量:2</span>
                            <span style="width: 6rem;display: inline-block;">1390.00</span>
                        </div>
                    </div>
                    <div class="text-right" style="padding: 10px 15px;margin-top: -2rem">
                        <a class="btn btn-sm btn-default" href="view?orderSn=2019110134946"
                           style="width: 87px;height: 30px;border: 1px solid rgba(234,86,14,1);border-radius: 20px;color: #EA560E;line-height: 15px;font-size: 15px;margin-right: 10px">再次购买</a>
                        <a class="btn btn-sm btn-default" href="view?orderSn=2019110134946"
                           style="width: 87px;height: 30px;border: 1px solid rgba(234,86,14,1);border-radius: 20px;color: #EA560E;line-height: 15px;font-size: 15px;margin-right: 10px">取消订单</a>
                        <a class="btn btn-sm btn-default" href="view?orderSn=2019110134946"
                           style="font-size: 16px; width: 85px;height: 30px;line-height: 14px; background: linear-gradient(-59deg,rgba(247,162,134,1) 0%,rgba(233,127,110,1) 100%);border-radius: 14px;color: #ffffff;">立即支付</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<div class="clearfix"></div>
[#--数据监控--]
<script>
    var _mtac = {};
    (function () {
        var mta = document.createElement("script");
        mta.src = "//pingjs.qq.com/h5/stats.js?v2.0.4";
        mta.setAttribute("name", "MTAH5");
        mta.setAttribute("sid", "500660889");

        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(mta, s);
    })();
</script>
</body>
</html>