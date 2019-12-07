<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
		<meta name=“viewport” content=“width=device-width, viewport-fit=cover”>
		<meta name="format-detection" content="telephone=no">
		<meta name="author" content="技术部">
		<meta name="copyright" content="SHOP">
		<link href="${base}/resources/mobile/member/css/renzheng.css" rel="stylesheet">
		<link href="${base}/resources/layui/css/layui.css" rel="stylesheet">
		<title>实名认证</title>

	</head>
	
	<body>
		<!--头部-->
		<form class="layui-form">
		<div>
			<div class="top">
				<a href="javascript:history.back();"><img src="${base}/newResources/member/images/jt.png" alt="" class="img" style="width: 8px;height: 16px;top: 10px;left: 10px;" /></a>
				<div class="text"><span style="font-size: 16px;">实名认证</span></div>
			</div>
            <div style="left: 0.32rem;position: absolute;top: 1rem;">
                <img src="${base}/newResources/member/images/th.png" style="width:0.4rem;height: 0.4rem;">
                <span style="padding: 0.2rem 0; color:#666666;">请确保填写信息和登录手机号信息为同一人</span>
            </div>
			<div class="name">
				<span>真实姓名:</span>
				<input type="text" name="realName" lay-verify="realName" placeholder="请输入真实姓名" />
			</div>
			<div class="sfzid">
				<span>身份证号:</span>
				<input type="text" name="idCard" lay-verify="idcard" placeholder="请输入身份证号" />
			</div>
		</div>
		<div class="sfzzm">
			<div class="zm">
				<div id="prvid">
                    <img src="${base}/newResources/member/images/zm.png" class="sfzZmImg"/>
                    <input type="hidden" name="idcardFront"/><#--lay-verify="idcardPickture"-->
				</div>
			</div>
		</div>
		<div class="sfzfm">
			<div class="fm">
				<div id="fm">
                    <img src="${base}/newResources/member/images/fm.png" class="sfzFmImg"/>
                    <input type="hidden" name="idCardReverse"/>
				</div>
			</div>
		</div>
		<div style="display: none;">
			<button lay-submit lay-filter="btn_form_submit">提交</button>
			<button type="reset">重置</button>
		</div>
            <input type="hidden" name="preActionName" value="${preActionName}">
        </form>
		<div class="tijiao" onclick="$('button:eq(0)').click();">
			<p>提交</p>
		</div>
        <!--弹框-->
        <div id="area_tip" style="display: none">
            <div class="mb"></div>
            <div class="con">
				<span class="rz">
						认证信息
					</span>
                <div class="conxq">
                    <div class="xm">
                        姓名 : <span>gdf</span>
                    </div>
                    <div class="sjh">
                        手机号 : <span class="phone">12345678912</span></div>
                    <div class="sfz">
                        身份证号 : <span class="cardId">123456789123456789</span></div>
                </div>
                <div class="cs">
                    请确认认证信息为同一人且真实有效，您只有3次认证机会。
                </div>
                <div class="anNiu">
                    <div class="a">
                        <span class="xg" onclick="modification();">修改</span>
                    </div>
                    <div>
                        <span class="qr" onclick="confirm();">确定</span>
                    </div>
                </div>

            </div>
        </div>
	</body>
	<script src="${base}/resources/mobile/member/js/jquery.js"></script>
	<script src="${base}/resources/layui/layui.js"></script>
    <script src="${base}/resources/layer_mobile/layer.js"></script>
    <script>
        var screenWid = document.documentElement.offsetWidth || document.body.offsetWidth;
        var nowWid = (screenWid / 750) * 100;
        var oHtml = document.getElementsByTagName("html")[0];
        //		console.log(nowWid);
        oHtml.style.fontSize = nowWid + "px";
    </script>
	<script type="text/javascript">
        layui.use(['form','element','upload'], function(){
            var upload = layui.upload;
            var form = layui.form;
            //监听提交
            form.verify({
                idcard : [/(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/, '身份证号格式不正确'],
                realName: function(value, item){
                    if(value==""){
                        return "请填写真实姓名";
                    }
                },
                idcardPickture: function (value, item) {
                    if(value==""){
                        return "请上传身份证照片";
                    }
                }
            });
            form.on('submit(btn_form_submit)', function (data) {
				confirmation(data.field);
                return false;
            });

            //普通图片上传
            var uploadInst_front = upload.render({
                elem: '#prvid',
                url: '${base}/member/authentification/upload',
                before: function(obj){
                    //预读本地文件示例，不支持ie8
                    obj.preview(function(index, file, result){
                        $('#prvid>img').attr('src', result); //图片链接（base64）
                    });
                },done: function(res){
                    //如果上传失败
                    if(res.code > 0){
                        return layer.msg('上传失败');
                    }
                    //上传成功
                    $('#prvid>input[name="idcardFront"]').val(res.data.src);
                },error: function(){
                    //演示失败状态，并实现重传
                    var demoText = $('#demoText');
                    demoText.html('<span style="color: #FF5722;">上传失败</span> <a class="layui-btn layui-btn-xs demo-reload">重试</a>');
                    demoText.find('.demo-reload').on('click', function(){
                        uploadInst_front.upload();
                    });
                }
            });

            var uploadInst_reverse = upload.render({
                elem: '#fm',
                url: '${base}/member/authentification/upload',
                before: function(obj){
                    //预读本地文件示例，不支持ie8
                    obj.preview(function(index, file, result){
                        $('#fm>img').attr('src', result); //图片链接（base64）
                    });
                },done: function(res){
                    //如果上传失败
                    if(res.code > 0){
                        return layer.msg('上传失败');
                    }
                    //上传成功
                    $('#fm>input[name="idCardReverse"]').val(res.data.src);
                },error: function(){
                    //演示失败状态，并实现重传
                    var demoText = $('#demoText');
                    demoText.html('<span style="color: #FF5722;">上传失败</span> <a class="layui-btn layui-btn-xs demo-reload">重试</a>');
                    demoText.find('.demo-reload').on('click', function(){
                        uploadInst_reverse.upload();
                    });
                }
            });

        });
	</script>
<script>
	var closeData={};
	function confirm(){
		modification();
		authentificat(closeData.dataField);
	}
	function modification() {
		$("#area_tip").hide();
	}
	function confirmation(field) {
		closeData.dataField=field;
		$("#area_tip").show();
		$(".xm>span").text(field.realName);
		$(".phone").text(${currentUser.mobile});
		$(".cardId").text(field.idCard);
	}
function authentificat(field){
    var index = layer.load(2, {shade: [0.8, '#393D49']});
    $.ajax({
        async:false,
        cache:false,
        url:'${base}/member/authentification/authentification',
        type:"POST",
        data:field,
        dataType:"json",
        success:function(data){
            layer.close(index);
            if(data.code==200){
                window.location.href="${base}"+data.url;
			 }else{
                layer.msg(data.msg);
            }
        }
    })
}
</script>
</html>