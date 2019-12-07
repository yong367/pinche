<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-充值兑伴儿积分</title>
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
	<script src="${base}/resources/mobile/member/js/jquery.validate.js"></script>
    <script src="${base}/resources/mobile/member/js/common.js"></script>
<script>
    function tijiao(){
$("#submitButton").prop("disabled","disabled");
var result = validate();
if( result== 'true'){
    $("#cashForm").submit();
}else{
    $.alert(result);
    $("#submitButton").removeAttr("disabled");
}
    }
    function validate() {
        var amount = $("#amount").val();
        var bank = $("#bank").val();
        var accountName = $("#accountName").val();
        var account = $("#account").val();
        var yue = $("#yue").val();
        var reg = /^[1-9][0-9]*$/;
        if ($.trim(amount) == '') {
            return "金额不能为空！";
        }else{
            if(!reg.test(amount)){
                return "金额只能是正整数";
            }else{
                var y=Math.floor(yue)*1;
                if((amount*1)>y){
                    return "提现金额不能大于当前余额！";
                }else{
                    if((amount*1) <100){
                        return "提现金额必须大于100";
                    }
                }
            }

        }
        if($.trim(bank) == ''){
            return "收款银行不能为空！";
          }
        if($.trim(accountName) == ''){
            return "开户名称不能为空！";
        }
        if($.trim(account) == ''){
            return "收款账号不能为空！";
        }
        return "true";

    }
</script>
</head>
<body class="profile">
	<header class="header-fixed" style="background:linear-gradient(126deg,rgba(150,100,111,1) 0%,rgba(107,107,138,1) 34%,rgba(217,124,117,1) 100%);color: #FFFFFF">
		<a class="pull-left" href="${base}/member/index">
			<span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
		</a>
		提现申请
	</header>
	<main>
		<div class="container-fluid">
            <form id="cashForm" action="${base}/member/cash/saveCashApply" method="post">
                <div class="list-group list-group-flat">
                    <div class="list-group-item">
                        <div class="list-group-item">
                            <div class="form-group">
                                <label for="rechargeAmount">提现金额</label>
                                <input  id="amount" name="amount" type="text" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="rechargeAmount">收款银行</label>
                                <input  id="bank" name="bank" type="text" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="rechargeAmount">开户名称</label>
                                <input  id="accountName" name="accountName"  type="text" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="rechargeAmount">收款账号</label>
                                <input  id="account" name="account"  type="text" class="form-control">
                            </div>
                        </div>

                    </div>

                    <div id="feeItem" class="fee-item list-group-item small">
					${message("member.memberDeposit.fee")}:
                        <strong id="fee"></strong>
                    </div>
                    <div class="list-group-item small"><img style="width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>余额: ${currency(currentUser.balance, false)}兑伴儿积分 ≈ ${currency(currentUser.balance, false)}元人民币</div>
                    <input id="yue" type="hidden" value="${currency(currentUser.balance, false)}">
                    <div class="text-center">
                        <button class="btn btn-primary" type="button" id="submitButton" onclick="tijiao()">${message("member.common.submit")}</button>
                        <a class="btn btn-default" href="${base}/member/index">${message("member.common.back")}</a>
                    </div>
                </div>

            </form>
		</div>
	</main>
</body>
</html>