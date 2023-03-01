<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title sclang>zerotier</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script type="text/javascript" src="/js/i18n.js"></script>
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
	#return_btn {
		cursor:pointer;
		position:absolute;
		margin-left:-30px;
		margin-top:-25px;
	}
	.popup_bar_bg_ks{
		position:fixed;	
		margin: auto;
		top: 0;
		left: 0;
		width:100%;
		height:100%;
		z-index:99;
		filter:alpha(opacity=90);  /*IE5、IE5.5、IE6、IE7*/
		background-repeat: repeat;
		visibility:hidden;
		overflow:hidden;
		background:rgba(68, 79, 83, 0.85) none repeat scroll 0 0 !important; /* W3C asuscss */
		background: url(/images/New_ui/login_bg.png); /* W3C rogcss */
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
	.content_status {
		position: absolute;
		-webkit-border-radius: 5px;
		-moz-border-radius: 5px;
		border-radius:10px;
		z-index: 10;
		margin-left: -215px;
		top: 0;
		left: 0;
		height:auto;
		box-shadow: 3px 3px 10px #000;
		background: rgba(0,0,0,0.88);
		width:748px;
		/*display:none;*/
		visibility:hidden;
	}
	.user_title{
		text-align:center;
		font-size:18px;
		color:#99FF00;
		padding:10px;
		font-weight:bold;
	}
	#ztpeers_status {
		border:0px solid #222;
		width:98%;
		font-family:'Lucida Console';
		font-size:12px;
		padding-left:13px;
		padding-right:33px;
		background: transparent;
		color:#FFFFFF;
		outline:none;
		overflow-x:hidden;
		line-height:1.5;
	}
	.contentM_qis {
		position: absolute;
		-webkit-border-radius: 5px;
		-moz-border-radius: 5px;
		border-radius: 5px;
		z-index: 200;
		background-color:#2B373B;
		margin-left: 10px;
		top: 250px;
		width:730px;
		return height:auto;
		box-shadow: 3px 3px 10px #000;
		/*display:none;*/
		line-height:1.8;
		visibility:hidden;
	}
	.pop_div_bg{
		background-color: #2B373B; /* W3C asuscss */
		background-color: #030102; /* W3C rogcss */
	}
	.QISform_wireless {
		width:690px;
		font-size:14px;
		color:#FFFFFF;
	}
	.remove_btn{
		background: transparent url(/res/zt_del.png) no-repeat scroll center top;
	}
	.edit_btn{
	  background: transparent url(/res/zt_edt.png) no-repeat scroll center top;
	}
	.add_btn{
		background: transparent url(/res/zt_add.png) no-repeat scroll center top;
	}
	.ks_btn {
		border:none;
		font-size:10pt;
		color: #fff;
		padding: 5px 5px 5px 5px;
		border-radius: 5px 5px 5px 5px;
		width:14%;
		cursor: pointer;
		vertical-align: middle;
		background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C asuscss */
		background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss */
	}
	.ks_btn:hover {
		border:none;
		font-size:10pt;
		color: #fff;
		padding: 5px 5px 5px 5px;
		border-radius: 5px 5px 5px 5px;
		width:14%;
		cursor: pointer;
		vertical-align: middle;
		background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C asuscss */
		background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss */
	}
	input[type=button]:focus {
		outline: none;
	}
	.show-btn0, .show-btn1, .show-btn2, .show-btn3, .show-btn4, .show-btn5 {
		font-family: Roboto-Light, "Microsoft JhengHei";
		font-size:10pt;
		color: #fff;
		padding: 10px 4px;
		border-radius: 5px 5px 0px 0px;
		width:12%;
		border-left: 1px solid #67767d; /* W3C asuscss */
		border-top: 1px solid #67767d; /* W3C asuscss */
		border-right: 1px solid #67767d; /* W3C asuscss */
		border-bottom: none; /* W3C asuscss */
		background: #67767d; /* W3C asuscss */
		border: 1px solid #91071f; /* W3C rogcss */
		background: none; /* W3C rogcss */
		margin-right: 6px;
		cursor:pointer
	}
	.show-btn0:hover, .show-btn1:hover, .show-btn2:hover, .show-btn3:hover, .show-btn4:hover, .show-btn5:hover, .active {
		cursor:pointer
		font-family: Roboto-Light, "Microsoft JhengHei";
		border: 1px solid #2f3a3e; /* W3C asuscss */
		background: #2f3a3e; /* W3C asuscss */
		border: 1px solid #91071f; /* W3C rogcss */
		background: #91071f; /* W3C rogcss */
	}
	#log_content {
		border:1px solid #000;
		width:99%;
		font-family:'Lucida Console';
		font-size:11px;
		padding-left:3px;
		padding-right:22px;
		background:transparent;
		color:#FFFFFF;
		outline:none;
		overflow-x:hidden;
		line-height:1.5;
	}
	.FormTitle em {
		color: #00ffe4;
		font-style: normal;
		font-weight:bold;
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
	#zerotier_main, #zerotier_ztnets, #zerotier_route_div_2, #zt_moons_settings_div, #zerotier_interface_div_0, #zerotier_interface_div_1, #zerotier_interface_div_2, #zerotier_interface_div_3, #zerotier_interface_div_4, #zerotier_interface_div_5 {
		border: none; /* W3C asuscss */
		border: 1px solid #91071f; /* W3C rogcss */
	}
	</style>
