<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - tailscale设置</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script type="text/javascript">

var db_tailscale = {};
var params_check = ["tailscale_enable", "tailscale_nat"]; 

function init() {
	show_menu(menu_hook);
	get_dbus_data();
}


function E(e) {
    	return (typeof(e) == 'string') ? document.getElementById(e) : e;
   }

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/tailscale",
		dataType: "json",
		async: false,
		success: function(data) {
			db_tailscale = data.result[0];
			conf2obj();
			if(db_tailscale["tailscale_enable"] == "1"){
				if(db_tailscale["tailscale_online"] == "3")
					E("status").innerHTML = "无法连接到服务器";
				else
					get_status();
			}
		}
	});
}

function conf2obj() {
//	for (var i = 0; i < params_input.length; i++) {
//		if (db_tailscale[params_input[i]]) {
//			E(params_input[i]).value = db_tailscale[params_input[i]];
//		}
//	}
	for (var i = 0; i < params_check.length; i++) {
		if (db_tailscale[params_check[i]]) {
			E(params_check[i]).checked = db_tailscale[params_check[i]] == "1";
		}
	}
}

function get_status() {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "tailscale_status.sh", "params": [], "fields": ""};
	$.ajax({
		type: "POST",
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(typeof response.result == "number")
				setTimeout("get_status();", 5000);
			else{
				E("status").innerHTML = response.result;
				setTimeout("get_status();", 20000);
			}
		},
		error: function() {
			setTimeout("get_status();", 5000);
		}
	});
}

function check_login() {
	var id = parseInt(Math.random() * 100000000);
	var postData = { "id": id, "method": "tailscale_config.sh", "params": "check_login", "fields": db_tailscale };
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
		}
	});
}


function save() {
//	for (var i = 0; i < params_input.length; i++) {
//		if (E(params_input[i])) {
//			db_tailscale[params_input[i]] = E(params_input[i]).value
//		}
//	}
	for (var i = 0; i < params_check.length; i++) {
		db_tailscale[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	showLoading();
	push_data(db_tailscale, "restart", 1);
}

function push_data(obj, arg, reload) {
	var id = parseInt(Math.random() * 100000000);
	var postData = { "id": id, "method": "tailscale_config.sh", "params": [arg], "fields": obj };
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			if(response.result == id && reload == 1)
				refreshpage();
		}
	});
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "软件中心", "离线安装", "tailscale");
	tablink[tablink.length - 1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_tailscale.asp");
}

function login() {
	window.open("http://"+window.location.hostname+":8088");
}
</script> 
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
		<input type="hidden" name="current_page" value="Module_tailscale.asp" />
		<input type="hidden" name="next_page" value="Module_tailscale.asp" />
		<input type="hidden" name="group_id" value="" />
		<input type="hidden" name="modified" value="0" />
		<input type="hidden" name="action_mode" value="" />
		<input type="hidden" name="action_script" value="" />
		<input type="hidden" name="action_wait" value="5" />
		<input type="hidden" name="first_time" value="" />
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
								<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
									<tr>
										<td bgcolor="#4D595D" colspan="3" valign="top">
											<div>&nbsp;</div>
											<div style="float:left;" class="formfonttitle">tailscale</div>
											<div style="float:right; width:15px; height:25px;margin-top:10px">
												<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
											</div>
											<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
											<div class="formfontdesc" style="padding-top:5px;margin-top:0px;float: left;" id="cmdDesc">
												<div>tailscale</div>
												<ul style="padding-top:5px;margin-top:10px;float: left;">
													<li>启用后，等待几秒钟，点击<u>加入网络</u></li> 
                                                    <li>登录到官网后台后如果需要访问内网其他设备,选择对应设备右边的Edit route settings启用内网nat</li>
                                                    <li>未付费账号仅一台设备支持开启内网nat,其他设备支持访问开启内网nat设备的ip段</li>
													<li><a href="https://login.tailscale.com" target="_blank" ><i><u>官网</u></i></a></li> 
												</ul>
											</div>
											<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
												<thead>
													<tr>
														<td colspan="2">开关设置</td>
													</tr>
												</thead>
												<tr id="switch_tr">
													<th>开启tailscale</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="tailscale_enable">
																<input id="tailscale_enable" class="switch" type="checkbox" style="display: none;">
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
												<tr id="switch_tr">
													<th>开启nat</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="tailscale_nat">
																<input id="tailscale_nat" class="switch" type="checkbox" style="display: none;">
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
												<tr id="status_tr">
													<th width="35%">状态</th>
													<td>
														<a>	<span id="status"></span>
														</a>
													</td>
												</tr>												
											</table>
											<div class="apply_gen">
												<input class="button_gen" id="cmdBtn" onClick="save();" type="button" value="提交" />
												<input id="login_id" class="button_gen" onClick="login();" type="button" value="加入网络" />
											</div>
											<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
											<div class="SCBottom">
												<br/>后台技术支持：<i>paldier</i> 
												<br/>Shell, Web by：<i>paldier</i>
											</div>
										</td>
									</tr>
								</table>
							</td>
							<td width="10" align="center" valign="top"></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	<div id="footer"></div>
</body>
</html>
