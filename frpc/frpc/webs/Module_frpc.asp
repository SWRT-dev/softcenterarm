<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- version: 2.1.8 -->
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - Frp内网穿透</title>
<link rel="stylesheet" type="text/css" href="index_style.css" />
<link rel="stylesheet" type="text/css" href="form_style.css" />
<link rel="stylesheet" type="text/css" href="usp_style.css" />
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<style type="text/css">
.show-btn1, .show-btn2 {
    border: 1px solid #222;
    background: #576d73;
    font-size:10pt;
    color: #fff;
    padding: 10px 3.75px;
    border-radius: 5px 5px 0px 0px;
    width:15%;
    }
.active {
    background: #2f3a3e;
}
.close {
    background: red;
    color: black;
    border-radius: 12px;
    line-height: 18px;
    text-align: center;
    height: 18px;
    width: 18px;
    font-size: 16px;
    padding: 1px;
    top: -10px;
    right: -10px;
    position: absolute;
}
/* use cross as close button */
.close::before {
    content: "\2716";
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
.user_title{
    text-align:center;
    font-size:18px;
    color:#99FF00;
    padding:10px;
    font-weight:bold;
}
.frpc_btn {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}
.frpc_btn:hover {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}
#frpc_config {
	width:99%;
	font-family:'Lucida Console';
	font-size:12px; background:#475A5F;
	color:#FFFFFF;
	text-transform:none;
	margin-top:5px;
	overflow:scroll;
}
.formbottomdesc {
    margin-top:10px;
    margin-left:10px;
}
input[type=button]:focus {
    outline: none;
}
</style>
<script>
var myid;
var db_frpc = {};
var node_max = 0;
var params_input = ["frpc_cron_time", "frpc_cron_hour_min", "frpc_common_serverAddr", "frpc_common_serverPort", "frpc_common_transport__protocol", "frpc_common_transport__tcpMux", "frpc_common_loginFailExit", "frpc_common_auth__token", "frpc_common_user", "frpc_common_log__to", "frpc_common_log__level", "frpc_common_log__maxDays", "frpc_common_transport__heartbeatInterval", "frpc_common_transport__tls__enable", "frpc_cron_type", "frpc_common_transport__tls__disableCustomTLSFirstByte", "frpc_common_transport__poolCount"]
var params_check = ["frpc_enable", "frpc_customize_conf"]
var params_base64 = ["frpc_config"]
function initial() {
	show_menu(menu_hook);
	get_dbus_data();
	get_status();
	toggle_func();
	conf2obj();
	buildswitch();
}
function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/frpc",
		dataType: "json",
		async: false,
		success: function(data) {
			db_frpc = data.result[0];
			conf2obj();
			update_visibility();
			toggle_func();
			$("#frpc_version_show").html("插件版本：" + db_frpc["frpc_version"]);
		}
	});
}
function conf2obj() {
	//input
	for (var i = 0; i < params_input.length; i++) {
		if(db_frpc[params_input[i]]){
			E(params_input[i]).value = db_frpc[params_input[i]];
		}
	}
	// checkbox
	for (var i = 0; i < params_check.length; i++) {
		if(db_frpc[params_check[i]]){
			E(params_check[i]).checked = db_frpc[params_check[i]] == 1 ? true : false
		}
	}
	//base64
	for (var i = 0; i < params_base64.length; i++) {
		if(db_frpc[params_base64[i]]){
			E(params_base64[i]).value = Base64.decode(db_frpc[params_base64[i]]);
		}
	}
	//dfnamic table data
	$("#conf_table").find("tr:gt(2)").remove();
	$('#conf_table tr:last').after(refresh_html());
}
function get_status() {
		var postData = {
			"id": parseInt(Math.random() * 100000000),
			"method": "frpc_status.sh",
			"params": [],
			"fields": ""
		};
		$.ajax({
			type: "POST",
			cache: false,
			url: "/_api/",
			data: JSON.stringify(postData),
			dataType: "json",
			success: function(response) {
				E("status").innerHTML = response.result;
				setTimeout("get_status();", 10000);
			},
			error: function() {
				setTimeout("get_status();", 5000);
			}
		});
	}

