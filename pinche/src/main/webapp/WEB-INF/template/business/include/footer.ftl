<footer>
	<div class="service">
		<div class="container">
			<div class="row">
				<div class="col-xs-2 col-xs-offset-1 text-center" style="width:16%">
					<dl>
						<dt>
								<div class="img-circle" style="background-color: #5ec4f7">
									<span class="fa fa-heart"></span>
								</div>
								<span class="pull-left">购买指南</span>
						</dt>
                        <dd><a href="${base}/articlehtml/gwznhyjs.html" target="_blank">会员介绍</a></dd>
                        <dd><a href="${base}/articlehtml/gwznxjgw.html" target="_blank">积分兑换</a></dd>
                        <dd><a href="${base}/articlehtml/gwznjfdh.html" target="_blank">积分兑换</a></dd>
					</dl>
				</div>
				<div class="col-xs-2 text-center" style="width:16%">
					<dl>
						<dt>
                            <div class="img-circle" style="background-color: #72ce52">
                                <span class="fa fa-truck"></span>
                            </div>

								<span class="pull-left">配送方式</span>
						</dt>
                        <dd><a href="${base}/articlehtml/psfssmps.html" target="_blank">上门配送</a></dd>
                        <dd><a href="${base}/articlehtml/psfsddzq.html" target="_blank">到店自取</a></dd>
                        <dd><a href="${base}/articlehtml/psfswxps.html" target="_blank">无需配送</a></dd>
					</dl>
				</div>
				<div class="col-xs-2 text-center" style="width:16%">
					<dl>
						<dt>
								<div class="img-circle" style="background-color: #f2d549">
									<span class="fa fa-rmb"></span>
								</div>
								<span class="pull-left">支付方式</span>
						</dt>
                        <dd><a href="${base}/articlehtml/zffszxzf.html" target="_blank">在线支付</a></dd>
                        <dd><a href="${base}/articlehtml/zffsxjzf.html" target="_blank">现金充值</a></dd>
                        <dd><a href="${base}/articlehtml/zffsyezf.html" target="_blank">余额支付</a></dd>
					</dl>
				</div>
				<div class="col-xs-2 text-center" style="width:16%">
					<dl>
						<dt>
                                <div class="img-circle" style="background-color: #fbb040">
                                    <span class="glyphicon glyphicon-wrench"></span>
                                </div>
								<span class="pull-left">售后服务</span>
						</dt>
                        <dd><a href="${base}/articlehtml/shfwshzc.html" target="_blank">售后政策</a></dd>
                        <dd><a href="${base}/articlehtml/shfwqxdd.html" target="_blank">取消订单</a></dd>
                        <dd><a href="${base}/articlehtml/shfwtksm.html" target="_blank">退款说明</a></dd>
					</dl>
				</div>
                <div class="col-xs-2 text-center" style="width:13%">
                    <dl>
                        <dd style="margin-top: 30px;font-size: 18px; font-weight:bold;font-family: '微软雅黑';color: #0397ed;">400-969-8198</dd>
                        <dd style="text-align: center; font-family: '微软雅黑';">消费者维权热线</dd>

                    </dl>
                </div>
				<div class="col-xs-2 text-center" style="width:13%">
					<img src="${base}/resources/business/images/qr_code.jpg" alt="${message("business.footer.weixin")}">
					<p>${message("business.footer.weixin")}</p>
				</div>
			</div>
		</div>
	</div>
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="info text-center">
				<ul class="list-inline">
					[@navigation_list position = "bottom"]
						[#list navigations as navigation]
							<li>
								<a href="${navigation.url}"[#if navigation.isBlankTarget] target="_blank"[/#if]>${navigation.name}</a>
								[#if navigation_has_next]|[/#if]
							</li>
						[/#list]
					[/@navigation_list]
				</ul>
				<p class="text-center">${setting.certtext}</p>
				<p class="text-center">${message("business.footer.copyright", setting.siteName)}</p>
				[@friend_link_list type = "image" count = 8]
					<ul class="list-inline">
						[#list friendLinks as friendLink]
							<li>
								<a href="${friendLink.url}" target="_blank">
									<img src="${friendLink.logo}" alt="${friendLink.name}">
								</a>
							</li>
						[/#list]
					</ul>
				[/@friend_link_list]
			</div>
		</div>
	</nav>
</footer>