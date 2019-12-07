<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>${message("admin.business.list")} </title>
    <meta name="author" content="技术部" />
    <meta name="copyright" content="SHOP" />
    <link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
    <script type="text/javascript">

    </script>
</head>
<body>
<div class="breadcrumb" />
    <a href="${base}/admin/common/index">${message("admin.breadcrumb.home")}</a> &raquo; ${prize.prizeName}-券码列表 <span>(${message("admin.page.total", page.total)})</span>
</div>
<form id="listForm" action="/admin/prizePond/ticketManage" method="get">
	<input type="hidden" name="id" value="${prize.id}"/>
    <div class="bar">
        <a href="/admin/prizePond/addPrizeTicket?id=${prize.id}" class="iconButton">
            <span class="addIcon">&nbsp;</span>${message("admin.common.add")}
        </a>
        <div class="buttonGroup">
            <a href="/resources/download/codeTemplate.xls" class="iconButton">
                <span class="downIcon">&nbsp;</span>下载模板
            </a>
        </div>
    </div>
    <table id="listTable" class="list">
        <tr>

            <th>
               券码值
            </th>
            <th>
               券码状态
            </th>
        </tr>
			[#list page.content as prizeTicket]
				<tr>
                    <td>
                       ${prizeTicket.codeValue}
                    </td>
                    <td>
						[#if prizeTicket.usable]可用[#else]不可用[/#if]
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