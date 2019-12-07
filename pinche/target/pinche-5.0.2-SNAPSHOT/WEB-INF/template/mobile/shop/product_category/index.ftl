<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>爱帮伴-商品分类</title>
    <link href="${base}/favicon.ico" rel="icon">
    <link rel="stylesheet" type="text/css" href="/newResources/shopindex/css/commen.css"/>
    <script src="/newResources/shopindex/js/jquery-1.9.1.min.js"></script>
    [#--<script src="/newResources/shopindex/js/navbar.js"></script>--]
    <title>分类</title>
    <style type="text/css">
        * {
            padding: 0;
            margin: 0;
        }

        ul, li {
            list-style: none;
        }

        body {
            width: 7.5rem;
            min-height: 13.34rem;
            height: auto;
            background: url(/newResources/shop/images/beijing.png) no-repeat;
            background-size: 100% 100%;
            font-family: "Source Han Sans CN", "PingFang SC;

        }

        .gb {
            display: block;
            width: 0.6rem;
            height: 0.6rem;
            position: absolute;
            top: 0.3rem;
            right: 0.3rem;
        }

        .gb img {
            display: block;
            width: 0.5rem;
            height: 0.5rem;
        }

        span {
            display: inline-block;
            margin: 0.1rem;
            font-weight: 500;
            background: #eef2fa;
            padding: 0.05rem 0.1rem;
        }

        .left {
            float: left;
        }

        .hang {
            width: 7.5rem;
            min-height: 0.3rem;
            height: auto;
            display: inline-flex;
            line-height: 0.3rem;
        }

        .yiji {
            text-align: center;
            width: 2rem;
            min-height: 0.3rem;
            height: auto;
            font-size: 0.32rem;
            color: #FFFFFF;
            font-weight: bold;
            padding-top: 0.1rem;
        }

        .erji {
            width: 5rem;
            min-height: 0.3rem;
            height: auto;
            font-size: 0.30rem;
            color: #504e52;
            margin-left: 0.5rem;
        }
    </style>
</head>

<body>
<div style="height: 1rem;"></div>
<div class=""/>
[#list rootProductCategories as rootProductCategory]
    <div class="hang">
        <div class="yiji left"
             onclick="javascript:window.location.href='${base}${rootProductCategory.path}'">${rootProductCategory.name}</div>
        <div class="erji left">
           	[#list rootProductCategory.children as productCategory]
                <span onclick="javascript:window.location.href='${base}${productCategory.path}'">${productCategory.name}</span>
            [/#list]
        </div>
    </div>
[/#list]

</div>
<div style="height: 1rem;"></div>
<div class="nav">
    <div class="">
        <ul class="navbar">
            <a href="/" class="">
                <li class="zhuye">
                    <img src="/newResources/shopindex/img/bar1.png"/>
                    <div class="bar-hui">主页</div>
                </li>
            </a>
            <a href="/product_category" class="">
                <li class="fenlei">
                    <img src="/newResources/shopindex/img/bar2-2.png"/>
                    <div class="bar-hui" style="color:#7d9bed">分类</div>
                </li>
            </a>
            <a href="/member/task/list" class="">
                <li class="zlh">
                    <img src="/newResources/shopindex/img/bar3.png"/>
                    <div class="bar-hui">赚零花</div>
                </li>
            </a>
            <a href="/cart/list" class="">
                <li class="gwc">
                    <img src="/newResources/shopindex/img/bar4.png"/>
                    <div class="bar-hui">购物车</div>
                </li>
            </a>
            <a href="/member/index" class=" ">
                <li class="wode">
                    <img src="/newResources/shopindex/img/bar5.png"/>
                    <div class="bar-hui">我的</div>
                </li>
            </a>
        </ul>
    </div>
</div>
<div class="clear " style="clear: both; "></div>
</body>
<script type="text/javascript ">
    //rem单位屏幕自适应代码(必要时放在最前面)-开始
    var screenWid = document.documentElement.offsetWidth || document.body.offsetWidth;
    var nowWid = (screenWid / 750) * 100;
    var oHtml = document.getElementsByTagName("html")[0];
    //		console.log(nowWid);
    oHtml.style.fontSize = nowWid + "px";
    //rem单位屏幕自适应代码(必要时放在最前面)-结束
</script>
</html>