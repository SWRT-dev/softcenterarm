<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html xmlns:v>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<title id="web_title">软件中心 -百度网盘下载</title>
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="index_style.css">
<link rel="stylesheet" type="text/css" href="form_style.css">
<link rel="stylesheet" type="text/css" href="usp_style.css">
<link rel="stylesheet" type="text/css" href="/calendar/fullcalendar.css">
<link rel="stylesheet" type="text/css" href="/device-map/device-map.css">
<script language="JavaScript" type="text/javascript" src="/js/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/js/httpApi.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/dbconf?p=baidupcs_&v=<% uptime(); %>"></script>
<style>
</style>
<script>
var baidupcs_disk='<% dbus_get_def("baidupcs_disk", "0"); %>';
var partitions_array = [];
function show_partition(){
require(['/require/modules/diskList.js?hash=' + Math.random().toString()], function(diskList){
var code="";
var mounted_partition = 0;
partitions_array = [];
var usbDevicesList = diskList.list();
for(var i=0; i < usbDevicesList.length; i++){
for(var j=0; j < usbDevicesList[i].partition.length; j++){
partitions_array.push(usbDevicesList[i].partition[j].mountPoint);
var accessableSize = simpleNum(usbDevicesList[i].partition[j].size-usbDevicesList[i].partition[j].used);
var totalSize = simpleNum(usbDevicesList[i].partition[j].size);
if(usbDevicesList[i].partition[j].status == "unmounted")
continue;
if(usbDevicesList[i].partition[j].partName==baidupcs_disk)
code +='<option value="'+ usbDevicesList[i].partition[j].partName+'" selected="selected">'+ usbDevicesList[i].partition[j].partName+'(空闲:'+accessableSize+' GB)</option>';
else
code +='<option value="'+ usbDevicesList[i].partition[j].partName+'" >'+ usbDevicesList[i].partition[j].partName+'(空闲:'+accessableSize+' GB)</option>';
mounted_partition++;
}
}
if(mounted_partition == 0)
code +='<option value="0">无U盘或移动硬盘</option>';
document.getElementById("usb_disk_id").innerHTML = code;
});
}
function initial(){
show_menu(menu_hook);
show_footer();
show_partition()
}
function applyRule(){
if(document.getElementById("usb_disk_id").value==0)
{
alert("无法启用，请插入U盘或移动硬盘");
return;
}
showLoading(2);
document.form.submit();
}
function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装", "百度盘");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_baidupcs.asp");
}
function reactive(){

window.open("http://"+window.location.hostname+":5299");

}
</script></head>
<body onload="initial();" onunload="unload_body();" onselectstart="return false;">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" action="/applydb.cgi?p=baidupcs" target="hidden_frame">
<input type="hidden" name="productid" value="<% nvram_get("productid"); %>">
<input type="hidden" name="current_page" value="Module_baidupcs.asp">
<input type="hidden" name="next_page" value="Module_baidupcs.asp">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_wait" value="">
<input type="hidden" name="action_mode" value="toolscript">
<input type="hidden" name="action_script" value="baidupcs_config.sh">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>" disabled>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
<input type="hidden" name="baidupcs_enable" value="<% dbus_get_def('baidupcs_enable','0'); %>">
<input type="hidden" name="baidupcs_https" value="<% dbus_get_def('baidupcs_https','0'); %>">
<input type="hidden" name="baidupcs_max_download" value="<% dbus_get_def('baidupcs_max_download','2'); %>">
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
<div id="content_title" class="formfonttitle" style="width:400px">百度网盘下载</div>
</td>
</tr>
</table>
</div>
<div id="PC_desc">
<table width="700px" style="margin-left:25px;">
<tr>
<td>
<div id="guest_image" style="background: url(images/New_ui/baidu.png);width: 100px;height: 100px;"></div>
</td>
<td>&nbsp;&nbsp;</td>
<td style="font-style: italic;font-size: 14px;">
<span id="desc_title">使用简介：</span>
<ol>
<li>百度网盘可以满速下载你的网盘文件</li>
<li>你需要插入U盘或移动硬盘才能启动此功能</li>
<li>保存设置后，点击打开链接按钮开启百度盘界面</li>
<li>仅支持BDUSS登录</li>
</ol>
<span id="desc_note" style="color:#FC0;">提示：</span>
<ol style="color:#FC0;margin:-5px 0px 3px -18px;*margin-left:18px;">
<li>如果账号下载太狠被百度拉黑限速了，充个会员或者等几天即可解锁</li>
<li>下载目录留空则使用默认，路径默认为 "/tmp/mnt/(你的U盘卷标名称)"</li>
</ol>
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
<th id="PC_enable">启用百度网盘下载</th>
<td>
<div align="center" class="left" style="width:94px; float:left; cursor:pointer;" id="radio_baidupcs_enable"></div>
<div class="iphone_switch_container" style="height:32px; width:74px; position: relative; overflow: hidden">
<script type="text/javascript">
$('#radio_baidupcs_enable').iphoneSwitch('<% dbus_get_def("baidupcs_enable","0"); %>',
function(){
document.form.baidupcs_enable.value = 1;
},
function(){
document.form.baidupcs_enable.value = 0;
}
);
</script>
</div>
</td>
</tr>
<tr>
<th>选择程序运行的磁盘</th>
<td>
<select id="usb_disk_id" name="baidupcs_disk" class="input_option input_25_table">
<option value="0">无U盘或移动硬盘</option>
</select>
</td>
</tr>
<tr id="baidupcs_savedir_tr">
<th>设置下载目录</th>
<td>
<input name="baidupcs_savedir" class="input_32_table" value="<% dbus_get_def("baidupcs_savedir", ""); %>">
</td>
</tr>
<tr id="baidupcs_https_tr">
<th>启用https</th>
<td>
<select name="baidupcs_https" style="width:200px;margin:0px 0px 0px 2px;" class="input_option">
<option value="0" <% dbus_match( "baidupcs_https", "0","selected"); %>>关闭</option>
<option value="1" <% dbus_match( "baidupcs_https", "1","selected"); %>>启用</option>
</select>
</td>
</tr>
<tr id="baidupcs_max_tr">
<th>设置最大下载进程数</th>
<td>
<select name="baidupcs_max_download" style="width:200px;margin:0px 0px 0px 2px;" class="input_option">
<option value="1" <% dbus_match( "baidupcs_max_download", "1","selected"); %>>1</option>
<option value="2" <% dbus_match( "baidupcs_max_download", "2","selected"); %>>2</option>
</select>
</td>
</tr>
<tr>

<th>管理窗口</th>

<td id="webshell_status">

<input class="button_gen" onclick="reactive();" type="button" value="打开窗口"/>

</td>

</tr>
<thead>
<tr>
<td colspan="2">日志信息</td>
</tr>
</thead>
<tr><td colspan="2">
<textarea cols="63" rows="25" wrap="off" readonly="readonly" id="textarea"style="width:99%;font-family:Courier New, Courier, mono; font-size:11px;" class="textarea_ssh_table">
<% nvram_dump("baidupcs.log",""); %>
</textarea>
</td></tr>
</table>
<div class="apply_gen">
<input class="button_gen" onclick="applyRule()" type="button" value="提交更改"/>
<input type="button" onClick="location.href=location.href" value="刷新日志" class="button_gen">
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
