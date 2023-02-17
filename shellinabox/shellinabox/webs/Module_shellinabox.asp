<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html xmlns:v>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<title id="web_title"><#587#> - webshell</title>
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="index_style.css">
<link rel="stylesheet" type="text/css" href="form_style.css">
<link rel="stylesheet" type="text/css" href="usp_style.css">
<link rel="stylesheet" type="text/css" href="/calendar/fullcalendar.css">
<link rel="stylesheet" type="text/css" href="/device-map/device-map.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<style>
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
</style>
<script>
function initial(){
show_menu();
show_footer();
}
function reactive(){
window.open("http://"+window.location.hostname+":4200");
}
function applyRule(){
showLoading(2);
document.form.submit();
}
function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装", "webshell");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_shellinabox.asp");
}
</script></head>
<body onload="initial();" onunload="unload_body();" onselectstart="return false;">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" action="/applydb.cgi?p=webshell" target="hidden_frame">
<input type="hidden" name="productid" value="<% nvram_get("productid"); %>">
<input type="hidden" name="current_page" value="Module_shellinabox.asp">
<input type="hidden" name="next_page" value="Module_shellinabox.asp">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_wait" value="">
<input type="hidden" name="action_mode" value="toolscript">
<input type="hidden" name="action_script" value="shellinabox_start.sh">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>" disabled>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
<input type="hidden" name="webshell_enable" value="<% dbus_get_def("webshell_enable", "0"); %>">
<table class="content" align="center" cellpadding="0" cellspacing="0" >
<tr>
<td width="17">&nbsp;</td>
<td valign="top" width="202">
<div id="mainMenu"></div>
<div id="subMenu"></div>
</td>
<td valign="top">
<div id="tabMenu" class="submenuBlock"></div>
<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0" >
<tr>
<td valign="top" >
<table width="730px" border="0" cellpadding="4" cellspacing="0" class="FormTitle" id="FormTitle">
<tbody>
<tr>
<td bgcolor="#4D595D" valign="top">
<div>&nbsp;</div>
<div style="margin-top:-5px;">
<table width="730px">
<tr>
<td align="left" >
<div id="content_title" class="formfonttitle" style="width:400px">WebShell</div>
            <div style="float:right; width:15px; height:25px;margin-top:10px">
             <img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
            </div>
</td>
</tr>
</table>
</div>
<div id="PC_desc">
<table width="700px" style="margin-left:25px;">
<tr>
<td>
<div id="guest_image" style="width: 100px;height: 87px;"></div>
</td>
<td>&nbsp;&nbsp;</td>
<td style="font-style: italic;font-size: 14px;">
<span id="desc_title">使用简介：</span>
<ol>
<li>webshell可以使你在web页面进行命令行管理</li>
<li>登录名和密码与web一致</li>
<li>你可以在此开启webshell后点击“打开窗口”按钮来使用</li>
</ol>
<span id="desc_note" style="color:#FC0;">提示：</span>
<ol style="color:#FC0;margin:-5px 0px 3px -18px;*margin-left:18px;">
<li>webshell使用的端口号为4200</li> </ol>
</td>
</tr>
</table>
</div>
<div id="edit_time_anchor"></div>
<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
<thead><tr>
<td colspan="2" >服务信息</td>
</tr></thead>
<tr>
<th id="PC_enable">启用WebShell</th>
<td>
<div align="center" class="left" style="width:94px; float:left; cursor:pointer;" id="radio_webshell_enable"></div>
<div class="iphone_switch_container" style="height:32px; width:74px; position: relative; overflow: hidden">
<script type="text/javascript">
$('#radio_webshell_enable').iphoneSwitch('<% dbus_get_def("webshell_enable", "0"); %>',
function(){
document.form.webshell_enable.value = 1;
},
function(){
document.form.webshell_enable.value = 0;
}
);
</script>
</div>
</td>
</tr>
<tr>
<th>管理窗口</th>
<td id="webshell_status">
<input class="button_gen" onclick="reactive();" type="button" value="打开窗口"/>
</td>
</tr>
</thead>
<thead><tr>
<td colspan="2">日志信息</td>
</tr></thead>
<tr><td colspan="2">
<div id="log_content" style="margin-top:-1px;display:block;overflow:hidden;">
<textarea id="log_content_text" cols="63" rows="20" wrap="on" readonly="readonly">
<% nvram_dump("webshell.log",""); %>
</textarea>
</div>
</td></tr>
</table>
<div class="apply_gen">
<input class="button_gen" onclick="applyRule()" type="button" value="应用设置"/>
</div>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</table>
</td>
<td width="10" align="center" valign="top">&nbsp;</td>
</tr>
</table>
<div id="footer"></div>
</form>
</body>
</html>

