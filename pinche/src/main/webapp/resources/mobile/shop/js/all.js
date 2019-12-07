var _abc_list_a=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
var _ABC_list_b=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];

var panduan_list=["√","×"];
var panduan_list_text=["对","错"];


var time_cols_to=[
		{
			textAlign: 'center',
			values: ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14','15', '16', '17', '18', '19', '20', '21', '22','23']
			//如果你希望显示文案和实际值不同，可以在这里加一个displayValues: [.....]
		},
		{
			textAlign: 'center',
			values: [':',]
			//如果你希望显示文案和实际值不同，可以在这里加一个displayValues: [.....]
		},
		{
			textAlign: 'center',
			values: ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14','15', '16', '17', '18', '19', '20', '21', '22','23','24', '25', '26', '27', '28', '29', '30', '31','32', '33', '34', '35', '36', '37', '38', '39','40', '41', '42', '43', '44', '45', '46', '47','48', '49','50', '51', '52', '53', '54', '55', '56', '57','58','59']
			//如果你希望显示文案和实际值不同，可以在这里加一个displayValues: [.....]
		},
		{
			textAlign: 'center',
			values: ['~']
			//如果你希望显示文案和实际值不同，可以在这里加一个displayValues: [.....]
		},
		{
			textAlign: 'center',
			values: ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14','15', '16', '17', '18', '19', '20', '21', '22','23']
			//如果你希望显示文案和实际值不同，可以在这里加一个displayValues: [.....]
		},
		{
			textAlign: 'center',
			values: [':',]
			//如果你希望显示文案和实际值不同，可以在这里加一个displayValues: [.....]
		},
		{
			textAlign: 'center',
			values: ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14','15', '16', '17', '18', '19', '20', '21', '22','23','24', '25', '26', '27', '28', '29', '30', '31','32', '33', '34', '35', '36', '37', '38', '39','40', '41', '42', '43', '44', '45', '46', '47','48', '49','50', '51', '52', '53', '54', '55', '56', '57','58','59']
			//如果你希望显示文案和实际值不同，可以在这里加一个displayValues: [.....]
		},
];
//判断是否为dom节点，使用方法isDOM(dom);
//首先要对HTMLElement进行类型检查，因为即使在支持HTMLElement
//的浏览器中，类型却是有差别的，在Chrome,Opera中HTMLElement的
//类型为function，此时就不能用它来判断了
var isDOM = ( typeof HTMLElement === 'object' ) ?
function(obj){
	return obj instanceof HTMLElement;
} :
function(obj){
	return obj && typeof obj === 'object' && obj.nodeType === 1 && typeof obj.nodeName === 'string';
};
//提取链接中的参数
function getUrlParam(name) {
	var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
	var r = window.location.search.substr(1).match(reg);
	if (r != null) return unescape(r[2]);
	return null;
};


//字符串转成dom节点
function new_dom(_html){
	var _dom_box_=document.createElement("div");
	_dom_box_.innerHTML=_html;
	if(_dom_box_.childNodes.length>1)return _dom_box_.childNodes;
	return _dom_box_.childNodes[0];
}

