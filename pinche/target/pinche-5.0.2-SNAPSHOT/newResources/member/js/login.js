$(function(){
	$(".register_tab span").mouseover(function(){
		var index=$(".register_tab span").index(this);
		$(this).addClass("active").siblings().removeClass("active");
		$(".register_div>div.login_div").hide().eq(index).show();
	});

})

