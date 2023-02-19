<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="-1" />
<link rel="shortcut icon" href="/res/icon-adbyby.png"/>
<link rel="icon" href="/res/icon-adbyby.png"/>
<title>软件中心 - adbyby</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/device-map/device-map.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
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
.loadingBarBlock{
	width:740px;
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

.FormTitle em {
    color: #00ffe4;
    font-style: normal;
    /*font-weight:bold;*/
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
</style>
<script>
var db_adbyby = {};
var _responseLen;
var noChange = 0;
var x = 6;
var params_check = ['adbyby_enable'];
var params_input = ['adbyby_mode', 'adbyby_block_cnshort'];
function init() {
	show_menu(menu_hook);
	get_dbus_data();
	get_status();
}

function hook_event(){
	$("#log_content2").click(
		function() {
		x = -10;
	});
}

function get_dbus_data(){
	$.ajax({
		type: "GET",
		url: "/_api/adbyby_",
		dataType: "json",
		async: false,
		success: function(data) {
			db_adbyby = data.result[0];
			conf2obj();
		}
	});
}

function conf2obj(){
	for (var i = 0; i < params_check.length; i++) {
		if(db_adbyby[params_check[i]]){
			E(params_check[i]).checked = db_adbyby[params_check[i]] != "0";
		}
	}
	for (var i = 0; i < params_input.length; i++) {
		if (db_adbyby[params_input[i]]) {
			$("#" + params_input[i]).val(db_adbyby[params_input[i]]);
		}
	}
	if (db_adbyby["adbyby_version"]){
		E("adbyby_version").innerHTML = "当前版本 - v" + db_adbyby["adbyby_version"];
	}
}

function get_status() {
	var postData = {"id": parseInt(Math.random() * 100000000), "method": "adbyby_status.sh", "params": [], "fields": ""};
	$.ajax({
		type: "POST",
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			E("adbyby_status").innerHTML = response.result;
			setTimeout("get_status();", 10000);
		},
		error: function() {
			setTimeout("get_status();", 5000);
		}
	});
}

function save() {
	showabLoadingBar();
	//input
	for (var i = 0; i < params_input.length; i++) {
		if (E(params_input[i]).value) {
			db_adbyby[params_input[i]] = E(params_input[i]).value;
		}else{
			db_adbyby[params_input[i]] = "";
		}
	}
	// checkbox
	for (var i = 0; i < params_check.length; i++) {
		db_adbyby[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	//console.log(db_adbyby);
	// post data
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "adbyby_config.sh", "params": ["restart"], "fields": db_adbyby };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid || parseInt(response.result) == uid){
				get_realtime_log();
			}
		}
	});
}

function get_realtime_log() {
	$.ajax({
		url: '/_temp/adbyby_run.log',
		type: 'GET',
		async: true,
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content3");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
				E("ok_button").style.display = "";
				retArea.scrollTop = retArea.scrollHeight;
				count_down_close();
				return true;
			}
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}
			if (noChange > 1000) {
				return false;
			} else {
				setTimeout("get_realtime_log();", 100);
			}
			retArea.value = response.replace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		},
		error: function() {
			setTimeout("get_realtime_log();", 500);
		}
	});
}

