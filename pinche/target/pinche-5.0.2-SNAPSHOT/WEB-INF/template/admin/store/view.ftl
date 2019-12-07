<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.store.view")} </title>
<meta name="author" content="技术部" />
<meta name="copyright" content="SHOP" />
<link href="${base}/resources/admin/css/selectmultiple.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="${base}/newResources/admin/css/toExamine.css">
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.selectmultiple.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script src="http://api.map.baidu.com/api?v=2.0&ak=0XCHq5yKzScu7AelWGRjnlq0eQnjqmZE"></script>
    <style type="text/css">
        #allmap{height:1500px;width:500px;}
        #r-result{width:100%}
    </style>
<script type="text/javascript">
function pass() {
    window.location.href = "${base}/admin/store/review?id=" + ${store.id} +"&status=pass";
}
function fail() {
    window.location.href = "${base}/admin/store/review?id=" + ${store.id} +"&status=fail"
}
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/common/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.store.view")}
	</div>
    <div id="box">
        <div id="boxHead">
            <div id="boxHeadLogo">
                <img src="${store.logo}" alt="" style="width: 80px;height: 80px;">
            </div>
            <div id="boxHeadText">
                <p id="textTop"><span id="dy">${store.name}</span>
                    <span id="open" style="margin-left:15px; ">启用</span>
                    [#if store.status == "pending"]
                        <button style="margin-left:690px;color:green;" onclick="pass()">✔通过</button>
                        <button style="color:red;" onclick="fail()">✖未通过</button>
                    [/#if]
                    <input style="color: #488BD1;float: right;width:40px; height: 30px;text-align: center;background: white;"type="button " class="button" value="↺${message("admin.common.back")}" onclick="history.back(); return false;" />
                </p>
                <p id="textBottom">
                    <span class="s" style="margin-left: 0px;">商家：&nbsp;<span>${store.business.username}</span></span>
                    <span class="s">状态：&nbsp;<span style="color: #FF5555;">[#if store.status == 'pending']等待审核
                        [#elseif store.status == 'failed']失败
                        [#elseif store.status == 'approved']审核通过
                        [#elseif store.status == 'success']开店成功[/#if]
                    </span></span>
                    <span class="s">创建日期：&nbsp;<span>${store.createdDate}</span></span>
                    <span class="s">到期日期：&nbsp;<span>${store.endDate}</span></span>
                </p>
            </div>
        </div>
        <div id="boxText">
            <div id="oDiv1" style="float: left;">
                <div><span>店铺种类：</span></div>
                <div><span>店铺负责人：</span></div>
                <div><span>店铺等级：</span></div>
                <div><span>店铺电话：</span></div>
                <div><span>营业时间：</span></div>
                <div><span>店铺地址：</span></div>
                <div><span>详细地址：</span></div>
            </div>
            <div id="oDiv2" style="float: left;">
                <div><span>
                    [#if store.business.chooseIdEntityInformation == 'merchant']商家
                    [#elseif store.business.chooseIdEntityInformation=='channel']渠道[/#if]
                    </span></div>
                <div><span>${store.storeManager}</span></div>
                <div><span>${store.storeRank.name}</span></div>
                <div><span>${store.phone}</span></div>
                <div><span>${store.businessHours}</span></div>
                <div><span>${store.area.name}</span></div>
                <div><span>${store.detailAddress}</span></div>

            </div>
            <div id="oDiv3" style="float: left;">
                <div><span>店铺规模：</span></div>
                <div><span>负责人电话：</span></div>
                <div><span>店铺分类：</span></div>
                <div><span>店铺关键词：</span></div>
                <div style="height: 124px;line-height: 124px;">
                    <span>店铺简介：</span>
                </div>
            </div>
            <div id="oDiv4" style="float: left;">
                <div><span>
                    [#if store.business.chooseCompanyOrPerson == 'company']企业
                    [#elseif store.business.chooseCompanyOrPerson=='person']个人[/#if]
                </span></div>
                <div><span>${store.storeManagerPhone}</span></div>
                <div><span>${store.storeCategory.name}</span></div>
                <div><span>${store.keyword}</span></div>
                <div style="height: 124px;line-height: 124px;">
                    <span>${store.introduction}</span>
                </div>
            </div>
        </div>
        <div style="width: 1240px;height: 300px;" id="mapBox">
            <div style="float: left;width: 150px;height:300px;line-height: 300px;text-align:right;background: #F1F8FF;"><span style="font-size:14px;color: #25267D">位置信息：</span></div>
             [#if store.longitude != null && store.latitude != null]
                <div id="allmap" style="width: 500px; height: 300px;float: left;"></div>
                    <div id="r-result">
                        <input id="longitude" type="hidden" style="width:100px; margin-right:10px;" value="${store.longitude}"/>
                        <input id="latitude" type="hidden" style="width:100px; margin-right:10px;" value="${store.latitude}"/>
                        <input type="button" value="定位" onclick="theLocation()" style="width: 55px;height: 25px;margin-top:271px;margin-left: 24px;" />
                    </div>
             [/#if]
        </div>

        [#if store.business.chooseCompanyOrPerson == 'company']
        <div id="boxFooterQy">
            <div id="businessInformation" style="background:#F1F8FF">
                <span>营业执照信息</span>
            </div>
            <div id="bigBoxQy">
                <div id="box1" style="background: #F1F8FF">
                    <div><span>企业名称：</span></div>
                    <div><span>法人姓名：</span></div>
                </div>
                <div id="box2" style="background:#F1F8FF">
                    <div><span>${store.business.companyName}</span></div>
                    <div><span>${store.business.legalPerson}</span></div>
                </div>
                <div id="box3" style="background:#F1F8FF">
                    <div><span>社会统一信用代码：</span></div>
                    <div><span>营业期限：</span></div>
                </div>
                <div id="box4" style="background:#F1F8FF">
                    <div><span>${store.business.organizationCode}</span></div>
                    <div><span>
                        [#if store.business.startDate != null && store.business.endDate != null]${store.business.startDate}~~
                            ${store.business.endDate}
                            [#elseif store.business.longTime == true]长期
                        [/#if]
                    </span></div>
                </div>
                <div style="width: 100%;height: 81px;"></div>
                <div id="box5" >
                    <div style="background:#F1F8FF"><span>营业执照图片：</span></div>
                    <div style="line-height: 111px;">
                <span>
                    <img src="${store.business.licenseImage}" alt="" style="width: 135px;height: 100px;margin-top: 5px;">
                </span>
                    </div>
                </div>
            </div>
        </div>
        [/#if]
        <!--个人-->
        [#if store.business.chooseCompanyOrPerson == 'person']
        <div id="boxFooterGr">
            <div id="shopkeeperIdentityInformation" style="background: background: #F1F8FF">
                <span>店主身份信息</span>
            </div>
            <div class="shopMain1">
                <div style="background: #F1F8FF"><span>店主姓名: </span></div>
                <div><span>${store.business.storeName}</span></div>
                <div style="background: #F1F8FF"><span>身份证号：</span></div>
                <div><span>${store.business.idCard}</span></div>
            </div>
            <div class="shopMain2">
                <div style="background: #f1f8ff"><span>身份证正面照片：</span></div>
                <div>
                <span>
                    <img src="${store.business.idCardImage}" alt="" style="width: 135px;height: 100px;margin-top: 5px;">
                </span>
                </div>
                <div style="background:#f1f8ff">身份证反面照片：</div>
                <div>
                <span>
                    <img src="${store.business.reverseIdCardImage}" alt="" style="width: 135px;height: 100px;margin-top: 5px;">
                </span>
                </div>
            </div>
            <div class="shopMain3">
                <div style="background:#F1F8FF"><span>身份证有效期限：</span></div>
                <div><span>${store.business.idCardStartDate}~~${store.business.idCardEndDate}</span></div>
            </div>
        </div>
        [/#if]
    </div>
</body>
</html>
<script type="text/javascript">
    // 百度地图API功能
    var map = new BMap.Map("allmap");
    map.centerAndZoom(new BMap.Point(116.331398,39.897445),12);
    map.enableScrollWheelZoom(true);

    // 用经纬度设置地图中心点
    function theLocation(){
        if(document.getElementById("longitude").value != "" && document.getElementById("latitude").value != ""){
            map.clearOverlays();
            var new_point = new BMap.Point(document.getElementById("longitude").value,document.getElementById("latitude").value);
            var marker = new BMap.Marker(new_point);  // 创建标注
            map.addOverlay(marker);              // 将标注添加到地图中
            map.panTo(new_point);
        }
    }
</script>