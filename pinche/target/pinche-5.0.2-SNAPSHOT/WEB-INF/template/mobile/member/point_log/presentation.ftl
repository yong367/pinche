<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-积分转赠</title>
	<link href="${base}/favicon.ico" rel="icon">
    <link href="${base}/newResources/member/css/mobilestyle.css" rel="stylesheet" type="text/css" />
	<link href="${base}/resources/mobile/shop/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
    <link href="http://cdn.bootcss.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet" />
    <script src="${base}/resources/mobile/shop/js/jquery.js"></script>
	<script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/shop/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/shop/js/underscore.js"></script>
	<script src="${base}/resources/mobile/shop/js/common.js"></script>
    <script src="${base}/resources/mobile/shop/js/bootbox.min.js"></script>
	<script type="text/javascript">
	$().ready(function() {
        var $passwordForm = $("#passwordForm");
        var $submit = $("#buttonsubmit");

        // 表单验证
        // 表单验证
        $passwordForm.validate({
            rules: {
                pointNum: {
                    required: true,
                    pattern: /^[[0-9]*[1-9][0-9]*$/
                },
                receiveMobile: {
                    required: true,
                    pattern: /^1[3|4|5|6|7|8|9]\d{9}$/
                }
            },
            messages: {
                pointNum: {
                    pattern: "赠送分值必须是大于0的整数！"
                },
                receiveMobile: {
                    pattern: "请输入正确的手机号！"
                }


            },
             errorPlacement:function(error,element){
            $("#textError").html(error);
             },
            submitHandler: function (form) {
                var point = $("#pointNum").val();
                var mobile= $("#receiveMobile").val();
                bootbox.setLocale("zh_CN");
                bootbox.confirm({
                    size: "small",
                    message: "您确认将"+point+"积分送给"+mobile+"?",
                    callback: function(result){ /* result is a boolean; true = OK, false = Cancel*/
                        if(result){
                            $.ajax({
                                url: $passwordForm.attr("action"),
                                type: "POST",
                                data: $passwordForm.serialize(),
                                dataType: "json",
                                cache: false,
                                beforeSend: function () {
                                    $submit.prop("disabled", true);
                                },
                                success: function (message) {
                                    $.alert("转赠积分成功！");
                                    setTimeout(function () {
                                        $submit.prop("disabled", false);
                                        location.href = "${base}/member/point_log/list";
                                    }, 3000);
                                },
                                error: function (xhr, textStatus, errorThrown) {
                                    setTimeout(function () {
                                        $submit.prop("disabled", false);
                                    }, 3000);
                                }
                            });
                        }
                    }
                });

            }
        });

    });

	
	</script>
    <style>
        .help-block{
            display:block;
            margin-top:5px;
            margin-bottom:10px;
            color:red;
        }

    </style>

</head>
<body>
<div class="container" id="container" style="height: 100%;width: 100%;padding-right:0px;padding-left: 0px;">
    <div class="headerWarp">
        <div class="header">
            <span class="btn-back" onclick="javascript: history.back();">积分转赠</span>
        </div>
    </div>
    <form id="passwordForm" action="savePresentation" method="post">
    <div class="zhuceWarp" style="margin: 0;">
        <ul style="width: 100%">

            <li>
                <span class="zhuceLeft">赠送分值</span>
                <span class="spanCt"><input type="text" id="pointNum" name="pointNum" class="form-control" placeholder="请输入大于0的整数"/></span>
            </li>

            <li>
                <span class="zhuceLeft">对方帐号</span>
                <span class="spanCt"><input type="text" id="receiveMobile" name="receiveMobile" class="form-control" placeholder="手机号"/></span>
            </li>

        </ul>
    </div>
        <p id="textError" style="color: red;"></p>
    <div class="zhuceBt" style="width: 100%">
        <button type="submit" id="buttonsubmit">确认赠送</button>
    </div>
	</form>
</div>
</body>
</html>