function showabLoadingBar(seconds){
	if(window.scrollTo)
		window.scrollTo(0,0);
	disableCheckChangedStatus();
	
	htmlbodyforIE = document.getElementsByTagName("html");  //this both for IE&FF, use "html" but not "body" because <!DOCTYPE html PUBLIC.......>
	htmlbodyforIE[0].style.overflow = "hidden";	  //hidden the Y-scrollbar for preventing from user scroll it.
	
	winW_H();
	var blockmarginTop;
	var blockmarginLeft;
	if (window.innerWidth)
		winWidth = window.innerWidth;
	else if ((document.body) && (document.body.clientWidth))
		winWidth = document.body.clientWidth;
	
	if (window.innerHeight)
		winHeight = window.innerHeight;
	else if ((document.body) && (document.body.clientHeight))
		winHeight = document.body.clientHeight;
	if (document.documentElement  && document.documentElement.clientHeight && document.documentElement.clientWidth){
		winHeight = document.documentElement.clientHeight;
		winWidth = document.documentElement.clientWidth;
	}
	if(winWidth >1050){
	
		winPadding = (winWidth-1050)/2;	
		winWidth = 1105;
		blockmarginLeft= (winWidth*0.3)+winPadding-150;
	}
	else if(winWidth <=1050){
		blockmarginLeft= (winWidth)*0.3+document.body.scrollLeft-160;
	}
	
	if(winHeight >660)
		winHeight = 660;
	
	blockmarginTop= winHeight*0.3-140		
	E("loadingBarBlock").style.marginTop = blockmarginTop+"px";
	E("loadingBarBlock").style.marginLeft = blockmarginLeft+"px";
	E("loadingBarBlock").style.width = 770+"px";
	E("LoadingBar").style.width = winW+"px";
	E("LoadingBar").style.height = winH+"px";
	loadingSeconds = seconds;
	progress = 100/loadingSeconds;
	y = 0;
	LoadingabProgress(seconds);
}
function LoadingabProgress(seconds){
	E("LoadingBar").style.visibility = "visible";
	if (E("adbyby_enable").checked == false){
		E("loading_block3").innerHTML = "adbyby关闭中 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'><a href='https://github.com/SWRT-dev/softcenter' target='_blank'></font>adbyby工作有问题？请来<font color='#ffcc00'>https://github.com/SWRT-dev/softcenter</font>反应问题...</font></li>");
	} else {
		E("loading_block3").innerHTML = "adbyby启动中 ..."
		$("#loading_block2").html("<font color='#ffcc00'>----------------------------------------------------------------------------------------------------------------------------------");
	}
}

function hideadLoadingBar(){
	x = -1;
	E("LoadingBar").style.visibility = "hidden";
	refreshpage();
}

function count_down_close() {
	if (x == "0") {
		hideadLoadingBar();
	}
	if (x < 0) {
		E("ok_button1").value = "手动关闭"
		return false;
	}
	E("ok_button1").value = "自动关闭（" + x + "）"
		--x;
	setTimeout("count_down_close();", 1000);
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装", "广告屏蔽大师 Plus");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_adbyby.asp");
}
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<div id="LoadingBar" class="popup_bar_bg">
		<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
			<tr>
				<td height="100">
					<div id="loading_block3" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
					<div id="loading_block2" style="margin:10px auto;width:95%;"></div>
					<div id="log_content2" style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
						<textarea cols="63" rows="21" wrap="on" readonly="readonly" id="log_content3" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Courier New', Courier, mono; font-size:11px;background:#000;color:#FFFFFF;"></textarea>
					</div>
					<div id="ok_button" class="apply_gen" style="background: #000;display: none;">
						<input id="ok_button1" class="button_gen" type="button" onclick="hideadLoadingBar()" value="确定">
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
										<div style="float:left;" class="formfonttitle" style="padding-top: 12px">广告屏蔽大师 Plus</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div style="margin-left:5px;" id="head_illustrate">
											<li><em>adbyby</em>广告屏蔽大师 Plus 可以全面过滤各种横幅、弹窗、视频广告，同时阻止跟踪、隐私窃取及各种恶意网站</li>
										</div>
										<div id="adbyby_switch" style="margin:5px 0px 0px 0px;">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
												<tr>
													<td colspan="2">adbyby - 开关/状态</td>
												</tr>
												</thead>
												<tr id="switch_tr">
													<th>
														<label>开启adbyby</label>
													</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell">
															<label for="adbyby_enable">
																<input id="adbyby_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container" >
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
														<div style="display:table-cell;float: left;margin-left:270px;margin-top:-32px;position: absolute;padding: 5.5px 0px;">
														</div>
														<div id="adbyby_version" style="padding-top:5px;margin-right:50px;margin-top:-30px;float: right;"></div>	
													</td>
												</tr>
				                                <tr id="adbyby_status_tr">
				                                    <th>运行状态</th>
				                                    <td><span id="adbyby_status">获取中...</span>
				                                    </td>
				                                </tr>
				                                <tr>
				                                    <th>过滤模式</th>
				                                    <td>
				                                        <select id="adbyby_mode" name="adbyby_mode" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
				                                            <option value="0">全局模式</option>
				                                            <option value="1">ipset模式</option>
				                                            <!--option value="2">手动过滤模式</option-->
				                                        </select>
				                                    </td>
				                                </tr>
				                                <tr>
				                                    <th>过滤短视频APP和网站</th>
				                                    <td>
				                                        <select id="adbyby_block_cnshort" name="adbyby_block_cnshort" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
				                                            <option value="0">不过滤</option>
				                                            <option value="1">过滤</option>
				                                        </select>
				                                    </td>
				                                </tr>
											</table>
										</div>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">

											<!--
											<tr id="adbyby_status">
												<th>
													<label>adbyby状态</label>
												</th>
												<td>
 													<div id="warn" style="margin-top: 20px;text-align: center;font-size: 18px;margin-bottom: 20px;"class="formfontdesc" id="cmdDesc"></div>
												</td>										
											</tr>
											<tr id="adbyby_user">
												<td style="background-color: #2F3A3E;width:15%;">
													<label>自定义过滤规则</label>
												</td>
												</th>
												<td>
													<textarea placeholder='[adbyby]