//Base64.encode()加密,Base64.decode()解密。
function Base64() {
	// private property
	_keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	// public method for encoding
	this.encode = function (input) {
		var output = "";
		var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
		var i = 0;
		input = _utf8_encode(input);
		while (i < input.length) {
			chr1 = input.charCodeAt(i++);
			chr2 = input.charCodeAt(i++);
			chr3 = input.charCodeAt(i++);
			enc1 = chr1 >> 2;
			enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
			enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
			enc4 = chr3 & 63;
			if (isNaN(chr2)) {
				enc3 = enc4 = 64;
			} else if (isNaN(chr3)) {
				enc4 = 64;
			}
			output = output +
			_keyStr.charAt(enc1) + _keyStr.charAt(enc2) + _keyStr.charAt(enc3) + _keyStr.charAt(enc4);
		}
		return output;
	}
	// public method for decoding
	this.decode = function (input) {
		var output = "";
		var chr1, chr2, chr3;
		var enc1, enc2, enc3, enc4;
		var i = 0;
		input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
		while (i < input.length) {
			enc1 = _keyStr.indexOf(input.charAt(i++));
			enc2 = _keyStr.indexOf(input.charAt(i++));
			enc3 = _keyStr.indexOf(input.charAt(i++));
			enc4 = _keyStr.indexOf(input.charAt(i++));
			chr1 = (enc1 << 2) | (enc2 >> 4);
			chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
			chr3 = ((enc3 & 3) << 6) | enc4;
			output = output + String.fromCharCode(chr1);
			if (enc3 != 64) {
				output = output + String.fromCharCode(chr2);
			}
			if (enc4 != 64) {
				output = output + String.fromCharCode(chr3);
			}
		}
		output = _utf8_decode(output);
		return output;
	}
	// private method for UTF-8 encoding
	_utf8_encode = function (string) {
		string = string.replace(/\r\n/g,"\n");
		var utftext = "";
		for (var n = 0; n < string.length; n++) {
			var c = string.charCodeAt(n);
			if (c < 128) {
				utftext += String.fromCharCode(c);
			} else if((c > 127) && (c < 2048)) {
				utftext += String.fromCharCode((c >> 6) | 192);
				utftext += String.fromCharCode((c & 63) | 128);
			} else {
				utftext += String.fromCharCode((c >> 12) | 224);
				utftext += String.fromCharCode(((c >> 6) & 63) | 128);
				utftext += String.fromCharCode((c & 63) | 128);
			}
		}
		return utftext;
	}
	// private method for UTF-8 decoding
	_utf8_decode = function (utftext) {
		var string = "";
		var i = 0;
		var c = c1 = c2 = 0;
		while ( i < utftext.length ) {
			c = utftext.charCodeAt(i);
			if (c < 128) {
				string += String.fromCharCode(c);
				i++;
			} else if((c > 191) && (c < 224)) {
				c2 = utftext.charCodeAt(i+1);
				string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
				i += 2;
			} else {
				c2 = utftext.charCodeAt(i+1);
				c3 = utftext.charCodeAt(i+2);
				string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
				i += 3;
			}
		}
		return string;
	}
}
//按字数截断字符串，排除标点符号
function text_lenght_cut(_text,_length){
	if(_text.length>_length){
		var reg = /[\u3002|\uff1f|\uff01|\uff0c|\u3001|\uff1b|\uff1a|\u201c|\u201d|\u2018|\u2019|\uff08|\uff09|\u300a|\u300b|\u3008|\u3009|\u3010|\u3011|\u300e|\u300f|\u300c|\u300d|\ufe43|\ufe44|\u3014|\u3015|\u2026|\u2014|\uff5e|\ufe4f|\uffe5]/;
		if(reg.test(_text[(_length-1)])){
			_text=_text.substring(0,(_length-1))+'…';
		}else{
			_text=_text.substring(0,_length)+'…';
		}
	}
	return _text;
}

