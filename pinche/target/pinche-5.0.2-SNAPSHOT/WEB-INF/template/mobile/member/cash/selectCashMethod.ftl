<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html" xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>爱帮伴-兑伴儿提现</title>
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
    <script src="${base}/resources/mobile/member/js/jquery.form.js"></script>
    <script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
    <script src="${base}/resources/mobile/shop/js/jquery.spinner.js"></script>
    <script src="${base}/resources/mobile/member/js/velocity.js"></script>
    <script src="${base}/resources/mobile/member/js/velocity.ui.js"></script>
    <script src="${base}/resources/mobile/member/js/jquery.validate.js"></script>
    <script src="${base}/resources/mobile/member/js/underscore.js"></script>
    <script src="${base}/resources/mobile/member/js/common.js"></script>
    <script>
        function tijiao() {
            $("#submitButton").prop("disabled", "disabled");
            var result = validate();
            if (result == 'true') {
                $("#cashForm").submit();
            } else {
                $.alert(result);
                $("#submitButton").removeAttr("disabled");
            }
        }
        
        function validate() {
            var amount = $("#amount").val();
            var account = $("#account").val();
            var cashMethod = $("#selectMethod").val();
            var yue = $("#yue").val();
            var reg = /^[1-9][0-9]*$/;
            if ($.trim(amount) == '') {
                return "金额不能为空！";
            } else {
                if (!reg.test(amount)) {
                    return "金额只能是正整数";
                } else {
                    var y = Math.floor(yue) * 1;
                    if ((amount * 1) > y) {
                        return "提现金额不能大于当前余额！";
                    } else {
                        if((amount*1)>5000){
                            return "当日提现金额不能大于5000";
                        }else{
                            if ((amount * 1) < 100) {
                                return "提现金额必须大于100";
                            }
                        }
                    }
                }

            }
                
                if($.trim(account) == '' && cashMethod == 'alipayCash'){
                    return "收款账号不能为空！";
                }
                
            
            return "true";
            
        }
        function selectPayType(type){
            if(type == 'wxCash'){
                $("#markAccount").hide();
                $("#wx").css("border","1px solid #548FF7");
                $("#zfb").css("border","none");
                $("#selectMethod").val('wxCash');
            }
            if(type == 'alipayCash'){
                $("#markAccount").show();
                $("#zfb").css("border","1px solid #548FF7");
                $("#wx").css("border","none");
                $("#selectMethod").val('alipayCash');
            }
            jisuanamount();
        }
        function jisuanamount() {
            var yue = $("#yue").val()*1;
            var amount = $("#amount").val()*1;
            var reg = /^[1-9][0-9]*$/;
            if ($.trim(amount) != '' && reg.test(amount)) {
              var amt = amount-amount*0.006;
              $("#shijiAmount").html(amt.toFixed(2));
            }
            //第一步判断当前输入的金额是否大于余额
            var showamount=getApplyCashAmount();
            if(amount>yue){
                processShowAmount("金额已超过余额","true");
            }else{
                //第二步判断下当前的输入的金额是否大于可提现金额
                if(amount>showamount){
                    processShowAmount("金额已超过可提现金额","true");
                }else{
                    var amt=showamount-amount;
                    processShowAmount("可提现金额 "+amt,"false");
                }
            }

        }
        function getApplyCashAmount(){
            var cashMethod = $("#selectMethod").val();
            if(cashMethod == 'wxCash'){
               return  $("#wxCashapplyCashAmount").val();
            }
            if(cashMethod == 'alipayCash'){
                return  $("#zfbCashapplyCashAmount").val();
            }
        }
        function allAmount() {
            var yue=$("#yue").val();
            var showamount=getApplyCashAmount();
            var amount=0;
            if(yue*1>showamount){
                amount=showamount;
            }else{
                amount=yue;
            }
            $("#amount").val(Math.floor(amount));
             jisuanamount();
        }
        //处理显示金额，
        function processShowAmount(amount,cssFlag){
            $("#showApplyCashAmount").html(amount);
            if(cssFlag=='true'){
                $("#showApplyCashAmount").css("color","red");//color: #999999;
                $("#submitButton").prop("disabled", "disabled");
            }else{
                $("#showApplyCashAmount").css("color","#999999");
                $("#submitButton").removeAttr("disabled");
            }

        }
    </script>
    <style>
        *{
            padding: 0;
            margin: 0;
        }
        p{
            padding: 0;
        }

        html,body{
            width: 100%;
            height: 100%;
            font-size: 62.5%;
        }
        body div{
            background:white;
        }
    </style>
</head>
<body class="profile" style="background:#E7E7EF">
<header class="header-fixed" style="background:linear-gradient(126deg,rgba(150,100,111,1) 0%,rgba(107,107,138,1) 34%,rgba(217,124,117,1) 100%);color: #FFFFFF">
    <a class="pull-left" href="${base}/member/index">
        <span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
    </a>
   <span style="margin-left: -20px">我要提现</span>
</header>

