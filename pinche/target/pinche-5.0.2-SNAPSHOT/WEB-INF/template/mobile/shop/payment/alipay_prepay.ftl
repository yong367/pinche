<!DOCTYPE html>
<html>
<head>
    <meta charset="${requestCharset!"utf-8"}">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>${message("shop.payment.prePay")}</title>
    <script src="${base}/resources/mobile/shop/js/jquery.js"></script>
    <script src="${base}/resources/mobile/shop/js/alipay/ap.js"></script>


</head>
<body onload="autoToSubmit()">
<input id="url" type="hidden" value="${parameterMap.url}">
<script>
    function autoToSubmit() {
        var content = $("#url").val();
        _AP.pay(content);
    }
</script>
</body>
</html>