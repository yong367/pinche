<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>爱帮伴-我的兑伴</title>
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
    <script id="duiBanTemplate" type="text/template">
        <%
        function nickName(yongJinLog){
        if(yongJinLog.nickName !=null && yongJinLog.nickName!="undefined"){
        return yongJinLog.senderMemeber.nickName;
        }
        var s = yongJinLog.senderMemeber.username;
        return s.substring(0,3) + "****" + s.substring(7,11);
        }
        %>

        <%_.each(yongJinLogs, function(yongJinLog, i) {%>
        <div class="list-group list-group-flat small">

            <div class="list-group-item">
                <img style="width: 15px;height: 15px" src="${setting.currencySign}" alt="${setting.currencyIconName}"/>
                <%-nickName(yongJinLog)%>返佣</br>
                <span title="<%-moment(new Date(yongJinLog.createdDate)).format('YYYY-MM-DD HH:mm:ss')%>"><%-moment(new Date(yongJinLog.createdDate)).format('YYYY-MM-DD HH:mm:ss')%></span>
                <span class="pull-right">+<%-currency(yongJinLog.amount)%></span>
            </div>


        </div>
        <%})%>
    </script>


    <script type="text/javascript">
        $().ready(function () {

            var $depositLogItems = $("#depositLogItems");
            var duiBanTemplate = _.template($("#duiBanTemplate").html());

            // 无限滚动加载
            $depositLogItems.infiniteScroll({
                url: function (pageNumber) {
                    return "${base}/member/fans/contributionLog?pageNumber=" + pageNumber;
                },
                pageSize: 10,
                template: function (pageNumber, data) {
                    return duiBanTemplate({
                        yongJinLogs: data
                    });
                }
            });

        });
    </script>

</head>
<body class="profile">
<div style="background: url(/newResources/shop/images/home_topbgimg.png) no-repeat;background-size: 100% 100%;">
    <header class="header-fixed"
            style="box-shadow: none;border: none; background:none;height:40px;color: #FFFFFF;color: #FFFFFF">
        <a class="pull-left" href="javascript: history.back();">
            <span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
        </a>

        <span style="width:100%;margin-left: -20px;">我的兑伴</span>
    </header>
    <div style="height: 40px"></div>
    <div class="" style="height: 130px;background: none;">
        <div style="text-align: center;">
            <span style="font-size: 23px;display: block;">您当前已赚</span>
            <div style="width: 100%;text-align: center;margin: 0 auto;">
                <img style=" width: 20px;height: 20px;display: inline-block;vertical-align: top;margin-top: 7px;" src="${setting.currencySign}"
                     alt="${setting.currencyIconName}"/>
                <div style="font-size: 23px;margin-left:5px;display: inline-block;">${yongJin}</div>
            </div>
        </div>
        <#--<div style=" width: 100%;text-align: center;">个兑伴儿</div>-->
        <div style="text-align: center;margin-top:5px">
            兑伴儿数量满一百可提现
        </div>
    </div>
</div>

<main style="margin: 0;">
    <div class="container-fluid">


        <div class="panel panel-flat">
        <#--<div class="panel-body small">-->
        <#--<div>-->
        <#--<img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currentUser.nickName}返佣-->
        <#--<span title="<%-moment(new Date(wxCashLog.createdDate)).format('YYYY-MM-DD HH:mm:ss')%>"><%-moment(new Date(wxCashLog.createdDate)).format('YYYY-MM-DD')%></span>-->
        <#--</div>-->
        <#--</div>-->
            <div class="container-fluid">
                <div id="depositLogItems"></div>
            </div>
        </div>


    </div>
</main>
</body>
</html>