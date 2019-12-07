<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-交易记录</title>
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
	<script src="${base}/resources/mobile/member/js/moment.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script id="depositLogTemplate" type="text/template">
		<%
			function depositText(type) {
				switch(type) {
					case "recharge":
						return "${message("MemberDepositLog.Type.recharge")}";
					case "adjustment":
						return "${message("MemberDepositLog.Type.adjustment")}";
					case "orderPayment":
						return "${message("MemberDepositLog.Type.orderPayment")}";
					case "orderRefunds":
						return "${message("MemberDepositLog.Type.orderRefunds")}";
					case "jdBtlxReward":
                        return "${message("MemberDepositLog.Type.jdBtlxReward")}";
                    case "cash":
                        return "${message("MemberDepositLog.Type.cash")}";
                    case "cashRefunds":
                        return "${message("MemberDepositLog.Type.cashRefunds")}";
                    case "promotionReward":
                        return "${message("MemberDepositLog.Type.promotionReward")}";
                    case "taskReward":
                        return "任务奖励";
				}
			}
		%>
		<%_.each(depositLogs, function(depositLog, i) {%>
			<div class="list-group list-group-flat small">
				<div class="list-group-item">
					交易时间:
					<span title="<%-moment(new Date(depositLog.createdDate)).format('YYYY-MM-DD HH:mm:ss')%>"><%-moment(new Date(depositLog.createdDate)).format('YYYY-MM-DD')%></span>
				</div>
				<div class="list-group-item">
					${message("MemberDepositLog.type")}
					<span class="pull-right"><%-depositText(depositLog.type)%></span>
				</div>
				<div class="list-group-item">
					${message("MemberDepositLog.credit")}
					<span class="pull-right"><img  style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/><%-currency(depositLog.credit, false)%></span>
				</div>
				<div class="list-group-item">
					${message("MemberDepositLog.debit")}
					<span class="pull-right"><img  style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/><%-currency(depositLog.debit, false)%></span>
				</div>
				<div class="list-group-item">
					${message("MemberDepositLog.balance")}
					<em class="pull-right orange"> <img  style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/><%-currency(depositLog.balance, false)%></em>
				</div>
			</div>
		<%})%>
	</script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $depositLogItems = $("#depositLogItems");
		var depositLogTemplate = _.template($("#depositLogTemplate").html());
		
		// 无限滚动加载
		$depositLogItems.infiniteScroll({
			url: function(pageNumber) {
				return "${base}/member/deposit/log?pageNumber=" + pageNumber;
			},
			pageSize: 10,
			template: function(pageNumber, data) {
				return depositLogTemplate({
					depositLogs: data
				});
			}
		});
		
	});
	</script>
</head>
<body class="profile">
	<header class="header-fixed" style="background: #2cb6f1;color: #FFFFFF">
		<a class="pull-left" href="${base}/member/index">
			<span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
		</a>
		交易记录
	</header>
	<main>
		<div class="container-fluid">
			<div id="depositLogItems"></div>
		</div>
	</main>
</body>
</html>