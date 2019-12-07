/**
 * Created by Administrator on 2018/2/20.
 */
$(document).ready(function() {
	//公共导航
	var html = '<div class="container">'+
		'<ul class="navbar row">' +
		'<a href="/" class="con-sm-3 con-md-3">' +
		'<li class="zhuye">' +
		'<div class="icon bar1"></div>' +
		'<div class="bar-hui">主页</div>' +
		'</li>' +
		'</a>' +
		'<a href="/product_category" class="con-sm-3 con-md-3">' +
		'<li class="fenlei">' +
		'<div class="icon bar2"></div>' +
		'<div class="bar-hui">分类</div>' +
		'</li>' +
		'</a>' +
		'<a href="/member/task/list" class="con-sm-3 con-md-3">' +
		'<li class="zlh">' +
		'<div class="icon bar3"></div>' +
		'<div class="bar-hui">赚零花</div>' +
		'</li>' +
		'</a>' +
		'<a class="con-sm-3 con-md-3" href="/cart/list">' +
		'<li class="gwc">' +
		'<div class="icon bar4"></div>' +
		'<div class="bar-hui">购物车</div>' +
		'</li>' +
		'</a>' +
		'<a class="con-sm-3 con-md-3" href="/member/index">' +
		'<li class="wode">' +
		'<div class="icon bar5"></div>' +
		'<div class="bar-hui">我的</div>' +
		'</li>' +
		'</a>' +
		'</ul>'+
		'</div>';
	$('.nav').append(html);
});