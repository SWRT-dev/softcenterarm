﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="-1" />
<link rel="shortcut icon" href="/res/icon-alist.png" />
<link rel="icon" href="/res/icon-alist.png" />
<title>软件中心 - Alist文件列表</title>
<link rel="stylesheet" type="text/css" href="index_style.css">
<link rel="stylesheet" type="text/css" href="form_style.css">
<link rel="stylesheet" type="text/css" href="usp_style.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/device-map/device-map.css">
<link rel="stylesheet" type="text/css" href="/js/table/table.css">
<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" language="JavaScript" src="/js/table/table.js"></script>
<script type="text/javascript" language="JavaScript" src="/client_function.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<style>
a:focus {
	outline: none;
}
.SimpleNote {
	padding:5px 5px;
}
i {
    color: #FC0;
    font-style: normal;
} 
.loadingBarBlock{
	width:740px;
}
.popup_bar_bg_ks{
	position:fixed;
	margin: auto;
	top: 0;
	left: 0;
	width:100%;
	height:100%;
	z-index:99;
	/*background-color: #444F53;*/
	filter:alpha(opacity=90);  /*IE5、IE5.5、IE6、IE7*/
	background-repeat: repeat;
	visibility:hidden;
	overflow:hidden;
	/*background: url(/images/New_ui/login_bg.png);*/
	background:rgba(68, 79, 83, 0.85) none repeat scroll 0 0 !important;
	background-position: 0 0;
	background-size: cover;
	opacity: .94;
}

.FormTitle em {
    color: #00ffe4;
    font-style: normal;
    /*font-weight:bold;*/
}
.FormTable th {
	width: 30%;
}
.formfonttitle {
	font-family: Roboto-Light, "Microsoft JhengHei";
	font-size: 18px;
	margin-left: 5px;
}
.FormTitle, .FormTable, .FormTable th, .FormTable td, .FormTable thead td, .FormTable_table, .FormTable_table th, .FormTable_table td, .FormTable_table thead td {
	font-size: 14px;
	font-family: Roboto-Light, "Microsoft JhengHei";
}
</style>
<script type="text/javascript">
var dbus = {};
var refresh_flag
var db_alist = {}
var count_down;
var _responseLen;
var STATUS_FLAG;
var noChange = 0;
var params_check = ['alist_https', 'alist_publicswitch', 'alist_watchdog'];
var params_input = ['alist_cert_file', 'alist_key_file', 'alist_port', 'alist_cdn', 'alist_token_expires_in', 'alist_site_url', 'alist_watchdog_time'];

String.prototype.myReplace = function(f, e){
	var reg = new RegExp(f, "g"); 
	return this.replace(reg, e); 
}

function init() {
	show_menu(menu_hook);
	register_event();
	get_dbus_data();
	check_status();
}

function get_dbus_data(){
	$.ajax({
		type: "GET",
		url: "/_api/alist_",
		dataType: "json",
		async: false,
		success: function(data) {
			dbus = data.result[0];
			conf2obj();
			show_hide_element();
			pannel_access();
		}
	});
}

function pannel_access(){
	if(dbus["alist_enable"] == "1"){
		//var protocol = location.protocol;
		if(E("alist_publicswitch").checked){
			if(E("alist_https").checked){
				protocol = "https:";
			}else{
				protocol ="http:";
			}
		}else{
			protocol ="http:";
		}

		var hostname = document.domain;
		if (hostname.indexOf('.kooldns.cn') != -1 || hostname.indexOf('.ddnsto.com') != -1 || hostname.indexOf('.tocmcc.cn') != -1) {
			if(hostname.indexOf('.kooldns.cn') != -1){
				hostname = hostname.replace('.kooldns.cn','-alist.kooldns.cn');
			}else if(hostname.indexOf('.ddnsto.com') != -1){
				hostname = hostname.replace('.ddnsto.com','-alist.ddnsto.com');
			}else{
				hostname = hostname.replace('.tocmcc.cn','-alist.tocmcc.cn');
			}

			webUiHref = protocol + "//" + hostname;
		}else{
			webUiHref = protocol + "//" + location.hostname + ":" + dbus["alist_port"];
		}

		if(!dbus["alist_url_error"] && dbus["alist_site_url"]){
			webUiHref = dbus["alist_site_url"];
		}

		E("fileb").href = webUiHref;
		E("fileb").innerHTML = "访问 Alist 面板";
	}
}

