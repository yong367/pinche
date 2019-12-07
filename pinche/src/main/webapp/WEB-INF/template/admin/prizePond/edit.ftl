<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.member.edit")} </title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/layui/css/layui.css" rel="stylesheet">
</head>
<body>
<div class="breadcrumb">
	<a href="${base}/admin/common/index">首页</a> &raquo; 修改奖品
</div>
<form class="layui-form" action="update" method="post">
	<div class="layui-form-item">
		<label class="layui-form-label">奖品名称</label>
		<div class="layui-input-block">
			<input type="text" name="prizeName" value="${prize.prizeName}" placeholder="请输入奖品名称" autocomplete="off" class="layui-input" lay-verify="required" >
		</div>
	</div>
	<div class="layui-form-item">
		<label class="layui-form-label">奖品类型</label>
		<div class="layui-input-block">
			<select name="prizeType"  lay-filter="prizeType">
				<option value="VIRTUAL" [#if prize.prizeType=="VIRTUAL"] selected [/#if]>虚拟</option>
				<option value="MATERIAL" [#if prize.prizeType=="MATERIAL"] selected [/#if]>实物</option>
			</select>
		</div>
	</div>
	<div class="layui-form-item">
		<label class="layui-form-label">奖品子类型</label>
		<div class="layui-input-block">
			<select name="prizeSeedType" lay-filter="prizeSeedType">
				[#if prize.prizeType =="VIRTUAL"]
					<option value="POINT" [#if prize.prizeSeedType=="POINT"] selected [/#if]>积分</option>
					<option value="MONEY" [#if prize.prizeSeedType=="MONEY"] selected [/#if]>金额</option>
					<option value="TELEPHONECHARGE" [#if prize.prizeSeedType=="TELEPHONECHARGE"] selected [/#if]>话费</option>
					<option value="SUNINGTONGBAN" [#if prize.prizeSeedType=="SUNINGTONGBAN"] selected [/#if]>苏宁铜板</option>
                    <option value="TICKETCODE" [#if prize.prizeSeedType=="TICKETCODE"] selected [/#if]>券码</option>
				[#else]
					<option value="electronics" [#if prize.prizeSeedType=="electronics"] selected [/#if]>电子产品</option>
					<option value="mobilecommunication" [#if prize.prizeSeedType=="mobilecommunication"] selected [/#if]>移动通信</option>
					<option value="beautymakeup" [#if prize.prizeSeedType=="beautymakeup"] selected [/#if]>美妆</option>
					<option value="toy" [#if prize.prizeSeedType=="toy"] selected [/#if]>玩具</option>
					<option value="sportequipment" [#if prize.prizeSeedType=="sportequipment"] selected [/#if]>体育器材</option>
					<option value="other" [#if prize.prizeSeedType=="other"] selected [/#if]>其它</option>
				[/#if]
			</select>
		</div>
	</div>
	<div class="layui-form-item" id="virtualNumericalDiv" style="display: [#if prize.prizeType =="VIRTUAL" && prize.prizeSeedType!="TICKETCODE"] block [#else] none [/#if];">
		<label class="layui-form-label">虚拟数值</label>
		<div class="layui-input-block">
			<input type="text" name="virtualNumerical" value="${prize.virtualNumerical}" placeholder="请输入虚拟数值" autocomplete="off" class="layui-input" [#if prize.prizeType =="VIRTUAL" && prize.prizeSeedType!="TICKETCODE"] lay-verify="number" [#else] disabled="disabled" [/#if]/>
		</div>
	</div>
	<div class="layui-form-item">
		<label class="layui-form-label">奖品等级</label>
		<div class="layui-input-block">
			<select name="grade">
				<option value="1" [#if prize.grade == "1"] selected [/#if]>一等奖</option>
				<option value="2" [#if prize.grade == "2"] selected [/#if]>二等奖</option>
				<option value="3" [#if prize.grade == "3"] selected [/#if]>三等奖</option>
				<option value="4" [#if prize.grade == "4"] selected [/#if]>四等奖</option>
				<option value="5" [#if prize.grade == "5"] selected [/#if]>五等奖</option>
				<option value="6" [#if prize.grade == "6"] selected [/#if]>六等奖</option>
			</select>
		</div>
	</div>
	<div class="layui-form-item">
		<label class="layui-form-label">缩略图</label>
		<div class="layui-upload layui-input-block">
			<button type="button" class="layui-btn" id="test1">上传图片</button>
			<div class="layui-upload-list">
				<img class="layui-upload-img" style="width:100px;" src="${prize.breviaryPicture}">
				<input type="hidden" name="breviaryPicture" value="${prize.breviaryPicture}" lay-verify="breviaryPicture"/>
			</div>
		</div>
	</div>
	<div class="layui-form-item">
		<label class="layui-form-label">中奖展示图</label>
		<div class="layui-upload layui-input-block">
			<button type="button" class="layui-btn" id="test2">上传图片</button>
			<div class="layui-upload-list">
				<img class="layui-upload-img" style="width:100px;" src="${prize.winPrizePicture}">
				<input type="hidden" name="winPrizePicture" value="${prize.winPrizePicture}" lay-verify="winPrizePicture"/>
			</div>
		</div>
	</div>
	<div class="layui-form-item">
		<div class="layui-input-block">
			<button class="layui-btn" lay-submit lay-filter="btn_form_submit">立即提交</button>
			<button type="button" onclick="javascript:history.back();">返回</button>
		</div>
	</div>
	<input type="hidden" name="id" value="${prize.id}"/>
</form>
<div id="shifuDiv" style="display: none">
	<option value="electronics">电子产品</option>
	<option value="mobilecommunication">移动通信</option>
	<option value="beautymakeup">美妆</option>
	<option value="toy">玩具</option>
	<option value="sportequipment">体育器材</option>
	<option value="other">其它</option>
</div>
<div id="xuniDiv" style="display: none">
	<option value="POINT">积分</option>
	<option value="MONEY">金额</option>
	<option value="TELEPHONECHARGE">话费</option>
	<option value="SUNINGTONGBAN">苏宁铜板</option>
	<option value="TICKETCODE">券码</option>
</div>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script src="${base}/resources/layui/layui.js"></script>
<script type="text/javascript">
	layui.use(['form','element','upload'], function(){

		let upload = layui.upload;
		let form = layui.form;
		//监听提交
		form.on('submit(btn_form_submit)', function (data) {
			return true;
		});

		form.verify({
			breviaryPicture: function(value, item){
				if(value==""){
					return "请上传缩略图";
				}
			},
			winPrizePicture: function (value, item) {
				if(value==""){
					return "请上传中奖展示图";
				}
			}
		});
		form.on('select(prizeType)', function(data){
			if(data.value=="MATERIAL"){
				$("#virtualNumericalDiv").attr("style","display:none;");
				$('input[name="virtualNumerical"]').attr("disabled","disabled");
				$('input[name="virtualNumerical"]').removeAttr("lay-verify");
				$('select[name="prizeSeedType"]').html($("#shifuDiv").html());
			}else{
				$("#virtualNumericalDiv").attr("style","display:block;");
				$('input[name="virtualNumerical"]').removeAttr("disabled");
				$('input[name="virtualNumerical"]').attr("lay-verify","number");
				$('select[name="prizeSeedType"]').html($("#xuniDiv").html());
			}
			form.render();
		});

		form.on('select(prizeSeedType)', function(data){
			let prizeType = $('select[name="prizeType"]').val();
			if(prizeType=="VIRTUAL") {
				if (data.value == "TICKETCODE") {
					$("#virtualNumericalDiv").attr("style", "display:none;");
					$('input[name="virtualNumerical"]').attr("disabled", "disabled");
					$('input[name="virtualNumerical"]').removeAttr("lay-verify");
				} else {
					$("#virtualNumericalDiv").attr("style", "display:block;");
					$('input[name="virtualNumerical"]').removeAttr("disabled");
					$('input[name="virtualNumerical"]').attr("lay-verify", "number");
				}
			}
			form.render();
		});

		//缩略图上传
		var uploadInst_front = upload.render({
			elem: '#test1',
			url: '${base}/common/upload',
			before: function(obj){
				//预读本地文件示例，不支持ie8
				obj.preview(function(index, file, result){
					$('input[name="breviaryPicture"]').prev().attr('src', result); //图片链接（base64）
				});
			},done: function(res){
				//如果上传失败
				if(res.code > 0){
					return layer.msg('上传失败');
				}
				//上传成功
				$('input[name="breviaryPicture"]').val(res.data.src);
			},error: function(){
				//演示失败状态，并实现重传
				var demoText = $('input[name="breviaryPicture"]').parent();
				demoText.html('<span style="color: #FF5722;">上传失败</span> <a class="layui-btn layui-btn-xs demo-reload">重试</a>');
				demoText.find('.demo-reload').on('click', function(){
					uploadInst_front.upload();
				});
			}
		});

		//中奖图片上传
		var uploadInst_reverse = upload.render({
			elem: '#test2',
			url: '${base}/common/upload',
			before: function(obj){
				//预读本地文件示例，不支持ie8
				obj.preview(function(index, file, result){
					$('input[name="winPrizePicture"]').prev().attr('src', result); //图片链接（base64）
				});
			},done: function(res){
				//如果上传失败
				if(res.code > 0){
					return layer.msg('上传失败');
				}
				//上传成功
				$('input[name="winPrizePicture"]').val(res.data.src);
			},error: function(){
				//演示失败状态，并实现重传
				var demoText = $('input[name="winPrizePicture"]').parent();
				demoText.html('<span style="color: #FF5722;">上传失败</span> <a class="layui-btn layui-btn-xs demo-reload">重试</a>');
				demoText.find('.demo-reload').on('click', function(){
					uploadInst_reverse.upload();
				});
			}
		});
	});
</script>
</body>
</html>