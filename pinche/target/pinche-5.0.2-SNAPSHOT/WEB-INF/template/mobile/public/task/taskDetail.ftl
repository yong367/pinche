<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>${taskInfo.name}</title>
    <link href="${base}/favicon.ico" rel="icon">
    <link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
    <link href="${base}/resources/mobile/member/css/font-awesome.css" rel="stylesheet">
    <link href="${base}/resources/mobile/member/css/animate.css" rel="stylesheet">
    <link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
    <link href="${base}/resources/mobile/member/css/profile.css" rel="stylesheet">
    <style>
        @import "${base}/newResources/member/css/taskDetail.css";
    </style>
    <!--[if lt IE 9]>
    <script src="${base}/resources/mobile/member/js/html5shiv.js"></script>
    <script src="${base}/resources/mobile/member/js/respond.js"></script>
    <![endif]-->
    <script src="${base}/resources/mobile/member/js/jquery.js"></script>
    <script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
    <script src="${base}/resources/mobile/member/js/underscore.js"></script>
    <script src="${base}/resources/mobile/member/js/common.js"></script>
    <script src="${base}/resources/mobile/member/js/moment.js"></script>
    <style>
        .tableClass tr{
            line-height: 2.5rem;
        }
        *{
            padding: 0;
            margin: 0;
        }
        html,body{
            width: 100%;
            height: 100%;
            font-size: 62.5%;
        }
        /*#head{*/
        /*display: flex;*/
        /*align-items: center;*/
        /*position: fixed;*/
        /*top: 0px;*/
        /*width: 100%;*/
        /*height: 50px;*/
        /*font-size: 16px;*/
        /*color: white;*/
        /*background: #4A90F5;*/
        /*}*/
        #nav{
            margin-top: 50px;
            width: 100%;
            height: 130px;
            background: #5588F8;
        }
        #nav #money{
            width: 100%;
            height: 50px;
            line-height: 50px;
            text-align: center;
            color:white;
            font-size:30px;
        }
        #nav #navText{
            width: 100%;
            height:80px;
        }
        #nav #navText ul{
            display: flex;
            text-align: center;
            width: 100%;
            height: 80px;
            color:white;
            font-size: 14px;
            font-weight: bold;
        }
        #nav #navText ul li{
            list-style-type: none;
            width: 33%;
            float: left;
            padding-top: 10px;
            margin: 0 auto;
        }
        #navDiv ul{
            display: flex;
            text-align: center;
            width: 100%;
            height: 50px;
            line-height: 50px;
            color: #27A8EA;
            font-size: 15px;
        }
        #navDiv ul li{
            list-style-type: none;
            width: 33%;
            float: left;
            /*border-bottom:3px solid #27A8EA ;*/
            margin: 0 auto;
        }
        #navDiv ul  ff{
            list-style-type: none;
            width: 33%;
            float: left;
            border-bottom:3px solid #27A8EA ;
            margin: 0 auto;
        }
        .text{
            width: 100%;
            height: 40px;
            line-height: 40px;
            background: #F1F1F1;
            color: #27A8EA;
            font-size: 16px;
            font-weight: bold;
        }
        .txt{
            width: 100%;
            height: 40px;
            line-height: 40px;
            background:white;
            font-size: 16px;
            border-bottom: 1px solid #EEEEEE;
            border-top:1px solid #EEEEEE ;
        }
        .txt span:nth-child(1){
            color: #393939;
            margin-left: 20px;
        }
        .txt span:nth-child(2){
            font-size: 14px;
            color: #7C7C7C;
            margin-left: 30px;
        }
        #txtTwo p{
            margin-left: 20px;
            font-size: 13px;
        }
        #txtThree p{
            margin-left: 20px;
            font-size: 13px;
        }
    </style>
    <script>
        function acceptanceTask() {
            $("#acceptance").attr("disabled", "disabled");
            $.ajax({
                url : "${base}/member/task/acceptanceTask?taskBusinessMappingId=" + ${taskBusinessMapping.id},
                type : "GET",
                dataType : "json",
                success: function (result) {
                    if (result.status == 'success') {
                        if (confirm("接受任务成功,是否立即开始您的任务之旅?")) {
                            window.location.href = "${base}/member/task/myTask";
                        }

                    } else if(result.status == 'errorNoPermissions'){
                        if (confirm("您尚未开通分销人服务,是否开通?")) {
                            window.location.href = "${base}/member/task/agreedistribution";
                        }
                    }else{
                        $("#acceptance").removeAttr("disabled");
                        $.alert(result.msg);
                        window.location.href = "${base}/member/task/list";
                    }
                },
                error:function () {
                    $("#acceptance").removeAttr("disabled");
                }
            });
        }
        function goBack() {
            window.location.href = "${base}/member/task/list";
        }
        $(function(){
            $(".detail").find("img").css("width","100%");
        });
    </script>
    <script>
        window.onload=function(){
            var xxxx=document.getElementById("xxxx");
            var ylnr=document.getElementById("ylnr");
            var hxyq=document.getElementById("hxyq");
            var box1=document.getElementById("box1");
            var box2=document.getElementById("box2");
            var box3=document.getElementById("box3");
            var navDiv=document.getElementById("navDiv");
            box1.style.display="block";
            box2.style.display="none";
            box3.style.display="none";
            ylnr.style.borderBottom="none";
            hxyq.style.borderBottom="none";
            xxxx.onclick=function(){
                this.style.borderBottom="3px solid #27A8EA";
                ylnr.style.borderBottom="none";
                hxyq.style.borderBottom="none";
                box1.style.display="block";
                box2.style.display="none";
                box3.style.display="none";
            }
            ylnr.onclick=function(){
                this.style.borderBottom="3px solid #27A8EA";
                xxxx.style.borderBottom="none";
                hxyq.style.borderBottom="none";
                box2.style.display="block";
                box1.style.display="none";
                box3.style.display="none";
            }
            hxyq.onclick=function(){
                this.style.borderBottom="3px solid #27A8EA";
                xxxx.style.borderBottom="none";
                ylnr.style.borderBottom="none";
                box3.style.display="block";
                box1.style.display="none";
                box2.style.display="none";
            }
        }
        $(function(){
            $(".detail").find("img").css("width","100%");
        });
    </script>
