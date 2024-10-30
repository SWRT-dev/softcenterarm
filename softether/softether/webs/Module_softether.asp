<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心-Softether VPN server</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script language="JavaScript" type="text/javascript" src="/js/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/js/httpApi.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script>
var db_softether = {}
function init() {
	show_menu();
	get_dbus_data();
	get_status();
}
function get_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "softether_status.sh", "params":[1], "fields": ""};
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
function get_dbus_data() {
	$.ajax({
		type: "post",
		url: "dbconf?p=softether_",
		dataType: "script",
		async: false,
		success: function(data) {
			db_softether = db_softether_;
			E("softether_enable").checked = db_softether["softether_enable"] == "1";
			E("softether_tcp_v6").checked = db_softether["softether_tcp_v6"] == "1";
			E("softether_udp_v6").checked = db_softether["softether_udp_v6"] == "1";
			E("softether_manager_port_check").checked = db_softether["softether_manager_port_check"] == "1";
			E("softether_cascade_port_check").checked = db_softether["softether_cascade_port_check"] == "1";
			E("softether_openvpn_udp_check").checked = db_softether["softether_openvpn_udp_check"] == "1";
			E("softether_tcp_ports_check").checked = db_softether["softether_tcp_ports_check"] == "1";
			E("softether_l2tp_check").checked = db_softether["softether_l2tp_check"] == "1";
			E("softether_udp_ports_check").checked = db_softether["softether_udp_ports_check"] == "1";
			if(db_softether["softether_tcp_ports"]){					
				E("softether_tcp_ports").value = db_softether["softether_tcp_ports"];
			}
			if(db_softether["softether_udp_ports"]){					
				E("softether_udp_ports").value = db_softether["softether_udp_ports"];
			}
			if(db_softether["softether_manager_port"]){					
				E("softether_manager_port").value = db_softether["softether_manager_port"];
			}
			if(db_softether["softether_cascade_port"]){					
				E("softether_cascade_port").value = db_softether["softether_cascade_port"];
			}
		}
	});
}
function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "软件中心", "离线安装", "Softether VPN server");
	tablink[tabtitle.length - 1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_softether.asp");
}
function onSubmitCtrl() {
	showLoading(3);
	refreshpage(3);
	// collect data from checkbox
	db_softether["softether_enable"] = E("softether_enable").checked ? '1' : '0';
	db_softether["softether_tcp_v6"] = E("softether_tcp_v6").checked ? '1' : '0';
	db_softether["softether_udp_v6"] = E("softether_udp_v6").checked ? '1' : '0';
	db_softether["softether_manager_port_check"] = E("softether_manager_port_check").checked ? '1' : '0';
	db_softether["softether_cascade_port_check"] = E("softether_cascade_port_check").checked ? '1' : '0';
	db_softether["softether_openvpn_udp_check"] = E("softether_openvpn_udp_check").checked ? '1' : '0';
	db_softether["softether_tcp_ports_check"] = E("softether_tcp_ports_check").checked ? '1' : '0';
	db_softether["softether_l2tp_check"] = E("softether_l2tp_check").checked ? '1' : '0';
	db_softether["softether_udp_ports_check"] = E("softether_udp_ports_check").checked ? '1' : '0';
	db_softether["softether_manager_port"] = E("softether_manager_port").value;
	db_softether["softether_tcp_ports"] = E("softether_tcp_ports").value;
	db_softether["softether_udp_ports"] = E("softether_udp_ports").value;
	db_softether["softether_cascade_port"] = E("softether_cascade_port").value;
	
	// post data
	//var id = parseInt(Math.random() * 100000000);
	//var postData = {
	//	"id": id,
	//	"method": "softether_config.sh",
	//	"params": [1],
	//	"fields": db_softether
	//};
	db_softether["action_script"]="softether_config.sh";
	db_softether["action_mode"] = "restart";
	db_softether["current_page"] = "Module_softether.asp";
	db_softether["next_page"] = "Module_softether.asp";
	$.ajax({
		url: "/applydb.cgi?p=softether",
		cache: false,
		type: "POST",
		dataType: "html",
		data: $.param(db_softether)
	});
}
function openurl() {
    if(E("softether_manager_port").value == "") {
        alert("管理器连接端口为空！");
        return false; 
    }
	window.open("https://"+window.location.hostname+":"+E("softether_manager_port").value);
}
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<input type="hidden" name="current_page" value="Module_softether.asp"/>
	<input type="hidden" name="next_page" value="Module_softether.asp"/>
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
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div class="formfonttitle">Softether VPN server - Version 4.29 build 9680</div>
										<div style="float:right; width:15px; height:25px;margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote">
											<li>
											开启<a href="https://www.softether.org/" target="_blank"> <i><u>SoftEther VPN</u></i></a>后，需要用
											<a href="http://www.softether-download.com/cn.aspx?product=softether" target="_blank"> <i><u>SoftEther VPN Server Manager</u></i></a>进行进一步设置。
											<a href="https://www.right.com.cn/forum/thread-8240065-1-1.html" target="_blank"> <i><u>设置教程</u></i></a>&nbsp;&nbsp;&nbsp;
											<a href="https://www.softether.org/4-docs/1-manual/A._Examples_of_Building_VPN_Networks" target="_blank"> <i><u>官方示例</u></i></a>
											</li>
										</div>
										<div class="formfontdesc"></div>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">softether开关</td>
											</tr>
											</thead>
											<tr>
											<th>开启softether</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell">
														<label for="softether_enable">
															<input id="softether_enable" class="switch" type="checkbox" style="display: none;">
															<div class="switch_container" >
																<div class="switch_bar"></div>
																<div class="switch_circle transition_style">
																	<div></div>
																</div>
															</div>
														</label>
													</div>
												</td>
											</tr>
											<th>运行状态</th>
												<td>
													<div id="softether_status"><i><span id="status">获取中...</span></i></div>
												</td>
											<tr>
												<th>打开TCP端口入站<br>
												<label><input type="checkbox" id="softether_tcp_v6" name="softether_tcp_v6"><i>包含ipv6</i></label></th>
												<td>
												    <label><input type="checkbox" id="softether_manager_port_check" name="softether_manager_port_check">管理器连接端口：</label>
												    <input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" class="input_ss_table" id="softether_manager_port" name="softether_manager_port" style="width:50px" maxlength="5" value="" placeholder="" />
												    &nbsp;&nbsp;<span><input id="cmdBtn" onclick="openurl();" type="button" value="Web管理页"/></span><br>
												    <label><input type="checkbox" id="softether_cascade_port_check" name="softether_cascade_port_check">级联连接端口：</label>
												    <input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" class="input_ss_table" id="softether_cascade_port" name="softether_cascade_port" style="width:50px" maxlength="5" value="" placeholder="" /><br>
												    <label><input type="checkbox" id="softether_tcp_ports_check" name="softether_tcp_ports_check">其他端口列表：</label>
												    <input type="text" oninput="this.value=this.value.replace(/[^\d ]/g, '')" class="input_ss_table" id="softether_tcp_ports" name="softether_tcp_ports" maxlength="60" value="" placeholder="空格隔开" /><p><em>提示：相同端口号无需重复填写；请确认管理器的端口号监听是否打开。</em></p>
												</td>
											</tr>
											<tr>
												<th>打开UDP端口入站<br>
												<label><input type="checkbox" id="softether_udp_v6" name="softether_udp_v6"><i>包含ipv6</i></label></th>
							                    <td>
						                            <label><input type="checkbox" id="softether_l2tp_check" name="softether_l2tp_port_check">L2TP/IPSec服务</label><br>
							                        <label><input type="checkbox" id="softether_openvpn_udp_check" name="softether_openvpn_udp_check">OpenVPN服务（<em>以及TCP端口</em>）</label><br>
												    <label><input type="checkbox" id="softether_udp_ports_check" name="softether_udp_ports_check">其他端口列表：</label>   
												    <input type="text" oninput="this.value=this.value.replace(/[^\d ]/g, '')" class="input_ss_table" id="softether_udp_ports" name="softether_udp_ports" maxlength="60" value="" placeholder="空格隔开" />
								                </td>
											</tr>
										</table>
										<p>&nbsp;&nbsp;注意：关于“<em>其他端口列表</em>”栏，多个端口号，用<strong>空格隔开</strong>，例如：8080 443 992</p>
										<div class="apply_gen">
											<span><input class="button_gen" id="cmdBtn" onclick="onSubmitCtrl();" type="button" value="提交"/></span>
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="KoolshareBottom">
											<br/>论坛技术支持： <a href="https://www.right.com.cn" target="_blank"> <i><u>right.com.cn</u></i></a><br/>
											后台技术支持： <i>Xiaobao</i> <br/>
											Shell, Web by： <i>sadoneli</i><br/>
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
	</td>
	<div id="footer"></div>
</body>
</html>