function conf2obj(){
	for (var i = 0; i < params_check.length; i++) {
		if(dbus[params_check[i]]){
			E(params_check[i]).checked = dbus[params_check[i]] != "0";
		}
	}
	for (var i = 0; i < params_input.length; i++) {
		if (dbus[params_input[i]]) {
			$("#" + params_input[i]).val(dbus[params_input[i]]);
		}
	}
	if (dbus["alist_version"]){
		E("alist_version").innerHTML = " - " + dbus["alist_version"];
	}

	if (dbus["alist_binver"]){
		E("alist_binver").innerHTML = "程序版本：<em>" + dbus["alist_binver"] + "</em>";
	}else{
		E("alist_binver").innerHTML = "程序版本：<em>null</em>";
	}

	if (dbus["alist_webver"]){
		E("alist_webver").innerHTML = "面板版本：<em>" + dbus["alist_webver"] + "</em>";
	}else{
		E("alist_webver").innerHTML = "面板版本：<em>null</em>";
	}
}

function show_hide_element(){
	if(dbus["alist_enable"] == "1"){
		E("alist_status_tr").style.display = "";
		E("alist_version_tr").style.display = "";
		E("alist_info_tr").style.display = "";
		E("alist_pannel_tr").style.display = "";
		E("alist_apply_btn_1").style.display = "none";
		E("alist_apply_btn_2").style.display = "";
		E("alist_apply_btn_3").style.display = "";
	}else{
		E("alist_status_tr").style.display = "";
		E("alist_version_tr").style.display = "none";
		E("alist_info_tr").style.display = "none";
		E("alist_pannel_tr").style.display = "none";
		E("alist_apply_btn_1").style.display = "";
		E("alist_apply_btn_2").style.display = "none";
		E("alist_apply_btn_3").style.display = "none";
	}

	// URL ERROR
	if(dbus["alist_url_error"] == "1"){
		$("#alist_site_url").css({
			"border": "1px solid #fc0410",
			"color": "#fc0410"
		});
		E("warn_url").innerHTML = "【值错误】";
	}

	// CDN ERROR
	if(dbus["alist_cdn_error"] == "1"){
		$("#alist_cdn").css({
			"border": "1px solid #fc0410",
			"color": "#fc0410"
		});
		E("warn_cdn").innerHTML = "【值错误】";
	}

	// CERT/KEY ERROR
	if(dbus["alist_cert_error"] == "1"){
		$("#alist_cert_file").css({
			"border": "1px solid #fc0410",
			"color": "#fc0410"
		});
	}
	if(dbus["alist_key_error"] == "1"){
		$("#alist_key_file").css({
			"border": "1px solid #fc0410",
			"color": "#fc0410"
		});
	}

	if(dbus["alist_cert_error"] == "1" && dbus["alist_key_error"] == "1"){
		E("warn_cert").innerHTML = "【下方证书公钥Cert文件 + 证书私钥Key文件配置错误，无法启用https！详见插件日志】";
	}else if (dbus["alist_cert_error"] == "1" && dbus["alist_key_error"] != "1"){
		E("warn_cert").innerHTML = "【下方证书公钥Cert文件配置错误，无法启用https！详见插件日志】";
	}else if (dbus["alist_cert_error"] != "1" && dbus["alist_key_error"] == "1"){
		E("warn_cert").innerHTML = "【下方证书私钥Key文件配置错误，无法启用https！详见插件日志】";
	}

	// SHOW HIDE
	if(E("alist_publicswitch").checked == false){
		E("al_https").style.display = "none";
		E("al_cert").style.display = "none";
		E("al_key").style.display = "none";
		E("al_url").style.display = "none";
		E("al_cdn").style.display = "none";
	}else{
		E("al_url").style.display = "";
		E("al_https").style.display = "";
			E("al_cdn").style.display = "";
		if(E("alist_https").checked == false){
			E("al_cert").style.display = "none";
			E("al_key").style.display = "none";
		}else{
			E("al_cert").style.display = "";
			E("al_key").style.display = "";
		} 
	}
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "Alist文件列表");
	tablink[tablink.length - 1] = new Array("", "Module_alist.asp");
}