//返回上一页
function page_back(url){
	if(url){
		if(url<0){
			window.history.go(url);
		}else{
			window.location.href=url;
		}
	}else{
		window.history.go(-1);
	}
}
//停止冒泡
function stopFunc(e) {
	e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true;
	return false;
}
//呼出电话
function _tel(dom){
	//console.log(dom.getAttribute("tel"));
	window.location.herf="tel:"+dom.getAttribute("tel");
};
//调起微信地图
function _addr(dom){
	//提示
	var f_lat=parseFloat(dom.getAttribute("lat"));
	var f_lng=parseFloat(dom.getAttribute("lng"));
	if(f_lat&&f_lng){
		$.showLoading("正在调起地图")
		// 获取目标地经纬度
		//微信接口
		wx.openLocation({
			latitude: f_lat, // 纬度，浮点数，范围为90 ~ -90
			longitude: f_lng, // 经度，浮点数，范围为180 ~ -180。
			name: dom.getAttribute("weizhi"), // 位置名
			address: '', // 地址详情说明
			scale: 16, // 地图缩放级别,整形值,范围从1~28。默认为最大
			infoUrl: '', // 在查看位置界面底部显示的超链接,可点击跳转
			success: function(res){
				//调起成功
				$.hideLoading();
			},
			fail: function(errMsg){
				//调起失败
				$.hideLoading();
				layer.open({
					content: "地理位置调起失败",
					skin: 'msg',
					time: 2 //2秒后自动关闭
				});
			}
		});
	}
};
//token失效后通用操作
function token_out(){
	layer.open({
		content: "登录失效，将重新登录",
		skin: 'msg',
		time: 2 //2秒后自动关闭
	});
}
// 添加弹窗 
function new_pop(data){
	var btn_char='';
	var fun_char='';
	for (var dbi = 0; dbi < data.btn.length; dbi++) {
		var cfgchar="";
		btn_char=btn_char+'<button class="flex-1 pop_box_btn" onclick="pop_btn_click'+dbi+'()">'+data.btn[dbi].text+'</button>';
		if(data.btn[dbi].cfg){
			cfgchar=JSON.stringify(data.btn[dbi].cfg);
			fun_char=fun_char+'var cfgchar'+dbi+'='+cfgchar+';\nfunction pop_btn_click'+dbi+'(){'+(data.btn[dbi].click?'\n('+data.btn[dbi].click+')(cfgchar'+dbi+');':'')+'\nmask_clear();\n}\n';
		}else{
			fun_char=fun_char+'function pop_btn_click'+dbi+'(){'+(data.btn[dbi].click?'\n('+data.btn[dbi].click+')();':'')+'\nmask_clear();\n}\n';
		}

	}
	var popjs=document.createElement("script");
	popjs.innerHTML=fun_char;
	popjs.setAttribute("name","pop_");
	document.body.appendChild(new_dom('<div '+(data.class?'class="'+data.class+'"':'')+' name="pop_"><div class="pop_view_flex"><div class="mask" onclick="mask_clear()"></div><div class="pop_box"><p class="pop_box_title">'+(data.title?data.title:'标题')+'</p><p class="pop_box_val">'+(data.val?data.val:'内容')+'</p><div class="flex pop_box_button">'+btn_char+'</div></div></div></div>'));
	document.body.appendChild(popjs);
}
//默认的select标签未选择时的文本颜色，select为选中标签，d_color为有内容时颜色，n_color为无内容时颜色
function form_select_change(select,d_color,n_color) {
	d_color?"":d_color="#333";
	n_color?"":n_color="#aeaeae";
	if (!select.value) {
		select.style.color=n_color;
	}else{
		select.style.color=d_color;
	}
}
//select标签初始化
function select_init(d_color,n_color) {
	var sel=document.getElementsByTagName('select');
	for (var seli = 0; seli < sel.length; seli++) {
		form_select_change(sel[seli],d_color,n_color);
	}
}
//点击弹窗蒙层通用操作
function mask_clear(){
	var pop_=document.getElementsByName('pop_');
	for (var pop_i = 0; pop_i < pop_.length; pop_i++) {
		document.body.removeChild(pop_[pop_i]);
	}
	var scr=document.getElementsByTagName('script');
	for (var script_i = 0; script_i < scr.length; script_i++) {
		if(scr[script_i].getAttribute("name")=='pop_'){
			document.body.removeChild(scr[script_i]);
		}
	}
}
//关闭所有弹窗
function close_pop(){
	$(".pops").hide();
}
function no_date_dom(){
	return '<div class="no_data"><img src="../images/null.png" class="no_data_img"><p class="no_data_p">暂无数据</p></div>';
}
function no_date_dom2(){
	return '<div class="no_data"><img src="images/null.png" class="no_data_img"><p class="no_data_p">暂无数据</p></div>';
}
// alljs_ok();
// function alljs_ok(){
// 	try{
// 		pagejs_start();
// 	}catch(err){
// 		console.log(err);
// 		setTimeout(function(){
// 			alljs_ok();
// 		},2000)
// 	}
// }