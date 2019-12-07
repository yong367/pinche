<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="author" content="技术部">
    <meta name="copyright" content="SHOP">
    <title>爱帮伴-重新申请 </title>
    <link href="${base}/favicon.ico" rel="icon">
    <link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
    <link href="${base}/resources/business/css/bootstrap-select.css" rel="stylesheet">
    <link href="${base}/resources/business/css/bootstrap-fileinput.css" rel="stylesheet">
    <link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
    <link href="${base}/resources/business/css/animate.css" rel="stylesheet">
    <link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
    <link href="${base}/resources/business/css/common.css" rel="stylesheet">
    <link href="${base}/resources/js/My97DatePicker/skin/WdatePicker.css"  rel="stylesheet">
    <link href="${base}/newResources/business/css/popWindow.css" rel="stylesheet">

    <script src="${base}/resources/business/js/jquery.js"></script>
    <script src="${base}/resources/business/js/bootstrap.js"></script>
    <script src="${base}/resources/business/js/bootstrap-select.js"></script>
    <script src="${base}/resources/business/js/bootstrap-checkbox-x.js"></script>
    <script src="${base}/resources/business/js/bootstrap-fileinput.js"></script>
    <script src="${base}/resources/business/js/velocity.js"></script>
    <script src="${base}/resources/business/js/velocity.ui.js"></script>
    <script src="${base}/resources/business/js/summernote.js"></script>
    <script src="${base}/resources/business/js/sortable.js"></script>
    <script src="${base}/resources/business/js/jquery.validate.js"></script>
    <script src="${base}/resources/business/js/icheck.js"></script>
    <script src="${base}/resources/member/js/jquery.lSelect.js"></script>
    <script src="${base}/resources/business/js/underscore.js"></script>
    <script src="${base}/resources/business/js/adminLTE.js"></script>
    <script src="${base}/resources/business/js/common.js"></script>
    <script src="${base}/resources/business/js/moment.js"></script>
    <script src="${base}/resources/js/My97DatePicker/WdatePicker.js"></script>
    <script src="http://api.map.baidu.com/api?v=2.0&ak=0XCHq5yKzScu7AelWGRjnlq0eQnjqmZE"></script>
    <style>
        .pageClass{
            margin-bottom: 24px;
        }
        .lableFontSize{
            font-size: 14px;
        }
        .titleClass{
            background-color: #52BEED;
            width: 100%;
            height: 40px;
            font-family: Arial;
            color: white;
            font-size: 20px;
            padding-left:20px;
            padding-top:7px
        }
        .lableFontWeight{
            font-weight:bold;
        }
        /*body, html {width: 100%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";}*/
        #l-map{height:300px;width:500px;}
        #r-result{width:100%;}
    </style>
    <script type="text/javascript">
        $().ready(function() {
            var $areaId = $("#areaId");

            var $mainHeaderNav = $("header.main-header a").not("a.logout");
            var $mainSidebarNav = $("aside.main-sidebar a, aside.main-sidebar button");
            var $storeForm = $("#storeForm");
            var $storeRank = $("select[name='storeRankId']");
            var $storeRankQuantityDefault = $storeRank.find(":selected").data("store-rank-quantity");
            var $storeRankServiceFeeDefault = $storeRank.find(":selected").data("store-rank-service-fee");
            var $storeRankQuantity = $("#storeRankQuantity");
            var $storeRankServiceFee = $("#storeRankServiceFee");
            var $storeCategory = $("select[name='storeCategoryId']");
            var $storeCategoryBail = $("#storeCategoryBail");
            var $storeCategoryBailDefault = $storeCategory.find(":selected").data("store-category-bail");
            var $submit = $("#submitButton");

            // 地区选择
            $areaId.lSelect({
                url: "${base}/common/area"
            });

            // 主顶部导航
            $mainHeaderNav.click(function() {
                return false;
            });

            // 主侧边导航
            $mainSidebarNav.click(function() {
                return false;
            });

            // 店铺等级
           $storeRankQuantity.velocity("fadeIn").text($storeRankQuantityDefault);
            $storeRankServiceFee.velocity("fadeIn").html('<span style="color: black">您需支付</span>'+currency($storeRankServiceFeeDefault, false)+'<span style="color: black">元/年的服务费</span>');
            $storeRank.change(function() {
                var $element = $(this);
                var storeRankQuantity = $element.find(":selected").data("store-rank-quantity");
                var storeRankServiceFee = $element.find(":selected").data("store-rank-service-fee");
                $storeRankQuantity.velocity("fadeIn").text(storeRankQuantity);
                $storeRankServiceFee.velocity("fadeIn").html('<span style="color: black">您需支付</span>'+currency($storeRankServiceFeeDefault, false)+'<span style="color: black">元/年的服务费<span>');
            });

            // 店铺分类
            $storeCategoryBail.velocity("fadeIn").html('<span style="color: black">您需支付</span>'+currency($storeCategoryBailDefault, false)+'<span style="color: black">的保证金</span>');
            $storeCategory.change(function() {
                var $element = $(this);
                var storeCategoryBail = $element.find(":selected").data("store-category-bail");
                $storeCategoryBail.velocity("fadeIn").html('<span style="color: black">您需支付</span>'+ currency($storeCategoryBailDefault, false) +'<span style="color: black">的保证金</span>');
            });

            //百度地图
            var map = new BMap.Map("l-map");
            var point = new BMap.Point(116.331398,39.897445);
            map.centerAndZoom(point,11);
            map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
            map.enableContinuousZoom(true); //启用地图惯性拖拽
            // 百度地图API功能
            function G(id) {
                return document.getElementById(id);
            }

            var map = new BMap.Map("l-map");
            map.centerAndZoom("北京",12);                   // 初始化地图,设置城市和地图级别。

            var ac = new BMap.Autocomplete(    //建立一个自动完成的对象
                    {"input" : "suggestId"
                        ,"location" : map
                    });

            ac.addEventListener("onhighlight", function(e) {  //鼠标放在下拉列表上的事件
                var str = "";
                var _value = e.fromitem.value;
                var value = "";
                if (e.fromitem.index > -1) {
                    value = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;
                }
                str = "FromItem<br />index = " + e.fromitem.index + "<br />value = " + value;

                value = "";
                if (e.toitem.index > -1) {
                    _value = e.toitem.value;
                    value = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;
                }
                str += "<br />ToItem<br />index = " + e.toitem.index + "<br />value = " + value;
                G("searchResultPanel").innerHTML = str;
            });

            var myValue;
            ac.addEventListener("onconfirm", function(e) {    //鼠标点击下拉列表后的事件
                var _value = e.item.value;
                myValue = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;
                G("searchResultPanel").innerHTML ="onconfirm<br />index = " + e.item.index + "<br />myValue = " + myValue;

                setPlace();
            });


            function setPlace(){
                map.clearOverlays();    //清除地图上所有覆盖物
                function myFun(){
                    var pp = local.getResults().getPoi(0).point;    //获取第一个智能搜索的结果
                    map.centerAndZoom(pp, 18);
                    map.addOverlay(new BMap.Marker(pp));    //添加标注
                }
                var local = new BMap.LocalSearch(map, { //智能搜索
                    onSearchComplete: myFun
                });
                local.search(myValue);
            }
            // 添加单击事件
            map.addEventListener("click",function(e){
                map.clearOverlays();//清空原来的标注
                document.getElementById("longitude").value = e.point.lng;
                document.getElementById("latitude").value = e.point.lat;
                var marker = new BMap.Marker(new BMap.Point(e.point.lng, e.point.lat));  // 创建标注，为要查询的地方对应的经纬度
                map.addOverlay(marker);
            });



            // 表单验证
            $storeForm.validate({
                rules: {
                    storeRankId: "required",
                    name: {
                        remote: {
                            url: "${base}/business/store/check_name",
                            cache: false
                        }
                    },
                    storeManagerPhone: {
                        pattern: /^1[3|4|5|6|7|8|9]\d{9}$/
                    }

				[@business_attribute_list]
                    [#list businessAttributes as businessAttribute]
                        [#if businessAttribute.isRequired || businessAttribute.pattern?has_content]
							,businessAttribute_${businessAttribute.id}: {
								[#if businessAttribute.isRequired]
									required: true
                                    [#if businessAttribute.pattern?has_content],[/#if]
                                [/#if]
								[#if businessAttribute.pattern?has_content]
									pattern: /${businessAttribute.pattern}/
                                [/#if]
                            }
                        [/#if]
                    [/#list]
                [/@business_attribute_list]
                },
                messages: {
                    name: {
                        remote: "${message("common.validate.exist")}"
                    },
                    storeManagerPhone: {
                        pattern: "${message("common.validate.pattern")}"
                    }
                },
                submitHandler: function(form) {
                    $.ajax({
                        url: $storeForm.attr("action"),
                        type: "POST",
                        data: $storeForm.serializeArray(),
                        dataType: "json",
                        cache: false,
                        success: function() {
                            setTimeout(function() {
                                $submit.prop("disabled", false);
                                location.href = "${base}/business/index";
                            }, 2000);
                        }
                    });
                }
            });
        });

        function selectType(obj) {
            //如果选择商家
            var type="";
            if(obj == 'merchant') {
                type='merchant';
                $("#merchant").css('border','1px solid #52BEED');
                $("#channel").css('border','');
            }
            //如果选择渠道
            if(obj == 'channel') {
                type='channel';
                $("#channel").css('border','1px solid #52BEED');
                $("#merchant").css('border','');
            }
            $("#chooseIdEntityInformation").val(type);
            $("#nextButton").removeAttr('disabled');
            $("#nextButton").css('background-color','#52BEED');
        }
        function next() {
            $("#poPup").hide();
            $("#poPupTwo").show();
        }
        function selectIdEntity(obj) {
            var type="";
            if(obj == 'company'){
                //如果是 企业 就显示
                $(".company").show();
                $(".person").hide();
                type="company";
                $("#company").css('border','1px solid #52BEED');
                $("#person").css('border','');
            }
            if(obj == 'person'){
                $(".company").hide();
                $(".person").show();
                type="person";
                $("#person").css('border','1px solid #52BEED');
                $("#company").css('border','');
            }
            $("#chooseCompanyOrPerson").val(type);
            $("#confirmButton").removeAttr('disabled');
            $("#confirmButton").css('background-color','#52BEED');
        }
        function queding(){
            $("#poPupTwo").hide();
            $("#show").hide();
        }
        function longTimeFlag(obj) {
            if ($(obj).is(':checked')) {
                $("#longTime").val("true");
                $("#datetimeStart").val("");
                $("#datetimeEnd").val("")
            }
        }
        function uploadLicenseImage() {
            $("#uploadLicenseImage").css('z-index','-1');
        }
        function uploadLogo() {
            $("#uploadLogo").css('z-index','-1');
        }
        function uploadReverseIdCardImage() {
            $("#uploadReverseIdCardImage").css('z-index','-1');
        }
        function uploadIdCardImage() {
            $("#uploadIdCardImage").css('z-index','-1');
        }

        function tijiao() {
            var result = validateForm();
            if (result == 'true') {
                $("#storeForm").submit();
            } else {
                $.alert(result);
                $("#submitButton").removeAttr("disabled");
            }
        }
        function validateForm(){
            var chooseCompanyOrPerson= $("#chooseCompanyOrPerson").val();
            checkVal('name',"店铺名称不能为空");
            checkVal('introduction',"店铺简介不能为空");
            checkVal('phone',"店铺电话不能为空");
            checkVal('logo',"店铺logo不能为空");
            checkVal('storeManager',"店铺负责人不能为空");
            checkVal('storeManagerPhone',"负责人电话不能为空");
            checkVal('areaId',"店铺地址不能为空");
            checkVal('detailAddress',"详细地址不能为空");
            checkVal('businessHours',"营业时间不能为空");
            checkVal('keyword',"店铺关键词不能为空");
            //如果是企业
            if (chooseCompanyOrPerson == 'company'){
                checkVal('companyName',"企业名称不能为空");
                checkVal('organizationCode',"统一信用社会代码不能为空");
                checkVal('legalPerson',"法人姓名不能为空");
                checkVal('datetimeStart',"任务开始时间不能为空");
                checkVal('datetimeEnd',"任务结束时间不能为空");
                checkVal('licenseImage',"营业执照图片不能为空");
            }
            //如果是个人
            if (chooseCompanyOrPerson == 'person'){
                checkVal('storeName',"店主姓名不能为空");
                checkVal('idCard',"身份证号不能为空");
                checkVal('IdCardTimeStart',"身份证开始时间不能为空");
                checkVal('IdCardTimeEnd',"身份证结束时间不能为空");
                checkVal('idCardImage',"身份证正面照片不能为空");
                checkVal('reverseIdCardImage',"身份证反面照片不能为空");
            }
            return "true";
        }
        function checkVal(id,msg) {
            var val = $("#" + id).val();
            if ($.trim(val) == '') {
                alert(msg);
                throw new SyntaxError();
            }
        }


    </script>

</head>
<body class="hold-transition sidebar-mini">
<div id="show" style="position:fixed;top: 0;left: 0; width: 100%;height: 100%;background:black;opacity:0.3;z-index: 998;"></div>
<div class="wrapper">
		[#include "/business/include/main_header.ftl" /]
		[#include "/business/include/main_sidebar.ftl" /]

    <div class="content-wrapper">
        <div class="container-fluid">
            <section class="content-header">
                <h1>${message("business.store.register")}</h1>
            </section>
            <section class="content">
                <div class="row">

                    <div class="col-xs-12">
                        <form id="storeForm" class="form-horizontal" action="${base}/business/store/reapply" method="post">
                            <input type="hidden" id="chooseIdEntityInformation" name="business.chooseIdEntityInformation">
                            <input type="hidden" id="chooseCompanyOrPerson" name="business.chooseCompanyOrPerson">
                            <input type="hidden" id="longitude" name="longitude" >
                            <input type="hidden" id="latitude" name="latitude"  >
                            <div class="box">
                                <div class="tab-content">
                                    <div id="edit" class="tab-pane active">
                                        <div class="pageClass lableFontSize titleClass">
                                            店铺信息
                                        </div>
                                        <div class="form-group pageClass lableFontSize">
                                            <label class="col-xs-2 control-label lableFontWeight">店铺名称：</label>
                                            <div class="col-xs-4">
                                                <input type="text" id="name" name="name" class="form-control" maxlength="15" placeholder="&nbsp;请输入店铺名称，最多可输入15个字">
                                            </div>
                                        </div>
                                        <div class="form-group pageClass lableFontSize">
                                            <label class="col-xs-2 control-label lableFontWeight">店铺简介：</label>
                                            <div class="col-xs-4">
                                                <textarea id="introduction" name="introduction" class="form-control" rows="5" style="resize:none" maxlength="100" placeholder="请输入任务简介，最多可输入100个字"></textarea>
                                            </div>
                                        </div>
                                        <div class="form-group pageClass lableFontSize">
                                            <label class="col-xs-2 control-label lableFontWeight">店铺电话：</label>
                                            <div class="col-xs-4">
                                                <input type="text" id="phone" name="phone" class="form-control" placeholder="&nbsp;请输入店铺电话">
                                            </div>
                                        </div>
                                        <div class="form-group[#if !storeRanks??] hidden-element[/#if] pageClass lableFontSize">
                                            <label class="col-xs-2 control-label lableFontWeight">店铺等级：</label>
                                                <div class="col-xs-4">
                                                    <select  name="storeRankId" class="selectpicker form-control" data-size="5">
															[#list storeRanks as storeRank]
																[#if storeRank.isAllowRegister]
																	<option value="${storeRank.id}" data-store-rank-quantity="${(storeRank.quantity)!'${message("business.store.infiniteQuantity")}'}" data-store-rank-service-fee="${storeRank.serviceFee}">${storeRank.name}</option>
                                                                [/#if]
                                                            [/#list]
                                                    </select>
                                                    <p id="storeRankServiceFee" class="form-control-static text-red" style="display: inline"></p>
                                                </div>
                                        </div>
                                        <div class="form-group pageClass lableFontSize">
                                            <label class="col-xs-2 control-label  lableFontWeight" >店铺logo：</label>
                                            <div class="col-xs-4" onchange="uploadLogo()">
                                                <input id="logo" name="logo" type="hidden" data-provide="fileinput" data-file-type="image" >
                                                <span id="uploadLogo"  style="position: absolute;left: 8%;color: #cccccc; top: 5px;z-index: 990">请上传店铺Logo照片</span>
                                            </div>
                                        </div>
                                        <div class="form-group[#if !storeCategories??] hidden-element[/#if] pageClass lableFontSize">
                                            <label class="col-xs-2 control-label lableFontWeight">店铺分类：</label>
                                            <div class="col-xs-4">
                                                <select name="storeCategoryId" class="selectpicker form-control" data-live-search="true" data-size="10">
															[#list storeCategories as storeCategory]
                                                                <option value="${storeCategory.id}" data-store-category-bail="${storeCategory.bail}"[#if storeCategory.isDefault] selected[/#if]>${storeCategory.name}</option>
                                                            [/#list]
                                                </select>
                                                <p id="storeCategoryBail" class="form-control-static text-blue" style="display: inline"></p>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-xs-2 control-label lableFontWeight">${message("Store.productCategories")}:</label>
                                            <div class="col-xs-4">
                                                <select name="productCategoryIds" class="selectpicker form-control" data-live-search="true" data-size="10" data-none-selected-text="${message("business.common.choose")}" multiple>
															[#list productCategoryTree as productCategory]
                                                                <option name="${productCategory.generalRate}" class="${productCategory.selfRate}" value="${productCategory.id}" title="${productCategory.name}">
																	[#if productCategory.grade != 0]
                                                                        [#list 1..productCategory.grade as i]
																			&nbsp;&nbsp;
                                                                        [/#list]
                                                                    [/#if]
                                                                    ${productCategory.name}
                                                                </option>
                                                            [/#list]
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group pageClass lableFontSize">
                                            <label class="col-xs-2 control-label lableFontWeight">店铺负责人：</label>
                                            <div class="col-xs-4">
                                                <input type="text" id="storeManager" name="storeManager" class="form-control" placeholder="&nbsp;请输入店铺负责人姓名">
                                            </div>
                                        </div>
                                        <div class="form-group pageClass lableFontSize">
                                            <label class="col-xs-2 control-label lableFontWeight">负责人电话：</label>
                                            <div class="col-xs-4">
                                                <input type="text" id="storeManagerPhone" name="storeManagerPhone" class="form-control" placeholder="&nbsp;请输入负责人电话">
                                            </div>
                                        </div>
                                        <div class="form-group pageClass lableFontSize">
                                            <label class="col-xs-2 control-label lableFontWeight">店铺地址：</label>
                                            <div class="col-xs-6">
                                                    <input type="hidden" id="areaId" name="areaId" value="${(receiver.area.id)!}" treePath="${(receiver.area.treePath)!}" />
                                            </div>
                                        </div>
                                        <div class="form-group pageClass lableFontSize">
                                            <label class="col-xs-2 control-label lableFontWeight">经纬度：</label>
                                            <div id="l-map"></div>
                                            <div id="searchResultPanel" style="border:1px solid #C0C0C0;width:150px;height:auto; display:none;"></div>
                                            <div id="r-result" style="margin-left: 270px">请输入地址:<input type="text" id="suggestId" size="20" value="百度" style="width:150px;"></div>

                                        </div>
                                        <div class="form-group pageClass lableFontSize">
                                            <label class="col-xs-2 control-label lableFontWeight">详细地址：</label>
                                            <div class="col-xs-4">
                                                <input type="text" id="detailAddress" name="detailAddress" class="form-control" placeholder="&nbsp;请输入详细地址">
                                            </div>
                                        </div>
                                        <div class="form-group pageClass lableFontSize">
                                            <label class="col-xs-2 control-label lableFontWeight">营业时间：</label>
                                            <div class="col-xs-4">
                                                <input type="text" id="businessHours" name="businessHours" class="form-control" placeholder="&nbsp;请输入营业时间">
                                            </div>
                                        </div>
                                        <div class="form-group pageClass lableFontSize">
                                            <label class="col-xs-2 control-label lableFontWeight">店铺关键词：</label>
                                            <div class="col-xs-4">
                                                <input type="text" id="keyword" name="keyword" class="form-control" maxlength="10" placeholder="&nbsp;用空格隔开关键词，最多可填写10个关键词">
                                            </div>
                                        </div>
                                        <div class="company" style="display: block">
                                            [#--企业--]
                                            <div class="pageClass lableFontSize titleClass">
                                                营业执照信息
                                            </div>
                                            <div class="form-group pageClass lableFontSize">
                                                <label class="col-xs-2 control-label lableFontWeight">企业名称：</label>
                                                <div class="col-xs-4">
                                                    <input type="text" id="companyName" name="business.companyName" class="form-control" placeholder="&nbsp;填写内容必须与证件内容保持一致">
                                                </div>
                                            </div>
                                            <div class="form-group pageClass lableFontSize">
                                                <label class="col-xs-2 control-label lableFontWeight">社会信用代码：</label>
                                                <div class="col-xs-4">
                                                    <input type="text" id="organizationCode" name="business.organizationCode" class="form-control" placeholder="&nbsp;填写内容必须与证件内容保持一致">
                                                </div>
                                            </div>
                                            <div class="form-group pageClass lableFontSize">
                                                <label class="col-xs-2 control-label lableFontWeight">法人姓名：</label>
                                                <div class="col-xs-4">
                                                    <input type="text" id="legalPerson" name="business.legalPerson" class="form-control" placeholder="&nbsp;填写内容必须与证件内容保持一致">
                                                </div>
                                            </div>
                                            <div class="form-group pageClass lableFontSize">
                                                <label class="col-xs-2 control-label lableFontWeight">营业期限：</label>
                                                <div class="col-xs-5">
                                                    <input id="datetimeStart" style="width: 40%;height:31px;display: inline;background-color: white" name="business.startDate" readonly class="form-control Wdate"  onclick="WdatePicker({  maxDate:'#F{$dp.$D(\'datetimeEnd\')}' })"  type="text" placeholder="开始时间">
                                                    &nbsp;&nbsp;~&nbsp;&nbsp;
                                                    <input id="datetimeEnd" style="width: 40%;height:31px;display: inline;background-color: white" name="business.endDate" readonly class="form-control Wdate"  onclick="WdatePicker({ minDate:'#F{$dp.$D(\'datetimeStart\')}' })" type="text" placeholder="结束时间">
                                                    <input type="radio" id="longTime" name="business.longTime" value="false" onclick="longTimeFlag(this)">&nbsp;&nbsp;长期
                                                </div>
                                            </div>
                                            <div class="form-group pageClass lableFontSize">
                                                <label class="col-xs-2 control-label control-label lableFontWeight" >上传营业执照图片：</label>
                                                <div class="col-xs-4" onchange="uploadLicenseImage()">
                                                    <input id="licenseImage" name="business.licenseImage"  type="hidden" data-provide="fileinput" data-file-type="image" >
                                                <span id="uploadLicenseImage"  style="position: absolute;left: 8%;color: #cccccc; top: 5px;z-index: 1000">请上传营业执照照片</span>
                                                </div>
                                            </div>
                                        </div>
                                        [#--个人--]
                                        <div class="person" style="display: block">
                                            <div class="pageClass lableFontSize titleClass">
                                                店主身份信息
                                            </div>
                                            <div class="form-group pageClass lableFontSize">
                                                <label class="col-xs-2 control-label lableFontWeight">店主姓名：</label>
                                                <div class="col-xs-4">
                                                    <input type="text" id="storeName" name="business.storeName" class="form-control" placeholder="&nbsp;填写内容必须与证件内容保持一致">
                                                </div>
                                            </div>
                                            <div class="form-group pageClass lableFontSize">
                                                <label class="col-xs-2 control-label lableFontWeight">身份证号</label>
                                                <div class="col-xs-4">
                                                    <input type="text" id="idCard" name="business.idCard" class="form-control" placeholder="&nbsp;填写内容必须与证件内容保持一致">
                                                </div>
                                            </div>
                                            <div class="form-group pageClass lableFontSize">
                                                <label class="col-xs-2 control-label lableFontWeight">身份证有效期限：</label>
                                                <div class="col-xs-4">
                                                    <input id="IdCardTimeStart" style="width: 40%;height:31px;display: inline;background-color: white" name="business.idCardStartDate" readonly class="form-control Wdate"  onclick="WdatePicker({  maxDate:'#F{$dp.$D(\'IdCardTimeEnd\')}' })"  type="text" placeholder="开始时间">
                                                    &nbsp;&nbsp;~&nbsp;&nbsp;
                                                    <input id="IdCardTimeEnd" style="width: 40%;height:31px;display: inline;background-color: white" name="business.idCardEndDate" readonly class="form-control Wdate"  onclick="WdatePicker({ minDate:'#F{$dp.$D(\'IdCardTimeStart\') }' })" type="text" placeholder="结束时间">
                                                </div>
                                            </div>
                                            <div class="form-group pageClass lableFontSize">
                                                <label class="col-xs-2 control-label control-label lableFontWeight" >上传身份照片：</label>
                                                <div class="col-xs-2"  onchange="uploadIdCardImage()">
                                                    <input id="idCardImage" name="business.idCardImage" type="hidden" style="display: inline" data-provide="fileinput" data-file-type="image" placeholder="身份证正面照片">
                                                    <span id="uploadIdCardImage"  style="position: absolute;left: 8%;color: #cccccc; top: 5px;z-index: 1000">请上传身份证正面照片</span>
                                                </div>
                                                <div class="col-xs-2" onchange="uploadReverseIdCardImage()">
                                                    <input id="reverseIdCardImage" name="business.reverseIdCardImage" type="hidden" style="display: inline" data-provide="fileinput" data-file-type="image" placeholder="身份证反面照片">
                                                    <span id="uploadReverseIdCardImage"  style="position: absolute;left: 8%;color: #cccccc; top: 5px;z-index: 1000">请上传身份证反面照片</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="box-footer">
                                            <div class="row">
                                                <div class="col-xs-4 col-xs-offset-2">
                                                    <button class="btn btn-primary" type="button" id="submitButton" onclick="tijiao()">${message("business.store.submit")}</button>
                                                    <button class="btn btn-default" type="button" data-toggle="back">${message("business.common.back")}</button>
                                                </div>
                                            </div>
                                        </div>
                            </form>
                    </div>
                </div>
            </section>
        </div>
    </div>
		[#include "/business/include/main_footer.ftl" /]
</div>
<div id="poPup" style="z-index: 1000">
    <div class="title" ><span style="padding-left: 20px;">选择您的商户种类</span></div>
    <div class="oDiv" >
        <div id="merchant" class="poPupDiv" tabindex="0" onclick="selectType('merchant')">
            <img src="/newResources/business/images/firstPageImg/u418.png" alt="">
            <p class="oPtwo" >我是商家</p>
        </div>
        <div id="channel" class="poPupDiv" tabindex="0" onclick="selectType('channel')">
            <img src="/newResources/business/images/firstPageImg/u421.png" alt="">
            <p class="oPtwo" >我是渠道</p>
        </div>
    </div>
    <div class="footerDiv"><input  id="nextButton" type="button" style="background-color: #cccccc" class="next" disabled value="下一步" onclick="next()"></div>
</div>

<div id="poPupTwo" style="display: none;z-index: 999">
    <div class="title"><span>选择您的商户规模</span></div>
    <div class="oDiv">
        <div id="company" class="poPupDiv" tabindex="0" onclick="selectIdEntity('company')">
            <img src="/newResources/business/images/firstPageImg/u427.png" alt="">
            <p class="oPtwo" >我是企业</p>
        </div>
        <div id="person" class="poPupDiv" tabindex="0" onclick="selectIdEntity('person')">
            <img src="/newResources/business/images/firstPageImg/u430.png" alt="">
            <p class="oPtwo" >我是个人</p>
        </div>
    </div>
    <div class="footerDiv"><input class="over" disabled style="background-color: #cccccc" type="button" value="确认" id="confirmButton" onclick="queding()"></div>
</div>

</body>
</html>