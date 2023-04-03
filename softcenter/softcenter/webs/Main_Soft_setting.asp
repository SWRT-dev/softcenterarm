<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title sclang>Softcenter - Offline installation</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/js/i18n.js"></script>
<style>
input[type=button]:focus {
	outline: none;
}
</style>
<script>
var _responseLen;
var noChange = 0;
String.prototype.myReplace = function(f, e){
	var reg = new RegExp(f, "g"); 
	return this.replace(reg, e); 
}
function init() {
	show_menu(menu_hook);
	set_skin();
	sc_load_lang("sc1");
	get_log();
}
function set_skin(){
	if(isGundam){
		$("#scapp").attr("scskin", 'Gundam');
	}
	if(isKimetsu){
		$("#scapp").attr("scskin", 'Kimetsu');
	}
	if(isEva){
		$("#scapp").attr("scskin", 'Eva');
	}
	if(isEva)
	$('#github').html('机体编号：<i><u>EVA01</u></i> </a><br/>技术支持： <a href="https://www.right.com.cn" target="_blank"> <i><u>right.com.cn</u></i> </a><br/>Project项目： <a href ="https://github.com/SWRT-dev/softcenter" target="_blank"> <i><u>SWRT补完计划</u></i> </a><br/>Copyright： <a href="https://github.com/SWRT-dev" target="_blank"><i>SWRT补完委员会</i></a>')
	else
	$('#github').html('论坛技术支持： <a href="https://www.right.com.cn" target="_blank"> <i><u>right.com.cn</u></i> </a><br/>Github项目： <a href ="https://github.com/SWRT-dev/softcenter" target="_blank"> <i><u>https://github.com/SWRT-dev</u></i> </a><br/>Copyright： <a href="https://github.com/SWRT-dev" target="_blank"><i>SWRTdev</i></a>')
}
function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", dict["Software Center"], dict["Offline installation"]);
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp");
}
function upload_software() {
	var filename = $("#file").val();
	filename = filename.split('\\');
	filename = filename[filename.length - 1];
	var filelast = filename.split('.');
	filelast = filelast[filelast.length - 1];
	if (filelast != 'gz') {
		alert(dict["File format is incorrect"]);
		return false;
	}
	document.getElementById('file_info').style.display = "none";
	var formData = new FormData();
	formData.append(filename, $('#file')[0].files[0]);
	//changeButton(true);
	$.ajax({
		url: '/_upload',
		type: 'POST',
		cache: false,
		data: formData,
		processData: false,
		contentType: false,
		complete: function(res) {
			if (res.status == 200) {
				var moduleInfo = {
					"soft_name": filename,
				};
				document.getElementById('file_info').style.display = "block";
				install_now(moduleInfo);
			}
		}
	});
}
function install_now(moduleInfo) {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "ks_tar_install.sh", "params": [], "fields": moduleInfo};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(response.result == id){
				get_log(1);
			}
		}
	});
}
function get_log(s) {
	var retArea = E("soft_log_area");
	$.ajax({
		url: '/_temp/soft_log.txt',
		type: 'GET',
		dataType: 'text',
		cache: false,
		success: function(response) {
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.myReplace("XU6J03M6", " ");
				retArea.scrollTop = retArea.scrollHeight;
				if (s) {
					setTimeout("window.location.reload()", 3000);
				}
				return true;
			}
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}
			if (noChange > 4000) {
				//tabSelect("app1");
				return false;
			} else {
				setTimeout("get_log(1);", 1000);
			}
			retArea.value = response;
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		},
		error: function(xhr, status, error) {
			if (s) {
				E("soft_log_area").value = dict["Failed to load log file"];
			}
		}
	});
}
</script>
</head>
<body id="scapp" scskin="swrt" onload="init();">
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
				<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
					<tr>
						<td align="left" valign="top">
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div sclang style="float:left;" class="formfonttitle">Software Center, Offline installation</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div class="formfontdesc" style="padding-top:5px;margin-top:0px;float: left;" id="cmdDesc"></div>
										<div style="padding-top:5px;margin-top:0px;float: left;" id="NoteBox" >
											<li sclang>On this page, you can upload the plugin's offline installation package for manual installation;</li>
											<li sclang>Offline installation will automatically decompress the tar.gz suffix archived package, then find out the install.sh file in the first level folder of the archived package and execute it;</li>
											<li sclang>It is recommended to write the plugin version, md5 and other information to the install.sh file;</li>
											<li sclang>Note : You should choose offline installation package of the supported CPU architectures to install, otherwise it will not run;</li>
										</div>
										<div class="formfontdesc" id="cmdDesc"></div>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
											<thead>
											<tr>
												<td sclang colspan="2">Softcenter - Offline installation</td>
											</tr>
											</thead>
											<tr>
												<th><a sclang class="hintstyle" href="javascript:void(0);" onclick="openssHint(24)">Offline installation</a></th>
												<td>
													<input sclang type="button" id="upload_btn" class="button_gen" onclick="upload_software();" value="Upload"/>
													<input style="color:#FFCC00;*color:#000;width: 200px;" id="file" type="file" name="file"/>
													<img id="loadingicon" style="margin-left:5px;margin-right:5px;display:none;" src="/images/InternetScan.gif">
													<span sclang id="file_info" style="display:none;">Done</span>
												</td>
											</tr>
										</table>
										<div id="log_content" class="soft_setting_log">
											<textarea cols="63" rows="40" wrap="on" readonly="readonly" id="soft_log_area" class="soft_setting_log1" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
										</div>
										<div class="SCBottom" id="github">
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