function register_event(){
	$(".popup_bar_bg_ks").click(
		function() {
			count_down = -1;
		});
	$(window).resize(function(){
		var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
		var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
		if($('.popup_bar_bg_ks').css("visibility") == "visible"){
			document.scrollingElement.scrollTop = 0;
			var log_h = E("loadingBarBlock").clientHeight;
			var log_w = E("loadingBarBlock").clientWidth;
			var log_h_offset = (page_h - log_h) / 2;
			var log_w_offset = (page_w - log_w) / 2 + 90;
			$('#loadingBarBlock').offset({top: log_h_offset, left: log_w_offset});
		}
	});
}

function check_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "alist_config.sh", "params":['status'], "fields": ""};
	$.ajax({
		type: "POST",
		url: "/_api/",
		async: true,
		dataType: "json",
		data: JSON.stringify(postData),
		success: function (response) {
			E("alist_status").innerHTML = response.result;
			setTimeout("check_status();", 10000);
		},
		error: function(){
			E("alist_status").innerHTML = "获取运行状态失败";
			setTimeout("check_status();", 5000);
		}
	});
}

function save(flag){
	var db_alist = {};
	if(flag){
		console.log(flag)
		db_alist["alist_enable"] = flag;
	}else{
		db_alist["alist_enable"] = "0";
	}
	for (var i = 0; i < params_check.length; i++) {
			db_alist[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	for (var i = 0; i < params_input.length; i++) {
		if (E(params_input[i])) {
			db_alist[params_input[i]] = E(params_input[i]).value;
		}
	} 
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "alist_config.sh", "params": ["web_submit"], "fields": db_alist};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(response.result == id){
				get_log();
			}
		}
	});
}

function get_log(flag){
	E("ok_button").style.visibility = "hidden";
	showALLoadingBar();
	$.ajax({
		url: '/_temp/alist_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.myReplace("XU6J03M6", " ");
				E("ok_button").style.visibility = "visible";
				retArea.scrollTop = retArea.scrollHeight;
				if(flag == 1){
					count_down = -1;
					refresh_flag = 0;
				}else{
					count_down = 6;
					refresh_flag = 1;
				}
				count_down_close();
				return false;
			}
			setTimeout("get_log(" + flag + ");", 500);
			retArea.value = response.myReplace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
		},
		error: function(xhr) {
			E("loading_block_title").innerHTML = "暂无日志信息 ...";
			E("log_content").value = "日志文件为空，请关闭本窗口！";
			E("ok_button").style.visibility = "visible";
			return false;
		}
	});
}

function showALLoadingBar(){
	document.scrollingElement.scrollTop = 0;
	E("loading_block_title").innerHTML = "&nbsp;&nbsp;alist日志信息";
	E("LoadingBar").style.visibility = "visible";
	var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var log_h = E("loadingBarBlock").clientHeight;
	var log_w = E("loadingBarBlock").clientWidth;
	var log_h_offset = (page_h - log_h) / 2;
	var log_w_offset = (page_w - log_w) / 2 + 90;
	$('#loadingBarBlock').offset({top: log_h_offset, left: log_w_offset});
}
function hideALLoadingBar(){
	E("LoadingBar").style.visibility = "hidden";
	E("ok_button").style.visibility = "hidden";
	if (refresh_flag == "1"){
		refreshpage();
	}
}
function count_down_close() {
	if (count_down == "0") {
		hideALLoadingBar();
	}
	if (count_down < 0) {
		E("ok_button1").value = "手动关闭"
		return false;
	}
	E("ok_button1").value = "自动关闭（" + count_down + "）"
		--count_down;
	setTimeout("count_down_close();", 1000);
}

