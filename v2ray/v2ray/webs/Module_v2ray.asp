<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html xmlns:v>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<title>软件中心 - v2ray</title>
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="index_style.css">
<link rel="stylesheet" type="text/css" href="form_style.css">
<link rel="stylesheet" type="text/css" href="usp_style.css">
<link rel="stylesheet" type="text/css" href="/calendar/fullcalendar.css">
<link rel="stylesheet" type="text/css" href="/device-map/device-map.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/calendar/jquery-ui.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/ss-menu.js"></script>
<script type="text/javascript" src="/dbconf?p=v2ray&v=<% uptime(); %>"></script>
<style>
#selectable .ui-selecting { background: #FECA40; }
#selectable .ui-selected { background: #F39814; color: white; }
#selectable .ui-unselected { background: gray; color: green; }
#selectable .ui-unselecting { background: green; color: black; }
#selectable { border-spacing:0px; margin-left:0px;margin-top:0px; padding: 0px; width:100%;}
#selectable td { height: 22px; }
.parental_th{
color:white;
background:#2F3A3E;
cursor: pointer;
width:160px;
height:22px;
border-bottom:solid 1px black;
border-right:solid 1px black;
}
.parental_th:hover{
background:rgb(94, 116, 124);
cursor: pointer;
}
.checked{
background-color:#9CB2BA;
width:82px;
border-bottom:solid 1px black;
border-right:solid 1px black;
}
.disabled{
width:82px;
border-bottom:solid 1px black;
border-right:solid 1px black;
}
#switch_menu{
text-align:right
}
#switch_menu span{
/*border:1px solid #222;*/
border-radius:4px;
font-size:16px;
padding:3px;
}
/*#switch_menu span:hover{
box-shadow:0px 0px 5px 3px white;
background-color:#97CBFF;
}*/
.click:hover{
box-shadow:0px 0px 5px 3px white;
background-color:#97CBFF;
}
.clicked{
background-color:#2894FF;
box-shadow:0px 0px 5px 3px white;
}
.click{
background:#8E8E8E;
}
.contentM_qis{
position:absolute;
-webkit-border-radius: 5px;
-moz-border-radius: 5px;
border-radius: 5px;
z-index:200;
background-color:#2B373B;
display:none;
margin-left: 32%;
top: 250px;
}
</style>
<script>
var _responseLen;
function initial(){
show_menu(menu_hook);
show_footer();
get_log();
verifyFields();
update_v2ray_ui(db_v2ray);
}
function update_v2ray_ui(obj) {
	for (var field in obj) {
		var el = E(field);

		if (el != null && el.getAttribute("type") == "checkbox") {
			if (obj[field] != "1") {
				el.checked = false;
			} else {
				el.checked = true;
			}
			continue;
		}

		if (el != null) {
			el.value = obj[field];
		}
	}
	//E("v2ray_json").value = do_js_beautify(Base64.decode(E("v2ray_json").value));
}
function isJSON(str) {
	if (typeof str == 'string' && str) {
		try {
			var obj = JSON.parse(str);
			if (typeof obj == 'object' && obj) {
				return true;
			} else {
				return false;
			}
		} catch (e) {
			console.log('error：' + str + '!!!' + e);
			return false;
		}
	}
	//console.log('It is not a string!')
}
function applyRule() {
if (E("v2ray_use_json").checked == true){
			if(E('v2ray_json').value.indexOf("vmess://") != -1){
				var vmess_node = JSON.parse(Base64.decode(E('v2ray_json').value.split("//")[1]));
				console.log("use v2ray vmess://");
				console.log(vmess_node);
				document.form.v2ray_server.value = vmess_node.add;
				document.form.v2ray_port.value = vmess_node.port;
				document.form.v2ray_uuid.value = vmess_node.id;
				document.form.v2ray_security.value = "auto";
				document.form.v2ray_alterid.value = vmess_node.aid;
				document.form.v2ray_network.value = vmess_node.net;
				if(vmess_node.net == "tcp"){
					document.form.v2ray_headtype_tcp.value= vmess_node.type;
				}else if(vmess_node.net == "kcp"){
					document.form.v2ray_headtype_kcp.value = vmess_node.type;
				}
				document.form.v2ray_network_host.value = vmess_node.host;
				document.form.v2ray_network_path.value = vmess_node.path;
				if(vmess_node.tls == "tls"){
					document.form.v2ray_network_security.value = "tls";
				}else{
					document.form.v2ray_network_security.value = "none";
				}
				document.form.v2ray_mux_enable.value = 1;
				document.form.v2ray_use_json.value = 0;
				document.form.v2ray_json.value = "";
			}
			else if(isJSON(E('v2ray_json').value)){
				if(E('v2ray_json').value.indexOf("outbound") != -1){
					document.form.v2ray_json.value = Base64.encode(pack_js(E('v2ray_json').value));
				}else{
					alert("错误！你的json配置文件有误！\n正确格式请参考:https://www.v2ray.com/chapter_02/01_overview.html");
					return false;
				}
			}else{
				alert("错误！检测到你输入的v2ray配置不是标准json格式！");
				return false;
			}
}
showLoading(5);
document.form.submit();
}
function reload_Soft_Center() {
	location.href = "/Main_Soft_center.asp";
}
$(document).ready(function () {
$('#radio_v2ray_enable').iphoneSwitch(document.form.v2ray_enable.value,
function(){
document.form.v2ray_enable.value = "1";
},
function(){
document.form.v2ray_enable.value = "0";
}
);
});
$(document).ready(function () {
$('#radio_v2ray_udp_enable').iphoneSwitch(document.form.v2ray_udp_enable.value,
function(){
document.form.v2ray_udp_enable.value = "1";
},
function(){
document.form.v2ray_udp_enable.value = "0";
}
);
});
function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装", "V2RAY");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_v2ray.asp");
}
function get_log() {
	$.ajax({
		url: '/res/v2ray_log.htm',
		dataType: 'html',
		success: function(response) {
			var retArea = document.getElementById("log_content1");
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}
			if (noChange > 6000) {
				//retArea.value = "当前日志文件为空";
				return false;
			} else {
				setTimeout("get_log();",400);
			}
			retArea.innerHTML = response
			_responseLen = response.length;
			if (retArea.value == "") {
				document.getElementById("log_content1").value = "暂无日志信息！";
			}
		},
		error: function(xhr) {
			//setTimeout("get_log();", 1000);
			document.getElementById("log_content1").value = "暂无日志信息！";
		}
	});
}
function done_validating() {
	return true;
}
function verifyFields(r) {
	var v2ray_on = true;
	//v2ray
	var json_on = E("v2ray_use_json").checked == true;
	var json_off = E("v2ray_use_json").checked == false;
	var http_on = E("v2ray_network").value == "tcp" && E("v2ray_headtype_tcp").value == "http";
	var host_on = E("v2ray_network").value == "ws" || E("v2ray_network").value == "h2" || http_on;
	var path_on = E("v2ray_network").value == "ws" || E("v2ray_network").value == "h2";
	showhide("v2ray_use_json_basic_tr", v2ray_on);
	showhide("v2ray_uuid_basic_tr", (v2ray_on && json_off));
	showhide("v2ray_alterid_basic_tr", (v2ray_on && json_off));
	showhide("v2ray_security_basic_tr", (v2ray_on && json_off));
	showhide("v2ray_network_basic_tr", (v2ray_on && json_off));
	showhide("v2ray_headtype_tcp_basic_tr", (v2ray_on && json_off && E("v2ray_network").value == "tcp"));
	showhide("v2ray_headtype_kcp_basic_tr", (v2ray_on && json_off && E("v2ray_network").value == "kcp"));
	showhide("v2ray_network_host_basic_tr", (v2ray_on && json_off && host_on));
	showhide("v2ray_network_path_basic_tr", (v2ray_on && json_off && path_on));
	showhide("v2ray_network_security_basic_tr", (v2ray_on && json_off));
	showhide("v2ray_mux_enable_basic_tr", (v2ray_on && json_off));
	showhide("v2ray_json_basic_tr", (v2ray_on && json_on));

	//node add/edit pannel
		if(E("v2ray_use_json").checked){
			E('v2ray_server_support_tr').style.display = "none";
			E('v2ray_port_support_tr').style.display = "none";
			E('v2ray_uuid_basic_tr').style.display = "none";
			E('v2ray_alterid_basic_tr').style.display = "none";
			E('v2ray_security_basic_tr').style.display = "none";
			E('v2ray_network_basic_tr').style.display = "none";
			E('v2ray_headtype_tcp_basic_tr').style.display = "none";
			E('v2ray_headtype_kcp_basic_tr').style.display = "none";
			E('v2ray_network_path_basic_tr').style.display = "none";
			E('v2ray_network_host_basic_tr').style.display = "none";
			E('v2ray_network_security_basic_tr').style.display = "none";
			E('v2ray_mux_enable_basic_tr').style.display = "none";
			E('v2ray_json_basic_tr').style.display = "";
		}else{
			E('v2ray_server_support_tr').style.display = "";
			E('v2ray_port_support_tr').style.display = "";
			E('v2ray_uuid_basic_tr').style.display = "";
			E('v2ray_alterid_basic_tr').style.display = "";
			E('v2ray_security_basic_tr').style.display = "";
			E('v2ray_network_basic_tr').style.display = "";
			E('v2ray_headtype_tcp_basic_tr').style.display = "";
			E('v2ray_headtype_kcp_basic_tr').style.display = "";
			E('v2ray_network_path_basic_tr').style.display = "";
			E('v2ray_network_host_basic_tr').style.display = "";
			E('v2ray_network_security_basic_tr').style.display = "";
			E('v2ray_mux_enable_basic_tr').style.display = "";
			E('v2ray_json_basic_tr').style.display = "none";
			var http_on_2 = E("v2ray_network").value == "tcp" && E("v2ray_headtype_tcp").value == "http";
			var host_on_2 = E("v2ray_network").value == "ws" || E("v2ray_network").value == "h2" || http_on_2;
			var path_on_2 = E("v2ray_network").value == "ws" || E("v2ray_network").value == "h2"
			showhide("v2ray_headtype_tcp_basic_tr", (E("v2ray_network").value == "tcp"));
			showhide("v2ray_headtype_kcp_basic_tr", (E("v2ray_network").value == "kcp"));
			showhide("v2ray_network_host_basic_tr", host_on_2);
			showhide("v2ray_network_path_basic_tr", path_on_2);
			showhide("v2ray_json_basic_tr", (E("v2ray_use_json").checked));
		}
}
</script></head>
<body onload="initial();" onunload="unload_body();" onselectstart="return false;">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" action="/applydb.cgi?p=v2ray" target="hidden_frame">
<input type="hidden" name="productid" value="<% nvram_get("productid"); %>">
<input type="hidden" name="current_page" value="Module_v2ray.asp">
<input type="hidden" name="next_page" value="Module_v2ray.asp">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_wait" value="2">
<input type="hidden" name="action_mode" value="toolscript">
<input type="hidden" name="action_script" value="v2ray_config.sh">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>" disabled>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
<input type="hidden" name="v2ray_enable" value="<% dbus_get_def('v2ray_enable', '0'); %>">
<input type="hidden" name="v2ray_udp_enable" value="<% dbus_get_def('v2ray_udp_enable', '0'); %>">
<input type="hidden" name="ss_china_state" value="<% nvram_get('ss_china_state'); %>">
<input type="hidden" name="ss_foreign_state" value="<% nvram_get('ss_foreign_state'); %>">
<input type="hidden" name="v2ray_dns" value="<% dbus_get_def('v2ray_dns', '0'); %>">
<input type="hidden" name="v2ray_use_json" value="<% dbus_get_def('v2ray_use_json', '0'); %>">
<input type="hidden" name="v2ray_json" value="<% dbus_get_def('v2ray_json', ''); %>">
<table class="content" align="center" cellpadding="0" cellspacing="0" >
<tr>
<td width="17">&nbsp;</td>
<td valign="top" width="202">
<div id="mainMenu"></div>
<div id="subMenu"></div>
</td>
<td valign="top">
<div id="tabMenu" class="submenuBlock"></div>
<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0" >
<tr>
<td valign="top" >
<table width="730px" border="0" cellpadding="4" cellspacing="0" class="FormTitle" id="FormTitle">
<tbody>
<tr>
<td bgcolor="#4D595D" valign="top">
<div>&nbsp;</div>
<div style="margin-top:-5px;">
<table width="730px">
<tr>
<td align="left" >
<div id="content_title" class="formfonttitle" style="width:400px"> v2ray</div>
            <div style="float:right; width:15px; height:25px;margin-top:10px">
             <img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
            </div>
