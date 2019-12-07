<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-商品列表 </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-select.css" rel="stylesheet">
	<link href="${base}/resources/business/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
    <script src="${base}/resources/business/js/jquery.form.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/bootstrap-select.js"></script>
	<script src="${base}/resources/business/js/velocity.js"></script>
	<script src="${base}/resources/business/js/velocity.ui.js"></script>
	<script src="${base}/resources/business/js/icheck.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $delete = $("#delete");
		var $shelves = $("#shelves");
		var $shelf = $("#shelf");
		var $checkAll = $("[data-toggle='checkAll']");
		var $ids = $("input[name='ids']");
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		// 删除
		$delete.deleteItem({
			url: "${base}/business/product/delete",
			data: function() {
				return $ids.serialize();
			},
			removeElement: function() {
				return $ids.filter(":checked").closest("tr");
			},
			complete: function() {
				$ids = $("input[name='ids']");
				$delete.add($shelves).add($shelf).attr("disabled", true);
				$checkAll.checkAll("uncheck");
				if ($ids.size() < 1) {
					setTimeout(function() {
						location.reload(true);
					}, 3000);
				}
			}
		});
		
		// 上架
		$shelves.click(function() {
			if (confirm("${message("business.product.shelvesConfirm")}")) {
				$.post("${base}/business/product/shelves", $ids.serialize(), function() {
					setTimeout(function() {
						location.reload(true);
					}, 3000);
				});
			}
		});
		
		// 下架
		$shelf.click(function() {
			if (confirm("${message("business.product.shelfConfirm")}")) {
				$.post("${base}/business/product/shelf", $ids.serialize(), function() {
					setTimeout(function() {
						location.reload(true);
					}, 3000);
				});
			}
		});
		
		// ID多选框
		$ids.on("ifChanged", function() {
			$delete.add($shelves).add($shelf).attr("disabled", $ids.filter(":checked").size() < 1);
		});
        $('#uploadForm').ajaxForm(function(result){
            $('#filterModal').modal('hide');
            if(result.status=="success"){
                var text="失败数据："+result.errorCode;
                text+="已存在数据："+result.skipCode;
			$("#resultText").text(text);
			$("#filterModal1").modal('show');
            }
            else{
               alert(result.msg);
            }
        });

	});
	function uploadFile(){
        var obj = document.getElementById("uplodFile") ;
        obj.outerHTML=obj.outerHTML;
        $("#tijiaoButton").removeProp("disabled");
        $('#filterModal').modal('show');
	}
	function submitForm1(){
	    $("#tijiaoButton").prop("disabled","disabled");
        $('#uploadForm').submit();
	}
	</script>
</head>
<body class="hold-transition sidebar-mini">
	<div class="wrapper">
		[#include "/business/include/main_header.ftl" /]
		[#include "/business/include/main_sidebar.ftl" /]
		<div class="content-wrapper">
			<div class="container-fluid">
				<section class="content-header">
					<h1>券码列表</h1>
					<ol class="breadcrumb">
						<li>
							<a href="${base}/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">券码列表</li>
					</ol>
				</section>
				<section class="content">

					<div class="row">
						<div class="col-xs-12">
								<div class="box">
									<div class="box-header">
                                        <div id="filterModal" class="modal fade" tabindex="-1">
                                            <div class="modal-dialog" style="margin-top: 10%">
                                                <div class="modal-content">
                                                    <form action="/business/productCoupon/uploadCoupon" method="post" enctype="multipart/form-data" id="uploadForm">
                                                    <div class="modal-header">
                                                        <button class="close" type="button" data-dismiss="modal">&times;</button>
                                                        <h4 class="modal-title">${message("business.common.moreOption")}</h4>
                                                    </div>
                                                    <div class="modal-body form-horizontal">

															<input type="hidden" name="skuId" value="${skuId}"/>
                                                        <div class="form-group">
                                                            <label class="col-xs-3 control-label">Excel文件:</label>
                                                            <div class="col-xs-7">
                                                                <input type="file" name="file"  accept=".xls,.xlsx" id="uplodFile"/>
                                                            </div>
                                                        </div>

                                                    </div>
                                                    </form>
                                                    <div class="modal-footer">
                                                        <button class="btn btn-primary" type="button" id="tijiaoButton" onclick="submitForm1()">${message("business.common.ok")}</button>
                                                        <button class="btn btn-default" type="button" data-dismiss="modal">${message("business.common.cancel")}</button>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                        <div id="filterModal1" class="modal fade" tabindex="-1">
                                            <div class="modal-dialog" style="margin-top: 10%">
                                                <div class="modal-content">
                                                        <div class="modal-header">
                                                            <button class="close" type="button" data-dismiss="modal">&times;</button>
                                                            <h4 class="modal-title">上传结果信息</h4>
                                                        </div>
                                                        <div class="modal-body form-horizontal">

                                                            <input type="hidden" name="skuId" value="${skuId}"/>
                                                            <div class="form-group">
                                                                <label class="col-xs-3 control-label">结果内容:</label>
                                                                <div class="col-xs-7">
                                                                   <textarea id="resultText" style="width: 100%;height: 200px"></textarea>
                                                                </div>
                                                            </div>

                                                        </div>
                                                        <div class="modal-footer">
                                                            <button class="btn btn-default" type="button" data-dismiss="modal">关闭</button>
                                                        </div>
                                                </div>
                                            </div>
                                        </div>
										<div class="row">
											<div class="col-xs-9">
												<div class="btn-group">
													<a class="btn btn-default" onclick="uploadFile()">
														<i class="fa fa-plus"></i>
														上传券码
													</a>
                                                    <a class="btn btn-default" href="/resources/download/codeTemplate.xls">
                                                        <i class="fa fa-download"></i>
													下载模板文件
                                                    </a>
												</div>
											</div>
											</div>
										</div>
									</div>
									<div class="box-body table-responsive no-padding">
										<table class="table table-hover">
											<thead>
												<tr>
													<th>
														券码值
													</th>
													<th>
													券码状态
													</th>
												</tr>
											</thead>
											<tbody>
												[#list page.content as product]
													<tr>
														<td>
															${product.codeValue}
														</td>
														<td>
															${product.usable?string("可用","不可用")}
														</td>
													</tr>
												[/#list]
											</tbody>
										</table>
										[#if !page.content?has_content]
											<p class="no-result">${message("business.common.noResult")}</p>
										[/#if]
									</div>
                            <form action="${base}/business/productCoupon/list" method="get">
                                <input name="pageSize" type="hidden" value="${page.pageSize}">
                                <input name="pageNumber" type="hidden" value="${page.pageNumber}">
                                <input name="skuId" type="hidden" value="${skuId}">
									[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
										[#if totalPages > 1]
											<div class="box-footer clearfix">
												[#include "/business/include/pagination.ftl"]
											</div>
										[/#if]
									[/@pagination]
							</form>
								</div>
						</div>
					</div>
				</section>
			</div>
		</div>
		[#include "/business/include/main_footer.ftl" /]
	</div>
</body>
</html>