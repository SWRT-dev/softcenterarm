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
</style>
<script>
var params_check = ["zerotier_enable", "zerotier_nat"];
var zerotier_input = ["zerotier_id"];
function E(e) {
	return (typeof(e) == 'string') ? document.getElementById(e) : e;
}
function init() {
	show_menu(menu_hook);
	get_dbus_data();
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/dbconf?p=zerotier_",
		dataType: "script",
		async: false,
		success: function(data) {
			db_zerotier = db_zerotier_;
			conf2obj();
			check_status();
		}
	});
}

function conf2obj() {
	// check for 0 and 1
	for (var i = 0; i < params_check.length; i++) {
		if(db_zerotier_[params_check[i]]){
			E(params_check[i]).checked = db_zerotier_[params_check[i]] == 1 ? true : false
		}
	}
	//input
	for (var i = 0; i < zerotier_input.length; i++) {
		if(db_zerotier_[zerotier_input[i]]){
			E(zerotier_input[i]).value = db_zerotier_[zerotier_input[i]];
		}
	}
}

function save() {
	showLoading(3);
	refreshpage(3);
	// check for 0 and 1
	for (var i = 0; i < params_check.length; i++) {
		db_zerotier[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	//input
	for (var i = 0; i < zerotier_input.length; i++) {
		if (E(zerotier_input[i]).value) {
			db_zerotier[zerotier_input[i]] = E(zerotier_input[i]).value;
		}
	}
	db_zerotier["action_script"]="zerotier_config.sh";
	db_zerotier["action_mode"] = "restart";
	$.ajax({
		url: "/applydb.cgi?p=zerotier",
		cache: false,
		type: "POST",
		dataType: "text",
		data: $.param(db_zerotier)
	});
}

function check_status(){

	$.ajax({
		url: '/logreaddb.cgi?p=zerotier_status.log&script=zerotier_status.sh',
		dataType: 'html',
		success: function (response) {
			//console.log(response)
			E("zerotier_status").innerHTML = response;
			setTimeout("check_status();", 5000);
		},
		error: function(){
			setTimeout("check_status();", 5000);
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
                						<div id="zerotier_title" style="float:left;" class="formfonttitle" style="padding-top: 12px">Zerotier</div>
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
													<th>启用zerotier</th>
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
													<th>运行状态</th>
													<td colspan="2"  id="zerotier_status">
													</td>
												</tr>
												<tr>
													<th>自动允许客户端NAT</th>
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
													<th>ZeroTier Network ID</th>
													<td style="width:25%;">
													<input type="text" class="input_ss_table" style="width:auto;" name="zerotier_id" value="" maxlength="300" size="50" id="zerotier_id" />
													</td>
												</tr>
												<tr>
													<th>zerotier官网</th>
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
											Web api ver : <i>v1.1</i>
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

