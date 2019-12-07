<!DOCTYPE html>commonissue
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="技术部">
	<meta name="copyright" content="SHOP">
	<title>爱帮伴-账户设置</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/profile.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/member/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/member/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/member/js/jquery.js"></script>
	<script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script>


        var is_weixin = (function(){return navigator.userAgent.toLowerCase().indexOf('micromessenger') !== -1})();
        window.onload = function() {
            var winHeight = typeof window.innerHeight != 'undefined' ? window.innerHeight : document.documentElement.clientHeight; //兼容IOS，不需要的可以去掉
            var btn = document.getElementById('J_weixin');
            var tip = document.getElementById('weixin-tip');
            var close = document.getElementById('close');
            if (is_weixin) {
                btn.onclick = function(e) {
                    tip.style.height = winHeight + 'px'; //兼容IOS弹窗整屏
                    tip.style.display = 'block';
                    return false;
                }
                close.onclick = function() {
                    tip.style.display = 'none';
                }
            }
        }
	</script>
</head>
<body class="profile">
	<header class="header-fixed" style="background:linear-gradient(126deg,rgba(150,100,111,1) 0%,rgba(107,107,138,1) 34%,rgba(217,124,117,1) 100%);color: #FFFFFF">
		<a class="pull-left" href="javascript: history.back();">
			<span class="glyphicon glyphicon-menu-left" style="color: #FFFFFF"></span>
		</a>
		个人设置
	</header>
	<main style="margin: 21px auto;">
		<div class="container-fluid">
			<div class="panel panel-flat" style="margin-bottom:0">
				<div class="user-face-Warp" style="background:rgba(255,255,255,0.2);background:linear-gradient(126deg,rgba(150,100,111,1) 0%,rgba(107,107,138,1) 34%,rgba(217,124,117,1) 100%);">
					<div class="usr_face">
					   <img src="[#if currentUser.imageUrl?has_content]
					${currentUser.imageUrl}
					[#else]
					${setting.defaultMemberLogo}
					[/#if]" style="width: 100%;height: 100%;float: left;"/>
					  </div>
					  <h1 style="color: #ffffff">${currentUser.username}</h1>
					  <h2 style="color:rgba(255,255,255,1);margin-left:100px;text-align:center;padding:0;width:95px;height:30px;background:rgba(0,0,0,0.2);border-radius:24px;border:1px solid rgba(255,255,255,1);">${currentUser.memberRank.name}</h2>
				</div>
			</div>
			
			<div class="list-group list-group-flat" style="margin-bottom:0">
				<div class="list-group-item">
					${message("member.index.receiverList")}
					<a class="pull-right gray-darker" href="${base}/member/receiver/list">
						${message("member.index.receiverList")}
						<span class="glyphicon glyphicon-menu-right"></span>
					</a>
				</div>
			</div>
			[#--<div class="list-group list-group-flat">
				<div class="list-group-item">
					${message("member.index.profileEdit")}
					<a class="pull-right gray-darker" href="${base}/member/profile/edit">
						${message("member.index.profileEdit")}
						<span class="glyphicon glyphicon-menu-right"></span>
					</a>
				</div>
			</div>--]
			<div class="list-group list-group-flat" style="margin-bottom:0">
				<div class="list-group-item">
					${message("member.index.passwordEdit")}
					<a class="pull-right gray-darker" href="${base}/member/password/edit">
						${message("member.index.passwordEdit")}
						<span class="glyphicon glyphicon-menu-right"></span>
					</a>
				</div>
			</div>
			<div class="list-group list-group-flat" style="margin-bottom:0">
				<div class="list-group-item">
					${message("member.index.socialUserList")}
					<a class="pull-right gray-darker" href="${base}/member/social_user/list">
						${message("member.index.socialUserList")}
						<span class="glyphicon glyphicon-menu-right"></span>
					</a>
				</div>
			</div>
			<div class="list-group list-group-flat" style="margin-bottom:0">
				<div class="list-group-item">
					实名认证
					[#if currentUser.authenticationStatus]
						<a class="pull-right gray-darker" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);text-decoration: none;">
							已认证
							<span class="glyphicon glyphicon-menu-right"></span>
						</a>
					[#else]
						<a class="pull-right gray-darker" href="${base}/member/authentification/authentification?preActionName=setting">
							[#--实名认证--]
							<span class="glyphicon glyphicon-menu-right"></span>
						</a>
					[/#if]
				</div>
			</div>
           [#-- <div class="list-group list-group-flat">
                <div class="list-group-item">
				京东白条
                    <a class="pull-right gray-darker" href="${base}/member/jdInvitation">
                        激活邀请码
                        <span class="glyphicon glyphicon-menu-right"></span>
                    </a>
                </div>
            </div>--]
            [#--<div class="list-group list-group-flat">
                <div class="list-group-item">
                    邀伴返佣
					--][#--邀请码&nbsp;:&nbsp;&nbsp;<span style="font-size: 16px;font-weight: bold;color: red">${currentUser.shareCode}</span>--][#--
                    <a class="pull-right gray-darker" href="${base}/member/share/index">
                        朋友注册有奖励，点击邀请
                        <span class="glyphicon glyphicon-menu-right"></span>
                    </a>
                </div>
            </div>--]

            [#--<div class="list-group list-group-flat">--]
                [#--<div class="list-group-item">--]
                    [#--课程分享--]
                    [#--<a class="pull-right gray-darker" href="${base}/member/onlineMath/course">--]
                        [#--二维码分享课程--]
                        [#--<span class="glyphicon glyphicon-menu-right"></span>--]
                    [#--</a>--]
                [#--</div>--]
            [#--</div>--]

            [#--<div class="list-group list-group-flat">--]
                [#--<div class="list-group-item">--]
                    [#--消息通知--]
                    [#--<a class="pull-right gray-darker" href="${base}/member/article/list/101" >--]
                        [#--xx--]
                        [#--<span class="glyphicon glyphicon-menu-right"></span>--]
                    [#--</a>--]
                [#--</div>--]
            [#--</div>--]
			
			[#--<div class="list-group list-group-flat">--]
				[#--<div class="list-group-item">--]
					[#--<a class="btn btn-lg btn-primary btn-flat btn-block" href="${base}/member/logout" style="background: #2cb6f1;">${message("member.index.logout")}</a>--]
				[#--</div>--]
			[#--</div>--]
		</div>
	</main>
</body>
</html>