<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache" />
    <meta HTTP-EQUIV="Expires" CONTENT="-1" />
    <link rel="shortcut icon" href="images/favicon.png" />
    <link rel="icon" href="images/favicon.png" />
    <title>软件中心 - 花生壳内网穿透</title>
    <link rel="stylesheet" type="text/css" href="index_style.css" />
    <link rel="stylesheet" type="text/css" href="form_style.css" />
    <link rel="stylesheet" type="text/css" href="usp_style.css" />
    <link rel="stylesheet" type="text/css" href="ParentalControl.css">
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
		var dbus = {};
		var params_inp = ["phddns_appid", "phddns_appkey"];
        function init() {
            show_menu(menu_hook);
            get_dbus_data();
			get_run_status();
        }
		function conf2obj(){
			for (var i = 0; i < params_inp.length; i++) {
				if(dbus[params_inp[i]]){
					E(params_inp[i]).value = dbus[params_inp[i]];
				}
			}
			E("phddns_enable").checked = dbus["phddns_enable"] == "1";
		}
        function get_dbus_data() {
            $.ajax({
                type: "GET",
                url: "/_api/phddns",
                dataType: "json",
                async: false,
                success: function (data) {
                    dbus = data.result[0];
                    conf2obj();
					showDataStatus();
                }
            });
        }
        function showDataStatus() {
            if (typeof(dbus["phddns_status"]) == "undefined")
				$("#status").html("（空）");
            else if (dbus["phddns_status"] == "0")
				$("#status").html("花生壳已关闭");
            else if (dbus["phddns_status"] == "1")
				$("#status").html("花生壳已在线");
            else if (dbus["phddns_status"] == "2")
				$("#status").html("花生壳登录中");
            else if (dbus["phddns_status"] == "3")
				$("#status").html("花生壳重试中");

            if (typeof(dbus["phddns_sn"]) == "undefined")
				$("#sn").html("（空）");
			else
				$("#sn").html(dbus["phddns_sn"]);
            if (typeof(dbus["phddns_ip"]) == "undefined")
				$("#ip").html("（空）");
			else
				$("#ip").html(dbus["phddns_ip"]);
        }
        function push_data(obj, arg) {
            var id = parseInt(Math.random() * 100000000);
            var postData = { "id": id, "method": "phddns_config.sh", "params": [arg], "fields": obj };
            $.ajax({
                url: "/_api/",
                cache: false,
                type: "POST",
                dataType: "json",
                data: JSON.stringify(postData),
                success: function (response) {
                    if (response.result == id) {
                        refreshpage();
                    }
                }
            });
        }
        function push_data(obj, arg) {
            var id = parseInt(Math.random() * 100000000);
            var postData = { "id": id, "method": "phddns_config.sh", "params": [arg], "fields": obj };
            $.ajax({
                url: "/_api/",
                cache: false,
                type: "POST",
                dataType: "json",
                data: JSON.stringify(postData),
                success: function (response) {
                    if (response.result == id) {
                        refreshpage();
                    }
                }
            });
        }
		function menu_hook(title, tab) {
			tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装", "花生壳内网穿透");
			tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_phddns.asp");
		}
		function save() {
			dbus["phddns_enable"] = E("phddns_enable").checked ? "1" : "0";
			for (var i = 0; i < params_inp.length; i++) {
				if (E(params_inp[i]).value) {
					dbus[params_inp[i]] = E(params_inp[i]).value;
				}
			}
			push_data(dbus, "restart");
		}
		function getqr() {
			var obj ={};
            var id = parseInt(Math.random() * 100000000);
            var postData = { "id": id, "method": "phddns_config.sh", "params": ["getqr"], "fields": obj };
            $.ajax({
                url: "/_api/",
                cache: false,
                type: "POST",
                dataType: "json",
                data: JSON.stringify(postData),
                success: function (response) {
					if(response.result != "no")
						window.open(Base64.decode(response.result));
                }
            });
		}
		function manager() {
			var obj ={};
            var id = parseInt(Math.random() * 100000000);
            var postData = { "id": id, "method": "phddns_config.sh", "params": ["geturl"], "fields": obj };
            $.ajax({
                url: "/_api/",
                cache: false,
                type: "POST",
                dataType: "json",
                data: JSON.stringify(postData),
                success: function (response) {
					if(response.result != "no")
						window.open(Base64.decode(response.result));
                }
            });
		}
		function get_run_status(){
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "phddns_status.sh", "params":[], "fields": ""};
			$.ajax({
				type: "POST",
				cache:false,
				url: "/_api/",
				data: JSON.stringify(postData),
				dataType: "json",
				success: function(response){
					console.log(response)
				    if (response.result == "0")
						$("#status").html("花生壳已关闭");
				    else if (response.result == "1")
						$("#status").html("花生壳已在线");
				    else if (response.result == "2")
						$("#status").html("花生壳登录中");
				    else if (response.result == "3")
						$("#status").html("花生壳重试中");
					setTimeout("get_run_status();", 10000);
				},
				error: function(){
					setTimeout("get_run_status();", 5000);
				}
			});
		}
    </script>
