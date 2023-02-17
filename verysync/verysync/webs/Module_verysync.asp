<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - 微力同步 verysync.com</title>
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
<script>
var db_verysync = {}
function init() {
	show_menu(menu_hook);
	get_dbus_data();
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "dbconf?p=verysync_,softcenter_module_verysync_",
		dataType: "script",
		success: function(data) {
			db_verysync = db_verysync_;
			db_softcenter_module_verysync_version = db_softcenter_module_verysync_;
			E("verysync_enable").checked = db_verysync["verysync_enable"] == "1";
			E("verysync_swap_enable").checked = db_verysync["verysync_swap_enable"] == "1";
			E("verysync_monitor_enable").checked = db_verysync["verysync_monitor_enable"] == "1";

			var params = ["port", "wan_enable", "home"];
			for (var i = 0; i < params.length; i++) {
				if (params[i] == 'port') {
					if (db_verysync["verysync_port"] === (void 0) || db_verysync["verysync_port"] == "") {
						db_verysync["verysync_port"] = "8886";
					}
				}
				if (db_verysync["verysync_" + params[i]]) {
					E("verysync_" + params[i]).value = db_verysync["verysync_" + params[i]];
				}
			}
			try{
				$("#plugin_version").html("插件版本：" + db_softcenter_module_verysync_version['softcenter_module_verysync_version']);
			}catch (e) {
			}

			var verysync_version = db_verysync['verysync_version'] || '';
			var lan_ipaddr_rt = "<% nvram_get("lan_ipaddr_rt");%>";
			var verysync_port = db_verysync['verysync_port'];
			var verysync_url  = "http://"+lan_ipaddr_rt+":"+verysync_port;
			if (verysync_version == "") {
				verysync_version="将在第一次设置提交后自动下载对应版本，提交后请等待几分钟后手工刷新该页面查看，如果一直无法下载请手动下载微力<a href='http://www.verysync.com/download.php?platform=linux-arm' target='_blank'>ARM版</a> 或 <a href='http://www.verysync.com/download.php?platform=linux-arm64' target='_blank'>ARM64版</a> ，手动上传到 /tmp/filetransfer/ 再回到当前页面点击提交即可。";
			} 
			$('#verysync_version').html('微力版本: ' + verysync_version);
			$('#verysync_manual_url').html('<a href="'+verysync_url+'" target="_blank">'+verysync_url+'</a>');

			try{
				var verysync_disklist = JSON.parse(atob(db_verysync['verysync_disklist']));
				$.each(verysync_disklist, function(key, item){
					var option = $("<option></option>")
									.attr("value", item.mount_point)
									.text(item.mount_point+" 大小:"+item.size + " 可用:"+item.free)
					$('#verysync_home').append(option);
				});

				$('#verysync_home').val(db_verysync["verysync_home"]||"");
			}catch(e){
			}
		}
	});
}

function save() {
	var port = $('#verysync_port').val() ;
    if (port < 1024 || port > 65535){
        alert("端口应设置为1024-65535之间");
		return false;
    }
	var home = $('#verysync_home').val()
	if (home == "") {
		alert("您必须设定一个应用数据目录路径用于存储索引信息，请将该目录设定为有较大存储空间的位置")
		return false;
	}

	showLoading(2);
	//refreshpage(2);
	// collect data from checkbox
	db_verysync["verysync_enable"] = E("verysync_enable").checked ? '1' : '0';
	db_verysync["verysync_swap_enable"] = E("verysync_swap_enable").checked ? '1' : '0';
	db_verysync["verysync_monitor_enable"] = E("verysync_monitor_enable").checked ? '1' : '0';
	var params = ["port", "wan_enable", "home"];
	for (var i = 0; i < params.length; i++) {
    	db_verysync["verysync_" + params[i]] = E("verysync_" + params[i]).value;
	}
	delete db_verysync['verysync_disklist'];
	// post data
	//var id = parseInt(Math.random() * 100000000);
	//var postData = {"id": id, "method": "verysync_config.sh", "params": [1], "fields": db_verysync };
	db_verysync["action_script"]="verysync_config.sh";
	db_verysync["action_mode"] = "restart";
	$.ajax({
		url: "applydb.cgi?p=verysync",
		type: "POST",
		dataType: "text",
		data: $.param(db_verysync),
		success: function(){
			location.reload();
		}
	});
}

