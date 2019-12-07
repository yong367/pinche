<div class="footer">
	<div class="service clearfix">
		<dl>
			<dt class="icon1">新手指南</dt>
			<dd>
				<a href="${base}/articlehtml/memberreg.html">会员注册</a>
			</dd>
			<dd>
				<a href="${base}/articlehtml/law.html">法律声明</a>
			</dd>
		</dl>
		<dl>
			<dt class="icon2">特色服务</dt>
			<dd>
				<a href="#">报名流程</a>
			</dd>
			
			<dd>
				<a href="${base}/articlehtml/contactme.html">联系我们</a>
			</dd>
			
		</dl>
		<dl>
			<dt class="icon3">支付方式</dt>
			<dd>
				<a href="${base}/articlehtml/advise.html">投诉建议</a>
			</dd>
			<dd>
				<a href="${base}/articlehtml/merchant.html">商家入驻</a>
			</dd>
			
		</dl>
		<dl>
			<dt class="icon4">配送方式</dt>
			<dd>
				<a href="${base}/articlehtml/orderquestion.html">订单问题</a>
			</dd>
			<dd>
				<a href="${base}/articlehtml/useragreement.html">用户协议</a>
			</dd>
			
		</dl>
		<div class="qrCode">
			<img src="${base}/resources/shop/images/qr_code.jpg" alt="${message("shop.footer.weixin")}" />
			${message("shop.footer.weixin")}
		</div>
	</div>
	<div class="bottom">
		<div class="bottomNav">
			<ul>
				[@navigation_list position = "bottom"]
					[#list navigations as navigation]
						<li>
							<a href="${navigation.url}"[#if navigation.isBlankTarget] target="_blank"[/#if]>${navigation.name}</a>
							[#if navigation_has_next]|[/#if]
						</li>
					[/#list]
				[/@navigation_list]
			</ul>
		</div>
		<div class="info">
			<p>${setting.certtext}</p>
			<p>${message("shop.footer.copyright", setting.siteName)}</p>
			[@friend_link_list type = "image" count = 8]
				<ul>
					[#list friendLinks as friendLink]
						<li>
							<a href="${friendLink.url}" target="_blank">
								<img src="${friendLink.logo}" alt="${friendLink.name}" />
							</a>
						</li>
					[/#list]
				</ul>
			[/@friend_link_list]
		</div>
	</div>
	[#include "/shop/include/statistics.ftl" /]
</div>