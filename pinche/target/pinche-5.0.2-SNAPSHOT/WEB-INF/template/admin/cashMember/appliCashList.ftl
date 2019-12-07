<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.cash.list")} </title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $reviewForm = $("#reviewForm");
	var $id = $("#id");
	var $isPassed = $("#isPassed");
	
	[#if flashMessage?has_content]
			alert("${flashMessage}");
	[/#if]


    // 审核
	$.review = function(cashId) {
		$.dialog({
			type: "warn",
			content: "${message("admin.cash.reviewConfirm")}",
			ok: "${message("admin.common.true")}",
			cancel: "${message("admin.common.false")}",
			onOk: function() {
				$id.val(cashId);
				$isPassed.val("true");
				$reviewForm.submit();
				return false;
			},
			onCancel: function() {
				$id.val(cashId);
				$isPassed.val("false");
				$reviewForm.submit();
				return false;
			}
		});
	};
});

function exportCashList(){
    $("#exportsearchValue").val($("#searchValue").val());
    $("#exportCashForm").submit();
}
    
</script>
</head>
<body>
<form id="exportCashForm" action="/admin/memberCash/exportCashList" method="POST" style="display: none">
    <input type="text" id="exportsearchValue" name="searchValue" value="${page.searchValue}" maxlength="200" />
</form>
	<form id="reviewForm" action="review" method="post">
		<input type="hidden" id="id" name="id"/>
		<input type="hidden" id="isPassed" name="isPassed" />
	</form>
	<div class="breadcrumb">
		<a href="${base}/admin/common/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.cash.list")} <span>(${message("admin.page.total", page.total)})</span>
	</div>
	<form id="listForm" action="/admin/memberCash/appliCashList" method="get">
		<div class="bar">
			<div class="buttonGroup">
				<a href="javascript:;" id="refreshButton" class="iconButton">
					<span class="refreshIcon">&nbsp;</span>${message("admin.common.refresh")}
				</a>
				<div id="pageSizeMenu" class="dropdownMenu">
					<a href="javascript:;" class="button">
						${message("admin.page.pageSize")}<span class="arrow">&nbsp;</span>
					</a>
					<ul>
						<li[#if page.pageSize == 10] class="current"[/#if] val="10">10</li>
						<li[#if page.pageSize == 20] class="current"[/#if] val="20">20</li>
                        <li[#if page.pageSize == 50] class="current"[/#if] val="50">50</li>
                        <li[#if page.pageSize == 100] class="current"[/#if] val="100">100</li>
					</ul>
				</div>
			</div>
			<div id="searchPropertyMenu" class="dropdownMenu">
				<div class="search">
					<span class="arrow">&nbsp;</span>
					<input type="text" id="searchValue" name="searchValue" value="${page.searchValue}" maxlength="200" />
					<button type="submit">&nbsp;</button>
				</div>
				<ul>
					<li[#if page.searchProperty == "member.username"] class="current"[/#if] val="member.username">会员手机号</li>
				</ul>
			</div>
			<input type="button" value="导出数据" onclick="exportCashList()"/>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th>
					<a href="javascript:;" class="sort" name="amount">会员提现金额</a>
				</th>
                <th>
                    实际提现(已扣除0.6%手续费)
                </th>
				
				<th>
					<a href="javascript:;" class="sort" name="business.name">会员账户</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="status">${message("Cash.status")}</a>
				</th>
                <th>
                    <a href="javascript:;" class="sort" name="cashMethod">提现方式</a>
                </th>
				<th>
					<a href="javascript:;" class="sort" name="createdDate">${message("admin.common.createdDate")}</a>
				</th>
				<th>
					<span>${message("admin.common.action")}</span>
				</th>
			</tr>
			[#list page.content as cash]
				<tr[#if !cash_has_next] class="last"[/#if]>
					<td>
						${currency(cash.amount)}
					</td>
                    <td>
						${currency(cash.transferAmount)}
                    </td>
					<td>
						${cash.member.username}
					</td>
					<td>
						<span>
							[#if cash.status == "FAILED"]提现失败[/#if]
							[#if cash.status == "CashException"]订单异常[/#if]
							[#if cash.status == "PROCESSING"]处理中[/#if]
							[#if cash.status == "SUCCESS"]提现成功[/#if]
						</span>
					</td>
                    <td>
                        [#if cash.cashMethod == "wxCash"]微信提现[/#if]
                        [#if cash.cashMethod == "alipayCash"]支付宝提现[/#if]
                    </td>
					<td>
						<span title="${cash.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${cash.createdDate?string("yyyy-MM-dd HH:mm:ss")}</span>
					</td>
					<td>
						[#if cash.status == "PROCESSING"]
                            [#--<input type="button" value="确定" onclick="firmCash()"/>--]
                            [#--<a href="/admin/memberCash/firmCash?id=${cash.id}">确定转账</a>--]
                            <a href="javascript:if(confirm('确定要进行提现吗?'))location='/admin/memberCash/firmCash?id=${cash.id}'">确定转账</a>
						[/#if]
					</td>
				</tr>
			[/#list]
		</table>
		[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
			[#include "/admin/include/pagination.ftl"]
		[/@pagination]
	</form>
</body>
</html>