</head>

<body onload="init();">
    <div id="TopBanner"></div>
    <div id="Loading" class="popup_bg"></div>
    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"> </iframe>
    <form method="POST" name="form" action="" target="hidden_frame">
    <input type="hidden" name="current_page" value="Module_phddns.asp" />
    <input type="hidden" name="next_page" value="Module_phddns.asp" />
    <input type="hidden" name="group_id" value="" />
    <input type="hidden" name="modified" value="0" />
    <input type="hidden" name="action_mode" value=" Refresh " />
    <input type="hidden" name="action_script" value="" />
    <input type="hidden" name="action_wait" value="5" />
    <input type="hidden" name="first_time" value="" />
    <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>" />
    <input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>" />
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
                            <table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3"
                                class="FormTitle" id="FormTitle">
                                <tr>
                                    <td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
                                        <div style="float:left;" class="formfonttitle" style="padding-top: 12px">
                                            花生壳内网穿透</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote" id="head_illustrate"><em>https://hsk.oray.com/</em></div>
                                        <div class="formfontdesc" id="cmdDesc">
                                        </div>
                                        <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3"
                                            class="FormTable">
                                            <tr>
                                                <th width="20%">
                                                    启用花生壳
                                                </th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell">
														<label for="phddns_enable">
															<input id="phddns_enable" class="switch" type="checkbox" style="display: none;">
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
                                            <tr>
                                                <th style="width:25%;">
                                                    状态：
                                                </th>
                                                <td>
                                                    <span id="status">-</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th style="width:25%;">
                                                    SN码：
                                                </th>
                                                <td>
                                                    <span id="sn">-</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th style="width:25%;">
                                                    IP：
                                                </th>
                                                <td>
                                                    <span id="ip">-</span>
                                                </td>
                                            </tr>
											<tr id="appid_tr">
												<th style="width:25%;">AppID</th>
												<td><input type="password" id="phddns_appid" name="phddns_appid" class="input_ss_table" value="" style="width:260px;" autocomplete="off" autocorrect="off" autocapitalize="off" maxlength="100" spellcheck="false" readonly onBlur="switchType(this, false);" onFocus="switchType(this, true);this.removeAttribute('readonly');"></td>
											</tr>
											<tr id="appkey_tr">
												<th style="width:25%;">AppKey</th>
												<td><input type="password" id="phddns_appkey" name="phddns_appkey" class="input_ss_table" value="" style="width:260px;" autocomplete="off" autocorrect="off" autocapitalize="off" maxlength="100" spellcheck="false" readonly onBlur="switchType(this, false);" onFocus="switchType(this, true);this.removeAttribute('readonly');"></td>
											</tr>
                                        </table>
                                        <div class="apply_gen">
											<input class="button_gen" type="button" onclick="save()" value="提交"/>
											<input class="button_gen" type="button" onclick="getqr()" value="扫码登录"/>
											<input class="button_gen" type="button" onclick="manager()" value="管理页面"/>
                                        </div>
										<div id="phddns_help">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
												<td>
													<ul>
														<li>使用此插件时,需要先添加AppID和AppKey,然后提交。</li>
														<li>提交后页面会显示SN码,然后点扫码登录 。</li>
														<li>完成之后点击管理页面即可开始管理内网穿透配置。</li>
														<li>AppID和AppKey获取方法,参考链接：<a href="https://www.right.com.cn/forum/thread-823071-1-1.html" target="_blank" ><i><u>https://www.right.com.cn/forum/thread-823071-1-1.html</u></i></a></li>
													</ul>
												</td>
												</tr>
											</table>
										</div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
                                        <div class="KoolshareBottom">
                                            花生壳官网： <a href="https://hsk.oray.com" target="_blank"><i>hsk.oray.com</i>
                                             <br/>
                                            开放平台： <a href="https://open.oray.com/" target="_blank"><i>open.oray.com</i>
                                            <br/>
                                            Shell & Web by： <i>SWRTdev</i><br/>
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