<script>
var params_check = ["zerotier_enable", "zerotier_nat"];
var zerotier_input = ["zerotier_id", "zerotier_moonid"];
var dbus = {};
var refresh_flag;
var count_down;
function init() {
	show_menu(menu_hook);
	get_dbus_data();
}

function get_dbus_data(){
	$.ajax({
		type: "GET",
		url: "/_api/zerotier_",
		dataType: "json",
		async: false,
		success: function(data) {
			dbus = data.result[0];
			conf2obj();
			if(dbus["zerotier_enable"] == "1"){
				get_proces_status();
			}
		}
	});
}

function conf2obj(){
	for (var i = 0; i < params_check.length; i++) {
		if(dbus[params_check[i]]){
			E(params_check[i]).checked = dbus[params_check[i]] != "0";
		}
	}
	for (var i = 0; i < zerotier_input.length; i++) {
		if (dbus[zerotier_input[i]]) {
			$("#" + zerotier_input[i]).val(dbus[zerotier_input[i]]);
		}
	}
	if (dbus["zerotier_version"]){
		E("zerotier_version").innerHTML = " - " + dbus["zerotier_version"];
	}
}

function showWBLoadingBar(){
	document.scrollingElement.scrollTop = 0;
	E("loading_block_title").innerHTML = "&nbsp;&nbsp;ZeroTier日志信息";
	E("LoadingBar").style.visibility = "visible";
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

function get_log(flag){
	E("ok_button").style.visibility = "hidden";
	showWBLoadingBar();
	$.ajax({
		url: '/_temp/zerotier.log',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
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
			setTimeout("get_log(" + flag + ");", 600);
			retArea.value = response.replace("XU6J03M6", " ");
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

function get_proces_status() {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "zerotier_status.sh", "params":[], "fields": ""};
	$.ajax({
		type: "POST",
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			//console.log(response);
			if(response.result != id){
				E("zerotier_status").innerHTML = response.result;
			}
			setTimeout("get_proces_status();", 5000);
		},
		error: function() {
			setTimeout("get_proces_status();", 15000);
		}
	});
}

function save(){
	var dbus_new = {};
	for (var i = 0; i < params_check.length; i++) {
		dbus_new[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	
	for (var i = 0; i < zerotier_input.length; i++) {
		dbus_new[zerotier_input[i]] = E(zerotier_input[i]).value;
	}

	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "zerotier_config.sh", "params": ["restart"], "fields": dbus_new};
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

function deorbit_moon(){
	var dbus_new = {};
	dbus_new["zerotier_moonid"] = E("zerotier_moonid").value;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "zerotier_config.sh", "params": ["deorbit"], "fields": dbus_new};
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

function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线下载", "zerotier");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_zerotier.asp");
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
				<textarea cols="50" rows="26" wrap="off" readonly="readonly" id="log_content" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" ></textarea>
			</div>
			<div id="ok_button" class="apply_gen" style="background:#000;visibility:hidden;">
				<input id="ok_button1" class="button_gen" type="button" onclick="hideWBLoadingBar()" value="确定">
			</div>
			</td>
		</tr>
	</table>
</div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<input type="hidden" name="current_page" value="Module_zerotier.asp"/>
<input type="hidden" name="next_page" value="Module_zerotier.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value="restart"/>
<input type="hidden" name="action_script" value="zerotier_config.sh"/>
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
            <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0" style="display: block;">
				<tr>
					<td align="left" valign="top">
						<div>
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div><i>Zerotier是一个开源，跨平台，而且适合内网穿透互联的傻瓜配置虚拟 VPN LAN&nbsp;</i></div>
										<div>&nbsp;</div>
                						<div id="zerotier_title" style="float:left;" class="formfonttitle" style="padding-top: 12px">Zerotier<lable id="zerotier_version"></lable></div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div id="zerotier_switch" style="margin:0px 0px 0px 0px;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
												<tr>
													<td colspan="2">全局设置</td>
												</tr>
												</thead>
												<tr>
													<th style="width:25%;">启用zerotier</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="zerotier_enable">
																<input id="zerotier_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container">
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
													</td>
												</tr>
												<tr>
													<th style="width:25%;">运行状态</th>
													<td colspan="2"  id="zerotier_status">
													</td>
												</tr>
												<tr>
													<th style="width:25%;">自动允许客户端NAT</th>
													<td>
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="zerotier_nat">
																<input id="zerotier_nat" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container">
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
														允许Zerotier的拨入客户端访问路由器LAN资源（需要在 Zerotier管理页面设定到LAN网段的路由表）
													</td>
												</tr>
												<tr>
													<th style="width:25%;">ZeroTier Network ID</th>
													<td style="width:75%;">
													<input type="text" class="input_ss_table" style="width:300;" name="zerotier_id" value="" maxlength="50" size="50" id="zerotier_id" />
													</td>
												</tr>
												<tr>
													<th style="width:25%;">ZeroTier MOON ID</th>
													<td style="width:75%;">
													<input type="text" class="input_ss_table" style="width:300;" name="zerotier_moonid" value="" maxlength="50" size="50" id="zerotier_moonid" />&nbsp;留空为不使用moon
													</td>
												</tr>
												<tr>
													<th style="width:25%;">zerotier官网</th>
													<td>
													<input type="button" class="button_gen" value="zerotier官网" onclick="javascript:window.open('https://my.zerotier.com/network','target');" /><br>
													点击跳转到Zerotier官网管理平台，新建或者管理网络，并允许客户端接入访问你私人网路（新接入的节点默认不允许访问）
													</td>
												</tr>
											</table>
										</div>
										<div id="zerotier_table" style="margin:10px 0px 0px 0px; display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th colspan="4">需要访问其它zerotier的内网LAN网段,IP和网关和zerotier后台对应即可(本机的LAN网段不用填进去)</th>
												</tr>
				                            	<tr id="row_rules_caption">
												 
				                                    <th width="10%">
				                                        启用 <i class="icon-circle-arrow-down"></i>
				                                    </th>
													<th width="20%">
				                                        IP <i class="icon-circle-arrow-down"></i>
				                                    </th>
													<th width="25%">
				                                        网关 <i class="icon-circle-arrow-down"></i>
				                                    </th>
				                                    <th width="5%">
				                                        <center><i class="icon-th-list"></i></center>
				                                    </th>
				                                </tr>
				                                <tr>
				                                 	<th>
														<select class="input_ss_table" style="width:100px;height:25px;" name="zerotier_enable_x_0" id="zerotier_enable_x_0">
															<option value="0" selected="">否</option>
															<option value="1">是</option>
														</select>
				                       				</th>
				                                	<th>
														<input type="text" class="input_ss_table" style="width:auto;" name="zerotier_ip_x_0" value="" maxlength="300" size="50" id="zerotier_ip_x_0" />
				                                    </th>
				                      				<th>
														<input type="text" class="input_ss_table" style="width:auto;" name="zerotier_route_x_0" value="" maxlength="300" size="50" id="zerotier_route_x_0" />
				                                    </th>
				                                 	<th>
				                                        	<input style="margin:-2px 0px -4px -2px;" class="add_btn" style="max-width: 219px" type="button" onclick="markGroupRULES(this, 64, ' Add ');" value=""/>
				                                    </th>
				                                </tr>
				                                <tr id="row_rules_body" >
				                                    <td colspan="4" style="border-top: 0 none; padding: 0px;">
				                                        <div id="MRULESList_Block"></div>
				                                    </td>
				                                </tr>
											</table>
										</div>

										<div class="apply_gen">
											<input id="cmdBtn" type="button" class="button_gen" onclick="save()" value="应用"/>
										</div>
										<div class="SCBottom" style="float:right; width:180px; height:70px">
											Shell&Web by： <i>paldier & chongshengB</i><br>
											Web api ver : <i>v1.5</i>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
        </td>
    </tr>
</table>
<div id="footer"></div>
</body>
</html>