function buildswitch() {
	$("#frpc_enable").click(
	function() {
		if (E('frpc_enable').checked) {
			document.form.frpc_enable.value = 1;
		} else {
			document.form.frpc_enable.value = 0;
		}
	});
}
function save() {
	if (E("frpc_customize_conf").checked) {
		if (trim(E("frpc_config").value) == "") {
			alert("已选择自定义设置模式，但内容为空!");
			return false;
		}
	} else {
		if (trim(E("frpc_common_auth__token").value) == "" || E("frpc_cron_time").value == "") {
			alert("表单有必填项未填写!");
			return false;
		}
		if(E("frpc_cron_time").value == "0"){
		    E("frpc_cron_hour_min").value = "";
		    E("frpc_cron_type").value = "";
		}
		//清空隐藏表单的值
		if(E("frpc_common_log__to").value == "" || E("frpc_common_log__to").value == "/dev/null" || E("frpc_common_log__to").value == "console"){
            E("frpc_common_log__level").value = "";
            E("frpc_common_log__maxDays").value = "";
		}
		if(E("frpc_common_transport__tls__enable").value == "false"){
            E("frpc_common_transport__tls__disableCustomTLSFirstByte").value = "";
		}
	}
	showLoading(3);

	//input
	for (var i = 0; i < params_input.length; i++) {
		if (trim(E(params_input[i]).value) && trim(E(params_input[i]).value) != db_frpc[params_input[i]]) {
			db_frpc[params_input[i]] = trim(E(params_input[i]).value);
		}else if (!trim(E(params_input[i]).value) && db_frpc[params_input[i]]) {
			db_frpc[params_input[i]] = "";
            }
	}
	// checkbox
	for (var i = 0; i < params_check.length; i++) {
        if (E(params_check[i]).checked != db_frpc[params_check[i]]){
            db_frpc[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
        }
	}
	//base64
	for (var i = 0; i < params_base64.length; i++) {
		if (E(params_base64[i]).value && Base64.encode(E(params_base64[i]).value) != db_frpc[params_base64[i]]) {
            db_frpc[params_base64[i]] = Base64.encode(E(params_base64[i]).value);
		} else if (!E(params_base64[i]).value && db_frpc[params_base64[i]]) {
			db_frpc[params_base64[i]] = "";
            }
	}
	//console.log(db_frpc);
	// post data
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "frpc_config.sh", "params": [1], "fields": db_frpc };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
				refreshpage();
			}
		}
	});
}
function clear_log() {
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "frpc_config.sh", "params": ["clearlog"], "fields": db_frpc };
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
	tabtitle[tabtitle.length - 1] = new Array("", "软件中心", "离线安装", "Frpc 内网穿透");
	tablink[tablink.length - 1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_frpc.asp");
}
function addTr(o) {
	var _form_addTr = document.form;
		
	if (E("proto_node").value == "tcp" || E("proto_node").value == "udp") {
		if (!trim(E("subname_node").value) || !trim(E("localhost_node").value) || !trim(E("localport_node").value) || !trim(E("remoteport_node").value)) {
			alert("表单有必填项未填写!");
			return false;
		}
	} else {
		if (!trim(E("subname_node").value) || !trim(E("subdomain_node").value) || !trim(E("localhost_node").value) || !trim(E("localport_node").value)) {
			alert("表单有必填项未填写!");
			return false;
		}
	}
	// 允许用户一栏，若留空，用 none 替代
	if ((E("proto_node").value == "stcp" || E("proto_node").value == "xtcp") && trim(E("remoteport_node").value) == "") {
		E("remoteport_node").value = "none";
	}
		
	var ns = {};
	var p = "frpc";
	node_max += 1;
	var params = ["proto_node", "subname_node", "subdomain_node", "localhost_node", "localport_node", "remoteport_node", "encryption_node", "gzip_node"];
	if (!myid) {
		for (var i = 0; i < params.length; i++) {
			ns[p + "_" + params[i] + "_" + node_max] = $('#' + params[i]).val().trim();
		}
	} else {
		for (var i = 0; i < params.length; i++) {
			ns[p + "_" + params[i] + "_" + myid] = $('#' + params[i]).val().trim();
		}
	}
	var postData = {"id": parseInt(Math.random() * 100000000), "method": "dummy_script.sh", "params":[], "fields": ns };
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			//回传成功后，重新生成表格
			refresh_table();
			// 添加成功一个后将输入框清空
			document.form.proto_node.value = "tcp";
			document.form.subname_node.value = "";
			document.form.subdomain_node.value = "none";
			document.form.localhost_node.value = "";
			document.form.localport_node.value = "";
			document.form.remoteport_node.value = "";
			document.form.encryption_node.value = "none";
			document.form.gzip_node.value = "none";
			E('remoteport_node').disabled = false;
			E('subdomain_node').disabled = true;
		}
	});
}
function delTr(o) { //删除配置行功能
	if (confirm("你确定删除吗？")) {
		//定位每行配置对应的ID号
		var id = $(o).attr("id");
		var ids = id.split("_");
		var p = "frpc";
		id = ids[ids.length - 1];
		// 定义ns数组，用于回传给dbus
		var ns = {};
		var params = ["proto_node", "subname_node", "subdomain_node", "localhost_node", "localport_node", "remoteport_node", "encryption_node", "gzip_node"];
		for (var i = 0; i < params.length; i++) {
			//空的值，用于清除dbus中的对应值
			ns[p + "_" + params[i] + "_" + id] = "";
		}
		//回传删除数据操作给dbus接口
		var postData = {"id": parseInt(Math.random() * 100000000), "method": "dummy_script.sh", "params":[], "fields": ns };
		$.ajax({
			type: "POST",
			cache:false,
			url: "/_api/",
			data: JSON.stringify(postData),
			dataType: "json",
			success: function(response) {
				refresh_table();
			}
		});
	}
}
function refresh_table() {
	$.ajax({
		type: "GET",
		url: "/_api/frpc",
		dataType: "json",
		async: false,
		success: function(data) {
			db_frpc = data.result[0];
			$("#conf_table").find("tr:gt(2)").remove();
			$('#conf_table tr:last').after(refresh_html());
		}
	});
}
function editlTr(o) { //编辑节点功能，显示编辑面板
	checkTime = 2001; //编辑节点时停止可能在进行的刷新
	var id = $(o).attr("id");
	var ids = id.split("_");
	confs = getAllConfigs();
	id = ids[ids.length - 1];
	var c = confs[id];
	document.form.proto_node.value = c["proto_node"];
	document.form.subname_node.value = c["subname_node"];
	document.form.subdomain_node.value = c["subdomain_node"];
	document.form.localhost_node.value = c["localhost_node"];
	document.form.localport_node.value = c["localport_node"];
	remoteport = document.form.proto_node.value;
	if (remoteport == "http" || remoteport == "https") {
		E('remoteport_node').disabled = true;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('remoteport_node').value = "none";
	}  else if (remoteport == "stcp" || remoteport == "xtcp") {
		E('remoteport_node').disabled = false;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
	} else if (remoteport == "tcp" || remoteport == "udp") {
		E('remoteport_node').disabled = false;
		E('subdomain_node').disabled = true;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "none";
	}
	document.form.remoteport_node.value = c["remoteport_node"];
	document.form.encryption_node.value = c["encryption_node"];
	document.form.gzip_node.value = c["gzip_node"];
	myid = id;
}
function getAllConfigs() {
	var dic = {};
	for (var field in db_frpc) {
		names = field.split("_");
		dic[names[names.length - 1]] = 'ok';
	}
	confs = {};
	var p = "frpc";
	var params = ["proto_node", "subname_node", "subdomain_node", "localhost_node", "localport_node", "remoteport_node", "encryption_node", "gzip_node"];
	for (var field in dic) {
		var obj = {};
		for (var i = 0; i < params.length; i++) {
			var ofield = p + "_" + params[i] + "_" + field;
			if (typeof db_frpc[ofield] == "undefined") {
				obj = null;
				break;
			}
			obj[params[i]] = db_frpc[ofield];
		}
		if (obj != null) {
			var node_i = parseInt(field);
			if (node_i > node_max) {
				node_max = node_i;
			}
			obj["node"] = field;
			confs[field] = obj;
		}
	}
	return confs;
}
function refresh_html() {
	confs = getAllConfigs();
	var n = 0;
	for (var i in confs) {
		n++;
	}
	var html = '';
	for (var field in confs) {
		var c = confs[field];
		html = html + '<tr>';
		html = html + '<td>' + c["proto_node"] + '</td>';
		if (c["proto_node"] == "stcp" || c["proto_node"] == "xtcp") {
			html = html + '<td><a href="javascript:void(0)" onclick="open_conf(\'stcp_settings\');" style="cursor:pointer;"><em><u>' + c["subname_node"] + '</u></em></a></td>';
		} else {
			html = html + '<td>' + c["subname_node"] + '</td>';
		}
		if ((c["proto_node"] == "tcp" || c["proto_node"] == "udp") && c["subdomain_node"] == "none") {
			html = html + '<td>' + "-" + '</td>';
		} else {
			html = html + '<td>' + c["subdomain_node"] + '</td>';
		}
		html = html + '<td>' + c["localhost_node"] + '</td>';
		html = html + '<td>' + c["localport_node"] + '</td>';
		if (c["proto_node"] == "tcp" || c["proto_node"] == "udp" || c["proto_node"] == "stcp" || c["proto_node"] == "xtcp") {
            if (c["remoteport_node"] == "none") {
                html = html + '<td>' + "-" + '</td>'; 
            } else {
			    html = html + '<td>' + c["remoteport_node"] + '</td>';
            }
		} else {
			html = html + '<td>' + "-" + '</td>';
		}
		if (c["encryption_node"] == "none") {
			html = html + '<td>' + "-" + '</td>';
		} else {
			html = html + '<td>' + c["encryption_node"] + '</td>';
		}
		if (c["gzip_node"] == "none") {
			html = html + '<td>' + "-" + '</td>';
		} else {
			html = html + '<td>' + c["gzip_node"] + '</td>';
		}
		html = html + '<td>';
		html = html + '<input style="margin-left:-3px;" id="dd_node_' + c["node"] + '" class="edit_btn" type="button" onclick="editlTr(this);" value="">'
		html = html + '</td>';
		html = html + '<td>';
		html = html + '<input style="margin-top: 4px;margin-left:-3px;" id="td_node_' + c["node"] + '" class="remove_btn" type="button" onclick="delTr(this);" value="">'
		html = html + '</td>';
		html = html + '</tr>';
	}
	return html;
}