function menu_hook() {
	tabtitle[tabtitle.length - 1] = new Array("", "软件中心", "离线安装", "verysync");
	tablink[tablink.length - 1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_verysync.asp");
}

function verifyFields(focused, quiet){
	var port =E('verysync_port').value ;
    if(port < 1024 || port > 65535){
        alert("端口应设置为1024-65535之间");
    }
	return 1;
}
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<form method="POST" name="form" action="/applydb.cgi?p=verysync_" target="hidden_frame">
	<input type="hidden" name="current_page" value="Module_verysync.asp"/>
	<input type="hidden" name="next_page" value="Module_verysync.asp"/>
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
										<div style="float:left;" class="formfonttitle">微力同步</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></div>
										<div class="formfontdesc" id="cmdDesc">开启微力同步后，你就拥有了私有的云盘，可以和您的任何设备进行高效的传输，目前支持所有主流的平台，下载其它客户端请到<a href="http://verysync.com/download?s=merlin" target="_blank">官网下载</a></div>
                                        <table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="verysync_detail">
                                            <tr>
												<td>微力官网</td>
												<td><a href="http://verysync.com/?sid=merlin" target="_blank">http://verysync.com</a></td>
											</tr>
                                            <tr>
												<td>微力社区</td>
                                                <td><a href="http://forum.verysync.com/?sid=merlin" target="_blank">http://forum.verysync.com</a></td>
											</tr>
                                            <tr>
												<td>微信号</td>
                                                <td>verysync</td>
											</tr>
											<tr>
												<td>QQ群</td>
                                                <td>微力同步官方群: 851608182</td>
											</tr>
                                        </table>
                                        <table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">微力同步开关</td>
											</tr>
											</thead>
											<tr>
											<th>开启微力同步</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell;float: left;">
														<label for="verysync_enable">
															<input id="verysync_enable" class="switch" type="checkbox" style="display: none;">
															<div class="switch_container" >
																<div class="switch_bar"></div>
																<div class="switch_circle transition_style">
																	<div></div>
																</div>
															</div>
														</label>
													</div>
													<span style="float: left;" id="plugin_version"></span>
													<br />
													<span style="float: left;" id="verysync_version"></span>
												</td>
											</tr>
											<tr>
												<th>微力管理界面</th>
												<td colspan="2" id="verysync_manual_url"></td>
											</tr>
                                    	</table>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="verysync_detail">
											<thead>
											<tr>
												<td colspan="2">微力同步 参数设置</td>
											</tr>
											</thead>
											<tr>
												<th>Web管理端口</th>
												<td>
													<div>
														<input type="txt" name="verysync_port" id="verysync_port" class="input_ss_table" maxlength="5" value="8886"/>
													</div>
												</td>
											</tr>
											<tr>
												<th>允许外网访问</th>
												<td>
													<select style="width:164px;margin-left: 2px;" class="input_option" id="verysync_wan_enable" name="verysync_wan_enable">
														<option value="0" selected>关闭</option>
														<option value="1">开启</option>
													</select>
												</td>
											</tr>
                                            <tr>
												<th>应用数据目录</th>
												<td>
													<!-- <input type="text" name="verysync_home" id="verysync_home" class="input_ss_table"  value="" /> -->
													<select name="verysync_home" id="verysync_home">
													<option value="">选择数据目录</option>
													</select>
													<br />
													<span>请指定硬盘路径，索引会占用较大的空间 建议设置为磁盘根目录,设定后如果修改该路径，同步的任务列表将重置</span>
												</td>
											</tr>
											<tr>
												<th>启用虚拟内存</th>
												<td>
													<input id="verysync_swap_enable" type="checkbox" />
													<br />
													<span style="float: left;">第一次启用初始化需要花费较多的时间，如果没有挂载虚拟内存,微力会自动创建512M的SWAP空间，第一次请多等待些许时间</span>
												</td>
											</tr>
											<tr>
												<th>进程守护</th>
												<td>
													<input id="verysync_monitor_enable" type="checkbox" />
													<br />
													<span style="float: left;">小内存不要启用此功能</span>
												</td>
											</tr>
										</table>
 										<div id="warn" style="display: none;margin-top: 20px;text-align: center;font-size: 20px;margin-bottom: 20px;" class="formfontdesc" id="cmdDesc"><i>开启双线路负载均衡模式才能进行本页面设置，建议负载均衡设置比例1：1</i></div>
										<div class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="save()">提交</button>
										</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
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
	<div id="footer"></div>
</body>
</html>

