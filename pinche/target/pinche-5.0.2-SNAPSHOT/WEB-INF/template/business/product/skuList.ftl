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
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/bootstrap-select.js"></script>
	<script src="${base}/resources/business/js/velocity.js"></script>
	<script src="${base}/resources/business/js/velocity.ui.js"></script>
	<script src="${base}/resources/business/js/icheck.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">

	</script>
</head>
<body class="hold-transition sidebar-mini">
	<div class="wrapper">
		[#include "/business/include/main_header.ftl" /]
		[#include "/business/include/main_sidebar.ftl" /]
		<div class="content-wrapper">
			<div class="container-fluid">
				<section class="content-header">
					<h1>商品库存管理</h1>
					<ol class="breadcrumb">
						<li>
							<a href="${base}/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">商品库存管理</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
								<div class="box">
									<div class="box-body table-responsive no-padding">
										<table class="table table-hover">
											<thead>
												<tr>
													<th>
															价格
													</th>
													<th>
															剩余库存
													</th>
													<th>
													锁定库存
													</th>
													<th>
														规格说明
													</th>
                                                    <th>
                                                        操作
                                                    </th>
												</tr>
											</thead>
											<tbody>
												[#list skuList as sku]
													<tr>
														<td>
															${sku.price}
														</td>
                                                        <td>
															${sku.stock}
                                                        </td>
                                                        <td>
															${sku.allocatedStock}
                                                        </td>
                                                        <td>
															${sku.specification}
                                                        </td>
														<td>
																<a href="${base}/business/productCoupon/list?skuId=${sku.id}" >券码管理</a>
														</td>
													</tr>
												[/#list]
											</tbody>
										</table>
									</div>
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