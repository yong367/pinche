<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>爱帮伴-我的粉丝</title>
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
    <script src="${base}/resources/mobile/member/js/common.js"></script>
    <script src="${base}/resources/mobile/member/js/moment.js"></script>
    <script id="fansTemplate" type="text/template">
        <%
        function imageUrl(fansLog){
        if(fansLog.imageUrl !=null && fansLog.imageUrl!="undefined"){
        return fansLog.imageUrl;
        }
        return "/upload/image/default_member_logo.jpg";
        }
        function nickName(fansLog){
        if(fansLog.nickName !=null && fansLog.nickName!="undefined"){
        return fansLog.nickName;
        }
        var username = fansLog.username;
        return username.substring(0,3) + "****" + username.substring(7,11);
        }
        function yongJin(fansLog){
        if(fansLog.amount !=null && fansLog.amount!="undefined"){
        return fansLog.amount;
        }
        return 0;
        }
        %>


        <%_.each(fansLogs, function(fansLog, i) {%>
        <div class="list-group list-group-flat small">
            <div class="list-group-item">
                <div>

                    <img src="<%-imageUrl(fansLog)%>" style="width: 50px;height: 50px;border-radius: 2.5rem">
                    <%-nickName(fansLog)%>
                    <span style="float:right;margin-top:12px">
                        返佣<img style="width: 15px;height: 15px" src="${setting.currencySign}"
                               alt="${setting.currencyIconName}"/>
                        <%-yongJin(fansLog)%>
                    </span>

                </div>

            </div>
        </div>
        <%})%>
    </script>


    <script type="text/javascript">
        $().ready(function () {

            var $depositLogItems = $("#depositLogItems");
            var fansTemplate = _.template($("#fansTemplate").html());

            // 无限滚动加载
            $depositLogItems.infiniteScroll({
                url: function (pageNumber) {
                    return "${base}/member/fans/fansLog?pageNumber=" + pageNumber;
                },
                pageSize: 10,
                template: function (pageNumber, data) {
                    return fansTemplate({
                        fansLogs: data
                    });
                }
            });

        });
    </script>
</head>
<body class="profile">
<header class="header-fixed"
        style="background:linear-gradient(-85deg,rgba(169,207,252,1) 0%,rgba(144,164,251,1) 21%,rgba(148,168,254,1) 54%,rgba(148,168,254,1) 71%,rgba(213,190,218,1) 100%);color: #FFFFFF">
    <a class="pull-left" href="javascript: history.back();">
        <span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
    </a>
    我的粉丝
</header>
<main>
    <#--<div class="container-fluid">
        <div class="panel panel-flat">
            <div style="text-align: center;margin-top:10px;margin-bottom: 10px;">
                <div style="width: 90%;height: 30px; margin: 0 auto;background: #F2F2F2;border-radius: 2px;">
                    <img style="width: 20px;margin: 5px 10px;float: left" src="${base}/resources/mobile/member/images/sousuo.png"/>
                    <input type="text" name="" placeholder="店内搜索"
                           style=" float:left;font-size: 16px;width: 80%;margin:5px 0;height:20px;border: 0;outline: none;background: #F2F2F2;color: #999999;"/>
                </div>
            </div>
        &lt;#&ndash;<div style="width: 90%;height: 30px; margin: 0 auto;background: rgba(0,0,0,1);border-radius: 2px;opacity: 0.05;">
            <img src="${base}/resources/mobile/member/images/sousuo.png"" alt="">
            <input type="text" placeholder="" style="width: px;border: 0;outline: none;background:rgba(0,0,0,1);color:#0C0C0C;">
        </div>&ndash;&gt;
        &lt;#&ndash;<a style="font-size: 20px">您现在有</a></br>
        <div style="text-align: center;font-size: 25px">
            ${fansCount}
        </div>
        <a style="font-size: 15px">个粉丝</a>&ndash;&gt;
        </div>

    </div>-->


    <div class="container-fluid">
        <div id="depositLogItems"></div>
    </div>

</main>
</body>
</html>