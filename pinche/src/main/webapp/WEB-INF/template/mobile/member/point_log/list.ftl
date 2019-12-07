<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-我的积分</title>
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
	<script id="pointLogTemplate" type="text/template">
		<%
			function typeText(type) {
				switch(type) {
					case "systemReward":
						return "系统赠送";
					case "exchange":
						return "${message("PointLog.Type.exchange")}";
					case "undoExchange":
						return "${message("PointLog.Type.undoExchange")}";
					case "adjustment":
						return "${message("PointLog.Type.adjustment")}";
					case "personalTurn":
					return "个人转赠";
					case "merchantReward":
					return "商户赠送";
					case "other":
					return "它类积分转换";
				}
			}
		%>
		<%_.each(pointLogs, function(pointLog, i) {%>
			<div class="list-group list-group-flat small">
				<div class="list-group-item">
					${message("member.common.createdDate")}:
					<span title="<%-moment(new Date(pointLog.createdDate)).format('YYYY-MM-DD HH:mm:ss')%>"><%-moment(new Date(pointLog.createdDate)).format('YYYY-MM-DD')%></span>
				</div>

				<div class="list-group-item">
					${message("PointLog.credit")}
					<span class="pull-right"><%-pointLog.credit ? pointLog.credit : "-"%></span>
				</div>
				<div class="list-group-item">
					${message("PointLog.debit")}
					<span class="pull-right"><%-pointLog.debit ? pointLog.debit : "-"%></span>
				</div>
				<div class="list-group-item">
					${message("PointLog.balance")}
					<em class="pull-right orange"><%-pointLog.balance%></em>
				</div>
                <div class="list-group-item">
				备注
                    <span class="pull-right"><%-pointLog.memo%></span>
                </div>
			</div>
		<%})%>
	</script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $pointLogItems = $("#pointLogItems");
		var pointLogTemplate = _.template($("#pointLogTemplate").html());
		
		// 无限滚动加载
		$pointLogItems.infiniteScroll({
			url: function(pageNumber) {
				return "${base}/member/point_log/list?pageNumber=" + pageNumber;
			},
			pageSize: 10,
			template: function(pageNumber, data) {
				return pointLogTemplate({
					pointLogs: data
				});
			}
		});
	
	});
	</script>
        <style>
        .sel_btn{
            height: 21px;
            line-height: 21px;
            padding: 0 13px;
            background: #02bafa;
            border: 1px #26bbdb solid;
            border-radius: 3px;
            /*color: #fff;*/
            display: inline-block;
            text-decoration: none;
            font-size: 14px;
            outline: none;
        }
        .ch_cls{
            background: #e4e4e4;
        }
    </style>
</head>
<body class="profile">
	<header class="header-fixed">
		<a class="pull-left" href="${base}/member/index">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		${message("member.pointLog.list")}
	</header>
	<main>
		<div class="jifenNew">
			当前积分  ${currentPoint}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="${base}/member/point_log/presentation" class="sel_btn ch_cls">转送积分</a>
		</div>
		<div class="container-fluid">
			<div id="pointLogItems"></div>
		</div>
	</main>
</body>
</html>