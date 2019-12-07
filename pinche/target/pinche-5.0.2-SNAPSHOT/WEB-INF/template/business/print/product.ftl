<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-购物单打印 </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<link href="${base}/resources/business/css/print.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script type="text/javascript">
	$().ready(function() {
	
		var $print = $("#print");
		
		// 打印
		$print.click(function() {
			window.print();
		});
	
	});
	</script>
</head>
<body class="print">
	<div class="bar hidden-print">
		<button id="print" class="btn btn-default" type="button">
			<i class="fa fa-print"></i>
			${message("business.print.print")}
		</button>
	</div>
	<main>
		<table class="table table-bordered">
			<tr>
				<td>
					<img src="${setting.logo}" alt="${setting.siteName}">
				</td>
				<td>
					<p>${setting.siteName}</p>
					<p>${setting.siteUrl}</p>
				</td>
				<td>
					<p>${message("Order.member")}: ${order.member.username}</p>
					<p>${message("Order.consignee")}: ${order.consignee}</p>
				</td>
			</tr>
			<tr>
				<td>${message("Order.sn")}: ${order.sn}</td>
				<td>${message("business.common.createdDate")}: ${order.createdDate?string("yyyy-MM-dd")}</td>
				<td>${message("business.print.printDate")}: ${.now?string("yyyy-MM-dd")}</td>
			</tr>
			<tr>
				<td>${message("Order.memo")}: ${order.memo}</td>
				<td colspan="2">
					[#if order.paymentMethodName??]
						<p>${message("Order.paymentMethod")}: ${order.paymentMethodName}</p>
					[/#if]
					[#if order.shippingMethodName??]
						<p>${message("Order.shippingMethod")}: ${order.shippingMethodName}</p>
					[/#if]
						<p>${message("Order.price")}:<img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/> ${currency(order.price, false)}</p>
					[#if order.fee > 0]
						<p>${message("Order.fee")}: <img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(order.fee, false)}</p>
					[/#if]
					[#if order.freight > 0]
						<p>${message("Order.freight")}: <img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(order.freight, false)}</p>
					[/#if]
					[#if order.tax > 0]
						<p>${message("Order.tax")}: <img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(order.tax, false)}</p>
					[/#if]
					[#if order.promotionDiscount > 0]
						<p>${message("Order.promotionDiscount")}: <img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(order.promotionDiscount, false)}</p>
					[/#if]
					[#if order.couponDiscount > 0]
						<p>${message("Order.couponDiscount")}: <img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(order.couponDiscount, false)}</p>
					[/#if]
					[#if order.offsetAmount != 0]
						<p>${message("Order.offsetAmount")}: <img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(order.offsetAmount, false)}</p>
					[/#if]
					<p>
						${message("Order.amount")}: <strong><img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(order.amount, false)}</strong>
					</p>
				</td>
			</tr>
		</table>
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>${message("business.print.number")}</th>
					<th>${message("OrderItem.sn")}</th>
					<th>${message("OrderItem.name")}</th>
					<th>${message("OrderItem.price")}</th>
					<th>${message("OrderItem.quantity")}</th>
					<th>${message("OrderItem.subtotal")}</th>
				</tr>
			</thead>
			<tbody>
				[#list order.orderItems as orderItem]
					<tr>
						<td>${orderItem_index + 1}</td>
						<td>${orderItem.sn}</td>
						<td>
							${abbreviate(orderItem.name, 50, "...")}
							[#if orderItem.specifications?has_content]
								<span class="gray-darker">[${orderItem.specifications?join(", ")}]</span>
							[/#if]
							[#if orderItem.type != "general"]
								<span class="text-red">[${message("Product.Type." + orderItem.type)}]</span>
							[/#if]
						</td>
						<td>
							[#if orderItem.type == "general"]
                                <img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(orderItem.price, false)}
							[#else]
								-
							[/#if]
						</td>
						<td>${orderItem.quantity}</td>
						<td>
							[#if orderItem.type == "general"]
                                <img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(orderItem.subtotal, false)}
							[#else]
								-
							[/#if]
						</td>
					</tr>
				[/#list]
			</tbody>
		</table>
		<div class="text-right">Powered By lifeabb.com</div>
	</main>
</body>
</html>