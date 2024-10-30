<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html xmlns:v>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>软件中心 - zerotier</title>
<link rel="stylesheet" type="text/css" href="index_style.css"> 
<link rel="stylesheet" type="text/css" href="form_style.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/js/table/table.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<script language="JavaScript" type="text/javascript" src="/js/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/js/httpApi.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/js/table/table.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script type="text/javascript" src="/js/i18n.js"></script>
<style>
.SimpleNote {
	padding:5px 5px;
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
</style>
<script>
var count_down;
var	refresh_flag;
var params_chk = ['shellinabox_enable'];
function init(){
	show_menu(menu_hook);
	get_dbus_data();
	get_status();
}
function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/shellinabox",
		dataType: "json",
		async: false,
		success: function(data) {
			db_shellinabox = data.result[0];
			conf2obj();
			update_visibility();
			$("#shellinabox_version_show").html("插件版本：" + db_shellinabox["shellinabox_version"]);
		}
	});
}
function conf2obj() {
	if(db_shellinabox["shellinabox_enable"]) {
	    E("shellinabox_enable").checked = db_shellinabox["shellinabox_enable"] == 1 ? true : false;
	}
}
function get_status() {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "shellinabox_status.sh", "params": [], "fields": ""};
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
function update_visibility(){
	if(db_shellinabox["shellinabox_enable"] == 1){
	    E("shellinabox_window").style.display = "";
	}
}
function reactive(){
	window.open("http://"+window.location.hostname+":4200");
}
function save(){
	var dbus_new = {};
	for (var i = 0; i < params_chk.length; i++) {
		dbus_new[params_chk[i]] = E(params_chk[i]).checked ? '1' : '0';
	}
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "shellinabox_config.sh", "params": ["web_submit"], "fields": dbus_new};
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
function showWBLoadingBar(){
	document.scrollingElement.scrollTop = 0;
	E("loading_block_title").innerHTML = "&nbsp;&nbsp;shellinabox日志信息";
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
function get_log(){
	E("ok_button").style.visibility = "hidden";
	showWBLoadingBar();
	$.ajax({
		url: '/_temp/shellinabox_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
				E("ok_button").style.visibility = "visible";
				retArea.scrollTop = retArea.scrollHeight;
				count_down = 6;
				refresh_flag = 1;
				count_down_close();
				return false;
			}
			setTimeout("get_log();", 600);
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
function menu_hook(title, tab){
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装", "shellinabox");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_shellinabox.asp");
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
										<div class="formfonttitle">shellinabox<lable id="shellinabox_version"></lable></div>
										<div style="float:right; width:15px; height:25px;margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote">
											<span>shellinabox可以使你在web页面进行命令行管理</span>
											<span>&nbsp;&nbsp;&nbsp;登录名和密码与web一致&nbsp;&nbsp;&nbsp;</span>
											<span><a type="button" class="ks_btn" href="javascript:void(0);" onclick="get_log(1)" style="margin-left:5px;">查看日志</a></span>
										</div>
										<div">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
												<thead>
													<tr>
														<td colspan="2">shellinabox - 设定</td>
													</tr>
												</thead>
												<tr id="switch_tr">
													<th>开关</th>
													<td>
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="shellinabox_enable">
																<input id="shellinabox_enable" class="switch" type="checkbox" style="display: none;">
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
												<tr id="shellinabox_status_tr">
													<th>运行状态</th>
													<td>
														<span style="margin-left:4px" id="status"></span>
													</td>
												</tr>
												<tr>
													<th>管理窗口</th>
													<td id="shellinabox_window" style="display:none;">
													<input class="button_gen" onclick="reactive();" type="button" value="打开窗口"/>
													</td>
												</tr>
											</table>
										</div>
										<div id="shellinabox_div" class="apply_gen"">
											<input class="button_gen" id="shellinabox_btn" onClick="save()" type="button" value="保存" />
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
	<div id="footer"></div>
</body>
</html>
