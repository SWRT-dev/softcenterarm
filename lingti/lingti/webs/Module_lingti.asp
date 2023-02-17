<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>灵缇路由器插件</title>
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
<style>
</style>
<script>
function E(e) {
	return (typeof(e) == 'string') ? document.getElementById(e) : e;
}
function init() {
	show_menu(menu_hook);
	get_dbus_data();
	check_status();
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/dbconf?p=lingti_",
		dataType: "script",
		async: false,
		success: function(data) {
			db_lingti = db_lingti_;
			E("lingti_enable").checked = db_lingti["lingti_enable"] == "1";
		}
	});
}
function save() {
	showLoading(3);
	refreshpage(3);
	db_lingti["lingti_enable"] = E("lingti_enable").checked ? '1' : '0';
	db_lingti["action_script"]="lingti_config.sh";
	db_lingti["action_mode"] = "restart";
	$.ajax({
		url: "/applydb.cgi?p=lingti",
		cache: false,
		type: "POST",
		dataType: "text",
		data: $.param(db_lingti)
	});
}
function check_status(){

	$.ajax({
		url: '/logreaddb.cgi?p=lingti_status.log&script=lingti_status.sh',
		dataType: 'html',
		success: function (response) {
			//console.log(response)
			E("lingti_status").innerHTML = response;
			setTimeout("check_status();", 5000);
		},
		error: function(){
			setTimeout("check_status();", 5000);
		}
	});
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线下载", "灵缇路由器插件");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_lingti.asp");
}
</script>
</head>
<body onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<input type="hidden" name="current_page" value="Module_lingti.asp"/>
<input type="hidden" name="next_page" value="Module_lingti.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value="restart"/>
<input type="hidden" name="action_script" value="lingti_config.sh"/>
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
                						<div id="lingti_title" style="float:left;" class="formfonttitle" style="padding-top: 12px">灵缇游戏加速</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote" id="head_illustrate"><i></i><a href='https://lingti666.com' target='_blank'><em>点击打开官网</em></a><br/>启用插件后在官网下载app即可正常配置加速线路.<br/>填写邀请码:wchafo，可以获得一定时长的免费加速时间.</div>
										<div id="cpufreq_switch" style="margin:0px 0px 0px 0px;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
												<tr>
													<td colspan="2">设置</td>
												</tr>
												</thead>
												<tr>
													<th>启用</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="lingti_enable">
																<input id="lingti_enable" class="switch" type="checkbox" style="display: none;">
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
													<td colspan="2"  id="lingti_status">
													</td>
												</tr>
											</table>
										</div>
										<div class="apply_gen">
											<input id="cmdBtn" type="button" class="button_gen" onclick="save()" value="应用"/>
										</div>
										<div class="KoolshareBottom" style="float:right; width:180px; height:70px">
											Shell&Web by： <i>paldier</i>
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

