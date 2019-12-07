[@product_list productCategoryId = productCategory.id count = 3 orderBy = "monthSales desc"]
	[#if products?has_content]
		<div class="hotProduct">
			<dl>
				<dt>${message("shop.product.hotProduct")}</dt>
				[#list products as product]
					<dd>
						<a href="${base}${product.path}">
							<img src="${product.thumbnail!setting.defaultThumbnailProductImage}" alt="${product.name}" />
							<span title="${product.name}">${abbreviate(product.name, 52)}</span>
						</a>

							[#if productCategory.id == 304]
                                <strong style="color: #52bffe">${product.store.name}</strong>
							[#else]
                            <strong>
                                <img style="padding-top: 5px;width: 15px;height: 15px;" src="${setting.currencySign}"  alt="${setting.currencyIconName}"/>${currency(product.price, false)}
								[#--[#if setting.isShowMarketPrice]
                                    <del>${currency(product.marketPrice, false)}</del>
								[/#if]--]
                            </strong>
							[/#if]


					</dd>
				[/#list]
			</dl>
		</div>
	[/#if]
[/@product_list]