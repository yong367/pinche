<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>初始化评论</title>
    <link href="${base}/favicon.ico" rel="icon">
    <link href="${base}/resources/mobile/shop/css/bootstrap.css" rel="stylesheet">
    <link href="${base}/resources/business/css/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen">
    <link href="${base}/resources/mobile/shop/css/font-awesome.css" rel="stylesheet">
    <link href="${base}/resources/mobile/shop/css/animate.css" rel="stylesheet">
    <link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
    <link href="${base}/resources/mobile/shop/css/review.css" rel="stylesheet">
    <!--[if lt IE 9]>
    <script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
    <script src="${base}/resources/mobile/shop/js/respond.js"></script>
    <![endif]-->
    <script src="${base}/resources/mobile/shop/js/jquery.js"></script>
    <script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
    <script src="${base}/resources/business/js/bootstrap-datetimepicker.min.js"></script>
    <script src="${base}/resources/business/js/bootstrap-datetimepicker.zh-CN.js"></script>
    <script src="${base}/resources/mobile/shop/js/jquery.rating.js"></script>
    <script src="${base}/resources/mobile/shop/js/jquery.validate.js"></script>
    <script src="${base}/resources/mobile/shop/js/underscore.js"></script>
    <script src="${base}/resources/mobile/shop/js/common.js"></script>
    <style>
        .tableClass tr{
            line-height: 2rem;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            $('#datetimeStart').datetimepicker({
                language:  'zh-CN',
                format:'yyyy-mm-dd',
                weekStart: 1, /*以星期一为一星期开始*/
                autoclose: true,
                minView:2, /*精确到天*/
                todayHighlight: true,
                pickerPosition: "bottom-left"
            });
        });
        var page =2;
            //获取商品详情
            function findUserByProduct(){
                var productId = $("#productId").val();
                if(productId != 'error'){
                    $.ajax({
                        url: "/member/login/findUserByProduct",
                        type: "POST",
                        data: "productId="+productId,
                        dataType: "json",
                        success: function(data) {
                            $("#showProductImage").attr("src",data.image);
                            $("#totalReviewCount").html(data.reviewCount);
                            $("#totalSalesCount").html(data.sales);
                        },
                        error:function (xhr, textStatus, errorThrown) {
                            console.log(errorThrown);
                        }
                    });
                }
            }
        function submitForm() {
            $("#pinglun").attr("disabled","disabled");
            var productId = $("#productId").val();
            var password =$("#password").val();
            var scoreId = $("#scoreId").val();
            var content = $("#content").val();
            var datetimeStart = $("#datetimeStart").val();
            $("#pinglun").attr("disabled","disabled");
                $.ajax({
                            url: "/member/login/saveInitReview",
                            type: "POST",
                            data: "productId="+productId+"&password="+password+"&score="+scoreId+"&content="+content+"&datetimeStart="+datetimeStart,
                            dataType: "json",
                            success: function(data) {
                                $("#pinglun").removeAttr("disabled");
                                if(data.status =='y'){
                                    $("#content").val("");
                                    alert("评论成功");
                                }else{
                                    alert(data.msg);
                                }
                            },
                        error: function(xhr, textStatus, errorThrown) {
                            $("#pinglun").removeAttr("disabled");
                }
            });
        }


    </script>
</head>
<body class="add-review">
<header class="header-fixed" style="background-color: #2cb6f1;color: white">
    <a class="pull-left" href="${base}/product/detail/${product.id}#review">
        <span class="glyphicon glyphicon-menu-left" style="color: white"></span>
    </a>
初始化评论
</header>
<main>
    <div class="media">
        <div >
            <img src="" id="showProductImage" width="200px" height="200px">
        </div>
        <div >
            当前评论总数：<span id="totalReviewCount"></span>
        </div>
        <div >
            当前商品销售总数：<span id="totalSalesCount"></span>
        </div>
    </div>
    <form id="reviewForm" action="${base}/review/save" method="post">
        <div class="form-group">
            <label>口令:</label>
            <input name="password" class="form-control" type="password" id="password" >
        </div>
        <div class="form-group">
            <label>商品选择:</label>
            <select name="productId" id="productId" onchange="findUserByProduct()" style="width: 100%">
                <option value="error">请选择商品</option>
            [#list products as product]
                <option value="${product.id}">${product_index + 1}. ${product.name}</option>
            [/#list]
            </select>
        </div>
        <div class="form-group">
            <label>评论时间</label>
            <input id="datetimeStart" value="2018-07-01" name="startDate" readonly class="form-control form_datetime" type="text">
        </div>
        <div class="form-group">
            <label>星级</label>
            <select name="score" id="scoreId">
                <option value="1">1分 非常不满</option>
                <option value="2">2分 不满意</option>
                <option value="3">3分 一般</option>
                <option value="4">4分 满意</option>
                <option value="5" selected>5分 非常满意</option>
            </select>
        </div>
        <div class="form-group">
            <label for="content">内容</label>
            <textarea id="content" name="content" class="form-control" rows="5"></textarea>
        </div>
        <button class="btn btn-lg btn-primary btn-block" type="button" id="pinglun" style="background-color: #2cb6f1" onclick="submitForm()">评论</button>
    </form>
</main>
</body>
</html>