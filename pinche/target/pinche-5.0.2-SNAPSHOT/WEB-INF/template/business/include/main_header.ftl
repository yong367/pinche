<header class="main-header" style="height: 80px">
	<a class="logo" href="${base}/business/index" style="background-color: #333333;margin-top: 15px">
		<span class="logo-mini" style="display: block;">
			<img class="img-circle" src="${base}/resources/business/images/blogo.png" style="width: 100%;height: 100%;border-radius: 0px">
		</span>
		[#--<span class="logo-lg">${abbreviate(currentStore.name, 16, "...")}</span>--]
	</a>
	<nav class="navbar navbar-static-top" style="background-color: #333333">
		<div class="container-fluid">
			[#--<a class="sidebar-toggle" href="javascript:;" data-toggle="offcanvas"></a>--]
			<div class="navbar-custom-menu">
				<ul class="nav navbar-nav">
                    <li class="dropdown notifications-menu">
                        <a class="dropdown-toggle" href="javascript:;void(0)" data-toggle="dropdown" style="margin-top: 15px;">
                            <span class="fa fa-bell-o" style="font-size: 20px;"></span>
							[@order_count storeId = currentStore.id status = "pendingPayment" hasExpired = false]
								[#assign pendingPaymentCount = count]
							[/@order_count]
							[@order_count storeId = currentStore.id status = "pendingReview" hasExpired = false]
								[#assign pendingReviewCount = count]
							[/@order_count]
							[@order_count storeId = currentStore.id status = "pendingShipment"]
								[#assign pendingShipmentCount = count]
							[/@order_count]
							[@order_count storeId = currentStore.id isPendingRefunds = true]
								[#assign isPendingRefundsCount = count]
							[/@order_count]
                            <div class="label">
								[#if pendingPaymentCount + pendingReviewCount + pendingShipmentCount + isPendingRefundsCount > 0]
                                    <span class="fa fa-circle text-red"></span>
								[/#if]
                            </div>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="header">
                                <span class="fa fa-warning text-orange"></span>
                                <strong>${message("business.mainHeader.notifications")}</strong>
                            </li>
                            <li>
                                <ul class="menu">
                                    <li>
                                        <a href="${base}/business/order/list?status=pendingPayment&hasExpired=false">
                                            <span class="fa fa-credit-card text-aqua"></span>
										${message("business.mainHeader.pendingPayment", pendingPaymentCount)}
                                        </a>
                                    </li>
                                    <li>
                                        <a href="${base}/business/order/list?status=pendingReview&hasExpired=false">
                                            <span class="fa fa-user-o text-red"></span>
										${message("business.mainHeader.pendingReview", pendingReviewCount)}
                                        </a>
                                    </li>
                                    <li>
                                        <a href="${base}/business/order/list?status=pendingShipment">
                                            <span class="fa fa-truck text-green"></span>
										${message("business.mainHeader.pendingShipment", pendingShipmentCount)}
                                        </a>
                                    </li>
                                    <li>
                                        <a href="${base}/business/order/list?isPendingRefunds=true">
                                            <span class="fa fa-rmb text-yellow"></span>
										${message("business.mainHeader.pendingRefunds", isPendingRefundsCount)}
                                        </a>
                                    </li>
                                </ul>
                            </li>
                            <li class="footer">
                                <a href="${base}/business/order/list">${message("business.mainHeader.viewOrders")}</a>
                            </li>
                        </ul>
                    </li>
					<li>
						<a href="${base}/business/store/setting" style="margin-top: 5px">
							<img class="img-circle" src="${currentStore.logo!setting.defaultStoreLogo}" alt="${currentStore.name}" style="width: 38px;height: 38px;">
							<span class="hidden-xs">${currentUser.username}</span>
						</a>
					</li>
					<li>
						<a class="logout" href="${base}/business/logout" style="margin-top: 13px;">
							<span class="fa fa-sign-out" style="font-size: 20px"></span>
							${message("business.mainHeader.logout")}
						</a>
					</li>
				</ul>
			</div>
		</div>
	</nav>
</header>