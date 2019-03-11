<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta HTTP-EQUIV="Pragma" CONTENT="no-cache" />
		<meta HTTP-EQUIV="Expires" CONTENT="-1" />
		<link rel="shortcut icon" href="images/favicon.png" />
		<link rel="icon" href="images/favicon.png" />
		<title>软件中心 - DC1服务器</title>
		<link rel="stylesheet" type="text/css" href="index_style.css" />
		<link rel="stylesheet" type="text/css" href="form_style.css" />
		<link rel="stylesheet" type="text/css" href="usp_style.css" />
		<link rel="stylesheet" type="text/css" href="ParentalControl.css">
		<link rel="stylesheet" type="text/css" href="css/icon.css">
		<link rel="stylesheet" type="text/css" href="css/element.css">
		<script type="text/javascript" src="/state.js"></script>
		<script type="text/javascript" src="/popup.js"></script>
		<script type="text/javascript" src="/help.js"></script>
		<script type="text/javascript" src="/validator.js"></script>
		<script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript" src="/general.js"></script>
		<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
		<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
		<script type="text/javascript" src="/dbconf?p=dc1svr_&v=<% uptime(); %>"></script>
		<script>
			var $j = jQuery.noConflict();
			function init() {
				show_menu(menu_hook);
				buildswitch();
				version_show();
				var rrt = document.getElementById("switch");
				if (document.form.dc1svr_enable.value != "1") {
					rrt.checked = false;
				} else {
					rrt.checked = true;
				}
			}
			function done_validating() {
				return true;
			}
			
			function buildswitch(){
				$j("#switch").click(
					function(){
					if(document.getElementById('switch').checked){
						document.form.dc1svr_enable.value = 1;
					}else{
						document.form.dc1svr_enable.value = 0;
					}
				});
			}
			
			function onSubmitCtrl() {
				showLoading(3);
				document.form.submit();
			}
			
			function reload_Soft_Center(){
				location.href = "/Main_Soft_center.asp";
			}
			
			function version_show(){
				$j("#dc1svr_version_status").html("<i>当前版本：" + db_dc1svr_['dc1svr_version']);
			    $j.ajax({
			        url: 'https://raw.githubusercontent.com/paldier/softcenter/master/dc1svr/config.json.js',
			        type: 'GET',
			        success: function(res) {
			            if(typeof(txt) != "undefined" && txt.length > 0) {
			                //console.log(txt);
			                var obj = $j.parseJSON(txt.replace("'", "\""));
					$j("#dc1svr_version_status").html("<i>当前版本：" + obj.version);
					if(obj.version != db_dc1svr_['dc1svr_version']) {
						$j("#dc1svr_version_status").html("<i>有新版本：" + obj.version);
					}
			            }
			        }
			    });
			}
			function menu_hook(title, tab) {
				tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装", "DC1服务器");
				tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_dc1svr.asp");
			}
		</script>
	</head>
	<body onload="init();">
		<div id="TopBanner"></div>
		<div id="Loading" class="popup_bg"></div>
		<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
		<form method="POST" name="form" action="/applydb.cgi?p=dc1svr_" target="hidden_frame">
			<input type="hidden" name="current_page" value="Module_dc1svr.asp" />
			<input type="hidden" name="next_page" value="Module_dc1svr.asp" />
			<input type="hidden" name="group_id" value="" />
			<input type="hidden" name="modified" value="0" />
			<input type="hidden" name="action_mode" value="toolscript" />
			<input type="hidden" name="action_script" value="dc1svr.sh" />
			<input type="hidden" name="action_wait" value="5" />
			<input type="hidden" name="first_time" value="" />
			<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get(" preferred_lang "); %>"/>
			<input type="hidden" name="firmver" value="<% nvram_get(" firmver "); %>"/>
			<input type="hidden" id="dc1svr_enable" name="dc1svr_enable" value='<% dbus_get_def("dc1svr_enable", "0"); %>' />
			<input type="hidden" id="dc1svr_key" name="dc1svr_key" value='<% dbus_get_def("dc1svr_key", "0"); %>' />
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
												<div style="float:left;" class="formfonttitle">DC1服务器 - 替换官方服务器</div>
												<div style="float:right; width:15px; height:25px;margin-top:10px">
													<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
												</div>
												<div style="margin-left:5px;margin-top:10px;margin-bottom:10px">
													<img src="/images/New_ui/export/line_export.png">
												</div>
												<div class="formfontdesc" id="cmdDesc">该工具用于“DC1插排”。</div>
												<div class="formfontdesc" id="cmdDesc"></div>
												<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="dc1_table">
													<thead>
														<tr>
															<td colspan="2">工具选项</td>
														</tr>
													</thead>
													<tr>
														<th>开启DC1服务器</th>
														<td colspan="2">
															<div class="switch_field" style="display:table-cell;float: left;">
																<label for="switch">
																	<input id="switch" class="switch" type="checkbox" style="display: none;">
																	<div class="switch_container">
																		<div class="switch_bar"></div>
																		<div class="switch_circle transition_style">
																			<div></div>
																		</div>
																	</div>
																</label>
															</div>
															<div id="dc1svr_version_show" style="padding-top:5px;margin-left:230px;margin-top:0px;"><i>当前版本：<% dbus_get_def("dc1svr_version", "未知"); %></i>
															</div>
															<div id="dc1svr_version_status" style="padding-top:5px;margin-left:330px;margin-top:-25px;"></div>
														</td>
													</tr>
													<tr id="key_tr">
														<th width="35%">连接密码</th>
														<td>
															<textarea  style="width:99%;background-color: #475A5F;color:#FFFFFF;" placeholder="# 此处填入连接密码，初始密码为路由器密码" rows="2" style="width:99%; font-family:'Lucida Console'; font-size:12px;background:#475A5F;color:#FFFFFF;" id="dc1svr_key" name="dc1svr_key" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" title=""></textarea>
														</td>
													</tr>
												</table>
												<div class="apply_gen">
													<button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl()">提交</button>
												</div>
												<div style="margin-left:5px;margin-top:10px;margin-bottom:10px">
													<img src="/images/New_ui/export/line_export.png">
												</div>
												<div id="NoteBox">
													<h2>使用说明：</h2>
													<h3>连接密码</h3>
													<p>默认密码为<font color="red">路由器密码</font></p>
													<h3>重启插排</h3>
													<p>启用本插件后<font color="red">必需把排插断电重启一次</font></p>
													<h3><font color="red">手机APP下载</font></h3>
													<a href="https://www.right.com.cn/forum/thread-448025-1-1.html" target="_blank">[<u> 点我跳转 </u>]</a>
													<h2>申明：本工具来自恩山论坛 <a href="https://www.right.com.cn/forum/thread-448025-1-1.html" target="_blank">点我跳转</a></h2>
												</div>
												<div style="margin-left:5px;margin-top:10px;margin-bottom:10px">
													<img src="/images/New_ui/export/line_export.png">
												</div>
												<div class="Bottom">
													<br/>论坛技术支持：
													<a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> 
													</a>
													<br/>后台技术支持： <i>Xiaobao</i> 
													<br/>Shell, Web by： <i>paldier</i>
													<br/>
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
		</form>
		</td>
		<div id="footer"></div>
	</body>
</html>
