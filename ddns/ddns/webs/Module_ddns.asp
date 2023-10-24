<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>ddns</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" language="JavaScript" src="/js/table/table.js"></script>
<script type="text/javascript" language="JavaScript" src="/client_function.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<style>
	.show-btn1, .show-btn2 {
		font-size:10pt;
		color: #fff;
		padding: 10px 3.75px;
		border-radius: 5px 5px 0px 0px;
		width:8.42%;
		border-left: 1px solid #67767d;
		border-top: 1px solid #67767d;
		border-right: 1px solid #67767d;
		border-bottom: none;
		background: #67767d;
		border: 1px solid #91071f; /* W3C rogcss */
		background: none; /* W3C rogcss */
	}
	.show-btn1:hover, .show-btn2:hover, .active {
		border: 1px solid #2f3a3e;
		background: #2f3a3e;
		border: 1px solid #91071f; /* W3C rogcss */
		background: #91071f; /* W3C rogcss */
	}
	#log_content{
		outline: 1px solid #222;
		width:748px;
	}
	#log_content_text{
		width:97%;
		padding-left:4px;
		padding-right:37px;
		font-family:'Lucida Console';
		font-size:11px;
		line-height:1.5;
		color:#FFFFFF;
		outline:none;
		overflow-x:hidden;
		border:0px solid #222;
		background:#475A5F;
		background:transparent; /* W3C rogcss */
	}
	.ks_btn {
		border: 1px solid #222;
		font-size:10pt;
		color: #fff;
		padding: 5px 5px 5px 5px;
		border-radius: 5px 5px 5px 5px;
		width:14%;
		background: linear-gradient(to bottom, #003333  0%, #000000 100%);
		background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss */
	}
	.ks_btn:hover, {
		border: 1px solid #222;
		font-size:10pt;
		color: #fff;
		padding: 5px 5px 5px 5px;
		border-radius: 5px 5px 5px 5px;
		width:14%;
		background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%);
		background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss */
	}
	#ddns_switch, #tablet_1, #tablet_2, #ddns_log { border:1px solid #91071f; } /* W3C rogcss */
	.input_option{
		vertical-align:middle;
		font-size:12px;
	}
	input[type=button]:focus {
		outline: none;
	}
