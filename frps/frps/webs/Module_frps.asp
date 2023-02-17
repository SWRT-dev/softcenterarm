<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - frps</title>
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
<script type="text/javascript" src="/res/frps-menu.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script>
var db_frps = {};
var params_input = ["frps_common_dashboard_port", "frps_common_dashboard_user", "frps_common_dashboard_pwd", "frps_common_bind_port", "frps_common_privilege_token", "frps_common_vhost_http_port", "frps_common_vhost_https_port", "frps_common_cron_time", "frps_common_max_pool_count", "frps_common_log_file", "frps_common_log_level", "frps_common_log_max_days", "frps_common_tcp_mux", "frps_common_cron_hour_min", "frps_common_tls_only", "frps_common_kcp_bind_port", "frps_common_quic_bind_port", "frps_common_bind_udp_port", "frps_common_extra_openport", "frps_common_ifopenport", "frps_common_subdomain_host", "frps_common_cron_type"]
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
				setTimeout("get_status();", 5000);
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
	if(E("frps_common_kcp_bind_port").value == E("frps_common_quic_bind_port").value) {
        if (E("frps_common_kcp_bind_port").value != "") {
            alert("kcp、quic绑定端口冲突！");
            return false; 
	    }
	}
    else if (E("frps_common_kcp_bind_port").value == E("frps_common_bind_udp_port").value) {
            if (E("frps_common_kcp_bind_port").value != "") {
                alert("kcp、udp绑定端口冲突！");
                return false; 
	    }
	    }
	else if (E("frps_common_quic_bind_port").value == E("frps_common_bind_udp_port").value) {
            if(E("frps_common_quic_bind_port").value != "") {
                alert("quic、udp绑定端口冲突！");
                return false; 
	    }
	}
	if (E("frps_extra_config").checked) {
		if (trim(E("frps_extra_options").value) == "") {
			alert("您已启用‘追加其他参数’，提交的表单不能为空!");
			return false;
		}
	}
	if(!E(frps_common_bind_port).value || !E(frps_common_privilege_token).value || !E(frps_common_cron_time).value){
		alert("提交的表单有‘必填项’，不能为空!");
		return false;
	}
	for (var i = 0; i < params_input.length; i++) {
		if (E(params_input[i]).value) {
			db_frps[params_input[i]] = E(params_input[i]).value;
		}else{
			db_frps[params_input[i]] = "";
		}
	}
	for (var i = 0; i < params_check.length; i++) {
		db_frps[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	//base64
	for (var i = 0; i < params_base64.length; i++) {
		if (!E(params_base64[i]).value) {
			db_frps[params_base64[i]] = "";
		} else {
			if (E(params_base64[i]).value.indexOf("=") != -1) {
				db_frps[params_base64[i]] = Base64.encode(E(params_base64[i]).value);
			} else {
				db_frps[params_base64[i]] = "";
			}
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
function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "软件中心", "离线安装", "frps内网穿透");
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
			}
			setTimeout("get_log();", 300);
			retArea.value = response.myReplace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
		},
		error: function(xhr) {
			E("loading_block_title").innerHTML = "暂无日志信息 ...";
			E("log_content").value = "日志文件为空，请关闭本窗口！";
			E("ok_button").style.visibility = "hidden";
			return false;
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
		$('#logfiletxt').val(res);
		}
	});
}
function get_frpsConf() {
    $.ajax({
    url: '/_temp/.frps.ini',
    type: 'GET',
    cache:false,
    dataType: 'text',
    success: function(res) {
		$('#Conftxt').val(res);
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
					<textarea cols="50" rows="26" wrap="off" readonly="readonly" id="log_content" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:transparent;color:#FFFFFF;outline: none;padding-left:3px;padding-right:22px;overflow-x:hidden"></textarea>
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
                                <div style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;">【frps】运行日志</div>
                                <div style="margin-left:15px"><i>&nbsp;文本不会自动刷新，只读取当天的运行日志（需要开启日志文件功能）。读取自日志链接【/tmp/upload/frps_lnk.log】。</i></div>
                                <div id="loading_block_spilt" style="margin:10px 0 10px 5px;" class="loading_block_spilt"></div>
                                <div style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
                                    <textarea cols="50" rows="26" wrap="off" readonly="readonly" id="logfiletxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #000;font-family:'Courier New', Courier, mono; font-size:11px;background:#000000;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                </div>
                                <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node1" class="button_gen" type="button" onclick="close_file('frpslogfile');" value="返回主界面">
                                </div>
                            </div>
                            <div id="frpsConf"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                <div style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;">【frps】配置文件</div>
                                <div style="margin-left:15px"><i>&nbsp;Frps当前配置文件，读取自【/tmp/upload/.frps.ini】。</i></div>
                                <div id="loading_block_spilt" style="margin:10px 0 10px 5px;" class="loading_block_spilt"></div>
                                <div style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
                                    <textarea cols="50" rows="26" wrap="off" readonly="readonly" id="Conftxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #000;font-family:'Courier New', Courier, mono; font-size:11px;background:#000000;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                </div>
                                <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node1" class="button_gen" type="button" onclick="close_file('frpsConf');" value="返回主界面">
                                </div>
                            </div>
						    
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div class="formfonttitle">Frps内网穿透<lable id="frps_version_show"><lable></div>
										<div style="float:right; width:15px; height:25px;margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote">
											<span>frp 是一个专注于内网穿透的高性能的反向代理应用，支持 TCP、UDP、HTTP、HTTPS 等多种协议。可以将内网服务以安全、便捷的方式通过具有公网 IP 节点的中转暴露到公网。【获取链接：<a href="https://github.com/fatedier/frp/releases" target="_blank"><em><u>Releases (Github)</u></em></a>】【官方文档：<a href="https://gofrp.org/docs" target="_blank"><em><u>gofrp.org</u></em></a>】<br>(<i>点击左侧项目的文字，可查看帮助信息</i>)</span>
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
														<div style="float: right;margin-top:5px;margin-right:30px;">
															
															<a type="button" href="https://github.com/SWRT-dev/softcenterarmng/blob/master/frps/version" target="_blank" class="ks_btn" style="cursor: pointer;margin-left:5px;border:none" >更新历史</a>
															<a type="button" class="ks_btn" href="javascript:void(0);" onclick="open_file('frpsConf');" style="cursor: pointer;margin-left:5px;border:none">配置文件</a>
															<a type="button" class="ks_btn" href="javascript:void(0);" onclick="get_log(1)" style="cursor: pointer;margin-left:5px;border:none">插件日志</a>
															<a type="button" class="ks_btn" href="javascript:void(0);" onclick="open_file('frpslogfile');" style="cursor: pointer;margin-left:5px;border:none">运行日志</a>
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
														<input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '')" id="frps_common_cron_time" name="frps_common_cron_time" class="input_ss_table" style="width:30px" value="30" placeholder="" />
														<select id="frps_common_cron_hour_min" name="frps_common_cron_hour_min" style="width:60px;vertical-align: middle;" class="input_option">
															<option value="min" selected="selected">分钟</option>
															<option value="hour">小时</option>
														</select>
														重新
														<select id="frps_common_cron_type" name="frps_common_cron_type" style="width:60px;vertical-align: middle;" class="input_option">
															<option value="L1" selected="selected">检查</option>
															<option value="L2">启动</option>
														</select>一次服务
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(20)">开启端口通过防火墙</a></th>
													<td>
														<select id="frps_common_ifopenport" name="frps_common_ifopenport" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
															<option value="v4" selected="selected">IPV4端口</option>
															<option value="v6">IPV6端口</option>
															<option value="both">(IPV4+IPV6)端口</option>
															<option value="false">不开启</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(19)">开启备用tcp端口</a></th>
													<td>
													    <input type="text" oninput="this.value=this.value.replace(/[^\d,]/g, '')" class="input_ss_table" id="frps_common_extra_openport" name="frps_common_extra_openport" maxlength="60" value="" placeholder="连续填写中间逗号隔开" />
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
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(2)">绑定端口</a></th>
													<td>
												<input type="text" oninput="this.value=this.value.replace(/[^\d-]/g, ''); if(value>65535)value=65535" class="input_ss_table" id="frps_common_bind_port" name="frps_common_bind_port" maxlength="5" value="" placeholder="必填项" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(3)">令牌</a></th>
													<td>
														<input type="password" name="frps_common_privilege_token" id="frps_common_privilege_token" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="256" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);" placeholder="必填项" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(13)">TCP 多路复用</a></th>
													<td>
														<select id="frps_common_tcp_mux" name="frps_common_tcp_mux" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
															<option value="true" selected="selected">开启（默认）</option>
															<option value="false">关闭</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(16)">kcp绑定端口</a></th>
													<td>
												<input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" class="input_ss_table" id="frps_common_kcp_bind_port" name="frps_common_kcp_bind_port" maxlength="5" value="" placeholder="留空，禁用kcp" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(15)">quic绑定端口</a></th>
													<td>
												<input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" class="input_ss_table" id="frps_common_quic_bind_port" name="frps_common_quic_bind_port" maxlength="5" value="" placeholder="留空，禁用quic" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(17)">udp绑定端口</a></th>
													<td>
												<input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" class="input_ss_table" id="frps_common_bind_udp_port" name="frps_common_bind_udp_port" maxlength="5" value="" placeholder="留空，即不配置" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(4)">虚拟主机http端口</a></th>
													<td>
														<input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" class="input_ss_table" id="frps_common_vhost_http_port" name="frps_common_vhost_http_port" maxlength="5" value="" placeholder="留空，即不配置" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(4)">虚拟主机https端口</a></th>
													<td>
														<input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" class="input_ss_table" id="frps_common_vhost_https_port" name="frps_common_vhost_https_port" maxlength="5" value="" placeholder="留空，即不配置" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(21)">子域名后缀</a></th>
													<td>
													    <input type="text" class="input_ss_table" id="frps_common_subdomain_host" name="frps_common_subdomain_host" maxlength="50" value="" placeholder="留空，即不配置"/>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(9)">最大连接池数量</a></th>
													<td>
													    <input type="text" oninput="this.value=this.value.replace(/[^\d-]/g, '')" class="input_ss_table" id="frps_common_max_pool_count" name="frps_common_max_pool_count" maxlength="4" value="" placeholder="留空，即默认5"/>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(14)">强制只接受TLS连接</a></th>
													<td>
														<select id="frps_common_tls_only" name="frps_common_tls_only" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
														    <option value="" selected="selected">（不配置，默认关闭）</option>
															<option value="true">开启</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(6)">日志文件路径</a></th>
													<td>
														<input type="text" class="input_ss_table" id="frps_common_log_file" name="frps_common_log_file" maxlength="100" value="" placeholder="填绝对路径,留空即不配置" />	
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(7)">日志等级</a></th>
													<td>
														<select id="frps_common_log_level" name="frps_common_log_level" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
															<option value="" selected="selected">（不配置，默认info）</option>
															<option value="error">error</option>
															<option value="warn">warn</option>
															<option value="info">info</option>
															<option value="debug">debug</option>
															<option value="trace">trace</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(8)">日志记录保留天数</a></th>
													<td>
													    <input type="text" oninput="this.value=this.value.replace(/[^\d-]/g, '')" class="input_ss_table" id="frps_common_log_max_days" name="frps_common_log_max_days" maxlength="3" value="" placeholder="留空，即默认3" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(1)">监控面板端口</a></th>
													<td>
														<input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" class="input_ss_table" value="" id="frps_common_dashboard_port" name="frps_common_dashboard_port" maxlength="5" value="" placeholder="留空，关闭面板" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(11)">监控面板用户名</a></th>
													<td>
												<input type="text" class="input_ss_table" id="frps_common_dashboard_user" name="frps_common_dashboard_user" maxlength="50" value="" placeholder="留空，即不配置" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(12)">监控面板密码</a></th>
													<td>
														<input type="password" name="frps_common_dashboard_pwd" id="frps_common_dashboard_pwd" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="256" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);" placeholder="留空，即不配置" />
													</td>
												</tr>
												<tr>
                                                <th style="width:20%;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(18)">其他参数追加</a><br>
                                                    <label><input type="checkbox" id="frps_extra_config" name="frps_extra_config"><i>启用</i>
                                                </th>
                                                <td>
                                                    <textarea cols="63" rows="10" wrap="off" id="frps_extra_options" name="frps_extra_options" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="font-size:11px;background:#475A5F;color:#FFFFFF" placeholder="# 不要与上面已存在的参数重复&#13;# 不要在参数行结尾输入字符&#13;# 若要注释，请在行首使用 # 符号&#10;&#10;# 举例：监控面板使用HTTPS连接参考设置&#10;dashboard_tls_mode = true&#10;dashboard_tls_cert_file = /tmp/etc/cert.pem&#10;dashboard_tls_key_file = /tmp/etc/key.pem" ></textarea>
                                                </td>
                                            </tr>
												
											</table>
										</div>
										<div class="apply_gen">
											<input class="button_gen" id="cmdBtn" onClick="save()" type="button" value="提交" />
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote">
											<span>* <i>注意事项</i>：</span>
											<li>1. 搭建环境：ipv4需要公网ip(或<a href="./Advanced_VirtualServer_Content.asp" target="_blank"><em>端口转发</em></a>到公网ip)；若需要，ipv6可以直接搭建，并用ipv6访问</li>
											<li>2. 为了frps稳定运行，强烈建议开启虚拟内存</li>
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

