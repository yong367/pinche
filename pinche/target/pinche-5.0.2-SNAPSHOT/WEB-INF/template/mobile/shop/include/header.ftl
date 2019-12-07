<header style="background: rgb(44,182,241)">
    <div class="home_head orange">
        <div class="flex flex-align-center home_head_form">
            <div class="hh_addr">
                <p class="hh_addr_p">全国</p>
            </div>
            <div class="flex-1 flex hh_search">
                <form id="searchForm" action="${base}/product/search" method="get" >
                    <input type="text" id="keyword" name="keyword" class="flex-1 hh_search_ipt" placeholder="${message("shop.index.keyword")}" />
                    <button type="submit" class="hh_search_sub" ><i class="icon_1 icon_1_search"></i></button>
                </form>
            </div>
        </div>
        <div class="userNewr" style="position: absolute;top:15%;right:3%;">
          [#--  <a id="login" class="login" href="${base}/member/login">${message("shop.index.login")}</a>--]
            <a id="member" class="member" href="${base}/member/index"></a>
        </div>
    </div>
</header>
<div class="navNew" id="navNew" style="z-index: 100;position: fixed;">
    <div class="scroller">
        <ul class="clearfix">
        [@navigation_list position = "middle"]
            [#list navigations as navigation]
                <li>
                    <a href="${navigation.url}"[#if navigation.isBlankTarget] target="_blank"[/#if]>${navigation.name}</a>
                </li>
            [/#list]
        [/@navigation_list]
        </ul>
    </div>
    <span class="last"><a href="${base}/product_category"></a></span>
</div>