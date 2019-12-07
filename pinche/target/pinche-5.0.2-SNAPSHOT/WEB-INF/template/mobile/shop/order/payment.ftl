<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-订单支付</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/shop/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/order.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/shop/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/shop/js/jquery.js"></script>
	<script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/shop/js/velocity.js"></script>
	<script src="${base}/resources/mobile/shop/js/velocity.ui.js"></script>
	<script src="${base}/resources/mobile/shop/js/underscore.js"></script>
	<script src="${base}/resources/mobile/shop/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $paymentModal = $("#paymentModal");
		var $amountPayable = $("#amountPayable");
		var $feeItem = $("#feeItem");
		var $fee = $("#fee");
		var $paymentForm = $("#paymentForm");
		var $paymentPluginId = $("#paymentPluginId");
		var $paymentPluginItem = $("#paymentPlugin div.list-group-item");
		var $paymentButton = $("#paymentButton");
		var sns = new Array();
		
		[#list orderSns as orderSn]
			sns.push(${orderSn});
		[/#list]
		
		[#if online]
			// 获取订单锁
			function acquireLock() {
				$.ajax({
					url: "lock",
					type: "POST",
					data: {
						orderSns: sns
					},
					dataType: "json"
				});
			}
			
			// 获取订单锁
			acquireLock();
			setInterval(function() {
				acquireLock();
			}, 50000);
			
			// 检查等待付款
			setInterval(function() {
				$.ajax({
					url: "check_pending_payment",
					type: "GET",
					data: {
						orderSns: sns
					},
					dataType: "json",
					success: function(data) {
						if (!data) {
							location.href = "${base}/member/order/list";
						}
					}
				});
			}, 10000);
			
			// 支付插件项
			$paymentPluginItem.click(function() {
				var $element = $(this);
				$element.addClass("active").siblings().removeClass("active");
				var paymentPluginId = $element.data("payment-plugin-id");
				$paymentPluginId.val(paymentPluginId);
				calculateAmount();
			});
			
			calculateAmount();
			
			// 计算金额
			function calculateAmount() {
				$.ajax({
					url: "calculate_amount",
					type: "GET",
					data: {
						orderSns: sns,
						paymentPluginId: $paymentPluginId.val()
					},
					dataType: "json",
					success: function(data) {
						$amountPayable.html('<img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>'+currency(data.amount, false));
						if (data.fee > 0) {
							$fee.html('<img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>'+currency(data.fee, false));
							if ($feeItem.is(":hidden")) {
								$feeItem.velocity("slideDown");
							}
						} else {
							if ($feeItem.is(":visible")) {
								$feeItem.velocity("slideUp");
							}
						}
					}
				});
			}
			
			/*// 支付
			$paymentForm.submit(function() {
				$paymentModal.modal();
			});*/
		[/#if]
	
	});

    // 订单提交
   function payment() {
       var url="";
        $.ajax({
            url: "${base}/payment",
            type: "POST",
            data: $("#paymentForm").serialize(),
            dataType: "json",
            async:false,
            beforeSend: function() {
                $("#paymentButton").attr("disabled", true);
                return;
            },
            success: function(data) {
                $("#paymentModal").modal();
                url=data.url;
            },
            complete: function() {
                $("#paymentButton").attr("disabled", false);
            }
        });
        window.open(url,"_blank");
    }
	</script>
</head>
<body class="order-payment">
	<div id="paymentModal" class="modal fade" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button class="close" type="button" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">${message("shop.order.hint")}</h4>
				</div>
				<div class="modal-body">
					[#noautoesc]
						${message("shop.order.paymentDialog")}
					[/#noautoesc]
				</div>
				<div class="modal-footer">
					<a class="btn btn-primary" href="${base}/member/order/list">${message("shop.order.paid")}</a>
					<a class="btn btn-default" href="${base}/">${message("shop.order.trouble")}</a>
					<a class="other-payment-method text-right small gray-darker" href="javascript:;" data-dismiss="modal">${message("shop.order.otherPaymentMethod")}</a>
				</div>
			</div>
		</div>
	</div>
	<header class="header-fixed" style="background:linear-gradient(-85deg,rgba(169,207,252,1) 0%,rgba(144,164,251,1) 21%,rgba(148,168,254,1) 54%,rgba(148,168,254,1) 71%,rgba(213,190,218,1) 100%);color: #FFFFFF">
		<a class="pull-left" href="${base}/member/order/list">
			<span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
		</a>
		订单支付
	</header>
	<main>
		<div class="container-fluid">
			<div class="list-group list-group-flat">
				[#list orders as order]
					<div class="list-group-item small">
						${message("Order.sn")}: ${order.sn}
						<a class="pull-right gray-darker" href="${base}/member/order/view?orderSn=${order.sn}">[${message("shop.order.view")}]</a>
					</div>
				[/#list]
			</div>
			<div class="list-group list-group-flat">
				<div class="list-group-item small">
					[#if order.status == "pendingPayment"]
						${message("shop.order.pendingPayment")}
					[#elseif order.status == "pendingReview"]
						${message("shop.order.pendingReview")}
					[#else]
						${message("shop.order.pending")}
					[/#if]
				</div>
				[#if expireDate??]
					<div class="list-group-item small">
						<strong class="orange">${message("shop.order.expireTips", expireDate?string("yyyy-MM-dd HH:mm"))}</strong>
					</div>
				[/#if]
			</div>
			<div class="list-group list-group-flat">
				[#if online]
					<div class="list-group-item">
						支付总额
						<strong id="amountPayable" class="pull-right red"></strong>
					</div>
					<div id="feeItem" class="fee-item list-group-item">
						${message("Order.fee")}
						<strong id="fee" class="pull-right red"></strong>
					</div>
				[#else]
					<div class="list-group-item">
						${message("Order.amountPayable")}
						<strong id="amountPayable" class="pull-right red"><img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(amount, false)}</strong>
					</div>
				[/#if]
				<div class="list-group-item">
					${message("Order.shippingMethod")}
					<span class="pull-right">${shippingMethodName!"-"}</span>
				</div>
				<div class="list-group-item">
					充值支付
					<span class="pull-right">${paymentMethodName!"-"}</span>
				</div>
			</div>
			[#if online]
				[#if paymentPlugins?has_content]
					<form id="paymentForm" action="${base}/payment" method="post">
						[#list orderSns as orderSn]
							<input name="paymentItemList[${orderSn_index}].type" type="hidden" value="ORDER_PAYMENT">
							<input name="paymentItemList[${orderSn_index}].orderSn" type="hidden" value="${orderSn}">
						[/#list]
						<input id="paymentPluginId" name="paymentPluginId" type="hidden" value="${defaultPaymentPlugin.id}">
						<div class="panel panel-flat">
							<div class="panel-heading">支付方式</div>
							<div class="panel-body">
								<div id="paymentPlugin" class="list-group list-group-flat">
									[#list paymentPlugins as paymentPlugin]
										<div class="[#if paymentPlugin == defaultPaymentPlugin]active [/#if]list-group-item" data-payment-plugin-id="${paymentPlugin.id}">
											<div class="media">
												<div class="media-left media-middle">
													<div class="media-object">
														[#if paymentPlugin.logo?has_content]
															<img src="${paymentPlugin.logo}" alt="${paymentPlugin.paymentName}">
														[#else]
															${paymentPlugin.paymentName}
														[/#if]
													</div>
												</div>
												<div class="media-body media-middle">
													<span class="small gray-darker">${abbreviate(paymentPlugin.description, 100, "...")}</span>
												</div>
												<div class="media-right media-middle">
													<span class="glyphicon glyphicon-ok-circle"></span>
												</div>
											</div>
										</div>
									[/#list]
								</div>
							</div>
							<div class="panel-footer">
								<button id="paymentButton" onclick="payment()" class="btn btn-lg btn-red btn-flat btn-block" type="button" style="background: rgb(148,168,254);">立即支付</button>
							</div>
						</div>
					</form>
				[/#if]
			[#else]
				[#noautoesc]
					[#list orders as order]
						[#if order.paymentMethod.content?has_content]
							<div class="panel panel-flat">${order.paymentMethod.content}</div>
						[/#if]
					[/#list]
				[/#noautoesc]
			[/#if]
		</div>
	</main>
</body>
</html>