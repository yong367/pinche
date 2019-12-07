<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>爱帮伴-提现列表</title>
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
    <script id="appliCashTemplate" type="text/template">
        <%
        function depositText(type) {
        switch(type) {
        case "SUCCESS":
        return "提现成功";
        case "PROCESSING":
        return "处理中";
        case "FAILED":
        return "提现失败";
        case "CashException":
        return "订单异常";
        }
        }
        function cashMethod (method) {
            switch(method) {
            case "wxCash":
            return "微信提现";
            case "alipayCash":
            return "支付宝提现";
        }
        }
        %>
        <%_.each(appliCashLogs, function(appliCashLog, i) {%>
        <div class="list-group list-group-flat small">
            <div class="list-group-item">
                提现日期:
                <span title="<%-moment(new Date(appliCashLog.createdDate)).format('YYYY-MM-DD HH:mm:ss')%>"><%-moment(new Date(appliCashLog.createdDate)).format('YYYY-MM-DD HH:mm:ss')%></span>
            </div>
            <div class="list-group-item">
                状态:
                <span class="pull-right"><%-depositText(appliCashLog.status)%></span>
            </div>
            <div class="list-group-item">
                提现金额:
                <span class="pull-right"><%-currency(appliCashLog.amount)%></span>
            </div>
            <div class="list-group-item">
            提现方式:
            <span class="pull-right"><%-cashMethod(appliCashLog.cashMethod)%></span>
            </div>
        </div>
        <%})%>
    </script>
    <script type="text/javascript">
        $().ready(function() {

            var $depositLogItems = $("#depositLogItems");
            var appliCashTemplate = _.template($("#appliCashTemplate").html());

            // 无限滚动加载
            $depositLogItems.infiniteScroll({
                url: function(pageNumber) {
                    return "${base}/member/deposit/appliCashLog?pageNumber=" + pageNumber;
                },
                pageSize: 10,
                template: function(pageNumber, data) {
                    return appliCashTemplate({
                        appliCashLogs: data
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
    爱帮伴-提现列表
</header>
<main>
    <div class="container-fluid">
        <div id="depositLogItems"></div>
    </div>
</main>
</body>
</html>