function close() {
	if (confirm('确定马上关闭吗.?')) {
		showLoading(2);
		refreshpage(2);
		var id = parseInt(Math.random() * 100000000);
		var postData = { "id": id, "method": "alist_config.sh", "params": ["stop"], "fields": "" };
		$.ajax({
			url: "/_api/",
			cache: false,
			type: "POST",
			dataType: "json",
			data: JSON.stringify(postData)
		});
	}
}

function get_run_log(){
	if(STATUS_FLAG == 0) return;
	$.ajax({
		url: '/_temp/alist_run_log.txt',
		type: 'GET',
		dataType: 'html',
		async: true,
		cache: false,
		success: function(response) {
			var retArea = E("log_content_alist");
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}
			if (noChange > 10) {
				return false;
			} else {
				setTimeout("get_run_log();", 1500);
			}
			retArea.value = response;

			if(E("alist_stop_log").checked == false){
				retArea.scrollTop = retArea.scrollHeight;
			}
			_responseLen = response.length;
		},
		error: function(xhr) {
			E("log_pannel_title").innerHTML = "暂无日志信息 ...";
			E("log_content_alist").value = "日志文件为空，请关闭本窗口！";
			setTimeout("get_run_log();", 5000);
		}
	});
}
function show_log_pannel(){
	document.scrollingElement.scrollTop = 0;
	E("log_pannel_div").style.visibility = "visible";
	var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var log_h = E("log_pannel_table").clientHeight;
	var log_w = E("log_pannel_table").clientWidth;
	var log_h_offset = (page_h - log_h) / 2;
	var log_w_offset = (page_w - log_w) / 2;
	$('#log_pannel_table').offset({top: log_h_offset, left: log_w_offset});
	STATUS_FLAG = 1;
	get_run_log();
}
function hide_log_pannel(){
	E("log_pannel_div").style.visibility = "hidden";
	STATUS_FLAG = 0;
}
function open_alist_hint(itemNum) {
	statusmenu = "";
	width = "350px";
	if (itemNum == 1) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;1. 此处显示alist二进制程序在路由器后台的简要运行情况，详细运行日志可以点击顶部的<b>alist运行日志</b>查看。<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;2. 当开启了实时进程守护后，可以看到alist二进制运行时长，即守护运行时间。<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;3. 当出现<b>获取运行状态失败</b>时，可能是路由器后台登陆超时或者httpd进程崩溃导致，如果是后者，请等待路由器httpd进程恢复，或者自行使用ssh命令：server restart_httpd重启httpd。<br/><br/>"
		_caption = "运行状态";
	}
	if (itemNum == 2) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;1. 此处显示alist二进制程序的版本号及其内置的alist面板版本号。<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;2. alist二进制程序下载自alist的github项目release页面的alist-linux-arm64版本。<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;3.目前只支持hnd机型中的armv8机型，比如cpu型号为BCM4906、BCM4908、BCM4912等armv8机型。<br/><br/>"
		_caption = "运行状态";
	}
	if (itemNum == 3) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;点击【查看密码】可以显示当前面板的账号和密码，请注意：如果你需要配置webdav，同样应该使用此用户名和密码。<br/><br/>"
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;点击【alist运行日志】可以实时查看alist程序的运行情况。"
		_caption = "信息获取";
	}
	if (itemNum == 4) {
		width = "780px";
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;在不同的配置和网络环境下，点击【访问Alist面板】进入的是不同地址：";
		statusmenu += "<br/><br/>";
		statusmenu += "1️⃣<font color='#F00'>局域网访问（http）</font><br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;1. alist插件内：关闭公网访问<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;2. 开启alist插件<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;3. 此时点击【访问Alist面板】就是访问局域网地址：https://192.168.50.1:5244，或：http://router.asus.com:5244";
		statusmenu += "<br/><br/>";
		statusmenu += "2️⃣<font color='#F00'>公网ddns访问（http）</font><br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;0. 路由器已经配置了ddns，如域名 ax86.ddns.com 解析到路由器的公网ip<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;1. alist插件内：开启公网访问<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;2. alist插件内：关闭https<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;3. alist插件内：网站URL可以不填写，或者填 http://ax86.ddns.com:5244<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;4. 开启alist插件<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;5. 网站URL不填的话，此时点击【访问Alist面板】就是访问局域网地址：http://192.168.50.1:5244<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;6. 网站URL要填的话，填：http://ax86.ddns.com:5244，此时点击【访问Alist面板】就是通过填写的url访问";
		statusmenu += "<br/><br/>";
		statusmenu += "3️⃣<font color='#F00'>公网ddns访问（https）</font><br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;0. 路由器已经配置了ddns，如域名 ax86.ddns.com，且配置了https证书<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;1. alist插件内：开启公网访问<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;2. alist插件内：开启https，证书公钥填/etc/cert.pem，证书私钥填：/etc/key.pem<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;3. alist插件内：网站URL可以不填写，或者填https://ax86.ddns.com:5244<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;4. 开启alist插件<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;5. 网站URL不填的话，此时点击【访问Alist面板】就是访问局域网地址：https://192.168.50.1:5244，不过会提示证书不安全<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;6. 网站URL要填的话，填：https://ax86.ddns.com:5244，此时点击【访问Alist面板】就是通过填写的url访问<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;7. 注意开启https后，所有http的访问方式将失效";
		statusmenu += "<br/><br/>";
		statusmenu += "4️⃣<font color='#F00'>ddnsto穿透访问</font><br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;0. 路由器已经配置了ddnsto，如域名 ax86.ddnsto.com<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;1. alist插件内：关闭公网访问关<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;2. ddnsto后台配置主域名：ax86-alist，ax86要换成自己的主域名<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;3. ddnsto后台配置目标主机地址：http://192.168.60.1:5244<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;4. 开启alist插件<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;5. 此时点击【访问Alist面板】就是访问ddnsto地址：https://ax86-alist.ddnsto.com<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;6. 你也可以开启公网访问后填写https://ax86-alist.ddnsto.com到网站URL";
		statusmenu += "</div>";
		_caption = "说明：";
		return overlib(statusmenu, OFFSETX, -160, OFFSETY, 10, RIGHT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, ''); 
	}
	if (itemNum == 5) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;采用perp对alist进程进行实时进程守护，这比一些定时检查脚本更有效率，当然如果alist程序在你的路由器上运行良好，完全可以不使用进程守护。"
		statusmenu += "<br/><br/>&nbsp;&nbsp;&nbsp;&nbsp;由于alist对路由器资源占用较多，所以强烈建议为路由器配置1G及以上的虚拟内存，以保证alist的稳定运行！"
		_caption = "实时进程守护";
	}
	if (itemNum == 6) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;开启公网访问后，alist将监听在0.0.0.0地址，这样就能从WAN外部访问路由器内的alist面板。<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;关闭公网访问后，alist将监听在局域网地址如：192.168.50.1上，这样alist面板仅能从局域网内部访问，"
		_caption = "开启公网访问";
	}
	if (itemNum == 7) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;alist面板默认端口为5244，你可以自行更改为其它端口。请注意：如果你需要配置webdav，同样应该使用该端口！。<br/><br/>"
		_caption = "面板端口";
	}
	if (itemNum == 8) {
		width = "780px";
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;网站URL可以不配置，但是如果你需要跟朋友分享资源的时候，比如你在局域网内通过http://192.168.50.1:5244登陆了alist，"
		statusmenu += "此时你想跟朋友分享资源的时候，复制某个文件连接，该连接仍然是http://192.168.50.1:5244/xxxx。<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;如果你给路由器配置了ddns访问路由器：https://ax86u.ddns.com:8443，那么可以将：https://ax86u.ddns.com:5224填写进去，然后你复制的文件连接就会是：https://ax86u.ddns.com:5244/xxxx<br/><br/>"
		_caption = "网站URL";
		return overlib(statusmenu, OFFSETX, -160, OFFSETY, 10, RIGHT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, ''); 
	}
	if (itemNum == 9) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;alist运行在路由器上，如果访问alist面板，路由器上的alist程序会将面板所需要的网页、javaScript文件、图标等资源等发送给访问的设备，这会消耗不少的路由器cpu资源。<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;此时给alist后台面板配置静态CDN，这些相关的静态资源如：网页、javaScript文件、图标，就会从公网的CDN服务器商获取，而不再请求路由器内的alist程序。<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;你可以前往alist文档网站，获取alist官方提供的一些CDN地址。<br/><br/>"
		_caption = "CDN地址";
	}
	if (itemNum == 10) {
		width = "690px";
		statusmenu = "1️⃣只有当开启公网访问时才能启用https，且建议路由器已经配置了DDNS + https证书的情况下才启用https选项！<br/><br/>";
		statusmenu += "2️⃣启用https后，下面的<b>证书公钥Cert文件</b>和<b>证书私钥Key文件</b>选项也必须正确填写，才能起作用！<br/><br/>";
		statusmenu += "3️⃣https启用成功后，后台面板就无法使用http地址进行访问了！<br/><br/>";
		statusmenu += "4️⃣如果你为路由器配置了DDNS和https证书，alist可以使用相同的证书，即：<br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;证书Cert文件路径(绝对路径)：<font color='#CC0066'>/etc/cert.pem</font><br/>";
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;证书Key文件路径(绝对路径)：<font color='#CC0066'>/etc/key.pem</font><br/><br/>";
		statusmenu += "5️⃣如果你使用ddnsto内网穿透服务，请不要开启https选项！<br/><br/>";
		_caption = "启用https：";
		return overlib(statusmenu, OFFSETX, -30, OFFSETY, 10, RIGHT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, ''); 
	}

	return overlib(statusmenu, OFFSETX, 10, OFFSETY, 10, RIGHT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');

	var tag_name = document.getElementsByTagName('a');
	for (var i = 0; i < tag_name.length; i++)
		tag_name[i].onmouseout = nd;

	if (helpcontent == [] || helpcontent == "" || hint_array_id > helpcontent.length)
		return overlib('<#defaultHint#>', HAUTO, VAUTO);
	else if (hint_array_id == 0 && hint_show_id > 21 && hint_show_id < 24)
		return overlib(helpcontent[hint_array_id][hint_show_id], FIXX, 270, FIXY, 30);
	else {
		if (hint_show_id > helpcontent[hint_array_id].length)
			return overlib('<#defaultHint#>', HAUTO, VAUTO);
		else
			return overlib(helpcontent[hint_array_id][hint_show_id], HAUTO, VAUTO);
	}
}
function mOver(obj, hint){
	$(obj).css({
		"color": "#00ffe4",
		"text-decoration": "underline"
	});
	open_alist_hint(hint);
}
function mOut(obj){
	$(obj).css({
		"color": "#fff",
		"text-decoration": ""
	});
	E("overDiv").style.visibility = "hidden";
}
</script>
</head>
<body id="app" skin='<% nvram_get("sc_skin"); %>' onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<div id="LoadingBar" class="popup_bar_bg_ks" style="z-index: 200;" >
		<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
			<tr>
				<td height="100">
					<div id="loading_block_title" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
					<div id="loading_block_spilt" style="margin:10px 0 10px 5px;" class="loading_block_spilt">
						<li><font color="#ffcc00">请等待日志显示完毕，并出现自动关闭按钮！</font></li>
						<li><font color="#ffcc00">在此期间请不要刷新本页面，不然可能导致问题！</font></li>
					</div>
					<div style="margin-left:15px;margin-right:15px;margin-top:10px;outline: 1px solid #3c3c3c;overflow:hidden">
						<textarea cols="50" rows="25" wrap="off" readonly="readonly" id="log_content" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:transparent;color:#FFFFFF;outline: none;padding-left:5px;padding-right:22px;overflow-x:hidden"></textarea>
					</div>
					<div id="ok_button" class="apply_gen" style="background:#000;visibility:hidden;">
						<input id="ok_button1" class="button_gen" type="button" onclick="hideALLoadingBar()" value="确定">
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div id="log_pannel_div" class="popup_bar_bg_ks" style="z-index: 200;" >
		<table cellpadding="5" cellspacing="0" id="log_pannel_table" class="loadingBarBlock" style="width:960px" align="center">
			<tr>
				<td height="100">
					<div style="text-align: center;font-size: 18px;color: #99FF00;padding: 10px;font-weight: bold;">alist日志信息</div>
					<div style="margin-left:15px"><i>🗒️此处展示alist程序的运行日志...</i></div>
					<div style="margin-left:15px;margin-right:15px;margin-top:10px;outline: 1px solid #3c3c3c;overflow:hidden">
						<textarea cols="50" rows="32" wrap="off" readonly="readonly" id="log_content_alist" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:transparent;color:#FFFFFF;outline: none;padding-left:5px;padding-right:22px;line-height:1.3;overflow-x:hidden"></textarea>
					</div>
					<div id="ok_button_alist" class="apply_gen" style="background:#000;">
						<input class="button_gen" type="button" onclick="hide_log_pannel()" value="返回主界面">
						<input style="margin-left:10px" type="checkbox" id="alist_stop_log">
						<lable>&nbsp;暂停日志刷新</lable>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<iframe name="hidden_frame" id="hidden_frame" width="0" height="0" frameborder="0"></iframe>
	<!--=============================================================================================================-->
	<table class="content" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td width="17">&nbsp;</td>
			<td valign="top" width="202">
				<div id="mainMenu"></div>
				<div id="subMenu"></div>
			</td>
			<td valign="top">
				<div id="tabMenu" class="submenuBlock"></div>
				<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
					<tr>
						<td align="left" valign="top">
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div class="formfonttitle">Alist <lable id="alist_version"></lable></div>
										<div style="float: right; width: 15px; height: 25px; margin-top: -20px">
											<img id="return_btn" alt="" onclick="reload_Soft_Center();" align="right" style="cursor: pointer; position: absolute; margin-left: -30px; margin-top: -25px;" title="返回软件中心" src="/images/backprev.png" onmouseover="this.src='/images/backprevclick.png'" onmouseout="this.src='/images/backprev.png'" />
										</div>
										<div style="margin: 10px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote">
											<a href="https://github.com/alist-org/alist" target="_blank"><em><u>Alist</u></em></a>&nbsp;一个支持多种存储的文件列表程序，使用 Gin 和 Solidjs。
											<span><a type="button" class="ks_btn" href="javascript:void(0);" onclick="get_log(1)" style="margin-left:5px;">插件日志</a></span>
										</div>
										<div id="alist_status_pannel">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
													<tr>
														<td colspan="2">Alist - 状态</td>
													</tr>
												</thead>
												<tr id="alist_status_tr" style="display: none;">
													<th><a onmouseover="mOver(this, 1)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">运行状态</a></th>
													<td>
														<span style="margin-left:4px" id="alist_status"></span>
													</td>
												</tr>
												<tr id="alist_version_tr" style="display: none;">
													<th><a onmouseover="mOver(this, 2)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">版本信息</a></th>
													<td>
														<span style="margin-left:4px" id="alist_binver"></span>
														<span style="margin-left:4px" id="alist_webver"></span>
													</td>
												</tr>
												<tr id="alist_info_tr" style="display: none;">
													<th><a onmouseover="mOver(this, 3)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">信息获取</a></th>
													<td>
														<a type="button" style="vertical-align:middle;cursor:pointer;" class="ks_btn" href="javascript:void(0);" onclick="save(3)" style="margin-left:5px;">查看密码</a>
														<a type="button" class="ks_btn" href="javascript:void(0);" onclick="show_log_pannel()" style="margin-left:5px;">alist运行日志</a>
													</td>
												</tr>
												<tr id="alist_pannel_tr" style="display: none;">
													<th><a onmouseover="mOver(this, 4)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">Alist面板</a></th>
													<td>
														<a type="button" style="vertical-align:middle;cursor:pointer;" id="fileb" class="ks_btn" href="" target="_blank">访问 Alist 面板</a>
													</td>
												</tr>
											</table>
										</div>
										<div id="alist_setting_pannel" style="margin-top:10px">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
													<tr>
														<td colspan="2">Alist - 设置</td>
													</tr>
												</thead>
												<!--<tr><th colspan="2"><em>基础设置</em></th></tr>-->
												<tr id="dashboard">
													<th><a onmouseover="mOver(this, 5)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">实时进程守护</a></th>
													<td>
														<input type="checkbox" id="alist_watchdog" style="vertical-align:middle;">
													</td>
												</tr>
												<tr id="dashboard">
													<th><a onmouseover="mOver(this, 6)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">开启公网访问</a></th>
													<td>
														<input type="checkbox" id="alist_publicswitch" onchange="show_hide_element();" style="vertical-align:middle;">
													</td>
												</tr>
												<!--<tr><th colspan="2"><em>配置文件</em> -- <em style="color: gold;">【请查看<a href="https://alist.nn.ci/zh/" target="_blank"><em>Alist官方文档</em></a>，不懂勿动！！！】</th></tr>-->
												<tr id="alist_port_tr">
													<th><a onmouseover="mOver(this, 7)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">面板端口</a></th>
													<td>
														<input type="text" id="alist_port" style="width: 50px;" maxlength="5" class="input_3_table" autocorrect="off" autocapitalize="off" style="background-color: rgb(89, 110, 116);" value="5244">
													</td>
												</tr>
												<tr>
													<th>用户登录过期时间</th>
													<td>
														<input onkeyup="this.value=this.value.replace(/[^1-9][^0-9]*/,'')" style="width:30px;" type="text" class="input_ss_table" id="alist_token_expires_in" name="alist_token_expires_in" maxlength="4" autocorrect="off" autocapitalize="off" value="48">
														<span>小时</span>
													</td>
												</tr>
												<tr id="al_url">
													<th><a onmouseover="mOver(this, 8)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">网站URL (site_url)</a><lable id="warn_url" style="color:red;margin-left:5px"><lable></th>
													<td>
													<input type="text" id="alist_site_url" style="width: 95%;" class="input_3_table" autocorrect="off" autocapitalize="off" style="background-color: rgb(89, 110, 116);" value="">
													</td>
												</tr>
												<tr id="al_cdn">
													<th><a onmouseover="mOver(this, 9)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">静态资源CDN地址<lable id="warn_cdn" style="color:red;margin-left:5px"><lable></a></th>
													<td>
													<input type="text" id="alist_cdn" style="width: 95%;" class="input_3_table" autocorrect="off" autocapitalize="off" style="background-color: rgb(89, 110, 116);" value="">
													</td>
												</tr>
												<tr id="al_https">
													<th><a onmouseover="mOver(this, 10)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">启用https</a></th>
													<td>
														<input type="checkbox" id="alist_https" onchange="show_hide_element();" style="vertical-align:middle;" />
														<span id="warn_cert" style="color:red;margin-left:5px;vertical-align:middle;font-size:11px;"><span>
													</td>
												</tr>
												<tr id="al_cert">
													<th>证书公钥Cert文件 (绝对路径)</th>
													<td>
													<input type="text" id="alist_cert_file" style="width: 95%;" class="input_3_table" autocorrect="off" autocapitalize="off" style="background-color: rgb(89, 110, 116);" value="" placeholder="/tmp/etc/cert.pem">
													</td>
												</tr>
												<tr id="al_key">
													<th>证书私钥Key文件 (绝对路径)</th>
													<td>
													<input type="text" id="alist_key_file" style="width: 95%;" class="input_3_table" autocorrect="off" autocapitalize="off" style="background-color: rgb(89, 110, 116);" value="" placeholder="/tmp/etc/key.pem">
													</td>
												</tr> 
											</table>
										</div>
										<div id="alist_apply" class="apply_gen">
											<input class="button_gen" style="display: none;" id="alist_apply_btn_1" onClick="save(1)" type="button" value="开启" />
											<input class="button_gen" style="display: none;" id="alist_apply_btn_2" onClick="save(2)" type="button" value="重启" />
											<input class="button_gen" style="display: none;" id="alist_apply_btn_3" onClick="save(0)" type="button" value="关闭" />
										</div>
										<div style="margin: 10px 0 10px 5px;" class="splitLine"></div>
										<div style="margin:10px 0 0 5px">
											<li>如有不懂，特别是alist配置文件的填写，请查看Alist官方文档<a href="https://alist.nn.ci/zh/" target="_blank"><em>点这里看文档</em></a></li>
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
			<td width="10" align="center" valign="top"></td>
		</tr>
	</table>
	<div id="footer"></div>
</body>
</html>

