<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>爱帮伴-订单支付</title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/order.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $dialogOverlay = $("#dialogOverlay");
	var $dialog = $("#dialog");
	var $other = $("#other");
	var $amountPayable = $("#amountPayable");
	var $fee = $("#fee");
	var $paymentForm = $("#paymentForm");
	var $paymentPluginId = $("#paymentPlugin input:radio");
	var $paymentButton = $("#paymentButton");
	var sns = new Array();
	
	[#list orderSns as orderSn]
		sns.push(${orderSn});
	[/#list]	
	
	[#if online]
		// 订单锁定
		setInterval(function() {
			$.ajax({
				url: "lock",
				type: "POST",
				data: {orderSns: sns},
				dataType: "json",
				cache: false
			});
		}, 50000);
		
		// 检查等待付款
		setInterval(function() {
			$.ajax({
				url: "check_pending_payment",
				type: "GET",
				data: {orderSns: sns},
				dataType: "json",
				cache: false,
				success: function(data) {
					if (!data) {
						location.href = "${base}/member/order/list";
					}
				}
			});
		}, 10000);
	[/#if]
	
	// 选择其它支付方式
	$other.click(function() {
		$dialogOverlay.hide();
		$dialog.hide();
	});
	
	// 支付插件
	$paymentPluginId.click(function() {
		$.ajax({
			url: "calculate_amount",
			type: "GET",
			data: {paymentPluginId: $(this).val(), orderSns: sns},
			dataType: "json",
			traditional: true,
			cache: false,
			success: function(data) {
				$amountPayable.html('<img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>'+currency(data.amount, false, true));
				if (data.fee > 0) {
					$fee.html('<img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>'+currency(data.fee,false)).parent().show();
				} else {
					$fee.parent().hide();
				}
			},
			error: function(){
				setTimeout(function() {
					location.reload(true);
				}, 3000);
			}
		});
	});
	
	// 支付
	$paymentForm.submit(function() {
		$dialogOverlay.show();
		$dialog.show();
	});

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
            $("#dialog").show();
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
<body>
	<div id="dialogOverlay" class="dialogOverlay"></div>
	[#include "/shop/include/header.ftl" /]
	<div class="container payment">
		<div class="row">
			<div class="span12">
				<div id="dialog" class="dialog">
					[#noautoesc]
						${message("shop.order.paymentDialog")}
					[/#noautoesc]
					<div>
						<a href="${base}/member/order/list">${message("shop.order.paid")}</a>
						<a href="${base}/">${message("shop.order.trouble")}</a>
					</div>
					<a href="javascript:;" id="other">${message("shop.order.otherPaymentMethod")}</a>
				</div>
				<div class="result">
					[#if order.status == "pendingPayment"]
						<div class="title">${message("shop.order.pendingPayment")}</div>
					[#elseif order.status == "pendingReview"]
						<div class="title">${message("shop.order.pendingReview")}</div>
					[#else]
						<div class="title">${message("shop.order.pending")}</div>
					[/#if]
					<table>
						<tr>
							<th colspan="4">${message("shop.order.info")}:</th>
						</tr>
						<tr>
							<td rowspan="4">${message("Order.sn")}:</td>
							<td rowspan="4">
								[#list orders as order]
								<div>
									<strong>${order.sn}</strong>
									<a href="${base}/member/order/view?orderSn=${order.sn}">[${message("shop.order.view")}]</a>
								</div>
								[/#list]
							</td>
						</tr>
						<tr>
							<td>${message("Order.shippingMethod")}:</td>
							<td>${shippingMethodName}</td>
						</tr>
						<tr>
							<td>${message("Order.paymentMethod")}:</td>
							<td>${paymentMethodName}</td>
						</tr>
						<tr>
							<td>${message("Order.amountPayable")}:</td>
							<td>
								[#if amount??]
									<strong id="amountPayable"><img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(amount, false, true)}</strong>
								[/#if]
								[#if fee??]
									<span[#if fee <= 0] class="hidden"[/#if]>(${message("Order.fee")}: <span id="fee"><img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(fee, false)}</span>)</span>
								[/#if]
							</td>
						</tr>
						[#if expireDate??]
							<tr>
								<td colspan="4">${message("shop.order.expireTips", expireDate?string("yyyy-MM-dd HH:mm"))}</td>
							</tr>
						[/#if]
					</table>
					[#if online]
						[#if paymentPlugins?has_content]
							<form id="paymentForm" action="${base}/payment" method="post" target="_blank">
								[#list orderSns as orderSn]
									<input type="hidden" name="paymentItemList[${orderSn_index}].type" value="ORDER_PAYMENT" />
									<input type="hidden" name="paymentItemList[${orderSn_index}].orderSn" value="${orderSn}" />
								[/#list]
								<table id="paymentPlugin" class="paymentPlugin">
									<tr>
										<th colspan="4">${message("Order.paymentMethod")}:</th>
									</tr>
									[#list paymentPlugins?chunk(4, "") as row]
										<tr>
											[#list row as paymentPlugin]
												[#if paymentPlugin?has_content]
													<td>
														<input type="radio" id="${paymentPlugin.id}" name="paymentPluginId" value="${paymentPlugin.id}"[#if paymentPlugin == defaultPaymentPlugin] checked="checked"[/#if] />
														<label for="${paymentPlugin.id}">
															[#if paymentPlugin.logo?has_content]
																<em title="${paymentPlugin.paymentName}" style="background-image: url(${paymentPlugin.logo});">&nbsp;</em>
															[#else]
																<em>${paymentPlugin.paymentName}</em>
															[/#if]
														</label>
													</td>
												[#else]
													<td>
														&nbsp;
													</td>
												[/#if]
											[/#list]
										</tr>
									[/#list]
								</table>
								<input type="button" onclick="payment()" id="paymentButton" class="paymentButton" value="${message("shop.order.payNow")}" />
							</form>
						[/#if]
					[#else]
						[#noautoesc]
							${paymentMethod.content}
						[/#noautoesc]
					[/#if]
				</div>
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>