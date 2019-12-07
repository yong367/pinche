[@brand_list productCategoryId = productCategory.id type = "image" count = 12]
	[#if brands?has_content]
		<div class="hotBrand clearfix">
			<dl>
				<dt>${message("shop.product.hotBrand")}</dt>
				[#list brands as brand]
					<dd style="border-bottom: 1px dashed #dddddd;[#if brand_index gte 10] border-bottom: 0px; [/#if]" [#if (brand_index + 1) % 2 == 0] class="even"[/#if]>
						<a href="${base}${brand.path}" title="${brand.name}">
							<img src="${brand.logo}" alt="${brand.name}" />
							<span>${brand.name}</span>
						</a>
					</dd>
				[/#list]
			</dl>
		</div>
	[/#if]
[/@brand_list]