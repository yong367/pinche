<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>${message("admin.message.send")} </title>
    <meta name="author" content="技术部" />
    <meta name="copyright" content="SHOP" />
    <link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.form.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
    <script type="text/javascript">
$(function () {
    $('#inputForm').ajaxForm(function(result){
        if (result.status === 'success') {
            alert("上传成功！");
            window.location.href="/admin/prizePond/ticketManage?id=${prizeId}"
        }else{
            alert(result.msg);
		}
    });
});
    </script>
</head>
<body>
<div class="breadcrumb">
    <a href="${base}/admin/common/index">${message("admin.breadcrumb.home")}</a> &raquo; 添加券码
</div>
<form id="inputForm" action="/admin/prizePond/uploadCoupon" method="post" enctype="multipart/form-data">
    <input type="hidden" name="prizeId" value="${prizeId}" />
    <table class="input">
        <tr>
            <th>
                <span class="requiredField">*</span>券码文件:
            </th>
            <td>
                <input type="file" name="file"  accept=".xls,.xlsx" id="uplodFile" />
            </td>
        </tr>
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <input type="submit" id="send" class="button" value="上传" />
            </td>
        </tr>
    </table>
</form>
</body>
</html>