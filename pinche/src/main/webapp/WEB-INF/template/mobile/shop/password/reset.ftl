<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>爱帮伴-密码重置</title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
    <link href="${base}/newResources/member/css/mobilestyle.css" rel="stylesheet" type="text/css" />
    <link href="${base}/resources/mobile/shop/css/bootstrap.css" rel="stylesheet">
    <link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
    <script src="${base}/resources/mobile/shop/js/jquery.js"></script>
    <script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
    <script src="${base}/resources/mobile/shop/js/jquery.validate.js"></script>
    <script src="${base}/resources/mobile/shop/js/underscore.js"></script>
    <script src="${base}/resources/mobile/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

    var $passwordForm = $("#passwordForm");
    var $password = $("#password");
    var $submit = $("input:submit");

    // 表单验证
    $passwordForm.validate({
        rules: {
            newPassword: {
                required: true,
                minlength: 4
            },
            rePassword: {
                required: true,
                equalTo: "#newPassword"
            }
        },
        submitHandler: function(form) {
            $.ajax({
                url: $passwordForm.attr("action"),
                type: "POST",
                data: $passwordForm.serialize(),
                dataType: "json",
                cache: false,
                beforeSend: function() {
                    $submit.prop("disabled", true);
                },
                success: function(message) {
                    setTimeout(function() {
                        $submit.prop("disabled", false);
                        location.href = "${base}/";
                    }, 3000);
                },
                error: function(xhr, textStatus, errorThrown) {
                    setTimeout(function() {
                        $submit.prop("disabled", false);
                    }, 3000);
                }
            });
        }
    });

});
</script>
</head>
<body>

<div class="container" id="container" style="height: 100%;width: 100%">
    <div class="headerWarp">
        <div class="header" style="position: relative;width: 100%;height: 100%;display: flex;line-height:4.4rem;align-items: center;background: #22ACE8;">
                <img src="${base}/newResources/member/images/btnBack.png" style="position:absolute;width: 24px;height:24px;left:16px" onclick="javascript: history.back();">
                <div class="btn-back" style="margin: 0 auto;width: 70%;height: 100%;text-align:center;font-size: 16px;color: white;">修改密码</div>
        </div>
    </div>
    <form id="passwordForm" action="reset" method="post" style="width:85.3%;margin: 0 auto">
        <input type="hidden" name="username" value="${user.username}" />
        <input type="hidden" name="key" value="${key}" />
        <input type="hidden" name="type" value="${type}" />
        <div style="display: flex;justify-content:space-between;width: 100%;height: 4.8rem;margin-top:28px;border:0;border-radius:5px;background:white;box-shadow:0px 0px 5px 0px rgba(206,206,206,1);">
            <div style="display: flex;align-items:center;width:4.0rem;height: 100%;">
                <img src="${base}/newResources/member/images/login/u24.png" alt="" style="width: 4.0rem;height: 4.0rem">
            </div>
            <div style="width: 80%;height: 100%;">
                <input type="password" id="newPassword" name="newPassword"  style="width: 100%;height: 100%;font-size: 1.6rem;outline: none;border: none;background: none;"placeholder="&nbsp;6-20位字母、数字和符号组成">
            </div>
        </div>
        <div style="display: flex;justify-content:space-between;width: 100%;height: 4.8rem;margin-top:28px;border:0;border-radius:5px;background:white;box-shadow:0px 0px 5px 0px rgba(206,206,206,1);">
            <div style="display: flex;align-items:center;width:4.0rem;height: 100%;">
                <img src="${base}/newResources/member/images/login/u24.png" alt="" style="width: 4.0rem;height: 4.0rem">
            </div>
            <div style="width: 80%;height: 100%;">
                <input type="password" name="rePassword"  style="width: 100%;height: 100%;font-size: 1.6rem;outline: none;border: none;background: none;"placeholder="&nbsp;再次确认密码">
            </div>
        </div>
    <#--</div>-->
    <div class="zhuceBt">
        <button type="submit">验证修改</button>
    </div>
	</form>

</div>
</body>
</html>