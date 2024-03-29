<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>爱帮伴-商品评论</title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $delete = $("a.delete");

	[#if flashMessage?has_content]
		$.alert("${flashMessage}");
	[/#if]

	// 删除
	$delete.click(function() {
		if (confirm("${message("member.dialog.deleteConfirm")}")) {
			var $this = $(this);
			$.ajax({
				url: "delete",
				type: "POST",
				data: {id: $this.attr("val")},
				dataType: "json",
				cache: false,
				success: function() {
					var $item = $this.closest("tr");
					if ($item.siblings("tr").size() < 2) {
						setTimeout(function() {
							location.reload(true);
						}, 3000);
					}
					$this.closest("tr").remove();
				}
			});
		}
		return false;
	});

});
</script>
</head>
<body>
	[#assign current = "reviewList" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="list">
					<div class="title">${message("member.review.list")}</div>
					<table class="list">
						<tr>
							<th>
								${message("member.review.productImage")}
							</th>
							<th>
								${message("Review.product")}
							</th>
							<th>
								${message("Review.score")}
							</th>
							<th>
								${message("member.common.createdDate")}
							</th>
							<th>
								${message("member.common.action")}
							</th>
						</tr>
						[#list page.content as review]
							<tr[#if !review_has_next] class="last"[/#if]>
								<td>
									<input type="hidden" name="id" value="${review.id}" />
									<img src="${review.product.thumbnail!setting.defaultThumbnailProductImage}" class="productThumbnail" alt="${review.product.name}" />
								</td>
								<td>
									<a href="${base}${review.product.path}#review" title="${review.product.name}" target="_blank">${abbreviate(review.product.name, 30)}</a>
								</td>
								<td>
									${review.score}
								</td>
								<td>
									<span title="${review.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${review.createdDate}</span>
								</td>
								<td>
									<a href="javascript:;" class="delete" val="${review.id}">[${message("member.common.delete")}]</a>
								</td>
							</tr>
						[/#list]
					</table>
					[#if !page.content?has_content]
						<p>${message("member.common.noResult")}</p>
					[/#if]
				</div>
				[@pagination pageNumber = page.pageNumber totalPages = page.totalPages pattern = "?pageNumber={pageNumber}"]
					[#include "/shop/include/pagination.ftl"]
				[/@pagination]
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>