<div style="display: flex;width: 100%;height: 42px;align-items: center;"><img src="${base}/newResources/member/images/balance/u297.png" alt="" style="width: 24px;height: 24px;"><div style="background:none;margin: 0 auto"><span style="font-size: 16px;color: white;">我的钱包</span></div></div>
<div style="width: 100%;height: 121px;background:linear-gradient(126deg,rgba(150,100,111,1) 0%,rgba(107,107,138,1) 34%,rgba(217,124,117,1) 100%);">
    <p style="width: 80%;height: 30px;line-height: 30px;color:white;font-size: 14px;margin-left: 20px;">我的兑伴儿</p>
    <p style="width:80%;height: 91px;line-height: 91px;color:white;font-size: 50px;margin-left: 20px;">${currentUser.balance}</p>
</div>
<form id="cashForm" action="${base}/member/appliCash/saveCashApply" method="post">
<div style="width: 100%;height: 30px;line-height: 30px;margin-top: 10px;"><p style="margin-left: 20px;color: #999999;font-size: 14px;padding-top: 5px">提现金额</p></div>
<div style="width: 100%;height:100px">
    <div style="display: flex;justify-content: space-around;align-items: center;width: 100%;height: 75px;">
        <span style="font-size: 30px;color: #333333;">￥</span>
        <input id="amount" name="amount" type="number" class="form-control" onkeyup="jisuanamount()" style="width:210px;height: 40px;font-size: 20px;font-weight: 300;border: none;outline: none;-webkit-box-shadow: none;"><img id="clearimg" src="${base}/newResources/member/images/balance/u409.png" alt="" style="width: 25px;height: 25px;visibility: hidden;">
    </div>
    <div style="display: flex;justify-content: space-between;font-size: 14px;">
        <span style="margin-left: 20px;color: #999999;" id="showApplyCashAmount">可提现金额 ${wxCashapplyCashAmount}</span><span style="margin-right: 20px;color: #4B8FDC;" onclick="allAmount()">全部提现</span>
        <input id="wxCashapplyCashAmount" type="hidden" value="${wxCashapplyCashAmount}">
        <input id="zfbCashapplyCashAmount" type="hidden" value="${zfbCashapplyCashAmount}">
    </div>

    <div style="display: none">
    <input type="hidden" id="openIdBindFlag"  value="${openIdBindFlag}"/>
    </div>
</div>

<div style="width: 100%;height: 40px;display: flex;margin-top: 10px;justify-content: space-around;align-items: center;background: #E7E7EF;">
    <div id="wx" onclick="selectPayType('wxCash')" style="width: 35%;height: 100%;display: flex;justify-content:center;align-items: center;background: white;border-radius: 5px;font-size: 1.4rem;border: 1px solid #548FF7"><img src="${base}/newResources/member/images/balance/u358.png" alt="">&nbsp;微信钱包</div>
    <div id="zfb" onclick="selectPayType('alipayCash')"style="width: 35%;height: 100%;display: flex;justify-content:center;align-items: center;background: white;border-radius: 5px;font-size: 1.4rem;"><img src="${base}/newResources/member/images/balance/u361.png" alt="">&nbsp;支付宝钱包</div>
    <input type="hidden" name="cashMethod" id="selectMethod" value="wxCash" />
</div>
    <input id="yue" type="hidden" value="${currentUser.balance}">
    <div style="width: 100%;height:50px;display: none;margin-top: 10px;" id="markAccount">
        <div style="display: flex;justify-content: space-around;align-items: center;width: 100%;">
            <span style="color: black;margin-top: 5px;font-size: 16px;">支付宝账户</span>
            <input id="account" name="account" type="number" class="form-control" style="width:210px;height: 40px;font-size: 20px;font-weight: 300;border: none;outline: none;-webkit-box-shadow:none;margin-top: 5px" placeholder="请输入支付宝账户">
        </div>
    </div>
<div style="width: 100%;height: 45px;display: flex;margin-top:16px;justify-content: space-around;align-items:center;background: #E7E7EF;">
    <#--<input type="button" value="立即提现" style="width:95%;height: 100%;background:#22ACE8;border: 0;color:white;border-radius: 5px;outline: none">-->
    <button class="btn btn-primary" type="button" id="submitButton"  onclick="tijiao()" style="width:50%;height: 100%;background:linear-gradient(297deg,rgba(147,114,133,1) 0%,rgba(148,114,132,1) 100%);
box-shadow:0px 6px 10px 0px rgba(206,206,206,1);border: 0;color:white;border-radius: 25px;outline: none;font-size: 20px;">立即提现</button>
</div>
</form>
<div style="margin: 16px;background: #E7E7EF;font-size: 16px">
    注意事项： <br/>
    1.每次提现金额必须大于100元 <br/>
    2.微信钱包/支付宝钱包提现每次结算金额上限各为5000元，每次成功结算后可提现金额上限重置为5000元。 <br/>
    3.实际到账金额=提现金额*0.6%（费用由微信/支付宝平台扣除）
    <#--注：余额≥100可提现
    <br/>
    <span id="showShuoMing">通过微信/支付宝提现，需扣除第三方支付服务费=提现金额*0.6%（非爱帮伴平台收取）</span>
    <P>实际提现到账:<span id="shijiAmount">0</span></P>-->
</div>
</body>
</html>