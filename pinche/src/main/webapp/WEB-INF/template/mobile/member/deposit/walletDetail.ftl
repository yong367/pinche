<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta name=“viewport” content=“width=device-width, viewport-fit=cover”>
<meta name="format-detection" content="telephone=no">
<meta name="author" content="技术部">
<meta name="copyright" content="SHOP">
<link rel="stylesheet" href="${base}/resources/mobile/member/css/wdmx.css" />
<link href="${base}/resources/layui/css/layui.css" rel="stylesheet">
<title>我的明细</title>
</head>
<body>
    <div class="top">
        <a href="javascript:history.back();"><img src="${base}/resources/mobile/member/images/jt.png" alt="" class="img" style="width: 8px;height: 16px;top: 10px;left: 10px;" /></a>
        <div class="text"><span style="font-size: 16px;margin-left: 10px">我的明细</span></div>
    </div>
    <div class="sy_con">
        <div class="jysj" onclick="$('.jy_leixing').hide();$('.xuanzeriqi').show();">
            交易时间
            <img src="${base}/resources/mobile/member/images/xia.png" />
            <img src="${base}/resources/mobile/member/images/shang.png" style="display: none;" />
        </div>
        <div class="jylx" onclick="$('.xuanzeriqi').hide();$('.jy_leixing').show();">
            交易类型
            <img src="${base}/resources/mobile/member/images/xia.png" />
            <img src="${base}/resources/mobile/member/images/shang.png" style="display: none;" />
        </div>
        <div class="xuanzeriqi" style="display: none;">
                <div class="ks">
                    <span class="left">开始时间</span>
                    <img class="right" src="${base}/resources/mobile/member/images/right_hui.png" />
                    <input class="right" type="text" class="layui-input" name="startTime" placeholder="请选择">
                </div>
                <div class="end">
                    <span class="left">结束时间</span>
                    <img class="right" src="${base}/resources/mobile/member/images/right_hui.png" />
                    <input class="right" type="text" class="layui-input" name="endTime" placeholder="请选择">
                </div>
            <div class="qrqx">
                <div class="quxiao left" onclick="$('.xuanzeriqi').hide();">
                    取消
                </div>
                <div class="queren left" onclick="loadData();">
                    搜索
                </div>
            </div>
        </div>
        <div class="jy_leixing" style="display: none;">
            <div class="leixing">
                <span class="left">选择类型</span>
                <select class="left" name="type">
                    <option value="">请选择</option>
                    <option value="recharge">预存款充值</option>
                    <option value="adjustment">预存款调整</option>
                    <option value="orderPayment">订单支付</option>
                    <option value="orderRefunds">订单退款</option>
                    <option value="promotionReward">推广奖励</option>
                    <option value="jdBtlxReward">京东白条拉新奖励</option>
                    <option value="taskReward">任务奖励</option>
                    <option value="cash">提现记录</option>
                    <option value="cashRefunds">提现退款</option>
                </select>
            </div>
            <div class="lxqrqx">
                <div style="height: 0.3rem;"></div>
                    <div class="quxiao left" onclick="$('.jy_leixing').hide();">
                        取消
                    </div>
                <div class="queren left" onclick="$('.jy_leixing').hide();loadData();">
                    确认
                </div>
            </div>
        </div>
    </div>
    <div style="height: 0.18rem;"></div>
    <div class="one">

    </div>
</body>
<script src="${base}/resources/mobile/member/js/jquery.js"></script>
<script src="${base}/resources/layui/layui.js"></script>
<script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
<script src="${base}/resources/mobile/member/js/underscore.js"></script>
<script src="${base}/resources/mobile/member/js/moment.js"></script>
<script src="${base}/resources/mobile/member/js/common.js"></script>
<script id="depositLogTemplate" type="text/template">
    <%
    function depositText(type) {
        switch(type) {
            case "recharge":
                return "预存款充值";
            case "adjustment":
                return "预存款调整";
            case "orderPayment":
                return "订单支付";
            case "orderRefunds":
                return "订单退款";
            case "promotionReward":
                return "推广奖励";
            case "jdBtlxReward":
                return "京东白条拉新奖励";
            case "taskReward":
                return "任务奖励";
            case "cash":
                return "提现";
            case "cashRefunds":
                return "提现退款";
        }
    }

    function compareM(credit,debit){
        if(credit>0){
            return "+"+credit;
        }
        if(debit>0){
            return "-"+debit;
        }
            return "";
    }
    %>
    <%_.each(depositLogs, function(depositLog, i) {%>
    <div class="neirong">
        <div style="height: 0.16rem;"></div>
        <div class="nr">
                <span class="time">
                <%-moment(new Date(depositLog.createdDate)).format('YYYY-MM-DD')%>
            </span>
            <span class="yongJin">
                <%-depositText(depositLog.type)%> &nbsp;<%-compareM(depositLog.credit,depositLog.debit)%>
            </span>
        </div>
        <div style="height: 0.16rem;"></div>
        <div class="renwu">
            <%-depositText(depositLog.type)%>
        </div>
    </div>
    <%})%>
</script>
<script type="text/javascript">
//rem单位屏幕自适应代码(必要时放在最前面)-开始
var screenWid = document.documentElement.offsetWidth || document.body.offsetWidth;
var nowWid = (screenWid / 750) * 100;
var oHtml = document.getElementsByTagName("html")[0];
//		console.log(nowWid);
oHtml.style.fontSize = nowWid + "px";
//rem单位屏幕自适应代码(必要时放在最前面)-结束
</script>
<script type="text/javascript">
layui.use(['form','layer','laydate'], function(){
    var form = layui.form;
    var layer=layui.layer;
    var laydate = layui.laydate;
    laydate.render({
        elem: '[name="startTime"]'
    });
    laydate.render({
        elem: '[name="endTime"]'
    });
});
function loadData(){
    $(".one").empty();
    var depositLogTemplate = _.template($("#depositLogTemplate").html());
    // 无限滚动加载
    $(".one").infiniteScroll({
        url: function(pageNumber) {
            return "${base}/member/deposit/log?pageNumber=" + pageNumber+"&type="+$('select[name="type"]').val()+"&startTime="+$('[name="startTime"]').val()+"&endTime="+$('[name="endTime"]').val();
        },
        pageSize: 10,
        template: function(pageNumber, data) {
            return depositLogTemplate({
                depositLogs: data
            });
        }
    });
    $('.xuanzeriqi').hide();
}
loadData();
</script>
</html>