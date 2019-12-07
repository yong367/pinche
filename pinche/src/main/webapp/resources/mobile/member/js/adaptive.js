//rem单位屏幕自适应代码(必要时放在最前面)-开始
var screenWid = document.documentElement.offsetWidth || document.body.offsetWidth;
var nowWid = (screenWid / 750) * 100;
var oHtml = document.getElementsByTagName("html")[0];
//		console.log(nowWid);
oHtml.style.fontSize = nowWid + "px";
//rem单位屏幕自适应代码(必要时放在最前面)-结束