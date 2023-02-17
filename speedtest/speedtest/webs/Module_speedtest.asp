<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="-1"/>
        <link rel="shortcut icon" href="images/favicon.png"/>
        <link rel="icon" href="images/favicon.png"/>
        <title>软件中心 - Speedtest网络测速</title>
        <link rel="stylesheet" type="text/css" href="index_style.css">
        <link rel="stylesheet" type="text/css" href="form_style.css">
        <link rel="stylesheet" type="text/css" href="usp_style.css">
        <link rel="stylesheet" type="text/css" href="/device-map/device-map.css" />
		<link rel="stylesheet" type="text/css" href="/res/softcenter.css"/>
        <script type="text/javascript" src="/state.js"></script>
        <script type="text/javascript" src="/popup.js"></script>
        <script type="text/javascript" src="/help.js"></script>
        <script type="text/javascript" src="/general.js"></script>
        <script type="text/javascript" src="/js/jquery.js"></script>
        <script type="text/javascript" src="/client_function.js"></script>
        <script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
        <script type="text/javascript" src="/form.js"></script>
		<script type="text/javascript" src="/res/softcenter.js"></script>
		<script type="text/javascript" src="/js/i18n.js"></script>
        <style type="text/css">
        </style>
        <script type="text/javascript">
			function E(e) {
				return (typeof(e) == 'string') ? document.getElementById(e) : e;
			}
            function init() {
                show_menu(menu_hook);
             }
			function save(action) {
				var uid = parseInt(Math.random() * 100000000);
				var params = (action == 1) ? "start" : "stop";
				var postData = {"id": uid, "method": "speedtest_config.sh", "params": [params], "fields": "" };
				$.ajax({
					url: "/_api/",
					cache: false,
					type: "POST",
					data: JSON.stringify(postData),
					dataType: "json",
					success: function(response) {
						console.log("response: ", response);
						if (response.result == uid) {
							get_status();
						} else {
							return false;
						}
					},
					error: function(XmlHttpRequest, textStatus, errorThrown){
						console.log(XmlHttpRequest.responseText);
						alert("skipd数据读取错误！");
					}
				});
			}
			function get_status(){
				var id = parseInt(Math.random() * 100000000);
				var postData = {"id": id, "method": "speedtest_status.sh", "params":[1], "fields": ""};
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
			function menu_hook(title, tab) {
				tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装", "speedtest");
				tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_speedtest.asp");
			}
			function openurl() {
			window.open("http://"+window.location.hostname+":8989");
			}
	</script>
	</head>
    <body onload="init();">
        <div id="TopBanner"></div>
        <div id="Loading" class="popup_bg"></div>
        <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
        <form method="post" name="form" action="/applydb.cgi?p=speedtest_" target="hidden_frame">
            <input type="hidden" name="current_page" value="Module_speedtest.asp"/>
            <input type="hidden" name="next_page" value="Module_speedtest.asp"/>
            <input type="hidden" name="group_id" value=""/>
            <input type="hidden" name="modified" value="0"/>
            <input type="hidden" name="action_mode" value="toolscript"/>
            <input type="hidden" name="action_script" value="speedtest_config.sh"/>
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
												<div class="formfonttitle">Speedtest网络测速</div>
												<div style="float:right; width:15px; height:25px;margin-top:-20px">
													<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
												</div>
												<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
												<div class="SimpleNote">
													<span>局域网网速测试工具</span><br>
													<span>仅支持手动开启，不支持自启动</span>
												</div>
												<div>
													<table style="margin:-1px 0px 0px 0px;" width="100%" border="0" align="center" cellpadding="4" cellspacing="0" class="FormTable">
														<thead>
															  <tr>
																<td colspan="2">Speedtest 相关设置</td>
															  </tr>
														</thead>
														<tr>
															<th style="width:25%;">运行状态</th>
															<td>
																<div id="speedtest_status"><i><span id="status" >获取中...</span></i></div>
															</td>
														</tr>
														<tr>
															<td>
															</td>
														</tr>
													</table>
												</div>
												<div class="apply_gen" align="center" style="top: 0px; width: 750px">
													<input class="button_gen" id="cmdBtn" type="button" onclick="save(1)" value="启动" />
													<input style="margin-left:10px" class="button_gen" id="cmdBtn1" type="button" onclick="save(0)" value="停止" />
													<input style="margin-left:10px" class="button_gen" id="cmdBtn2" type="button" onclick="openurl()" value="打开测试页面" />
												</div>
												<br/><br/><br/>
												<div class="SCBottom">
													<br/>
													后台技术支持： <i>paldier</i> <br/>
													Shell, Web by： <i>paldier</i><br/>
												</div>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
        </form>
        <div id="footer"></div>
    </body>
</html>
