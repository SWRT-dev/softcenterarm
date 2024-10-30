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
<title>软件中心 - socat端口转发</title>
<link rel="stylesheet" type="text/css" href="index_style.css" />
<link rel="stylesheet" type="text/css" href="form_style.css" />
<link rel="stylesheet" type="text/css" href="usp_style.css" />
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script language="JavaScript" type="text/javascript" src="/js/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/js/httpApi.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<style type="text/css">
.socat_btn {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}
.socat_btn:hover {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
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
var db_socat = {};
var node_max = 0;
function initial() {
	show_menu(menu_hook);
	get_dbus_data();
	conf2obj();
	get_status();
}
function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/socat",
		dataType: "json",
		async: false,
		success: function(data) {
			db_socat = data.result[0];
			conf2obj();
			update_visibility();
			$("#socat_version_show").html("插件版本：" + db_socat["socat_version"]);
		}
	});
}
function conf2obj() {
	if(db_socat["socat_cron_type"]) {
	    E("socat_cron_type").value = db_socat["socat_cron_type"];
	}
	if(db_socat["socat_cron_time_min"]) {
	    E("socat_cron_time_min").value = db_socat["socat_cron_time_min"];
	}
	if(db_socat["socat_cron_time_hour"]) {
	    E("socat_cron_time_hour").value = db_socat["socat_cron_time_hour"];
	}
	
	if(db_socat["socat_enable"]) {
	    E("socat_enable").checked = db_socat["socat_enable"] == 1 ? true : false;
	}
	//dfnamic table data
	$("#conf_table").find("tr:gt(2)").remove();
	$('#conf_table tr:last').after(refresh_html());
}
function get_status() {
	var postData = {
		"id": parseInt(Math.random() * 100000000),
		"method": "socat_status.sh",
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
function save() {
	if(!E("socat_cron_type").value){
	    E("socat_cron_time_min").value = "";
	    E("socat_cron_time_hour").value = "";
	}else if(E("socat_cron_type").value == "min"){
	    E("socat_cron_time_hour").value = "";
	}else if(E("socat_cron_type").value == "hour"){
	    E("socat_cron_time_min").value = "";
	}
	showLoading(2);
	
    db_socat["socat_cron_type"] = E("socat_cron_type").value;
    db_socat["socat_cron_time_min"] = E("socat_cron_time_min").value;
    db_socat["socat_cron_time_hour"] = E("socat_cron_time_hour").value;
    db_socat["socat_enable"] = E("socat_enable").checked ? '1' : '0';
    
    // post data
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "socat_config.sh", "params": ["restart"], "fields": db_socat };
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

	refreshpage(2);
}
function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "软件中心", "离线安装", "Socat 端口转发");
	tablink[tablink.length - 1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_socat.asp");
}
// 添加配置行
function addTr(o) {
	var _form_addTr = document.form;
		
	if (!trim(E("listen_port_node").value) || !trim(E("dest_ip_node").value) || !trim(E("dest_port_node").value)) {
			alert("表单有必填项未填写!");
			return false;
	}
		
	var ns = {};
	var p = "socat";
	node_max += 1;
	var params = ["family_node", "proto_node", "listen_port_node", "reuseaddr_node", "dest_proto_node", "dest_ip_node", "dest_port_node", "firewall_accept_node"];
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
			// 添加成功一个后将输入框还原
			document.form.family_node.value = "v6";
			document.form.proto_node.value = "tcp";
			document.form.listen_port_node.value = "";
			document.form.reuseaddr_node.value = "on";
			document.form.dest_proto_node.value = "tcp4";
			document.form.dest_ip_node.value = "";
			document.form.dest_port_node.value = "";
			document.form.firewall_accept_node.value = "off";
		}
	});
}
function delTr(o) { //删除配置行功能
	if (confirm("你确定删除吗？")) {
		//定位每行配置对应的ID号
		var id = $(o).attr("id");
		var ids = id.split("_");
		var p = "socat";
		id = ids[ids.length - 1];
		// 定义ns数组，用于回传给dbus
		var ns = {};
		var params = ["family_node", "proto_node", "listen_port_node", "reuseaddr_node", "dest_proto_node", "dest_ip_node", "dest_port_node", "firewall_accept_node"];
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
// 配置行刷新
function refresh_table() {
	$.ajax({
		type: "GET",
		url: "/_api/socat",
		dataType: "json",
		async: false,
		success: function(data) {
			db_socat = data.result[0];
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
	document.form.family_node.value = c["family_node"];
	document.form.proto_node.value = c["proto_node"];
	document.form.listen_port_node.value = c["listen_port_node"];
	document.form.reuseaddr_node.value = c["reuseaddr_node"];
	document.form.dest_proto_node.value = c["dest_proto_node"];
	document.form.dest_ip_node.value = c["dest_ip_node"];
	document.form.dest_port_node.value = c["dest_port_node"];
	document.form.firewall_accept_node.value = c["firewall_accept_node"];
	myid = id;
}
// 读取配置行数据
function getAllConfigs() {
	var dic = {};
	for (var field in db_socat) {
		names = field.split("_");
		dic[names[names.length - 1]] = 'ok';
	}
	confs = {};
	var p = "socat";
	var params = ["family_node", "proto_node", "listen_port_node", "reuseaddr_node", "dest_proto_node", "dest_ip_node", "dest_port_node", "firewall_accept_node"];
	for (var field in dic) {
		var obj = {};
		for (var i = 0; i < params.length; i++) {
			var ofield = p + "_" + params[i] + "_" + field;
			if (typeof db_socat[ofield] == "undefined") {
				obj = null;
				break;
			}
			obj[params[i]] = db_socat[ofield];
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
// 配置行内容刷新
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
		html = html + '<td>' + c["family_node"] + '</td>';
		html = html + '<td>' + c["proto_node"] + '</td>';
		html = html + '<td>' + c["listen_port_node"] + '</td>';
		html = html + '<td>' + c["reuseaddr_node"] + '</td>';
		html = html + '<td>' + c["dest_proto_node"] + '</td>';
	    html = html + '<td>' + c["dest_ip_node"] + '</td>';
		html = html + '<td>' + c["dest_port_node"] + '</td>';
		html = html + '<td>' + c["firewall_accept_node"] + '</td>';
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
//事件响应
function show_hide_element(){
	if(!E("socat_cron_type").value){
	    E("socat_cron_time_min").style.display = "none";
		E("socat_cron_time_hour").style.display = "none";
	}else if(E("socat_cron_type").value == "min") {
		E("socat_cron_time_min").style.display = "";
		E("socat_cron_time_hour").style.display = "none";
	}else if(E("socat_cron_type").value == "hour") {
	    E("socat_cron_time_min").style.display = "none";
	    E("socat_cron_time_hour").style.display = "";
	}
}
//更新隐藏项目
function update_visibility(){
	if(!db_socat["socat_cron_type"]){
	    E("socat_cron_time_min").style.display = "none";
		E("socat_cron_time_hour").style.display = "none";
	}else if(db_socat["socat_cron_type"] == "min") {
		E("socat_cron_time_min").style.display = "";
		E("socat_cron_time_hour").style.display = "none";
	}else if(db_socat["socat_cron_type"] == "hour") {
	    E("socat_cron_time_min").style.display = "none";
		E("socat_cron_time_hour").style.display = "";
	}
}
</script>
</head>
<body onload="initial();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=socat" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_socat.asp"/>
<input type="hidden" name="next_page" value="Module_socat.asp"/>
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
                                    <div style="float:left;" class="formfonttitle">软件中心 - Socat 端口转发</div>
                                    <div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                                    <div style="margin:30px 0 10px 5px;" class="splitLine"></div>
                                    <div class="formfontdesc">Socat 是 Linux 下的一个多功能的网络工具，名字来由是「Socket CAT」，其功能与有瑞士军刀之称的 Netcat 类似，可以看做是 Netcat 的加强版。【更多信息：<a href="http://www.dest-unreach.org/socat/" target="_blank"><em><u>点击查看</u></em></a>】</div>
                                    <div id="socat_switch_show">
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                        <tr id="switch_tr">
                                            <th>
                                                启用 Socat
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="socat_enable">
                                                        <input id="socat_enable" class="switch" type="checkbox" style="display: none;">
                                                        <div class="switch_container" >
                                                            <div class="switch_bar"></div>
                                                            <div class="switch_circle transition_style">
                                                                <div></div>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
                                                <div id="socat_version_show" style="padding-top:5px;margin-left:30px;margin-top:0px;float: left;"></div>
                                            </td>
                                        </tr>
                                        <tr id="socat_status">
                                            <th width="20%">运行状态</th>
                                            <td><span id="status">获取中..</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">定时功能 (留空关闭)</th>
                                            <td>每
                                                <select id="socat_cron_time_min" name="socat_cron_time_min" style="width:60px;vertical-align: middle;" class="input_option">
                                                    <option value="5">5</option>
                                                    <option value="6">6</option>
                                                    <option value="10">10</option>
                                                    <option value="12">12</option>
                                                    <option value="15">15</option>
                                                    <option value="20">20</option>
                                                    <option value="30">30</option>
                                                    <option value="60" selected="selected">60</option>
												</select>
												<select id="socat_cron_time_hour" name="socat_cron_time_hour" style="width:60px;vertical-align: middle;" class="input_option">
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    <option value="6">6</option>
                                                    <option value="8">8</option>
                                                    <option value="12" selected="selected">12</option>
                                                    <option value="24">24</option>
												</select>
												<select id="socat_cron_type" name="socat_cron_type" style="width:60px;vertical-align: middle;" class="input_option" onchange="show_hide_element();">
													<option value="">-空-</option>
													<option value="min">分钟</option>
													<option value="hour">小时</option>
												</select>
												重启一次服务
                                            </td>
                                        </tr>
                                    </table>
                                    </div>

                                    <div id="simple_table">
                                    <table id="conf_table" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" style="box-shadow: 3px 3px 10px #000;margin-top: 10px;">
                                          <thead>
                                              <tr>
                                                <td colspan="10">端口转发配置</td>
                                              </tr>
                                          </thead>
                                          <tr>
                                          <th>监听限制</th>
                                          <th>监听协议</th>
                                          <th>监听端口</th>
                                          <th>reuseaddr</th>
                                          <th>目标协议</th>
                                          <th>目标地址</th>
                                          <th>目标端口</th>
                                          <th>打开端口</th>
                                          <th>修改</th>
                                          <th>添加/删除</th>
                                          </tr>
                                          <tr>
                                        <td>
                                            <select id="family_node" name="family_node" style="width:70px;margin:0px 0px 0px 2px;" class="input_option" >
                                                <option value="v6">IPv6</option>
                                                <option value="v4">IPv4</option>
                                                <option value="v4/v6">v4/v6</option>
                                            </select>
                                        </td>
                                         <td>
                                            <select id="proto_node" name="proto_node" style="width:60px;margin:0px 0px 0px 2px;" class="input_option" >
                                                <option value="tcp">TCP</option>
                                                <option value="udp">UDP</option>
                                            </select>
                                        </td>
                                        <td>
                                            <input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" id="listen_port_node" name="listen_port_node" class="input_6_table" maxlength="6" placeholder=""/>
                                        </td>
                                         <td>
                                            <select id="reuseaddr_node" name="reuseaddr_node" style="width:50px;margin:0px 0px 0px 2px;" class="input_option">
                                                <option value="on">是</option>
                                                <option value="off">否</option>
                                            </select>
                                        </td>
                                        <td>
                                            <select id="dest_proto_node" name="dest_proto_node" style="width:70px;margin:0px 0px 0px 2px;" class="input_option">
                                                <option value="tcp4">v4-tcp</option>
                                                <option value="udp4">v4-udp</option>
                                                <option value="tcp6">v6-tcp</option>
                                                <option value="udp6">v6-udp</option>
                                            </select>
                                        </td>
                                        <td>
                                            <input type="text" id="dest_ip_node" name="dest_ip_node" class="input_12_table" maxlength="99" placeholder=""/>
                                        </td>
                                        <td>
                                            <input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" id="dest_port_node" name="dest_port_node" class="input_6_table" maxlength="6" placeholder=""/>
                                        </td>
                                        <td>
                                            <select id="firewall_accept_node" name="firewall_accept_node" style="width:50px;margin:0px 0px 0px 2px;" class="input_option">
                                                <option value="on">是</option>
                                                <option value="off" selected="selected">否</option>
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
                                    <div class="formbottomdesc" id="cmdDesc">
                                        注意：<br/>
                                        1、<i>打开端口</i>，防火墙将接受通过<i>监听端口</i>的入站网络数据。<br/>
                                        2、<i>reuseaddr</i>，允许在主进程终止后立即重新启动，即使某些子套接字没有完全关闭。<br/>
                                        3、端口转发配置中<i>添加/删除</i>为实时保存数据，请谨慎操作，修改后需<i>提交</i>才能运行。
                                    </div>
                                    <div style="margin:30px 0 10px 5px;" class="splitLine"></div>
                                    <div class="apply_gen">
                                        <span><input class="socat_btn" style="cursor:pointer" id="cmdBtn" onclick="save()" type="button" value="提交"/></span>
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
</form>
<div id="footer"></div>
</body>
</html>

