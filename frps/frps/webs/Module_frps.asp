<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - frps 服务器</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/> 
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css"> 	
<style>
input[type=button]:focus {
	outline: none;
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
.loadingBarBlock{
	width:740px;
}
.loading_block_spilt {
	background: #656565;
	height: 1px;
	width: 98%;
}

.contentM_qis {
    position: fixed;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius:10px;
    z-index: 10;
    background-color:#2B373B;
    /*margin-left: -100px;*/
    top: 100px;
    width:755px;
    return height:auto;
    box-shadow: 3px 3px 10px #000;
    background: rgba(0,0,0,0.85);
    display:none;
}
</style>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script>
var db_frps = {};
var params_input = ["frps_common_webServer__addr", "frps_common_webServer__port", "frps_common_webServer__user", "frps_common_webServer__password", "frps_common_bindAddr", "frps_common_bindPort", "frps_common_auth__token", "frps_common_vhostHTTPPort", "frps_common_vhostHTTPSPort", "frps_cron_time", "frps_common_transport__maxPoolCount", "frps_common_log__to", "frps_common_log__level", "frps_common_log__maxDays", "frps_common_transport__tcpMux", "frps_cron_hour_min", "frps_common_transport__tls__force", "frps_common_kcpBindPort", "frps_common_quicBindPort", "frps_common_allowPorts", "frps_openports", "frps_ifopenport", "frps_common_subDomainHost", "frps_cron_type", "frps_openports_u"]
var params_check = ["frps_enable", "frps_extra_config"];
var params_base64 = ["frps_extra_options"]
var	refresh_flag;
var count_down;
String.prototype.myReplace = function(f, e){
	var reg = new RegExp(f, "g"); 
	return this.replace(reg, e); 
}
function init(){
	show_menu(menu_hook);
	get_dbus_data();
	get_status();
	conf2obj();
	version_show();
	hook_event();
}
function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/frps",
		dataType: "json",
		async: false,
		success: function(data) {
			db_frps = data.result[0];
			console.log(db_frps);
			update_visibility();
			hook_event();
		}
	});
}
function get_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "frps_status.sh", "params":[1], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			if(response.result){
				E("status").innerHTML = response.result;
				setTimeout("get_status();", 10000);
			}
		},
		error: function(xhr){
			console.log(xhr)
			setTimeout("get_status();", 15000);
		}
	});
}
function conf2obj(){
	for (var i = 0; i < params_input.length; i++) {
		if(db_frps[params_input[i]]){
			E(params_input[i]).value = db_frps[params_input[i]];
		}
	}
	for (var i = 0; i < params_check.length; i++) {
		if(db_frps[params_check[i]]){
			E(params_check[i]).checked = db_frps[params_check[i]] == 1 ? true : false
		}
	}
	//base64
	for (var i = 0; i < params_base64.length; i++) {
		if(db_frps[params_base64[i]]){
			E(params_base64[i]).value = Base64.decode(db_frps[params_base64[i]]);
		}
	}
}
function save() {
	if(E("frps_common_kcpBindPort").value == E("frps_common_quicBindPort").value) {
        if (E("frps_common_kcpBindPort").value != "") {
            alert("Kcp、quic绑定端口冲突！");
            return false; 
	    }
	}
	if (E("frps_extra_config").checked) {
		if (trim(E("frps_extra_options").value) == "") {
			alert("您已勾选“启用追加”其他参数，表单不能为空!");
			return false;
		}
	}
	if(!E(frps_cron_time).value){
		alert("定时功能的时间为‘必填项’，填 0 为关闭!");
		return false;
	}
    if(E("frps_ifopenport").value && !trim(E("frps_openports").value) && !trim(E("frps_openports_u").value)){
        alert("您已选择“开启端口通过防火墙”，但端口号列表全部为空！");
        return false;
    }
	if(E(frps_cron_time).value == "0"){
	    E("frps_cron_hour_min").value = "";
	    E("frps_cron_type").value = "";
	}
	
	// 清空隐藏表单的值
	if(!E("frps_ifopenport").value){
		E("frps_openports").value = "";
		E("frps_openports_u").value = "";
	}
	if(!E("frps_common_log__to").value || E("frps_common_log__to").value == "/dev/null" || E("frps_common_log__to").value == "console"){
        E("frps_common_log__level").value = "";
        E("frps_common_log__maxDays").value = "";
	}
	if(!E("frps_common_webServer__port").value){
        E("frps_common_webServer__addr").value = "";
        E("frps_common_webServer__user").value = "";
        E("frps_common_webServer__password").value = "";
    }

	//input
	for (var i = 0; i < params_input.length; i++) {
		if (trim(E(params_input[i]).value) && trim(E(params_input[i]).value) != db_frps[params_input[i]]) {
			db_frps[params_input[i]] = trim(E(params_input[i]).value);
		}else if (!trim(E(params_input[i]).value) && db_frps[params_input[i]]) {
			db_frps[params_input[i]] = "";
            }
	}
	// checkbox
	for (var i = 0; i < params_check.length; i++) {
        if (E(params_check[i]).checked != db_frps[params_check[i]]) {
            db_frps[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
        }
	}
	//base64
	for (var i = 0; i < params_base64.length; i++) {
		if (E(params_base64[i]).value && Base64.encode(E(params_base64[i]).value) != db_frps[params_base64[i]]) {
            db_frps[params_base64[i]] = Base64.encode(E(params_base64[i]).value);
		} else if (!E(params_base64[i]).value && db_frps[params_base64[i]]) {
			db_frps[params_base64[i]] = "";
            }
	}
	
	var uid = parseInt(Math.random() * 100000000);
	console.log("uid :", uid);
	var postData = {"id": uid, "method": "frps_config.sh", "params": ["web_submit"], "fields": db_frps };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			console.log("response: ", response);
			if (response.result == uid) {
				get_log();
			} else {
				return false;
			}
		},
		error: function(XmlHttpRequest, textStatus, errorThrown){
			console.log(XmlHttpRequest.responseText);
			alert("skipd数据读取错误！");
		}
	});
}
function clear_log() {
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "frps_config.sh", "params": ["clearlog"], "fields": db_frps };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
			}
		}
	});
}
function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "软件中心", "离线安装", "Frps服务器");
	tablink[tablink.length - 1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_frps.asp");
}
function hook_event(){
	$(".popup_bar_bg_ks").click(
		function() {
			count_down = -1;
		});
	$(window).resize(function(){
		if($('.popup_bar_bg_ks').css("visibility") == "visible"){
			document.scrollingElement.scrollTop = 0;
			var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
			var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
			var log_h = E("loadingBarBlock").clientHeight;
			var log_w = E("loadingBarBlock").clientWidth;
			var log_h_offset = (page_h - log_h) / 2;
			var log_w_offset = (page_w - log_w) / 2 + 90;
			$('#loadingBarBlock').offset({top: log_h_offset, left: log_w_offset});
		}
	});
	// 显示或隐藏关联表格
	$("#frps_ifopenport").change(
		function(){
		if(E("frps_ifopenport").value == ""){
			E("tcp_ports_tr").style.display = "none";
			E("udp_ports_tr").style.display = "none";
		}else{
			E("tcp_ports_tr").style.display = "";
			E("udp_ports_tr").style.display = "";
		}
	});
	$("#frps_common_log__to").change(
		function(){
		if(E("frps_common_log__to").value == "" || E("frps_common_log__to").value == "/dev/null" || E("frps_common_log__to").value == "console"){
			E("log_level_tr").style.display = "none";
            E("log_maxDays_tr").style.display = "none";
		}else{
		    E("log_level_tr").style.display = "";
		    E("log_maxDays_tr").style.display = "";
		}
	});
	$("#frps_common_webServer__port").change(
		function(){
		if(E("frps_common_webServer__port").value == ""){
			E("webServerAddr_tr").style.display = "none";
            E("webServerUser_tr").style.display = "none";
            E("webServerPwd_tr").style.display = "none";
        }else{
            E("webServerAddr_tr").style.display = "";
            E("webServerUser_tr").style.display = "";
            E("webServerPwd_tr").style.display = "";
        }
	});
}
function showWBLoadingBar(){
	document.scrollingElement.scrollTop = 0;
	E("LoadingBar").style.visibility = "visible";
	E("loading_block_title").innerHTML = "【frps】插件日志";
	var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var log_h = E("loadingBarBlock").clientHeight;
	var log_w = E("loadingBarBlock").clientWidth;
	var log_h_offset = (page_h - log_h) / 2;
	var log_w_offset = (page_w - log_w) / 2 + 90;
	$('#loadingBarBlock').offset({top: log_h_offset, left: log_w_offset});
}
function hideWBLoadingBar(){
	E("LoadingBar").style.visibility = "hidden";
	E("ok_button").style.visibility = "hidden";
	if (refresh_flag == "1"){
		refreshpage();
	}
}
function count_down_close() {
	if (count_down == "0") {
		hideWBLoadingBar();
	}
	if (count_down < 0) {
		E("ok_button1").value = "手动关闭"
		return false;
	}
	E("ok_button1").value = "自动关闭（" + count_down + "）"
		--count_down;
	setTimeout("count_down_close();", 1000);
}
function get_log(action){
	E("ok_button").style.visibility = "hidden";
	showWBLoadingBar();
	$.ajax({
		url: '/_temp/frps_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.myReplace("XU6J03M6", " ");
				E("ok_button").style.visibility = "visible";
				retArea.scrollTop = retArea.scrollHeight;
				if(action == 1){
					count_down = -1;
					refresh_flag = 0;
				}else{
					count_down = 5;
					refresh_flag = 1;
				}
				count_down_close();
				return false;
			}else if (response.length == 0){
                E("loading_block_title").innerHTML = "暂无日志信息 ...";
                E("log_content").value = "插件日志文件为空";
                E("ok_button").style.visibility = "visible";
                return false;
			}
			setTimeout("get_log();", 300);
			retArea.value = response.myReplace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
		}
	});
}
function get_frpslogfile() {
    $.ajax({
    url: '/_temp/frps_lnk.log',
    type: 'GET',
    cache:false,
    dataType: 'text',
    success: function(res) {
        if (res.length == 0){
           E("logfiletxt").value = "运行日志文件为空或未配置"; 
        }else{ $('#logfiletxt').val(res); }
		}
	});
}
function get_frpsConf() {
    $.ajax({
    url: '/_temp/.frps.toml',
    type: 'GET',
    cache:false,
    dataType: 'text',
    success: function(res) {
        if (res.length == 0){
           E("Conftxt").value = "配置文件为空，请开启frps..."; 
        }else{ $('#Conftxt').val(res); }
		}
	});
}
function open_file(open_file) {
	if (open_file == "frpslogfile") {
		get_frpslogfile();
	}
	if (open_file == "frpsConf") {
		get_frpsConf();
	}
	$("#" + open_file).fadeIn(200);
}
function close_file(close_file) {
	$("#" + close_file).fadeOut(200);
}
//刷新网页更新显示状态
function update_visibility(){
	if(!db_frps["frps_ifopenport"]){
		E("tcp_ports_tr").style.display = "none";
		E("udp_ports_tr").style.display = "none";
	}else{
		E("tcp_ports_tr").style.display = "";
		E("udp_ports_tr").style.display = "";
	}
	if(!db_frps["frps_common_log__to"] || db_frps["frps_common_log__to"] == "/dev/null" || db_frps["frps_common_log__to"] == "console"){
	    E("log_level_tr").style.display = "none";
		E("log_maxDays_tr").style.display = "none";
	}else{
        E("log_level_tr").style.display = "";
        E("log_maxDays_tr").style.display = "";
    }
	if(!db_frps["frps_common_webServer__port"]){
	    E("webServerAddr_tr").style.display = "none";
		E("webServerUser_tr").style.display = "none";
		E("webServerPwd_tr").style.display = "none";
	}else{
		E("webServerAddr_tr").style.display = "";
		E("webServerUser_tr").style.display = "";
		E("webServerPwd_tr").style.display = "";
	}
}
function openssHint(itemNum){
    statusmenu = "";
    width="350px";

    if(itemNum == 0){
        statusmenu ="如果发现开关不能开启，那么请检查<a href='Advanced_System_Content.asp'><u><font color='#00F'>系统管理 -- 系统设置</font></u></a>页面内Enable JFFS custom scripts and configs是否开启。";
        _caption = "服务说明";
    }
    else if(itemNum == 1){
        statusmenu ="服务器的监控面板端口，不设定端口无法使用面板功能";
        _caption = "webServer.port字段";
    }
    else if(itemNum == 2){
        statusmenu ="服务器的服务端口。注：留空是默认的TCP 7000端口，客户端可以根据需要配置是否连接(依据指定的底层通信协议类型)。";
        _caption = "bindPort字段";
    }
    else if(itemNum == 3){
        statusmenu ="服务器的特权授权码，客户端必须配置相同才能连接。<br/><font color='#F46'>注意：</font>使用带有特殊字符的密码，可能会导致frpc连接不上服务器。";
        _caption = "auth.token字段";
    }
    else if(itemNum == 4){
        statusmenu ="服务器虚拟主机HTTP和HTTPS端口，留空即表示不开启。<font color='#F46'>注意：</font>frpc 默认开启 TLS 和 禁用第一个TLS自定义字节 功能，若不调整设置，HTTPS可能不能端口复用，请查阅官方文档。";
        _caption = "vhostHTTPPort 和 vhostHTTPSPort字段";
    }
    else if(itemNum == 5){
        statusmenu ="显示Frps是否正常运行，并显示进程PID";
        _caption = "运行状态";
    }
    else if(itemNum == 6){
        statusmenu ="是否开启日志保存。默认为空，即console<br/>①控制台（console），日志输出到标准输出。但插件会丢弃标准输出及错误信息，无法读取；<br/>②文件，日志保存到【/tmp/frps.log】。插件也会重定向标准输出及错误信息给它，均可读取；<br/>③黑洞（/dev/null），日志被丢弃。但插件会重定向标准输出及错误信息至临时文件，可读取。";
        _caption = "log.to字段";
    }
    else if(itemNum == 7){
        statusmenu ="选择日志记录等级，留空默认info。<br/>可选内容(依次)：trace, debug, info, warn, error。其中error级别信息量最少。";
        _caption = "log.level字段";
    }
    else if(itemNum == 8){
        statusmenu ="要保留日志记录文件的天数(不含当天)，留空，默认3天。在log.to配置的目录可以找到按日期命名的文件，一天一个。";
        _caption = "log.maxDays字段";
    }
    else if(itemNum == 9){
        statusmenu ="最大连接池数量，留空即默认5。<br/>当为指定的代理启用连接池后，frp 会预先和后端服务建立起指定数量的连接，每次接收到用户请求后，会从连接池中取出一个连接和用户连接关联起来，避免了等待与后端服务建立连接以及 frpc 和 frps 之间传递控制信息的时间";
        _caption = "transport.maxPoolCount字段";
    }
    else if(itemNum == 10){
        statusmenu ="定时执行操作。<font color='#F46'>检查：</font>检查frp的进程是否存在，若不存在则重新启动；<font color='#F46'>启动：</font>重新启动frp进程，而不论当时是否在正常运行。重新启动服务可能导致活动中的连接短暂中断.<br/><font color='#F46'>注意：</font>填写内容为 0 关闭定时功能！<br/>建议：选择分钟填写“60的因数”【1、2、3、4、5、6、10、12、15、20、30、60】，选择小时填写“24的因数”【1、2、3、4、6、8、12、24】。";
        _caption = "定时功能";
    }
    else if(itemNum == 11){
        statusmenu ="面板登录用户名";
        _caption = "webServer.user字段";
    }
    else if(itemNum == 12){
        statusmenu ="面板登录密码";
        _caption = "webServer.password字段";
    }
    else if(itemNum == 13){
        statusmenu ="默认启用，如需关闭，可以在 frps 和 frpc 中配置，该配置项在服务端和客户端必须一致.<br/><strong>多路复用</strong>：不再需要为每一个用户请求创建一个连接，使连接建立的延迟降低，并且避免了大量文件描述符的占用，使 frp 可以承载更高的并发数。";
        _caption = "transport.tcpMux字段";
    }
    else if(itemNum == 14){
        statusmenu ="强制frps只接受开启TLS加密的frpc连接，默认关闭";
        _caption = "transport.tls.force字段";
    }
    else if(itemNum == 15){
        statusmenu ="监听UDP端口，用于接收采用quic协议的frpc，留空，表示frps不启用quic（quic/kcp端口不要冲突）。";
        _caption = "quicBindPort字段";
    }
    else if(itemNum == 16){
        statusmenu ="监听UDP端口，用于接收采用kcp协议的frpc，留空，表示frps不启用kcp（quic/kcp端口不要冲突）.";
        _caption = "kcpBindPort字段";
    }
    else if(itemNum == 17){
        statusmenu ="允许代理绑定的服务端端口列表，默认留空（不限制）。<br/>格式可简写，<strong>例如</strong>：1000-2000 2001 3000-4000 （英文的中横线和空格），后台会转换为标准格式";
        _caption = "allowPorts 字段";
    }
    else if(itemNum == 18){
        statusmenu ="输入frp参数语句，格式必须正确，内容将追加到frps配置文件的后面。<br/><font color='#F46'>部分追加</font>：必须使用TOML格式参数且勿重复配置，上表格某个参数留空后，才能在此重设。<br/><font color='#F46'>完整追加</font>：将<strong>上表格的全部参数留空后，追加完整的配置文件</strong>，视Frp版本而定，可能支持：INI/TOML/YAML/JSON 格式。INI/TOML/YAML 格式请使用 # 符号注释, JSON格式未知。具体参看frp官方文档。";
        _caption = "附加其他参数";
    }
    else if(itemNum == 19){
        statusmenu ="按需填写，打开从外部访问服务器的端口。例如 bindPort、http/https等TCP端口，以及KCP、QUIC协议等UDP端口。还可额外打开备用端口，用于frpc客户端配置tcp/udp等代理的“远程端口remotePort”参数。设置时端口号用<font color='#F46'>空格隔开连续填写</font>。例如：8080 443 992";
        _caption = "通过防火墙的端口号";
    }
    else if(itemNum == 20){
        statusmenu ="若要开启WAN口端口通信，请选择端口的类型（IPv4或IPv6），再填写端口列表，对应的通信可通过防火墙入站。";
        _caption = "开启端口通过防火墙";
    }
    else if(itemNum == 21){
        statusmenu ="默认留空。若subDomainHost不为空，例如frps.com；可在frpc中对类型为http/https的代理设置subdomain，若设为test，路由将使用test.frps.com。";
        _caption = "subDomainHost字段";
    }
    else if(itemNum == 22){
        statusmenu ="服务器管理面板绑定地址。留空默认 127.0.0.1（限本机访问），要远程访问，请按需设置。";
        _caption = "webServer.addr字段";
    }
    else if(itemNum == 23){
        statusmenu ="服务器绑定地址。留空默认 0.0.0.0（即所有地址，含IPv6）";
        _caption = "bindAddr字段";
    }
        return overlib(statusmenu, OFFSETX, -160, LEFT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');

    var tag_name= document.getElementsByTagName('a');
    for (var i=0;i<tag_name.length;i++)
        tag_name[i].onmouseout=nd;

    if(helpcontent == [] || helpcontent == "" || hint_array_id > helpcontent.length)
        return overlib('<#defaultHint#>', HAUTO, VAUTO);
    else if(hint_array_id == 0 && hint_show_id > 21 && hint_show_id < 24)
        return overlib(helpcontent[hint_array_id][hint_show_id], FIXX, 270, FIXY, 30);
    else{
        if(hint_show_id > helpcontent[hint_array_id].length)
            return overlib('<#defaultHint#>', HAUTO, VAUTO);
        else
            return overlib(helpcontent[hint_array_id][hint_show_id], HAUTO, VAUTO);
    }
}
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<div id="LoadingBar" class="popup_bar_bg_ks" style="z-index: 200;" >
		<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
			<tr>
				<td height="100">
				<div id="loading_block_title" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
				<div id="loading_block_spilt" style="margin:10px 0 10px 5px;" class="loading_block_spilt"></div>
				<div style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
					<textarea cols="50" rows="26" wrap="off" readonly="readonly" id="log_content" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:transparent;color:#FFFFFF;outline: none;padding-left:3px;padding-right:22px;overflow-x:auto"></textarea>
				</div>
				<div id="ok_button" class="apply_gen" style="background: #000;visibility:hidden;">
					<input id="ok_button1" class="button_gen" type="button" onclick="hideWBLoadingBar()" value="确定">
				</div>
				</td>
			</tr>
		</table>
	</div>
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
						    
						    <div id="frpslogfile"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                <div style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;">【frps】运行日志 / 标准输出</div>
                                <div style="margin-left:15px"><i>&nbsp;1、文本不会自动刷新，需配置日志输出且仅看当天。来自软链接【/tmp/upload/frps_lnk.log】。</i></div>
                                <div style="margin-left:15px"><i>&nbsp;2、若使用 “追加其他参数” 方式配置日志输出参数（上表格参数须留空），请注意：<br>&nbsp;&nbsp;&nbsp;①&nbsp;“键名” 关键词只出现一次，不要出现多次（无论是否注释）；<br>&nbsp;&nbsp;&nbsp;②&nbsp;“键值” 指定的文件路径在可写文件系统上。</i></div>
                                <div id="loading_block_spilt" style="margin:10px 0 10px 5px;" class="loading_block_spilt"></div>
                                <div style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
                                    <textarea cols="50" rows="26" wrap="off" readonly="readonly" id="logfiletxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #000;font-family:'Courier New', Courier, mono; font-size:11px;background:#000000;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                </div>
                                <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                        <input id="edit_node1" class="button_gen" type="button" onclick="close_file('frpslogfile');" value="返回主界面">&nbsp;&nbsp;
                                        <input class="button_gen" type="button" onclick="close_file('frpslogfile');clear_log();" value="清空日志">
                                </div>
                            </div>
                            <div id="frpsConf"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                <div style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;">【frps】配置文件</div>
                                <div style="margin-left:15px"><i>&nbsp;启动服务时生成，位置【/tmp/upload/.frps.toml】。</i></div>
                                <div id="loading_block_spilt2" style="margin:10px 0 10px 5px;" class="loading_block_spilt"></div>
                                <div style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
                                    <textarea cols="50" rows="26" wrap="off" readonly="readonly" id="Conftxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #000;font-family:'Courier New', Courier, mono; font-size:11px;background:#000000;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                </div>
                                <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node2" class="button_gen" type="button" onclick="close_file('frpsConf');" value="返回主界面">
                                </div>
                            </div>
						    
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div class="formfonttitle">Frps内网穿透服务器<lable id="frps_version_show"><lable></div>
										<div style="float:right; width:15px; height:25px;margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="formfontdesc">
											<span>frp 是一个专注于内网穿透的高性能的反向代理应用，支持 TCP、UDP、HTTP、HTTPS 等多种协议。可以将内网服务以安全、便捷的方式通过具有公网 IP 节点的中转暴露到公网。【仓库链接：<a href="https://github.com/fatedier/frp" target="_blank"><em><u>Github</u></em></a>】【中文文档：<a href="https://gofrp.org/zh-cn/docs/" target="_blank"><em><u>gofrp.org</u></em></a>】<br>(<i>点击左侧项目的文字，可查看帮助信息</i>)</span>
										</div>
										<div id="frps_main">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr id="switch_tr">
													<th>
														<label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(0)">开启Frps</a></label>
													</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="frps_enable">
																<input id="frps_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container" >
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
														<div style="float: left;margin-top:5px;margin-left:30px;">
															<a type="button" class="ks_btn" href="javascript:void(0);" onclick="open_file('frpsConf');" style="cursor: pointer">配置文件</a>&nbsp;&nbsp;&nbsp;
															<a type="button" class="ks_btn" href="javascript:void(0);" onclick="get_log(1)" style="cursor: pointer">插件日志</a>&nbsp;&nbsp;&nbsp;
															<a type="button" class="ks_btn" href="javascript:void(0);" onclick="open_file('frpslogfile');" style="cursor: pointer">运行日志</a>
														</div>
													</td>
												</tr>
												
												<th style="width:25%;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(5)">运行状态</a></th>
												<td>
													<div id="frps_status"><i><span id="status">获取中...</span></i></div>
												</td>
												
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(10)">定时功能(<i>0为关闭</i>)</a></th>
													<td>
														每
														<input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '')" id="frps_cron_time" name="frps_cron_time" class="input_ss_table" style="width:30px" maxlength="2" value="30" placeholder="" />
														<select id="frps_cron_hour_min" name="frps_cron_hour_min" style="width:60px;vertical-align: middle;" class="input_option">
															<option value="min">分钟</option>
															<option value="hour">小时</option>
														</select>
														重新
														<select id="frps_cron_type" name="frps_cron_type" style="width:60px;vertical-align: middle;" class="input_option">
															<option value="watch">检查</option>
															<option value="start">启动</option>
														</select>一次服务
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(20)">开启端口通过防火墙...</a></th>
													<td>
														<select id="frps_ifopenport" name="frps_ifopenport" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
															<option value="">-否-</option>
															<option value="v4">IPv4</option>
															<option value="v6">IPv6</option>
															<option value="both">IPv4+IPv6</option>
														</select>
													</td>
												</tr>
												<tr id="tcp_ports_tr" style="display: none;">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(19)">TCP端口号列表</a></th>
													<td>
													    <input type="text" oninput="this.value=this.value.replace(/[^\d ]/g, '')" class="input_ss_table" id="frps_openports" name="frps_openports" maxlength="150" value="" placeholder="用空格隔开" />
													</td>
												</tr>
												<tr id="udp_ports_tr" style="display: none;">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(19)">UDP端口号列表</a></th>
													<td>
													    <input type="text" oninput="this.value=this.value.replace(/[^\d ]/g, '')" class="input_ss_table" id="frps_openports_u" name="frps_openports_u" maxlength="150" value="" placeholder="用空格隔开" />
													</td>
												</tr>
											</table>
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="margin-top:8px;">
												<thead>
													  <tr>
														<td colspan="2">Frps 参数设置</td>
													  </tr>
												</thead>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(23)">绑定地址</a></th>
													<td>
												<input type="text" class="input_ss_table" id="frps_common_bindAddr" name="frps_common_bindAddr" maxlength="99" value="" placeholder="0.0.0.0" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(2)">绑定端口</a></th>
													<td>
												<input type="text" oninput="this.value=this.value.replace(/[^\d-]/g, ''); if(value>65535)value=65535" class="input_ss_table" id="frps_common_bindPort" name="frps_common_bindPort" maxlength="6" value="" placeholder="7000" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(3)">令牌token</a></th>
													<td>
														<input type="password" name="frps_common_auth__token" id="frps_common_auth__token" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="75" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);" placeholder="认证码" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(13)">TCP 多路复用</a></th>
													<td>
														<select id="frps_common_transport__tcpMux" name="frps_common_transport__tcpMux" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
															<option value="">-空-</option>
															<option value="true">启用</option>
															<option value="false">关闭</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(16)">KCP绑定端口</a></th>
													<td>
												<input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" class="input_ss_table" id="frps_common_kcpBindPort" name="frps_common_kcpBindPort" maxlength="5" value="" placeholder="可选" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(15)">QUIC绑定端口</a></th>
													<td>
												<input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" class="input_ss_table" id="frps_common_quicBindPort" name="frps_common_quicBindPort" maxlength="5" value="" placeholder="可选" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(17)">允许的端口列表</a></th>
													<td>
												<input type="text" class="input_ss_table" id="frps_common_allowPorts" name="frps_common_allowPorts" maxlength="150" value="" placeholder="点击参数文字看帮助" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(4)">虚拟主机HTTP端口</a></th>
													<td>
														<input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" class="input_ss_table" id="frps_common_vhostHTTPPort" name="frps_common_vhostHTTPPort" maxlength="5" value="" placeholder="可选" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(4)">虚拟主机HTTPS端口</a></th>
													<td>
														<input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" class="input_ss_table" id="frps_common_vhostHTTPSPort" name="frps_common_vhostHTTPSPort" maxlength="5" value="" placeholder="可选" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(21)">子域名后缀</a></th>
													<td>
													    <input type="text" class="input_ss_table" id="frps_common_subDomainHost" name="frps_common_subDomainHost" maxlength="75" value="" placeholder="可选"/>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(9)">最大连接池数量</a></th>
													<td>
													    <input type="text" oninput="this.value=this.value.replace(/[^\d-]/g, '')" class="input_ss_table" id="frps_common_transport__maxPoolCount" name="frps_common_transport__maxPoolCount" maxlength="4" value="" placeholder="5"/>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(14)">强制只接受TLS连接</a></th>
													<td>
														<select id="frps_common_transport__tls__force" name="frps_common_transport__tls__force" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
														    <option value="">-空-</option>
														    <option value="false">关闭</option>
															<option value="true">启用</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(6)">日志输出记录...</a></th>
													<td>
                                                    <select id="frps_common_log__to" name="frps_common_log__to" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                        <option value="">-空-</option>
                                                        <option value="/tmp/frps.log">文件（/tmp/frps.log）</option>
                                                        <option value="/dev/null">黑洞（/dev/null）</option>
                                                        <option value="console">控制台（console）</option>
                                                    </select>
                                                    </td>
												</tr>
												<tr id="log_level_tr" style="display: none;">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(7)">日志级别</a></th>
													<td>
														<select id="frps_common_log__level" name="frps_common_log__level" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
															<option value="">-空-</option>
															<option value="error">error</option>
															<option value="warn">warn</option>
															<option value="info">info</option>
															<option value="debug">debug</option>
															<option value="trace">trace</option>
														</select>
													</td>
												</tr>
												<tr id="log_maxDays_tr" style="display: none;">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(8)">日志文件保留天数</a></th>
													<td>
													    <input type="text" oninput="this.value=this.value.replace(/[^\d-]/g, '')" class="input_ss_table" id="frps_common_log__maxDays" name="frps_common_log__maxDays" maxlength="3" value="" placeholder="3" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(1)">管理面板端口...</a></th>
													<td>
														<input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" class="input_ss_table" value="" id="frps_common_webServer__port" name="frps_common_webServer__port" maxlength="5" value="" placeholder="留空，关闭面板" />
													</td>
												</tr>
												<tr id="webServerAddr_tr" style="display: none;">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(22)">管理面板地址</a></th>
													<td>
												<input type="text" class="input_ss_table" id="frps_common_webServer__addr" name="frps_common_webServer__addr" maxlength="99" value="" placeholder="127.0.0.1" />
													</td>
												</tr>
												<tr id="webServerUser_tr" style="display: none;">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(11)">管理面板用户名</a></th>
													<td>
												<input type="text" class="input_ss_table" id="frps_common_webServer__user" name="frps_common_webServer__user" maxlength="50" value="" placeholder="可选" />
													</td>
												</tr>
												<tr id="webServerPwd_tr" style="display: none;">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(12)">管理面板密码</a></th>
													<td>
														<input type="password" name="frps_common_webServer__password" id="frps_common_webServer__password" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="75" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);" placeholder="可选" />
													</td>
												</tr>
												<tr>
                                                <th style="width:20%;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(18)">追加其他参数</a><br>
                                                    <label><input type="checkbox" id="frps_extra_config" name="frps_extra_config"><i>启用追加</i>
                                                </th>
                                                <td>
                                                    <textarea cols="63" rows="10" wrap="off" id="frps_extra_options" name="frps_extra_options" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="font-size:11px;background:#475A5F;color:#FFFFFF" placeholder="# 上述表格某个参数留空后，才可在此重设（TOML）&#13;# 上述表格全部留空后，视Frp版本，可使用格式（TOML/YAML/JSON/INI）&#13;# 通常INI/TOML/YAML格式使用 # 符号注释, JSON格式未知&#10;&#10;# 举例：管理面板开启TLS参考：&#10;webServer.tls.certFile = &#34;/tmp/etc/cert.pem&#34;&#10;webServer.tls.keyFile = &#34;/tmp/etc/key.pem&#34;" ></textarea>
                                                </td>
                                            </tr>
												
											</table>
										</div>
										<div class="apply_gen">
											<input class="button_gen" id="cmdBtn" onClick="save()" type="button" value="提交" />
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="formbottomdesc">
											<span>* <i>注意事项</i>：</span>
											<li>1. 搭建环境：IPv4需要公网IP；IPv6可以直接搭建（用IPv6访问）</li>
											<li>2. 为了Frps稳定运行，强烈建议开启虚拟内存</li>
											<li>3. 点击左侧项目的文字，可查看<i>帮助信息</i></li>
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<div id="footer"></div>
</body>
</html>

