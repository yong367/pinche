<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>爱帮伴-我的订单</title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {
	
	[#if flashMessage?has_content]
		$.alert("${flashMessage}");
	[/#if]
	
});

</script>
</head>
<body>
	[#assign current = "orderList" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="list">
					<div class="title">
						<a href="${base}/member/order/list" [#if status== null]class="activeTitle"[/#if] >全部订单</a>
						<a href="${base}/member/order/list?status=pendingPayment" [#if status== "pendingPayment"]class="activeTitle"[/#if]>待付款</a>
						<a href="${base}/member/order/list?status=pendingShipment" [#if status== "pendingShipment"]class="activeTitle"[/#if]>待发货</a>
						<a href="${base}/member/order/list?status=shipped" [#if status== "shipped"]class="activeTitle"[/#if]>待收货</a>
					</div>
					
					
					<table class="list">
						<tr>
							<th class="firstTd">${message("member.orderItem.sku")}${message("OrderItem.name")}</th>
							<th>${message("OrderItem.quantity")}</th>
							<th>${message("Order.amount")}</th>
							<th>${message("Order.status")}</th>
							<th>${message("member.common.action")}</th>
						</tr>
						[#list page.content as order]
							<tr>
								<td colspan="5" class="orderColspan">
									<span>订单号：${order.sn}</span>
									<span>[#if order.store.type == "self"]${message("member.order.self")}[/#if]</span>
									<span>下单${message("member.order.time")}：${order.createdDate}</span>
								</td>
							</tr>
							[#list order.orderItems as orderItem]
								<tr>
									<td>
										<img src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" width="80" height="80" />
										<var>${abbreviate(orderItem.name, 50, "...")}</var>
									</td>
									<td class="rightBorder">
										${orderItem.quantity}
									</td>
									[#if orderItem_index < 1]
										<td rowspan="${order.orderItems?size}" style="color:#f19413">
                                            <img style="width: 15px;height: 15px; float: none" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(order.amount, false)}
										</td>
										<td rowspan="${order.orderItems?size}">
											${message("Order.Status." + order.status)}
											[#if order.hasExpired()]
												<span class="silver">(${message("member.order.hasExpired")})</span>
											[/#if]
										</td>
										<td rowspan="${order.orderItems?size}">
											<a href="view?orderSn=${order.sn}">[${message("member.common.view")}]</a>
										</td>
									[/#if]	
								</tr>	
							[/#list]
						[/#list]						
					</table>			
					[#if !page.content?has_content]
						<p>${message("member.common.noResult")}</p>
					[/#if]
				</div>
				[@pagination pageNumber = page.pageNumber totalPages = page.totalPages pattern = "?pageNumber={pageNumber}"]
					[#include "/shop/include/pagination.ftl"]
				[/@pagination]
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>