function get_frpc_conf() {
	$.ajax({
		url: '/_temp/.frpc.toml',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
            if (res.length == 0){
            E("frpctxt").value = "配置文件为空，请开启frpc..."; 
            }else{ $('#frpctxt').val(res); }
		}
	});
}
function get_stcp_conf() {
	$.ajax({
		url: '/_temp/.frpc_visitor.toml',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
			$('#usertxt').val(res);
		}
	});
}
function get_frpc_log() {
	$.ajax({
		url: '/_temp/frpc_lnk.log',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
            if (res.length == 0){
            E("logtxt").value = "日志文件为空或未配置"; 
			}else{ $('#logtxt').val(res); }
		}
	});
}
function open_conf(open_conf) {
	if (open_conf == "frpc_settings") {
		get_frpc_conf();
		console.log("2222")
	}
	if (open_conf == "stcp_settings") {
		get_stcp_conf();
		console.log("444")
	}
	if (open_conf == "frpc_log") {
		get_frpc_log();
	}
	$("#" + open_conf).fadeIn(200);
}
function close_conf(close_conf) {
	$("#" + close_conf).fadeOut(200);
}
function toggle_func() {
	E("simple_table").style.display = "";
	E("conf_table").style.display = "";
	E("customize_conf_table").style.display = "none";
	$('.show-btn1').addClass('active');
	$(".show-btn1").click(
		function() {
			$('.show-btn1').addClass('active');
			$('.show-btn2').removeClass('active');
			E("simple_table").style.display = "";
			E("conf_table").style.display = "";
			E("customize_conf_table").style.display = "none";
		}
	);
	$(".show-btn2").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn2').addClass('active');
			E("simple_table").style.display = "none";
			E("conf_table").style.display = "none";
			E("customize_conf_table").style.display = "";
		}
	);
	//未配置log时隐藏关联表单
	$("#frpc_common_log__to").change(
		function(){
		if(E("frpc_common_log__to").value == "" || E("frpc_common_log__to").value == "/dev/null" || E("frpc_common_log__to").value == "console"){
			E("log_level_tr").style.display = "none";
            E("log_maxDays_tr").style.display = "none";
		}else{
		    E("log_level_tr").style.display = "";
		    E("log_maxDays_tr").style.display = "";
		}
	});
	// frp从0.50.0开始Tls参数默认true
	$("#frpc_common_transport__tls__enable").change(
		function(){
		if(E("frpc_common_transport__tls__enable").value == "false"){
			E("TLSFirstByte_tr").style.display = "none";
		}else{
			E("TLSFirstByte_tr").style.display = "";
		}
	});
}
//网页重载时更新显示样式
function update_visibility(){
	if(!db_frpc["frpc_common_log__to"] || db_frpc["frpc_common_log__to"] == "console" || db_frpc["frpc_common_log__to"] == "/dev/null"){
	    E("log_level_tr").style.display = "none";
		E("log_maxDays_tr").style.display = "none";
	}else{
        E("log_level_tr").style.display = "";
        E("log_maxDays_tr").style.display = "";
    }
	if(db_frpc["frpc_common_transport__tls__enable"] == "false"){
	    E("TLSFirstByte_tr").style.display = "none";
	}else{
		E("TLSFirstByte_tr").style.display = "";
	}
}
function proto_onchange() {
	var remoteport = "";
	var obj = E('proto_node');
	var index = obj.selectedIndex; //序号，取当前选中选项的序号
	var r_https_port = "<%  nvram_get(https_lanport); %>"
	var r_ssh_port = "<%  nvram_get(sshd_port); %>"
	var r_computer_name = "<%  nvram_get(productid); %>"
	var r_lan_ipaddr = "<% nvram_get(lan_ipaddr); %>"
	var r_subname_node_http = r_computer_name + '_http';
	var r_subname_node_https = r_computer_name + '_https';
	var r_subname_node_ssh = r_computer_name + '_ssh';
	remoteport = obj.options[index].text;
	if (remoteport == "http" || remoteport == "https") {
		E('remoteport_node').disabled = true;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "";
		E('remoteport_node').value = "none";
	} else if (remoteport == "tcp" || remoteport == "udp") {
		E('remoteport_node').disabled = false;
		E('remoteport_node').value = "";
		E('subdomain_node').disabled = true;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "none";
	}  else if (remoteport == "stcp" || remoteport == "xtcp") {
		E('remoteport_node').disabled = false;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "";
		E('remoteport_node').value = "";
	} else if (remoteport == "router-http") {
		E('remoteport_node').disabled = true;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "";
		E('remoteport_node').value = "none";
		E('subname_node').value = r_subname_node_http;
		E('localhost_node').value = "127.0.0.1";
		E('localport_node').value = "80";
	} else if (remoteport == "router-https") {
		E('remoteport_node').disabled = true;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "";
		E('remoteport_node').value = "none";
		E('subname_node').value = r_subname_node_https;
		E('localhost_node').value = "127.0.0.1";
		E('localport_node').value = r_https_port;
	} else if (remoteport == "router-ssh-tcp") {
		E('remoteport_node').disabled = false;
		E('remoteport_node').value = "";
		E('subdomain_node').disabled = true;
		E('subdomain_node').value = "none";
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subname_node').value = r_subname_node_ssh;
		E('localhost_node').value = r_lan_ipaddr;
		E('localport_node').value = r_ssh_port;
	} else if (remoteport == "router-ssh-stcp") {
		E('remoteport_node').disabled = false;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "";
		E('remoteport_node').value = "";
		E('subname_node').value = r_subname_node_ssh;
		E('localhost_node').value = r_lan_ipaddr;
		E('localport_node').value = r_ssh_port;
	}
}
function openssHint(itemNum) {
	statusmenu = "";
	width = "350px";
	if (itemNum == 0) {
		statusmenu = "如果发现开关不能开启，那么请检查<a href='Advanced_System_Content.asp'><u><font color='#00F'>系统管理 -- 系统设置</font></u></a>页面内 Enable JFFS custom scripts and configs 是否开启";
		_caption = "服务说明";
	} else if (itemNum == 1) {
		statusmenu = " 需要连接的frp服务器的地址。留空，默认 0.0.0.0<br>若是固定ip，建议优先填入<font color='#F46'>IP地址</font>。动态ip，填入域名，ip更换时可能出现短暂失联。";
		_caption = " serverAddr 字段";
	} else if (itemNum == 2) {
		statusmenu = " 需要连接的frp服务器的端口，依据底层通信协议的设置而定，留空默认为TCP协议7000端口。";
		_caption = " serverPort 字段";
	} else if (itemNum == 3) {
		statusmenu = " 需要连接的frp服务器的授权码。要与服务器配置文件相同。<br><font color='#F46'>注意：</font>某些特殊字符的密码，可能会无法验证。";
		_caption = " auth.token 字段";
	} else if (itemNum == 4) {
		statusmenu = "显示 frpc 的进程状态及 pid";
		_caption = "运行状态";
	} else if (itemNum == 5) {
		statusmenu = "连接池，留空默认0，frp预先和后端服务建立起指定数量的连接。此功能适合有大量短连接请求时开启，其有效值受 Frps 配置文件中 transport.maxPoolCount 设定值限制。注: 当 TCP 多路复用启用后，连接池的提升有限，一般场景下无需关心。";
		_caption = " transport.poolCount 字段";
	} else if (itemNum == 6) {
		statusmenu = "是否开启日志保存。默认为空，即console<br/>①控制台（console），日志输出到标准输出。但插件会丢弃标准输出及错误信息，无法读取；<br/>②文件，日志保存到【/tmp/frpc.log】。插件也会重定向标准输出及错误信息给它，均可读取；<br/>③黑洞（/dev/null），日志被丢弃。但插件会重定向标准输出及错误信息至临时文件，可读取。";
		_caption = " log.to 字段";
	} else if (itemNum == 7) {
		statusmenu = "选择日志记录等级，留空默认info。<br/>可选内容(依次)：trace, debug, info, warn, error。其中error级别信息量最少。";
		_caption = " log.level 字段";
	} else if (itemNum == 8) {
		statusmenu = "要保留日志文件的天数(不含当天)，留空默认3天。在日志文件目录可以找到按日期命名的文件，一天一个。";
		_caption = " log.maxDays 字段";
	} else if (itemNum == 9) {
		statusmenu = "要穿透的协议类型，目前可选 http、https、tcp、stcp、udp、xtcp 类型，若要配置更多功能，请使用“自定义设置”模式。";
		_caption = "[代理项目]的 type 字段";
	} else if (itemNum == 10) {
		statusmenu = "穿透规则的命名。<strong>当使用 stcp、xtcp 类型添加规则后，可点击名称获得访问端角色的参考配置文件</strong>。<br><font color='#F46'>注意：</font>frp 规则命名不能重复";
		_caption = "[代理项目]的 name 字段";
	} else if (itemNum == 11) {
		statusmenu = " http(s) 类型的自定义域名；<strong>或stcp、xtcp类型的 secretKey 码</strong>。（注：本插件none=空）";
		_caption = "[代理项目] customDomains 或 secretKey 字段";
	} else if (itemNum == 12) {
		statusmenu = "要穿透的内部主机IP地址，如：192.168.1.1";
		_caption = "[代理项目]的 localIP 字段";
	} else if (itemNum == 13) {
		statusmenu = "要穿透的内部主机的端口，如：80或22";
		_caption = "[代理项目]的 localPort 字段";
	} else if (itemNum == 14) {
		statusmenu = "远程端口 或 允许访问端用户。（注：本插件none=空）";
		statusmenu += "<br/><b><font color='#669900'>远程端口（http/https）：</font></b>在Frps服务端配置。";
		statusmenu += "<br/><b><font color='#669900'>远程端口（tcp/udp）：</font></b>设定时，应在Frps可能配置的 allowPorts 字段值范围内。";
		statusmenu += "<br/><b><font color='#669900'>允许访问端用户列表（stcp/xtcp）：</font></b>①若留空，默认只允许同一用户下的 visitor 访问；②若指定具体用户，例如，简写为：user1 user2 （用空格隔开），后台会进行转换；③若配置为星号 * 则允许任何用户访问。";
		_caption = "[代理项目]的 remotePort 或 allowUsers 字段";
	} else if (itemNum == 15) {
		statusmenu = "加密，空值默认关闭。开启可有效防止流量被拦截。若<font color='#F46'>已启用全局 TLS</font>（默认启用），除 xtcp 外，此处不用再开启进行重复加密。加密将消耗一些系统资源。";
		_caption = "[代理项目]的 transport.useEncryption 字段";
	} else if (itemNum == 16) {
		statusmenu = "压缩，空值默认关闭。若传输的报文长度较长，开启压缩，可有效减小 frpc 与 frps 之间的网络流量，加快流量转发速度，但会额外消耗一些系统资源。";
		_caption = "[代理项目]的 transport.useCompression 字段";
	} else if (itemNum == 17) {
		statusmenu = "定时执行操作。<font color='#F46'>检查：</font>检查frp的进程是否存在，若不存在则重新启动；<font color='#F46'>启动：</font>重新启动frp进程，而不论当时是否在正常运行。重新启动服务会导致活动中的连接短暂中断.<br><font color='#F46'>注意：</font>填写内容为 0 关闭定时功能！<br/>建议：选择分钟填写“60的因数”【1、2、3、4、5、6、10、12、15、20、30、60】，选择小时填写“24的因数”【1、2、3、4、6、8、12、24】。";
		_caption = "定时功能";
	} else if (itemNum == 18) {
		statusmenu = "TLS 不发送自定义的 0x17 字节（当全局 TLS 启用后）。若为空，默认启用，即不发送。<font color='#F46'>若启用，可增强安全性，但不能复用 vhostHTTPSPort 端口</font>，建议查阅官方文档。";
		_caption = " transport.tls.disableCustomTLSFirstByte 字段";
	} else if (itemNum == 19) {
		statusmenu = "frpc 用户名称，用户较多时便于区分。设置后，结果表述为 {用户名称}.{代理名称}";
		_caption = " user 字段";
	} else if (itemNum == 20) {
		statusmenu = "通信协议，留空默认 tcp，还可选 quic、kcp、websocket、wss；<font color='#F46'>提示：</font>frpc “通信端口”匹配 frps 配置文件的端口号：tcp 对应“bindPort”，kcp 对应“kcpBindPort”，quic对应“quicBindPort”。";
		_caption = " transport.protocol 字段";
	} else if (itemNum == 21) {
		statusmenu = "默认开启，该配置在服务端和客户端必须一致。如需关闭，同时在 frps 和 frpc 中配置。<br><strong>多路复用</strong>：不再需要为每一个用户请求创建一个连接，使连接建立的延迟降低，并且避免了大量文件描述符的占用，使 frp 可以承载更高的并发数。";
		_caption = " transport.tcpMux 字段";
	} else if (itemNum == 22) {
		statusmenu = "客户端首次连接服务器失败后退出程序<br/>留空：默认启用<br/>建议：关闭";
		_caption = " loginFailExit 字段";
	} else if (itemNum == 23) {
		statusmenu = "<strong>简单设置</strong>：按下方表格指定参数快速配置，格式为TOML<br/><strong>高级配置</strong>：按照官方教程自己编写配置文件，视Frp版本而定，可能支持：INI/TOML/YAML/JSON 格式，语法错误将导致服务无法启动";
		_caption = "设置方式选择";
	} else if (itemNum == 24) {
		statusmenu = "向服务端发送心跳包的间隔时间，留空默认30秒。<font color='#F46'>提示：</font>当开启TCP多路复用后(默认开启)，可将心跳间隔设为<font color='#F46'>负数</font>以禁用此项，降低非必要流量消耗";
		_caption = " transport.heartbeatInterval 字段";
	} else if (itemNum == 25) {
		statusmenu = "frpc 使用 TLS 加密连接 frps。若为空，默认启用。若不配置证书，将使用自动生成的证书。如需配置证书，请使用“自定义设置”模式进行配置。<font color='#F46'>提示：</font>启用此功能后，在设置“穿透服务配置”时，除xtcp外无需再开启“加密”（transport.useEncryption）重复加密.";
		_caption = " transport.tls.enable 字段";
	} else if (itemNum == 26) {
		statusmenu = "查看正在生效的frp配置文件、frp当天的运行日志（若有配置）";
		_caption = "查看当前配置和运行日志";
	}
	return overlib(statusmenu, OFFSETX, -160, LEFT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');
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
</script>
</head>
<body onload="initial();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=frpc" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_frpc.asp"/>
<input type="hidden" name="next_page" value="Module_frpc.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
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
                        <table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3"  class="FormTitle" id="FormTitle">
                            <tr>
                                <td bgcolor="#4D595D" colspan="3" valign="top">
                                    <div>&nbsp;</div>
                                    <div style="float:left;" class="formfonttitle">软件中心 - Frpc内网穿透</div>
                                    <div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                                    <div style="margin:30px 0 10px 5px;" class="splitLine"></div>
                                    <div class="formfontdesc">Frp 是一个可用于内网穿透的高性能的反向代理应用。【仓库链接：<a href="https://github.com/fatedier/frp" target="_blank"><em><u>Github</u></em></a>】【中文文档：<a href="https://gofrp.org/zh-cn/docs/" target="_blank"><em><u>gofrp.org</u></em></a>】<br/><i>* 点击参数设置项目的文字，可查看帮助信息 *</i> *为了能稳定运行，强烈建议开启虚拟内存！*</div>
                                    <div id="frpc_switch_show">
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                        <tr id="switch_tr">
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(0)">开启Frpc</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="frpc_enable">
                                                        <input id="frpc_enable" class="switch" type="checkbox" style="display: none;">
                                                        <div class="switch_container" >
                                                            <div class="switch_bar"></div>
                                                            <div class="switch_circle transition_style">
                                                                <div></div>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
                                                <div id="frpc_version_show" style="padding-top:5px;margin-left:30px;margin-top:0px;float: left;"></div>
                                            </td>
                                        </tr>
                                        <tr id="frpc_status">
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(4)">运行状态</th>
                                            <td><span id="status">获取中...</span>
                                            </td>
                                        </tr>
                                       
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(17)">定时功能(<i>0为关闭</i>)</a></th>
                                            <td>
                                                每 <input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '')" id="frpc_cron_time" name="frpc_cron_time" class="input_3_table" maxlength="2" value="30" placeholder="" />
                                                <select id="frpc_cron_hour_min" name="frpc_cron_hour_min" style="width:60px;margin:3px 2px 0px 2px;" class="input_option">
                                                    <option value="min">分钟</option>
                                                    <option value="hour">小时</option>
                                                </select> 重新
                                                    <select id="frpc_cron_type" name="frpc_cron_type" style="width:60px;margin:3px 2px 0px 2px;" class="input_option">
                                                        <option value="watch">检查</option>
                                                        <option value="start">启动</option>
                                                    </select> 一次服务
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(26)">查看当前配置和日志</th>
                                            <td>
                                                <a type="button" class="frpc_btn" style="cursor:pointer" href="javascript:void(0);" onclick="open_conf('frpc_settings');" >查看当前配置</a>&nbsp;
                                                <a type="button" class="frpc_btn" style="cursor:pointer" href="javascript:void(0);" onclick="open_conf('frpc_log');" >查看frp运行日志</a>
                                            </td>
                                        </tr>
                                    </table>
                                    </div>

                                    <div id="tablet_show">
                                        <table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
                                            <tr width="235px">
                                             <td colspan="4" cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#000">
                                               <input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="简单设置"/>
                                               <input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="自定义设置"/>
                                             </td>
                                             </tr>
                                        </table>
                                    </div>

                                    <div id="simple_table">
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="box-shadow: 3px 3px 10px #000;margin-top: 0px;">
                                        <thead>
                                            <tr>
                                            <td colspan="2"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(23)">Frpc 简单设置</a></td>
                                            </tr>
                                        </thead>
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(1)">服务器</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" value="" id="frpc_common_serverAddr" name="frpc_common_serverAddr" maxlength="100" value="" placeholder="0.0.0.0"/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(2)">通信端口</a></th>
                                            <td>
                                        <input type="text" oninput="this.value=this.value.replace(/[^\d-]/g, ''); if(value>65535)value=65535" class="input_ss_table" id="frpc_common_serverPort" name="frpc_common_serverPort" maxlength="6" value="" placeholder="7000" />
                                            </td>
                                        </tr>
                                        
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(3)">令牌token</a></th>
                                            <td>
                                                <input type="password" name="frpc_common_auth__token" id="frpc_common_auth__token" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="75" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);" placeholder="必填" />
                                            </td>
                                        </tr>
                                        
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(21)">TCP 多路复用</a></th>
                                            <td>
                                                <select id="frpc_common_transport__tcpMux" name="frpc_common_transport__tcpMux" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="">-空-</option>
                                                    <option value="true">开启</option>
                                                    <option value="false">关闭</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(20)">底层通信协议</a></th>
                                            <td>
                                                <select id="frpc_common_transport__protocol" name="frpc_common_transport__protocol" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="">-空-</option>
                                                    <option value="tcp">tcp</option>
                                                    <option value="websocket">websocket</option>
                                                    <option value="kcp">kcp</option>
                                                    <option value="quic">quic</option>
                                                    <option value="wss">wss</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(22)">登录失败后退出</a></th>
                                            <td>
                                                <select id="frpc_common_loginFailExit" name="frpc_common_loginFailExit" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="none">-空-</option>
                                                    <option value="true">启用</option>
                                                    <option value="false" selected="selected">关闭</option>
                                                </select>
                                            </td>
                                        </tr>
                                        
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(19)">Frpc用户名称</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" id="frpc_common_user" name="frpc_common_user" maxlength="50" value="" placeholder="可选" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(24)">心跳间隔时间</a></th>
                                            <td>
                                        <input type="text" oninput="this.value=this.value.replace(/[^\d-]/g, '')" class="input_ss_table" id="frpc_common_transport__heartbeatInterval" name="frpc_common_transport__heartbeatInterval" maxlength="4" value="" placeholder="30"/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(25)">全局TLS加密...</a></th>
                                            <td>
                                                <select id="frpc_common_transport__tls__enable" name="frpc_common_transport__tls__enable" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="">-空-</option>
                                                    <option value="true">启用</option>
                                                    <option value="false">关闭</option>
                                                </select>
                                            </td>
                                        </tr>
                                        
                                        <tr id="TLSFirstByte_tr">
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(18)">禁用第一个TLS自定义字节</a></th>
                                            <td>
                                                <select id="frpc_common_transport__tls__disableCustomTLSFirstByte" name="frpc_common_transport__tls__disableCustomTLSFirstByte" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="">-空-</option>
                                                    <option value="true">启用</option>
                                                    <option value="false">关闭</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(5)">连接池大小</a></th>
                                            <td>
                                                <input type="text" oninput="this.value=this.value.replace(/[^\d-]/g, '')" class="input_ss_table" id="frpc_common_transport__poolCount" name="frpc_common_transport__poolCount" maxlength="4" value="" placeholder="0"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(6)">日志输出记录...</a></th>
                                            <td>
                                                <select id="frpc_common_log__to" name="frpc_common_log__to" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="">-空-</option>
                                                    <option value="/tmp/frpc.log">文件（/tmp/frpc.log）</option>
                                                    <option value="/dev/null">黑洞（/dev/null）</option>
                                                    <option value="console">控制台（console）</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="log_level_tr" style="display: none;">
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(7)">日志等级</a></th>
                                            <td>
                                                <select id="frpc_common_log__level" name="frpc_common_log__level" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="">-空-</option>
                                                    <option value="error">错误</option>
                                                    <option value="warn">警告</option>
                                                    <option value="info">信息</option>
                                                    <option value="debug">调试</option>
                                                    <option value="trace">追踪</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr id="log_maxDays_tr" style="display: none;">
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(8)">日志文件保留天数</a></th>
                                            <td>
                                                <input type="text" oninput="this.value=this.value.replace(/[^\d-]/g, '')" class="input_ss_table" id="frpc_common_log__maxDays" name="frpc_common_log__maxDays" maxlength="3" value="" placeholder="3"/>
                                            </td>
                                        </tr>
                                    </table>
                                    <table id="conf_table" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" style="box-shadow: 3px 3px 10px #000;margin-top: 10px;">
                                          <thead>
                                              <tr>
                                                <td colspan="10">穿透服务配置</td>
                                              </tr>
                                          </thead>

                                          <tr>
                                            <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(9)">协议类型</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(10)">代理名称 / 访客配置</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(11)">域名 / 密钥</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(12)">内网地址</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(13)">内网端口</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(14)">远程端口 / 允许用户</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(15)">加密</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(16)">压缩</a></th>
                                          <th>修改</th>
                                          <th>添加/删除</th>
                                          </tr>
                                          <tr>
                                        <td>
                                            <select id="proto_node" name="proto_node" style="width:70px;margin:0px 0px 0px 2px;" class="input_option" onchange="proto_onchange()" >
                                                <option value="tcp">tcp</option>
                                                <option value="udp">udp</option>
                                                <option value="stcp">stcp</option>
                                                <option value="http">http</option>
                                                <option value="https">https</option>
                                                <option value="http">router-http</option>
                                                <option value="https">router-https</option>
                                                <option value="tcp">router-ssh-tcp</option>
                                                <option value="stcp">router-ssh-stcp</option>
                                                <option value="xtcp">xtcp</option>
                                            </select>

                                        </td>
                                         <td>
                                            <input type="text" id="subname_node" name="subname_node" class="input_6_table" maxlength="50" style="width:60px;" placeholder=""/>
                                        </td>
                                         <td>
                                            <input type="text" id="subdomain_node" name="subdomain_node" class="input_12_table" maxlength="150" value="none" placeholder="" disabled/>
                                        </td>
                                        <td>
                                            <input type="text" id="localhost_node" name="localhost_node" class="input_12_table" maxlength="99" placeholder=""/>
                                        </td>
                                        <td>
                                            <input type="text" id="localport_node" name="localport_node" class="input_6_table" maxlength="6" placeholder=""/>
                                        </td>
                                        <td>
                                            <input type="text" id="remoteport_node" name="remoteport_node" class="input_6_table" maxlength="99" placeholder=""/>
                                        </td>
                                        <td>
                                            <select id="encryption_node" name="encryption_node" style="width:50px;margin:0px 0px 0px 2px;" class="input_option" >
                                                <option value="none">空</option>
                                                <option value="true">是</option>
                                                <option value="false">否</option>
                                            </select>
                                        </td>
                                        <td>
                                            <select id="gzip_node" name="gzip_node" style="width:50px;margin:0px 0px 0px 2px;" class="input_option" >
                                                <option value="none">空</option>
                                                <option value="true">是</option>
                                                <option value="false">否</option>
                                            </select>
                                        </td>
                                        <td width="7%">
                                            <div>
                                            </div>
                                        </td>
                                        <td width="10%">
                                            <div>
                                                <input type="button" class="add_btn" onclick="addTr()" value=""/>
                                            </div>
                                        </td>
                                          </tr>
                                      </table>
                                    </div>

                                    <div id="customize_conf_table">
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" style="box-shadow: 3px 3px 10px #000;margin-top: 0px;">
                                        <thead>
                                            <tr>
                                                <td colspan="2"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(23)">Frpc 高级配置</a></td>
                                            </tr>
                                        </thead>
                                            <tr>
                                                <th style="width:20%;">
                                                    <label><input type="checkbox" id="frpc_customize_conf" name="frpc_customize_conf"><i>自定义配置</i>
                                                </th>
                                                <td>
                                                    <textarea cols="50" rows="40" id="frpc_config" name="frpc_config" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" placeholder="# 视Frp版本而定，可能支持：INI/TOML/YAML/JSON 格式，以下为TOML示例&#13;&#10;# 通常 INI/TOML/YAML 格式可使用 # 符号注释, JSON格式未知&#13;&#10;serverAddr = &#34;127.0.0.1&#34;&#13;&#10;serverPort = 7000&#10;&#10;[[proxies]]&#10;name = &#34;ssh&#34;&#10;type = &#34;tcp&#34;&#10;localIP = &#34;127.0.0.1&#34;&#10;localPort = 22&#10;remotePort = 6000" ></textarea>
                                                </td>
                                            </tr>
                                    </table>
                                    </div>
                                    <div class="apply_gen">
                                        <span><input class="button_gen" id="cmdBtn" onclick="save()" type="button" value="提交"/></span>
                                    </div>
                                    <div style="margin:30px 0 10px 5px;" class="splitLine"></div>
                                    <div class="formbottomdesc" id="cmdDesc">
                                        <i>* 注意事项：</i><br/>
                                        1、“简单设置” 模式适合常规快速配置；熟练者可使用 “自定义设置” 模式，更灵活。<br/>
                                        2、<i>点击</i>参数设置项目的<i>文字</i>，可<i>查看帮助</i>信息。<br/>
                                        3、穿透设置中<i>添加/删除</i>为实时保存数据，请谨慎操作，修改后请<i>提交</i>以便生成配置文件。
                                    </div>
                                </td>
                            </tr>
                        </table>
                                    <!-- this is the popup area for user rules -->
                                    <div id="frpc_settings"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">Frpc 配置文件&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('frpc_settings');" value="关闭"><span class="close"></span></a></div>
                                        <div style="margin-left:15px"><i>启动服务时生成，位置【/tmp/upload/.frpc.toml】，如有疑问请查阅frp官网。</i></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="frpctxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node1" class="button_gen" type="button" onclick="close_conf('frpc_settings');" value="返回主界面">
                                        </div>
                                    </div>
                                    <div id="stcp_settings"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">Frpc stcp/xtcp 配置文件参考&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('stcp_settings');" value="关闭"><span class="close"></span></a></div>
                                        <div style="margin-left:15px"><i>1、启动服务时生成，位置【/tmp/upload/.frpc_visitor.toml】。</i></div>
                                        <div style="margin-left:15px"><i>2、用于Frpc访问端角色，根据实际情况进行修改（如：本地端口等），如有疑问请查阅frp官网。</i></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="usertxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node2" class="button_gen" type="button" onclick="close_conf('stcp_settings');" value="返回主界面">
                                        </div>
                                    </div>
                                    <div id="frpc_log"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">Frpc 日志文件 / 标准输出&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('frpc_log');" value="关闭"><span class="close"></span></a></div>
                                        <div style="margin-left:15px"><i>1、文本不会自动刷新，需配置日志输出且仅看当天，读取软链接[/tmp/upload/frpc_lnk.log]。</i></div>
                                        <div style="margin-left:15px"><i>2、若使用 “自定义设置” 模式，请确保日志输出参数设置满足条件：<br>&nbsp;&nbsp;&nbsp;①&nbsp;“键名” 关键词只出现一次，不要出现多次（无论是否注释）；<br>&nbsp;&nbsp;&nbsp;②&nbsp;“键值” 指定的文件路径在可写文件系统上。</i></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="logtxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node3" class="button_gen" type="button" onclick="close_conf('frpc_log');" value="返回主界面">
                                            &nbsp;&nbsp;<input class="button_gen" type="button" onclick="close_conf('frpc_log');clear_log();" value="清空日志">
                                        </div>
                                    </div>
                                    <!-- end of the popouparea -->
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <!--===================================Ending of Main Content===========================================-->
        </td>
        <td width="10" align="center" valign="top"></td>
    </tr>
</table>
</form>
<div id="footer"></div>
</body>
</html>

