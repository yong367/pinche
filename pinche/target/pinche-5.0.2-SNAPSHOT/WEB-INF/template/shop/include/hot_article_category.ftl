[@article_category_root_list count = 10]
	<div class="hotArticleCategory">
		<dl>
			<dt>通知中心</dt>
			[#list articleCategories as articleCategory]
				<dd>
					<a href="${base}${articleCategory.path}">${articleCategory.name}</a>
				</dd>
			[/#list]
		</dl>
	</div>
[/@article_category_root_list]