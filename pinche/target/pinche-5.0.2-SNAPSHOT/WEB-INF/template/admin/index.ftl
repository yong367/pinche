[#assign shiro = JspTaglibs["/WEB-INF/tld/shiro.tld"] /]
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<title>${message("admin.index.title")} </title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/css/index.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $nav = $("#nav a:not(:last)");
	var $menu = $("#menu dl");
	var $menuItem = $("#menu a");
	var $iframe = $("#iframe");
	
	$nav.click(function() {
		var $this = $(this);
		$nav.removeClass("current");
		$this.addClass("current");
		var $currentMenu = $($this.attr("href"));
		$menu.hide();
		$currentMenu.show();
		return false;
	});
	
	$menuItem.click(function() {
		var $this = $(this);
		$menuItem.removeClass("current");
		$this.addClass("current");
	});
	
	$iframe.load(function() {
		if ($iframe.is(":hidden") && $iframe.contents().find("body").html() != "") {
			$iframe.show().siblings().hide();
		}
	});

});
</script>
</head>
<body>
	<script type="text/javascript">
		if (self != top) {
			top.location = self.location;
		}
	</script>
	<table class="index">
		<tr>
			<th class="logo">
				<a href="index">
					<img src="${base}/resources/admin/images/header_logo.png" alt="商城" />
				</a>
			</th>
			<th>
				<div id="nav" class="nav" style="width: 1000px">
					<ul>
						[#list ["admin:member", "admin:memberCar","admin:memberCash","admin:memberDeposit"] as permission]
							[@shiro.hasPermission name = permission]
								<li>
									<a href="#member">${message("admin.index.memberNav")}</a>
								</li>
								[#break /]
							[/@shiro.hasPermission]
						[/#list]
						[#list ["admin:carLineManage"] as permission]
							[@shiro.hasPermission name = permission]
								<li>
                                    <a href="#carLine">线路管理</a>
                                </li>
								[#break /]
							[/@shiro.hasPermission]
						[/#list]
						[#list ["admin:pcOrder","admin:publishJourney"] as permission]
							[@shiro.hasPermission name = permission]
								<li>
                                    <a href="#order">${message("admin.index.orderNav")}</a>
                                </li>
								[#break /]
							[/@shiro.hasPermission]
						[/#list]
						[#list ["admin:message:announcement","admin:message:wxNotifyManage"] as permission]
							[@shiro.hasPermission name = permission]
								<li>
									<a href="#message">公告管理</a>
								</li>
								[#break /]
							[/@shiro.hasPermission]
						[/#list]
						[#list ["admin:setting", "admin:area",  "admin:admin", "admin:role"] as permission]
							[@shiro.hasPermission name = permission]
								<li>
									<a href="#system">${message("admin.index.systemNav")}</a>
								</li>
								[#break /]
							[/@shiro.hasPermission]
						[/#list]
                        <li>
                            <a href="${base}/" target="_blank">${message("admin.index.home")}</a>
                        </li>
					</ul>
				</div>
				<div class="link">

				</div>
				<div class="link">
					<strong>[@shiro.principal property = "displayName" /]</strong>
					${message("admin.index.hello")}!
					<a href="profile/edit" target="iframe">[${message("admin.index.profile")}]</a>
					<a href="logout" target="_top">[${message("admin.index.logout")}]</a>
				</div>
			</th>
		</tr>
		<tr>
			<td id="menu" class="menu">
				<dl id="member" class="default">
					<dt>${message("admin.index.memberGroup")}</dt>
					[@shiro.hasPermission name = "admin:member"]
						<dd>
							<a href="member/list" target="iframe">${message("admin.index.member")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:memberCar"]
						<dd>
							<a href="/admin/memberCar/list" target="iframe">车辆管理</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:memberDeposit"]
						<dd>
                            <a href="member_deposit/log" target="iframe">${message("admin.index.memberDeposit")}</a>
                        </dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:memberCash"]
						<dd>
							<a href="/admin/memberCash/appliCashList" target="iframe">会员提现管理</a>
						</dd>
					[/@shiro.hasPermission]
				</dl>
                <dl id="carLine" >
                    <dt>线路管理</dt>
					[@shiro.hasPermission name = "admin:carLineManage"]
						<dd>
                            <a href="carLine/list" target="iframe">线路管理</a>
                        </dd>
					[/@shiro.hasPermission]
                </dl>
                <dl id="order">
                    <dt>${message("admin.index.orderGroup")}</dt>
					[@shiro.hasPermission name = "admin:pcOrder"]
						<dd>
                            <a href="pcOrder/list" target="iframe">${message("admin.index.order")}</a>
                        </dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:publishJourney"]
						<dd>
                            <a href="pcOrder/list" target="iframe">行程管理</a>
                        </dd>
					[/@shiro.hasPermission]
                </dl>
				<dl id="message">
					<dt>内容管理</dt>
					[@shiro.hasPermission name = "admin:message:announcement"]
						<dd>
							<a href="/admin/announcement/list" target="iframe">公告管理</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:message:wxNotifyManage"]
						<dd>
							<a href="/admin/wxNotify/list" target="iframe">微信通知管理</a>
						</dd>
					[/@shiro.hasPermission]
				</dl>
				<dl id="system">
					<dt>${message("admin.index.systemGroup")}</dt>
					[@shiro.hasPermission name = "admin:setting"]
						<dd>
							<a href="setting/edit" target="iframe">${message("admin.index.setting")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:area"]
						<dd>
							<a href="area/list" target="iframe">${message("admin.index.area")}</a>
						</dd>
					[/@shiro.hasPermission]

					[@shiro.hasPermission name = "admin:admin"]
						<dd>
							<a href="admin/list" target="iframe">${message("admin.index.admin")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:role"]
						<dd>
							<a href="role/list" target="iframe">${message("admin.index.role")}</a>
						</dd>
					[/@shiro.hasPermission]
				</dl>
			</td>
			<td>
				<div class="breadcrumb">
					${message("admin.index.title")}
				</div>
				<table class="input">
					<tr>
						<th>
							${message("admin.index.systemName")}:
						</th>
						<td>
							爱帮伴
							[#--<a href="http://www.lifeabb.com" class="silver" target="_blank">[${message("admin.index.license")}]</a>--]
						</td>
						<th>
							${message("admin.index.systemVersion")}:
						</th>
						<td>
							1.0
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.official")}:
						</th>
						<td>
							<a href="http://www.lifeabb.com" target="_blank">http://www.lifeabb.com</a>
						</td>
						<th>

						</th>
						<td>

						</td>
					</tr>
					<tr>
						<td colspan="4">
							&nbsp;
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.javaVersion")}:
						</th>
						<td>
							${javaVersion}
						</td>
						<th>
							${message("admin.index.javaHome")}:
						</th>
						<td>
							${javaHome}
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.osName")}:
						</th>
						<td>
							${osName}
						</td>
						<th>
							${message("admin.index.osArch")}:
						</th>
						<td>
							${osArch}
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.serverInfo")}:
						</th>
						<td>
							<span title="${serverInfo}">${abbreviate(serverInfo, 30, "...")}</span>
						</td>
						<th>
							${message("admin.index.servletVersion")}:
						</th>
						<td>
							${servletVersion}
						</td>
					</tr>
					<tr>
						<td colspan="4">
							&nbsp;
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.pendingReviewOrderCount")}:
						</th>
						<td>
							${pendingReviewOrderCount}
						</td>
						<th>
							${message("admin.index.pendingShipmentOrderCount")}:
						</th>
						<td>
							${pendingShipmentOrderCount}
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.pendingReceiveOrderCount")}:
						</th>
						<td>
							${pendingReceiveOrderCount}
						</td>
						<th>
							${message("admin.index.pendingRefundsOrderCount")}:
						</th>
						<td>
							${pendingRefundsOrderCount}
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.marketableProductCount")}:
						</th>
						<td>
							${marketableSkuCount}
						</td>
						<th>
							${message("admin.index.notMarketableProductCount")}:
						</th>
						<td>
							${notMarketableSkuCount}
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.stockAlertProductCount")}:
						</th>
						<td>
							${stockAlertSkuCount}
						</td>
						<th>
							${message("admin.index.outOfStockProductCount")}:
						</th>
						<td>
							${outOfStockSkuCount}
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.memberCount")}:
						</th>
						<td>
							${memberCount}
						</td>
						<th>
							${message("admin.index.unreadMessageCount")}:
						</th>
						<td>
							${unreadMessageCount}
						</td>
					</tr>
					<tr>
						<td class="powered" colspan="4">
							COPYRIGHT © 2017-2018 lifeabb.com ALL RIGHTS RESERVED.
						</td>
					</tr>
				</table>
				<iframe id="iframe" name="iframe" frameborder="0"></iframe>
			</td>
		</tr>
	</table>
</body>
</html>