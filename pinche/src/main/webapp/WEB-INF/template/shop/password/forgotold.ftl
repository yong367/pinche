<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("shop.password.forgot")}[#if showPowered] [/#if]</title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/password.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $passwordForm = $("#passwordForm");
	var $username = $("#username");
	var $submit = $("input:submit");
	
	// 表单验证
	$passwordForm.validate({
		rules: {
			username: "required",
			email: {
				required: true,
				email: true
			},
            validateNo: "required"
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
				success: function(data) {
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
function sendValidateNo(){
    var mobile=$("#username").val();
    if(mobile){
        $.ajax({
            url: "${base}/password/forgot/sendValidateNo/"+mobile,
            type: "GET",
            dataType: "json",
            beforeSend: function() {
                $("#validateNoButton").prop("disabled", true);
            },
            success: function(data) {
                if(data.status =='success'){
                    alert(data.msg);
                }
            },
            error: function(xhr, textStatus, errorThrown) {
                setTimeout(function() {
                    $("#validateNoButton").prop("disabled", true);
                }, 3000);
            }
        });
    }

}
</script>
</head>
<body>
	[#include "/shop/include/header.ftl" /]
	<div class="container password">
		<div class="row">
			<div class="span12">
				<div class="wrap">
					<div class="main">
						<div class="title">
							<strong>${message("shop.password.forgot")}</strong>FORGOT PASSWORD
						</div>
						<form id="passwordForm" action="forgot" method="post">
							<input type="hidden" name="type" value="${type}" />
							<table>
								<tr>
									<th>
										<span class="requiredField">*</span>${message("shop.password.username")}:
									</th>
									<td>
										<input type="text" id="username" name="username" class="text" maxlength="200" />
									</td>
								</tr>
									<tr>
										<th>
											<span class="requiredField">*</span>${message("shop.captcha.name")}:
										</th>
										<td>
											<span class="fieldSet">
												<input type="text" id="validateNo" name="validateNo" class="text captcha" maxlength="6" autocomplete="off" /><input type="button" id="validateNoButton" onclick="sendValidateNo()" value='${message("merber.register.sendValidateNo")}'/>
											</span>
										</td>
									</tr>
								<tr>
									<th>
										&nbsp;
									</th>
									<td>
										<input type="submit" class="submit" value="${message("shop.password.submit")}" />
									</td>
								</tr>
							</table>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>