</style>
<script>
var dbus = {};
var _responseLen;
var noChange = 0;
var x = 5;
var params_inp = ['ddns_interval'];
var params_chk = ['ddns_enable'];
var lanip = "<% nvram_get("lan_ipaddr"); %>";
function init() {
	show_menu(menu_hook);
	generate_options();
	get_dbus_data();
	get_run_status();
}
function conf2obj(){
	for (var i = 0; i < params_inp.length; i++) {
		if(dbus[params_inp[i]])
			E(params_inp[i]).value = dbus[params_inp[i]];
		else
			E(params_inp[i]).value = "10";
	}
	for (var i = 0; i < params_chk.length; i++) {
		if(dbus[params_chk[i]]){
			E(params_chk[i]).checked = dbus[params_chk[i]] == "1";
		}
	}
}
function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/ddns",
		dataType: "json",
		cache: false,
		async: false,
		success: function(data) {
			dbus = data.result[0];
			conf2obj();
			toggle_func();
			update_visibility();
			hook_event();
		},
		error: function(XmlHttpRequest, textStatus, errorThrown){
			console.log(XmlHttpRequest.responseText);
			alert("skipd数据读取错误，请用在chrome浏览器中按F12键后，在console页面获取错误信息！");
		}
	});
}
function get_run_status(){
	$.ajax({
		type: "GET",
		url: "/_api/ddns_last_act",
		dataType: "json",
		async: true,
		cache: false,
		success: function(data) {
			var ddns_status = data.result[0];
			if (ddns_status["ddns_last_act"]) {
				E("run_status").innerHTML = ddns_status["ddns_last_act"];
			}
		},
		error: function(xhr) {
			E("run_status").innerHTML = "状态获取失败，请查看日志！";
		}
	});
	setTimeout("get_run_status();", 5000);
}
function save(flag) {
	var dbus_new = {}
	$("#show_btn2").trigger("click");
	// collect data from input and checkbox
	for (var i = 0; i < params_inp.length; i++) {
		dbus_new[params_inp[i]] = E(params_inp[i]).value;
	}
	for (var i = 0; i < params_chk.length; i++) {
		dbus_new[params_chk[i]] = E(params_chk[i]).checked ? '1' : '0';
	}
	if(flag == 2){
		// when clean log，don't save enable status
		dbus_new["ddns_enable"] = dbus["ddns_enable"]
	}
	// post data
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "ddns_config.sh", "params": [flag], "fields": dbus_new };
	$.ajax({
		url: "/_api/",
		cache: false,
		async: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response){
			if (response.result == id){
				get_log();
				if(E("ddns_enable").checked == false){
					setTimeout("refreshpage();", 1000);
				}else{
					if ($('.show-btn2').hasClass("active"))
						setTimeout("$('#show_btn1').trigger('click');", 8000);
					E("apply_button-2").style.display = "";
				}
			}
		}
	});
}
function generate_options(){
	for(var i = 10; i < 60; i++) {
		$("#ddns_interval").append("<option value='"  + i + "'>" + i + "</option>");
		$("#ddns_interval").val(3);
	}
	$("#ddns_interval").append("<option value='"  + 60 + "'>" + 60 + "</option>");
	$("#ddns_interval").val(3);
}
function hook_event(){
	$("#ddns_enable").click(
		function(){
		if(E('ddns_enable').checked){
			dbus["ddns_enable"] = "1";
			$('.show-btn1').addClass('active');
			$('.show-btn2').removeClass('active');
			E("tablet_show").style.display = "";
			E("last_act_tr").style.display = "";
			E("tablet_1").style.display = "";
			E("tablet_2").style.display = "none";
			E("apply_button-1").style.display = "";
			E("apply_button-2").style.display = "none";
		}else{
			dbus["ddns_enable"] = "0";
			$('.show-btn1').removeClass('active');
			$('.show-btn2').removeClass('active');
			E("tablet_show").style.display = "none";
			E("last_act_tr").style.display = "none";
			E("tablet_1").style.display = "none";
			E("tablet_2").style.display = "none";
			E("apply_button-1").style.display = "";
			E("apply_button-2").style.display = "none";
		}
	});
}
function get_log(){
	$.ajax({
		url: '/_temp/ddns_log.txt',
		type: 'GET',
		dataType: 'html',
		async: true,
		cache: false,
		success: function(response) {
			var retArea = E("log_content_text");
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}
			if (noChange > 200) {
				return false;
			} else {
				setTimeout("get_log();", 1500);
			}
			retArea.value = response;
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		},
		error: function(xhr) {
			setTimeout("get_log();", 5000);
			E("log_content_text").value = "暂无日志信息！";
		}
	});
}
function toggle_func(){
	$('.show-btn1').addClass('active');
	$(".show-btn1").click(
		function() {
			$('.show-btn1').addClass('active');
			$('.show-btn2').removeClass('active');
			E("tablet_1").style.display = "";
			E("tablet_2").style.display = "none";
			E("apply_button-1").style.display = "";
			E("apply_button-2").style.display = "";
		});
	$(".show-btn2").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn2').addClass('active');
			E("tablet_1").style.display = "none";
			E("tablet_2").style.display = "";
			E("apply_button-1").style.display = "none";
			E("apply_button-2").style.display = "";
			get_log();
		});
}
function update_visibility(){
	// pannel
	if(E("ddns_enable").checked == true){
		E("tablet_show").style.display = "";
		E("last_act_tr").style.display = "";
		E("tablet_1").style.display = "";
		E("apply_button-2").style.display = "";
	}else{
		E("tablet_show").style.display = "none";
		E("last_act_tr").style.display = "none";
		E("tablet_1").style.display = "none";
		E("apply_button-2").style.display = "none";
	}
}
function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装", "ddns");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_ddns.asp");
}
function openurl(){
	window.open("http://"+lanip+":9876");
}
</script>
</head>
<body onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
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
										<div style="float:left;" class="formfonttitle" style="padding-top: 12px">ddns</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div style="margin-left:5px;" id="head_illustrate">
											<li><em>ddns</em>是一款简单好用的DDNS。支持ipv4和/或ipv6自动更新域名解析到公网IP(支持<em>阿里云、腾讯云、Dnspod、Cloudflare、Callback、华为云、百度云、Porkbun、GoDaddy、Google Domain</em>) 。</li>
											<li><a href="https://github.com/jeessy2/ddns-go" target="_blank" ><i><u>使用教程</u></i></a></li>
										</div>
										<div id="ddns_switch" style="margin:5px 0px 0px 0px;">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
												<tr>
													<td colspan="2">ddns - 开关/状态</td>
												</tr>
												</thead>
												<tr id="switch_tr">
													<th>
														<label>开启ddns</label>
													</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell">
															<label for="ddns_enable">
																<input id="ddns_enable" class="switch" type="checkbox" style="display: none;">
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
												<tr id="last_act_tr" style="display: none;">
													<th>上次运行</th>
													<td>
														<span id="run_status"></span>
													</td>
												</tr>
											</table>
										</div>
										<div id="tablet_show" style="display: none;">
											<table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
												<tr>
													<td cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#222">
														<input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="服务配置"/>
														<input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="查看日志"/>
													</td>
													</tr>
											</table>
										</div>
										<div id="tablet_1" style="display: none;">
											<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr id="interval_tr">
													<th>检查周期</th>
													<td>
														<select style="width:40px;margin:0px 0px 0px 2px;" id="ddns_interval" name="ddns_interval" class="input_option"></select> 分钟
													</td>
												</tr>
											</table>
										</div>
										<div id="tablet_2" style="display: none;">
											<div id="log_content" style="margin-top:-1px;display:block;overflow:hidden;">
												<textarea cols="63" rows="20" wrap="on" readonly="readonly" id="log_content_text" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
										</div>
										<div id="apply_button" class="apply_gen">
											<input id="apply_button-1" class="button_gen" type="button" onclick="save(1)" value="提交">
											<input id="apply_button-2" class="button_gen" type="button" onclick="openurl();" value="打开控制面板" style="display: none;">
										</div>
										<div class="SCBottom" style="margin-top:50px;">
											GitHub: <a href="https://github.com/SWRT-dev/softcenter" target="_blank"><i><u>https://github.com/SWRT-dev/softcenter</u></i></a><br/>
											Shell & Web by: <i>paldier</i>
										</div>
									</td>
								</tr>
							</table>
						</div>
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