</td>
</tr>
</table>
<div style="margin:0px 0px 10px 5px;"><img src="/images/New_ui/export/line_export.png"></div>
</div>
<div id="PC_desc">
<table width="700px" style="margin-left:25px;">
<tr>
<td>
<div id="guest_image" style="background: url(res/icon-v2ray.png);width: 60px;height: 60px;"></div>
</td>
<td>&nbsp;&nbsp;</td>
<td style="font-size: 14px;">
<span id="desc_title">使用步骤：</span>
<ol>
<li>挂载虚拟内存</li>
<li>然后自行获取服务器参数</li>
<li>最后填写配置或在自定义配置里粘贴配置</li>
</ol>
<span id="desc_note" style="color:#FC0;">注意：</span>
<ol style="color:#FC0;margin:-5px 0px 3px -18px;*margin-left:18px;">
<li>测试版，不保证各项功能正常</li>
<li>所有别名及参数中不允许有">"字符。仅dns2socks模式socks5代理端口：23456 (待测) </li>
<li>本地代理必须为默认:协议socks端口1080</li>
</ol>
</td>
</tr>
</table>
</div>
<div id="edit_time_anchor"></div>
<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
<tr>
<th id="PC_enable">启用V2ray</th>
<td>
<div align="center" class="left" style="width:94px; float:left; cursor:pointer;" id="radio_v2ray_enable"></div>
<div class="iphone_switch_container" style="height:32px; width:74px; position: relative; overflow: hidden">
<script type="text/javascript">
$('#radio_v2ray_enable').iphoneSwitch('<% dbus_get_def("v2ray_enable", "0"); %>',
function(){
document.form.v2ray_enable.value = 1;
},
function(){
document.form.v2ray_enable.value = 0;
}
);
</script>
</div>
</td>
</tr>
</table>
<table id="list_table" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" >
<tr>
<td valign="top" align="center">
<div id="VSList_Block"></div>
<div >
<table width="100%" border="1" cellspacing="0" cellpadding="4" class="FormTable">
<tr>
<th width="20%">UDP转发</th>
<td align="left">
<div align="center" class="left" style="width:94px; float:left; cursor:pointer;" id="radio_v2ray_udp_enable"></div>
<div class="iphone_switch_container" style="height:32px; width:74px; position: relative; overflow: hidden">
<script type="text/javascript">
$('#radio_v2ray_udp_enable').iphoneSwitch('<% dbus_get_def("v2ray_udp_enable", "0"); %>',
function(){
document.form.v2ray_udp_enable.value = 1;
},
function(){
document.form.v2ray_udp_enable.value = 0;
}
);
</script>
</div>
</td>
</tr>
<tr>
<th>运行模式</th>
<td>
<select name="v2ray_mode" class="input_option input_15_table">
<option value="0" <% dbus_match( "v2ray_mode", "0","selected"); %>>国外代理模式</option>
<option value="1" <% dbus_match( "v2ray_mode", "1","selected"); %>>GFW列表模式</option>
<option value="2" <% dbus_match( "v2ray_mode", "2","selected"); %>>全局代理模式</option>
</select>
</td>
</tr>
<tr>
<th>DNS解析方式</th>
<td>
<select name="v2ray_dnsmode" class="input_option input_15_table">
<option value="0" <% dbus_match( "v2ray_dnsmode", "0","selected"); %>>远程解析模式</option>
<option value="1" <% dbus_match( "v2ray_dnsmode", "1","selected"); %>>Pdnsd解析模式</option>
<option value="2" <% dbus_match( "v2ray_dnsmode", "2","selected"); %>>dns2socks模式</option>
</select>
<a href="http://www.ip111.cn/" target=_blank>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;【 分流检测 】</a>
</td>
</tr>
<tr>
<th>国外DNS</th>
<td>
<select name="v2ray_dns" class="input_option input_15_table">
<option value="0" <% dbus_match( "v2ray_dns", "0","selected"); %>>opendns</option>
<option value="1" <% dbus_match( "v2ray_dns", "1","selected"); %>>googledns</option>
</select>
</td>
</tr>
<tr id="v2ray_use_json_basic_tr">
<th width="35%">使用json配置</th>
<td>
<input type="checkbox" id="v2ray_use_json" name="v2ray_use_json" onclick="verifyFields(this, 1);" value="<% dbus_get_def('v2ray_use_json', '0'); %>">
</td>
</tr>
<tr id="v2ray_server_support_tr" style="display: none;">
<th width="20%">地址（address）</th>
<td align="left">
<input type="text" maxlength="64" id="v2ray_server" name="v2ray_server" value="<% dbus_get_def('v2ray_server', 'abc.abc.abc'); %>" class="input_ss_table" style="width:342px;float:left;background-color: #475A5F;color:#FFFFFF;" autocorrect="off" autocapitalize="off"/>
</td>
</tr>
<tr id="v2ray_port_support_tr" style="display: none;">
<th width="20%">端口（port）</th>
<td align="left">
<input type="text" maxlength="64" id="v2ray_port" name="v2ray_port" value="<% dbus_get_def('v2ray_port', '12345'); %>" class="input_ss_table" style="width:342px;float:left;background-color: #475A5F;color:#FFFFFF;" autocomplete="off" autocorrect="off" autocapitalize="off"/>
</td>
</tr>
<tr id="v2ray_uuid_basic_tr" style="display: none;">
<th width="20%">用户id（id）</th>
<td align="left">
<input name="v2ray_uuid" style="background-color: #475A5F;color:#FFFFFF;" value="<% dbus_get_def('v2ray_uuid', '12345-1123-123-123abc'); %>">
</td>
</tr>
<tr id="v2ray_alterid_basic_tr" style="display: none;">
<th width="20%">额外ID (Alterld)</th>
<td align="left">
<input name="v2ray_alterid" style="background-color: #475A5F;color:#FFFFFF;" value="<% dbus_get_def('v2ray_alterid', '100'); %>">
</td>
</tr>
<tr id="v2ray_security_basic_tr" style="display: none;">
<th width="20%">加密方式 (security)</th>
<td align="left">
<select id="v2ray_security" name="v2ray_security" style="width:350px;margin:0px 0px 0px 2px;" class="input_option">
<option value="auto">自动</option>
<option value="aes-128-cfb">aes-128-cfb</option>
<option value="aes-128-gcm">aes-128-gcm</option>
<option value="chacha20-poly1305">chacha20-poly1305</option>
<option value="none">不加密</option>
</select>
</td>
</tr>
<tr id="v2ray_network_basic_tr" style="display: none;">
<th width="20%">传输协议 (network)</th>
<td align="left">
<select id="v2ray_network" name="v2ray_network" style="width:350px;margin:0px 0px 0px 2px;" class="input_option" onchange="verifyFields(this, 1);">
<option value="tcp">tcp</option>
<option value="kcp">kcp</option>
<option value="ws">ws</option>
<option value="h2">h2</option>
</select>
</td>
</tr>
<tr id="v2ray_headtype_tcp_basic_tr" style="display: none;">
<th width="20%">  * tcp伪装类型 (type)</th>
<td align="left">
<select id="v2ray_headtype_tcp" name="v2ray_headtype_tcp" style="width:350px;margin:0px 0px 0px 2px;" class="input_option" onchange="verifyFields(this, 1);">
<option value="none">不伪装</option>
<option value="http">伪装http</option>
</select>
</td>
</tr>
<tr id="v2ray_headtype_kcp_basic_tr" style="display: none;">
<th width="35%">* kcp伪装类型 (type)</th>
<td>
<select id="v2ray_headtype_kcp" name="v2ray_headtype_kcp" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" onchange="verifyFields(this, 1);">
<option value="none">不伪装</option>
<option value="srtp">伪装视频通话(srtp)</option>
<option value="utp">伪装BT下载(uTP)</option>
<option value="wechat-video">伪装微信视频通话</option>
</select>
</td>
</tr>
<tr id="v2ray_network_host_basic_tr" style="display: none;">
<th width="35%">* 伪装域名 (host)</th>
<td>
<input type="text" name="v2ray_network_host" id="v2ray_network_host" class="input_ss_table"  placeholder="没有请留空" maxlength="300" value=""/>
</td>
</tr>
<tr id="v2ray_network_path_basic_tr" style="display: none;">
<th width="35%">* 路径 (path)</th>
<td>
<input type="text" name="v2ray_network_path" id="v2ray_network_path" class="input_ss_table"  placeholder="没有请留空" maxlength="300" value=""/>
</td>
</tr>
<tr id="v2ray_network_security_basic_tr" style="display: none;">
<th width="20%">底层传输安全</th>
<td align="left">
<select id="v2ray_network_security" name="v2ray_network_security" style="width:350px;margin:0px 0px 0px 2px;" class="input_option">
<option value="none">关闭</option>
<option value="tls">tls</option>
</select>
</td>
</tr>
<tr id="v2ray_mux_enable_basic_tr" style="display: none;">
<th width="35%">多路复用 (Mux)</th>
<td>
<input type="checkbox" id="v2ray_mux_enable" name="v2ray_mux_enable" onclick="verifyFields(this, 1);" value="<% dbus_get_def("v2ray_mux_enable", "0"); %>">
</td>
</tr>
<tr id="v2ray_json_basic_tr" style="display: none;">
<th width="35%">v2ray json</th>
<td>
<textarea  style="width:99%;background-color: #475A5F;color:#FFFFFF;" placeholder="# 此处填入v2ray json，内容可以是标准的也可以是压缩的
# 请保证你json内的outbound配置正确！！！
# ------------------------------------
# 同样支持vmess://链接填入，格式如下：
vmess://ew0KICAidiI6ICIyIiwNCiAgInBzIjogIjIzMyIsDQogICJhZGQiOiAiMjMzLjIzMy4yMzMuMjMzIiwNCiAgInBvcnQiOiAiMjMzIiwNCiAgImlkIjogImFlY2EzYzViLTc0NzktNDFjMy1hMWUzLTAyMjkzYzg2Y2EzOCIsDQogICJhaWQiOiAiMjMzIiwNCiAgIm5ldCI6ICJ3cyIsDQogICJ0eXBlIjogIm5vbmUiLA0KICAiaG9zdCI6ICJ3d3cuMjMzLmNvbSIsDQogICJwYXRoIjogIi8yMzMiLA0KICAidGxzIjogInRscyINCn0=" rows="40" style="width:99%; font-family:'Lucida Console'; font-size:12px;background:#475A5F;color:#FFFFFF;" id="v2ray_json" name="v2ray_json" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" title=""></textarea>
</td>
</tr>
</table>
</div>
<div id="ss_status">
<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
<tr id="ss_state">
<th id="mode_state" width="35%">运行状态</th>
<td>
<div style="display:table-cell;float: left;margin-left:0px;">
<span id="ss_state1"><% nvram_get("ss_foreign_state"); %></span>
<br/>
<span id="ss_state2"><% nvram_get("ss_china_state"); %></span>
</div>
</td>
</tr>
<thead>
<tr>
<td colspan="2">运行信息</td>
</tr>
</thead>
<tr><td colspan="2">
<div id="log_content" style="margin-top:-1px;display:block;overflow:hidden;">
<textarea cols="63" rows="36" wrap="on" readonly="readonly" id="log_content1" style="width:99%;font-family:Courier New, Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
</div>
</td></tr>
</table>
</div>
<div class="apply_gen">
<input class="button_gen" onclick="applyRule()" type="button" value="应用设置"/>
<input type="button" onClick="location.href=location.href" value="刷新状态" class="button_gen">
</div>
</td>
</tr>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</table>
</td>
<td width="10" align="center" valign="top">&nbsp;</td>
</tr>
</table>
<div id="footer"></div>
</form>
</body>
</html>
