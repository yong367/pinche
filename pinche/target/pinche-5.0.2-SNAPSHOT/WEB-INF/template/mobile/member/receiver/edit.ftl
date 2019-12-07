<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-修改收货地址</title>
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
	<script src="${base}/resources/mobile/member/js/bootstrap-datepicker.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.lSelect.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script type="text/javascript">
		$().ready(function() {

			var $inputForm = $("#inputForm");
			var $areaId = $("#areaId");
			
			[#if flashMessage?has_content]
				$.alert("${flashMessage}");
			[/#if]
			
			// 地区选择
			$areaId.lSelect({
				url: "${base}/common/area"
			});
			
			$.validator.addMethod("requiredOne",
				function(value, element, param) {
					return $.trim(value) != "" || $.trim($(param).val()) != "";
				},
				"${message("member.receiver.requiredOne")}"
			);
			
			// 表单验证
			$inputForm.validate({
				rules: {
					consignee: "required",
					areaId: "required",
					address: "required",
					zipCode: {
						required: true,
						pattern: /^\d{6}$/
					},
					phone: {
						required: true,
						pattern: /^\d{3,4}-?\d{7,9}$/
					}
				}
			});
		
		});
	</script>
</head>
<body class="profile">
	<header class="header-fixed" style="background:linear-gradient(126deg,rgba(150,100,111,1) 0%,rgba(107,107,138,1) 34%,rgba(217,124,117,1) 100%);color: #FFFFFF">
		<a class="pull-left" href="${base}/member/receiver/list">
			<span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
		</a>
		${message("member.receiver.edit")}
	</header>
	<main>
		<div class="container-fluid">
			<form id="inputForm" action="update" method="post">
				<input name="receiverId" type="hidden" value="${receiver.id}">
				<div class="panel panel-flat">
					<div class="panel-body">
						<div class="form-group form-group12" style="border-radius: 0;">
							<label style="text-align: center" for="consignee">${message("Receiver.consignee")}</label>
							<var><input id="consignee" name="consignee" class="form-control" type="text" value="${receiver.consignee}" maxlength="20"></var>
						</div>
						<div class="form-group form-group12" style="border-radius: 0;height: 9rem">
							<label style="text-align: center">${message("Receiver.area")}</label>
							<var><div class="input-group">
								<input id="areaId" name="areaId" type="hidden" value="${(receiver.area.id)!}" treePath="${(receiver.area.treePath)!}">
							</div></var>
						</div>
						<div class="form-group form-group12" style="border-radius: 0;">
							<label style="text-align: center" for="address">${message("Receiver.address")}</label>
							<var><input id="address" name="address" class="form-control" type="text" value="${receiver.address}" maxlength="200"></var>
						</div>
						<div class="form-group form-group12" style="border-radius: 0;">
							<label style="text-align: center" for="zipCode">${message("Receiver.zipCode")}</label>
							<var><input id="zipCode" name="zipCode" class="form-control" type="text" value="${receiver.zipCode}" maxlength="200"></var>
						</div>
						<div class="form-group form-group12" style="border-radius: 0;">
							<label style="text-align: center" for="phone">${message("Receiver.phone")}</label>
							<var><input id="phone" name="phone" class="form-control" type="text" value="${receiver.phone}" maxlength="200"></var>
						</div>
						<div class="form-group">
							<label>${message("Receiver.isDefault")}</label>
							<input name="isDefault" type="checkbox" value="true" [#if receiver.isDefault] checked[/#if]>
							<input name="_isDefault" type="hidden" value="false">
						</div>
					</div>
					<div class="panel-footer text-center" >
						<button class="btn btn-primary" type="submit" style="outline: none;border: 0; width: 40%;border-radius: 20px;margin: 0px;background:linear-gradient(297deg,rgba(147,114,133,1) 0%,rgba(148,114,132,1) 100%);
box-shadow:0px 6px 10px 0px rgba(206,206,206,1);">${message("member.common.submit")}</button>
					</div>
				</div>
			</form>
		</div>
	</main>
</body>
</html>