!  ------------------------------ 阿呆喵[adbyby] 自定义过滤语法简表---------------------------------
!  --------------  规则基于ABP规则，并进行了字符替换部分的扩展-----------------------------
!  ABP规则请参考https://adblockplus.org/zh_CN/filters，下面为大致摘要
!  "!" 为行注释符，注释行以该符号起始作为一行注释语义，用于规则描述
!  "*" 为字符通配符，能够匹配0长度或任意长度的字符串，该通配符不能与正则语法混用。
!  "^" 为分隔符，可以匹配除了字母、数字或者 _ - . % 之外的任何字符。
!  "|" 为管线符号，来表示地址的最前端或最末端  比如 "|http://"  或  |http://www.abc.com/a.js|  
!  "||" 为子域通配符，方便匹配主域名下的所有子域。比如 "||www.baidu.com"  就可以不要前面的 "http://"
!  "~" 为排除标识符，通配符能过滤大多数广告，但同时存在误杀, 可以通过排除标识符修正误杀链接。

! ## #@# ##&  这3种为元素插入语法 (在语句末尾加 $B , 可以选择插入css语句在</body>前, 默认为</head>)
!  "##" 为元素选择器标识符，后面跟需要隐藏元素的CSS样式例如 #ad_id  .ad_class
! "#@#" 元素选择器白名单 
! "##&" 为JQuery选择器标识符，后面跟需要隐藏元素的JQuery筛选语法
!  元素隐藏支持全局规则   ##.ad_text  不需要前面配置域名,对所有页面有效. 误杀会比较多, 慎用.

!  文本替换选择器标识符, 支持通配符*和？，格式："页面C$s@内容A@内容B@"   意思为 <在使用"某正则模式" 在 "页面C"上用"内容A"替换"内容B" >  ; 
! 文本替换方式1:  S@   使用正则匹配替换
! 文本替换方式2:  s@   使用通配符 ?  *  匹配替换
!  -------------------------------------------------------------------------------------------

!新增规则语法测试样例

!样例1 使用正则删除某地方(替换 "<p...</p>" 字符串为 "http://www.admflt.com")
!<p id="lg"><img src="http://www.baidu.com/img/bdlogo.gif" width="270" height="129"></p>
!||www.baidu.com$S@<p.*<\/p>@http://www.admflt.com@
!||kafan.cn$s@<div id="hd">@<div id="hd" style="display:none!important">@' cols="50" rows="20" id="adbyby_user_txt" name="adbyby_user_txt" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
												</td>
											</tr>
											-->
                                    	</table>
										<div class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="save()">提交</button>
										</div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
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
	</form>
	</td>
	<div id="footer"></div>
</body>
</html>