</head>
<body class="profile">
<header class="header-fixed" style="background: #2cb6f1;color: #FFFFFF;height: 50px;">
    <a class="pull-left" href="javascript: history.back();">
        <span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
    </a>
${taskInfo.name}
</header>
<div id="nav">
    <div id="money"><p>${taskBusinessMapping.yongJin}元</p></div>
    <div id="navText">
        <ul>
            <li>
                <p>剩余天数<br><br>${residueDays}天</p>
            </li>
            <li>
                <p style="border-left: 1px solid white;border-right:1px solid white">剩余任务数<br><br>${taskInfo.oddTaskNumber}</p>
            </li>
            <li>
                <p>奖励发放时限<br><br>
                    [#if taskInfo.taskRewardSystems.realTimeAccountFlag == true]立即到账
                    [#elseif taskInfo.taskRewardSystems.realTimeAccountFlag == false]${taskInfo.taskRewardSystems.accountDay}
                    [/#if]
                </p>
            </li>
        </ul>
    </div>
    <div id="navDiv">
        <ul>
            <li id="xxxx" class="">详细信息</li>
            <li id="ylnr" class="">预览内容</li>
            <li id="hxyq" class="">核销要求</li>
        </ul>
    </div>
    <main id="box1">
        <div class="container-fluid">


            <div class="text">
                <span style="margin-left: 20px;">任务详情</span>
            </div>
            <div class="txt"><span>任务ID</span><span>${taskInfo.sn}</span></div>
            <div class="txt"><span>任务适用区域</span><span>全国</span></div>
            <div style="display: table;width: 100%;height: 100px;background: white;">
            [#--<div style="float: left;width:30%;height: 100%;line-height: 40px;">--]
                <span style="float: left;height: 100px;line-height: 100px;font-size: 16px;color: #393939;margin-left: 20px;">任务简介</span>
            [#--</div>--]
            [#--<div style="float: left;width:70%;height: 100%;">--]
                <div style="width: 70%;margin-left: 10px;display: table-cell;vertical-align:middle;font-size: 14px;color: #7c7c7c">
                    [#noautoesc ]
                        ${taskInfo.taskCaption}
                    [/#noautoesc]

                </div>
            </div>
        </div>
        <div class="txt"><span>任务发布商家</span><span>${taskInfo.business.store.name}</span></div>
        <div class="txt"><span>任务推广商家</span><span>${taskBusinessMapping.business.store.name}</span></div>
        <div class="txt"><span>创建日期</span><span>${taskInfo.createdDate}</span></div>
        <div class="txt"><span>生效时间</span><span>${taskInfo.startDate}~${taskInfo.endDate}</span></div>
        <div class="text">
            <span style="margin-left: 20px;">任务描述</span>
                [#noautoesc ]
                <div class="detail" style="padding-top: 5px;padding-bottom: 5rem">${taskInfo.taskDescription}</div>
                [/#noautoesc]
        </div>

</div>

</main>
<main  id="box2">
    <div class="container-fluid">

        [#if taskInfo.taskDistributionChoose.posterModelFlag == true]
        <div class="text">
            <span style="margin-left: 20px;">海报预览</span>
        </div>
        <div style="width: 100%;text-align: center;padding-bottom: 4rem"><img src="${taskInfo.taskDistributionChoose.posterUrl}" style="width: 100%;height: 700px"></div>
        [/#if]
        [#if taskInfo.taskDistributionChoose.articleModelFlag == true]
        <div class="text">
            <span style="margin-left: 20px;">文章预览</span>
                [#noautoesc ]
                <div class="detail" style="padding-top: 5px;">${taskInfo.taskDescription}</div>
                [/#noautoesc]
        </div>
        [/#if]
    </div>

</main>
<main  id="box3">
    <div class="container-fluid">
        <div class="text">
            <span style="margin-left: 20px;">核销文本要求</span>
        </div>
    [#list uploadEvidenceInfos as uploadEvidenceInfo]
        [#if uploadEvidenceInfo.type == "file"]
        <div class="text">
            <span style="margin-left: 20px;">核销图片要求</span>
        </div>
        <div style="width: 100%;height:100px;font-size: 16px;">
            <div style="display:flex;justify-content:space-between;width: 100%;height: 50px; line-height: 50px;"><span style="margin-left: 20px;">${uploadEvidenceInfo.chineseName}</span><span style="margin-right: 10px;color: #0066FF;">示例</span></div>
        [#--<div style="display:flex;justify-content:space-between;width: 100%;height: 50px;line-height: 50px;"><span style="margin-left: 20px;">2.上传转发群聊截图</span><span style="margin-right: 10px;color: #0066FF;">示例</span></div>--]
        </div>
        [/#if]

        [#if uploadEvidenceInfo.type == "text"]

        <div style="width: 100%;height: 50px;font-size: 16px;">
            <div style="width: 100%;height: 50px;line-height: 50px;"><span style="margin-left: 20px;">${uploadEvidenceInfo.chineseName}</span></div>
        [#--<div style="display:flex;justify-content:space-between;width: 100%;height: 50px;line-height: 50px;"><input type="text"value="123" placeholder="请输入" style=" width: 80%;height: 50px;margin-left: 20px;border:none;outline: none;"><span style="margin-right: 10px;color: #0066FF;">示例</span></div>--]
        </div>
        [/#if]
    [/#list]
    [#--<div class="text">--]
    [#--<span style="margin-left: 20px;">核销位置要求</span>--]
    [#--</div>--]
    [#--<div style="width: 100%;height:150px;font-size: 16px;">--]
    [#--<div style="width: 100%;height: 50px;line-height: 50px;"><span style="margin-left: 20px;">1.河北省石家庄市长安区</span></div>--]
    [#--<div style="width: 100%;height: 50px;line-height: 50px;"><span style="margin-left: 20px;">2.河北省石家庄市新华区</span></div>--]
    [#--<div style="width: 100%;height: 50px;line-height: 50px;"><span style="margin-left: 20px;">3.河北省石家庄市正定县</span></div>--]
    [#--</div>--]
    [#--<div class="text">--]
    [#--<span style="margin-left: 20px;">核销时间要求</span>--]
    [#--</div>--]
    [#--<div style="width: 100%;height: 300px;font-size: 16px;">--]
    [#--<div style="width: 100%;height: 50px;line-height: 50px;"><span style="margin-left: 20px;">星期四</span></div>--]
    [#--<div style="width: 100%;height: 50px;line-height: 50px;"><span style="margin-left: 20px;">星期五</span></div>--]
    [#--<div style="width: 100%;height: 50px;line-height: 50px;"><span style="margin-left: 20px;">星期六</span></div>--]
    [#--<div style="width: 100%;height: 50px;line-height: 50px;"><span style="margin-left: 20px;">星期日</span></div>--]
    [#--</div>--]
    </div>

</main>
<footer class="footer-fixed" style="padding:0;background: #2cb6f1;height: 4.5rem">
    <div style="text-align: center;height: 3rem;margin-top: 0.75rem">
        <button class="btn btn-default"  style="border-radius: 0.8rem" data-toggle="back" onclick="goBack()">${message("business.common.back")}</button>
        <button class="btn btn-default" id="acceptance" style="background-color: #ffa200;color: white;border-radius:0.8rem"  onclick="acceptanceTask()">接受</button>
    </div>
</footer>
</body>
</html>