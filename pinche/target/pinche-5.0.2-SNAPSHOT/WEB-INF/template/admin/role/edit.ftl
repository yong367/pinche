<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.role.edit")} </title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<style type="text/css">
.permissions label {
	min-width: 120px;
	_width: 120px;
	display: block;
	float: left;
	padding-right: 4px;
	_white-space: nowrap;
}
</style>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $selectAll = $("#inputForm .selectAll");
	
	[@flash_message /]
	
	$selectAll.click(function() {
		var $this = $(this);
		var $thisCheckbox = $this.closest("tr").find("input:checkbox");
		if ($thisCheckbox.filter(":checked").size() > 0) {
			$thisCheckbox.prop("checked", false);
		} else {
			$thisCheckbox.prop("checked", true);
		}
		return false;
	});
	
	// 表单验证
	$inputForm.validate({
		rules: {
			name: "required",
			permissions: "required"
		}
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		${message("admin.role.edit")}
	</div>
	<form id="inputForm" action="update" method="post">
		<input type="hidden" name="id" value="${role.id}" />
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Role.name")}:
				</th>
				<td>
					<input type="text" name="name" class="text" value="${role.name}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Role.description")}:
				</th>
				<td>
					<input type="text" name="description" class="text" value="${role.description}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					&nbsp;
				</td>
			</tr>
			<tr class="permissions">
				<th>
					<a href="javascript:;" class="selectAll" title="${message("admin.role.selectAll")}">${message("admin.role.memberGroup")}</a>
				</th>
				<td>
					<span class="fieldSet">
						<label>
							<input type="checkbox" name="permissions" value="admin:member"[#if role.permissions?seq_contains("admin:member")] checked="checked"[/#if] />${message("admin.role.member")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:memberCar"[#if role.permissions?seq_contains("admin:memberCar")] checked="checked"[/#if] />${message("admin.role.memberRank")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:memberDeposit"[#if role.permissions?seq_contains("admin:memberDeposit")] checked="checked"[/#if] />${message("admin.role.memberDeposit")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:memberCash" [#if role.permissions?seq_contains("admin:memberCash")] checked="checked"[/#if] />会员提现管理
						</label>
					</span>
				</td>
			</tr>
			<tr class="permissions">
				<th>
					<a href="javascript:;" class="selectAll" title="${message("admin.role.selectAll")}">线路管理</a>
				</th>
				<td>
					<span class="fieldSet">
						<label>
							<input type="checkbox" name="permissions" value="admin:carLineManage"[#if role.permissions?seq_contains("admin:carLineManage")] checked="checked"[/#if] />线路管理
						</label>
					</span>
				</td>
			</tr>
            <tr class="permissions">
                <th>
                    <a href="javascript:;" class="selectAll" title="${message("admin.role.selectAll")}">订单管理</a>
                </th>
                <td>
					<span class="fieldSet">
						<label>
							<input type="checkbox" name="permissions" value="admin:pcOrder" [#if role.permissions?seq_contains("admin:pcOrder")] checked="checked"[/#if]/>订单管理
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:publishJourney" [#if role.permissions?seq_contains("admin:publishJourney")] checked="checked"[/#if]/>行程管理
						</label>
					</span>
                </td>
            </tr>
			<tr class="permissions">
				<th>
					<a href="javascript:;" class="selectAll" title="${message("admin.role.selectAll")}">内容管理</a>
				</th>
				<td>
					<span class="fieldSet">
						<label>
							<input type="checkbox" name="permissions" value="admin:message:announcement"[#if role.permissions?seq_contains("admin:message:announcement")] checked="checked"[/#if] />公告管理
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:message:wxNotifyManage"[#if role.permissions?seq_contains("admin:message:wxNotifyManage")] checked="checked"[/#if] />微信通知管理
						</label>
					</span>
				</td>
			</tr>
            <tr class="permissions">
                <th>
                    <a href="javascript:;" class="selectAll" title="${message("admin.role.selectAll")}">${message("admin.role.systemGroup")}</a>
                </th>
                <td>
					<span class="fieldSet">
						<label>
							<input type="checkbox" name="permissions" value="admin:setting"[#if role.permissions?seq_contains("admin:setting")] checked="checked"[/#if] />${message("admin.role.setting")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:area"[#if role.permissions?seq_contains("admin:area")] checked="checked"[/#if] />${message("admin.role.area")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:admin"[#if role.permissions?seq_contains("admin:admin")] checked="checked"[/#if] />${message("admin.role.admin")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:role"[#if role.permissions?seq_contains("admin:role")] checked="checked"[/#if] />${message("admin.role.role")}
						</label>


					</span>
                </td>
            </tr>
			[#if role.isSystem]
				<tr>
					<th>
						&nbsp;
					</th>
					<td>
						<span class="tips">${message("admin.role.editSystemNotAllowed")}</span>
					</td>
				</tr>
			[/#if]
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="${message("admin.common.submit")}"[#if role.isSystem] disabled="disabled"[/#if] />
					<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back(); return false;" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>