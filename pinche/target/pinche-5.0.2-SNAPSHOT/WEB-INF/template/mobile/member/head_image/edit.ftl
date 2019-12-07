<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-修改头像</title>
    <link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
    <script src="${base}/resources/mobile/member/js/jquery.js"></script>
    <script src="${base}/resources/mobile/member/js/hammer.min.js"></script>
    <script src="${base}/resources/mobile/member/js/iscroll-zoom-min.js"></script>
    <script src="${base}/resources/mobile/member/js/lrz.all.bundle.js"></script>
    <script src="${base}/resources/mobile/member/js/PhotoClip.js"></script>
    <script>

	function uploadImg(){
	    $("#uploadImg").click();
	}
    $(function(){
        var pc = new PhotoClip('#clipArea', {
            size: 200,
            outputSize: 100,
            //adaptive: ['60%', '80%'],
            file: '#uploadImg',
            ok: '#clipBtn',
            //img: 'img/mm.jpg',
            loadStart: function() {
                console.log('开始读取照片');
            },
            loadComplete: function() {
                $(".photo-clip-rotation-layer").css("height","100%");
                $(".photo-clip-rotation-layer").css("width","100%");
                $(".photo-clip-move-layer").css("height","100%");
                $(".photo-clip-move-layer").css("width","100%");
                $("#xuanze").hide();
                $("#clipBtn").show();
                console.log('照片读取完成');
            },
            done: function(dataURL) {
                var formData = new FormData();
               formData.append("file",convertBase64UrlToBlob(dataURL),"tmp.jpg");
               formData.append("fileType","image");
                $.ajax({
                    // 你后台的接收地址
                    url : '/member/image/upload',
                    type : "POST",
                    data : formData,
                    dataType:"json",
                    processData : false,         // 告诉jQuery不要去处理发送的数据
                    contentType : false,        // 告诉jQuery不要去设置Content-Type请求头
                    beforeSend: function() {
                        alert("图片正在上传中，请耐心等待！");
                    },
                    success:function(data){

                        setTimeout(function() {
                            alert("头像上传成功！");
                            window.location.href="/member/index";
                        }, 4000);

                    },
                });
            },
            fail: function(msg) {
                alert(msg);
            }
        });

        // 加载的图片必须要与本程序同源，否则无法截图
//        pc.load('img/mm.jpg');
        $("#clipArea").removeAttr("style");

        $("#clipArea").css("overflow","hidden");
       $(".photo-clip-mask").css("top","40px");
        $(".photo-clip-mask").css("user-select","none");
        $(".photo-clip-layer").css("margin-top","-60px");
        $(".photo-clip-layer").css("background","#525252");
        $(".photo-clip-mask-top").css("background-color","rgba(0,0,0,0.7)");//B1B1B1
        $(".photo-clip-mask-left").css("background-color","rgba(0,0,0,0.7)");//B1B1B1
        $(".photo-clip-mask-right").css("background-color","rgba(0,0,0,0.7)");//B1B1B1
        $(".photo-clip-mask-bottom").css("background-color","rgba(0,0,0,0.7)");//B1B1B1


        $(".photo-clip-rotation-layer").css("height","100%");
        $(".photo-clip-rotation-layer").css("width","100%");
        $(".photo-clip-move-layer").css("height","100%");
        $(".photo-clip-move-layer").css("width","100%");
        $(".photo-clip-area").css("border","1px solid #FFFFFF");
	});
	function convertBase64UrlToBlob(urlData){
        //去掉url的头，并转换为byte
        var bytes=window.atob(urlData.split(',')[1]);
        //处理异常,将ascii码小于0的转换为大于0
        var ab = new ArrayBuffer(bytes.length);
        var ia = new Uint8Array(ab);
        for (var i = 0; i < bytes.length; i++) {
            ia[i] = bytes.charCodeAt(i);
        }
        // 此处type注意与photoClip初始化中的outputType类型保持一致
        return new Blob( [ab] , {type : 'image/jpeg'});
    }

</script>
    <style>
        body {
            margin: 0;
            text-align: center;
        }
        #clipArea {
            height: 100%;
        }
        a{
            color: white;
        }

    </style>
</head>
<body style="height: 100%;width: 100%;margin: 0;padding: 0;overflow: hidden;position:fixed">
<div style="height: 40px;background-color: #000000;position: absolute;left:0px;top: 0px;width: 100%; z-index:1000;">
    <a class="pull-left" href="javascript: window.history.back(-1)" style="line-height: 40px;width: 30px;font-size: 20px;">
        <span class="glyphicon glyphicon-menu-left"></span>
    </a>
    <span style="color:white;height: 40px;float: right;font-size: 16px;margin-right: 10px;padding-top: 9px;" onclick="uploadImg()" id="xuanze">选择</span>
    <span style="color:white;height: 40px;float: right;font-size: 16px;display: none;margin-right: 10px;padding-top: 9px;" id="clipBtn">使用</span>
    <#--<button onclick="uploadImg()" style="background: white;border: none;height: 40px;float: right;">···</button>
    <button id="clipBtn" style="background: white;border: none;height: 40px;float: right;display: none">上传图片</button>-->
    <input accept="image/*" type="file" id="uploadImg" style="display: none"/>
</div>
        <div id="clipArea"></div>
</body>
</html>