<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title> Cloudflared 内网穿透</title>
<link rel="stylesheet" type="text/css" href="index_style.css" />
<link rel="stylesheet" type="text/css" href="form_style.css" />
<link rel="stylesheet" type="text/css" href="usp_style.css" />
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<style type="text/css">
.active {
    background: #807e79;
    background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss*/
    border: 1px solid #91071f; /* W3C rogcss*/
}
.close {
    background: red;
    color: black;
    border-radius: 12px;
    line-height: 18px;
    text-align: center;
    height: 18px;
    width: 18px;
    font-size: 16px;
    padding: 1px;
    top: -10px;
    right: -10px;
    position: absolute;
}
/* use cross as close button */
.close::before {
    content: "\2716";
}
.contentM_qis {
    position: fixed;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius:10px;
    z-index: 10;
    background-color:#2B373B;
    /*margin-left: -100px;*/
    top: 100px;
    width:755px;
    return height:auto;
    box-shadow: 3px 3px 10px #000;
    background: rgba(0,0,0,0.85);
    display:none;
}
.user_title{
    text-align:center;
    font-size:18px;
    color:#99FF00;
    padding:10px;
    font-weight:bold;
}
.info_btn {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C */
	background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss*/
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}
.info_btn:hover {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
	background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss*/
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}

.formbottomdesc {
    margin-top:10px;
    margin-left:10px;
}
input[type=button]:focus {
    outline: none;
}
.cfd_custom_btn {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #003333 0%, #000000 100%);
	background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss*/
    font-size: 10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px;
    width: auto;
}

.cfd_custom_btn:hover {
    background: linear-gradient(to bottom, #27c9c9 0%, #279fd9 100%);
	background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss*/
}
</style>
<script>
var db_cloudflared = {};
var params_input = ["cloudflared_cron_time", "cloudflared_cron_hour_min", "cloudflared_token", "cloudflared_mode", "cloudflared_cmd", "cloudflared_log_level", "cloudflared_path", "cloudflared_cron_type"]
var params_check = ["cloudflared_enable"]
function initial() {
	show_menu(menu_hook);
	get_dbus_data();
	get_status();
	toggle_func();
	conf2obj();
	buildswitch();
}
function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/cloudflared",
		dataType: "json",
		async: false,
		success: function(data) {
			db_cloudflared = data.result[0];
			conf2obj();
			update_visibility();
			toggle_func();
		}
	});
}

function conf2obj() {
	//input
	for (var i = 0; i < params_input.length; i++) {
		if(db_cloudflared[params_input[i]]){
			E(params_input[i]).value = db_cloudflared[params_input[i]];
		}
	}
	// checkbox
	for (var i = 0; i < params_check.length; i++) {
		if(db_cloudflared[params_check[i]]){
			E(params_check[i]).checked = db_cloudflared[params_check[i]] == 1 ? true : false
		}
	}
}
function get_status() {
		var postData = {
			"id": parseInt(Math.random() * 100000000),
			"method": "cloudflared_status.sh",
			"params": [],
			"fields": ""
		};
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

function buildswitch() {
	$("#cloudflared_enable").click(
	function() {
		if (E('cloudflared_enable').checked) {
			document.form.cloudflared_enable.value = 1;
		} else {
			document.form.cloudflared_enable.value = 0;
		}
	});
}
function save() {
		if (trim(E("cloudflared_enable").value) == "1" && trim(E("cloudflared_mode").value) == "token" && trim(E("cloudflared_token").value) == "") {
			alert("隧道token未填写!");
			return false;
		}
		if (trim(E("cloudflared_cron_time").value) == "") {
			alert("cloudflared定时功能的值不能为空!不使用请填0");
			return false;
		}
		if (trim(E("cloudflared_enable").value) == "1" && trim(E("cloudflared_mode").value) == "user_cmd" && trim(E("cloudflared_cmd").value) == "") {
			alert("自定义启动参数未填写！");
			return false;
		}
		if(E("cloudflared_cron_time").value == "0"){
		    E("cloudflared_cron_hour_min").value = "";
		    E("cloudflared_cron_type").value = "";
		}
	showLoading(3);

	//input
	for (var i = 0; i < params_input.length; i++) {
		if (trim(E(params_input[i]).value) && trim(E(params_input[i]).value) != db_cloudflared[params_input[i]]) {
			db_cloudflared[params_input[i]] = trim(E(params_input[i]).value);
		}else if (!trim(E(params_input[i]).value) && db_cloudflared[params_input[i]]) {
			db_cloudflared[params_input[i]] = "";
            }
	}
	// checkbox
	for (var i = 0; i < params_check.length; i++) {
        if (E(params_check[i]).checked != db_cloudflared[params_check[i]]){
            db_cloudflared[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
        }
	}
	
	// post data
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "cloudflared_config.sh", "params": [1], "fields": db_cloudflared };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
				refreshpage();
			}
		}
	});
}
function clear_log() {
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "cloudflared_config.sh", "params": ["clearlog"], "fields": db_cloudflared };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
			}
		}
	});
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "软件中心", "离线安装", "cloudflared");
	tablink[tablink.length - 1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_cloudflared.asp");
}

function get_log() {
	$.ajax({
		url: '/_temp/cloudflared.log',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
            if (res.length == 0){
            E("logtxt").value = "日志文件为空或程序未启动"; 
            get_log();
			}else{ $('#logtxt').val(res); }
		}
	});
}

function open_conf(open_conf) {
	if (open_conf == "cloudflared_log") {
		get_log();
	}
	
	$("#" + open_conf).fadeIn(200);
}
function close_conf(close_conf) {
	$("#" + close_conf).fadeOut(200);
}
function toggle_func() {	
	$("#cloudflared_mode").change(
		function(){
			if(E("cloudflared_mode").value == "token" || E("cloudflared_mode").value == ""){
				E("user_cmd").style.display = "none";
				E("token").style.display = "";
			}else{
				E("token").style.display = "none";
				E("user_cmd").style.display = "";
			}
		}
	);
}

//网页重载时更新显示样式
function update_visibility(){
	if(!db_cloudflared["cloudflared_mode"] || db_cloudflared["cloudflared_mode"] == "token"){
	    E("user_cmd").style.display = "none";
		E("token").style.display = "";
	}else{
		E("token").style.display = "none";
		E("user_cmd").style.display = "";
	}
}
document.addEventListener('DOMContentLoaded', function() {
    var cfdEnableCheckbox = document.getElementById('cloudflared_enable');
    var cfdActionBtn = document.getElementById('cfd_action_btn');
    var feedbackMessage = document.createElement('div'); // 创建一个新的 div 元素用于显示反馈消息
    feedbackMessage.style.display = 'none'; // 初始时隐藏反馈消息
    feedbackMessage.style.marginLeft = '10px'; // 设置反馈消息的左边距
    feedbackMessage.style.transition = 'opacity 0.5s ease'; // 添加渐变效果
	// 将反馈消息添加到按钮旁边的父元素中
    cfdActionBtn.parentNode.appendChild(feedbackMessage);
    // 根据复选框的初始状态设置按钮文本
    updateButtonLabel(cfdEnableCheckbox.checked);

    // 监听复选框状态变化
    cfdEnableCheckbox.addEventListener('change', function() {
        updateButtonLabel(this.checked);
    });

    // 监听按钮点击事件
    cfdActionBtn.addEventListener('click', function() {
        var buttonText = cfdActionBtn.textContent.trim();
        if (buttonText === '重启') {
            restate(); // 执行重启函数
        } else if (buttonText === '更新') {
            update(); // 执行更新函数
        }
    });

    function updateButtonLabel(isChecked) {
        // 根据复选框的状态更新按钮文本
        cfdActionBtn.textContent = isChecked ? '重启' : '更新';
    }

    function restate() {
        // 执行重启
        var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "cloudflared_config.sh", "params": ["restart"], "fields": db_cloudflared };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
			 	showFeedback('重启执行成功');
			}
		}
	});
    }

    function update() {
        // 执行更新
        var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "cloudflared_config.sh", "params": ["update"], "fields": db_cloudflared };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
				showFeedback('更新执行成功');
			}
		}
	});
    }
	function showFeedback(message) {
        feedbackMessage.textContent = message; // 设置反馈消息的文本内容
        feedbackMessage.style.display = 'block'; // 显示反馈消息
        setTimeout(function() {
            feedbackMessage.style.opacity = '0'; // 在3秒后将反馈消息的透明度设为0
            setTimeout(function() {
                feedbackMessage.style.display = 'none'; // 在渐变结束后隐藏反馈消息
                feedbackMessage.style.opacity = '1'; // 重置透明度
            }, 500); // 0.5秒后隐藏反馈消息
        }, 3000); // 3秒后开始隐藏反馈消息
    }
});

function openssHint(itemNum) {
	statusmenu = "";
	width = "350px";
	if (itemNum == 0) {
		statusmenu = "开启cloudflared选项,拨动开关，右边的按钮会切换<br>更新按钮为在线更新cloudflared程序版本<br>重启按钮为重新启动cloudflared";
		_caption = "开启cloudflared";
	} else if (itemNum == 1) {
		statusmenu = "显示程序的进程状态及 pid";
		_caption = "运行状态";
	} else if (itemNum == 2) {
		statusmenu = "定时执行操作。<font color='#F46'>检查：</font>检查cloudflared的进程是否存在，若不存在则重新启动；<font color='#F46'>启动：</font>重新启动cloudflared进程，而不论当时是否在正常运行。重新启动服务会导致活动中的连接短暂中断.<br><font color='#F46'>注意：</font>填写内容为 0 关闭定时功能！<br/>建议：选择分钟填写“60的因数”【1、2、3、4、5、6、10、12、15、20、30、60】，选择小时填写“24的因数”【1、2、3、4、6、8、12、24】。";
		_caption = "定时功能";
	} else if (itemNum == 3) {
		statusmenu = " 显示cloudflared的运行日志。";
		_caption = " 运行日志 ";
	} else if (itemNum == 4) {
		statusmenu = "使用默认的启动参数，只需要填入隧道token即可<br>不会使用选常规即可，只需要输入隧道token，就能在官网后台管理";
		_caption = "启动参数";
	} else if (itemNum == 6) {
		statusmenu = " 设置cloudflared的启动参数，不需要填入程序路径，只需要填启动参数即可<br>例如 tunnel --no-autoupdate --logfile /tmp/upload/cloudflared.log --loglevel info run token eyJhIjoiZDIxsjMw2usa9GFFG0vsadhDg4YjU4ZGFlN";
		_caption = "自定义启动参数";
	} else if (itemNum == 7) {
		statusmenu = " 设定cloudflared运行日志的详细程度，默认info级别不会产生太多输出。<br>等级由低到高：debug < info < warn < Error < Fatal <br>日志路径/tmp/upload/cloudflared.log";
		_caption = " 日志等级";
	} else if (itemNum == 8) {
		statusmenu = "自定义cloudflared的文件路径，文件大小约35M<br>确保填写完整的路径及文件名，且文件名必须为cloudflared<br>没有程序会在线下载官方最新版本，也可以手动下载进行upx压缩后手动上传到路由";
		_caption = " 程序路径";
	} 
	return overlib(statusmenu, OFFSETX, -160, LEFT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');
	var tag_name = document.getElementsByTagName('a');
	for (var i = 0; i < tag_name.length; i++)
		tag_name[i].onmouseout = nd;
	if (helpcontent == [] || helpcontent == "" || hint_array_id > helpcontent.length)
		return overlib('<#defaultHint#>', HAUTO, VAUTO);
	else if (hint_array_id == 0 && hint_show_id > 21 && hint_show_id < 24)
		return overlib(helpcontent[hint_array_id][hint_show_id], FIXX, 270, FIXY, 30);
	else {
		if (hint_show_id > helpcontent[hint_array_id].length)
			return overlib('<#defaultHint#>', HAUTO, VAUTO);
		else
			return overlib(helpcontent[hint_array_id][hint_show_id], HAUTO, VAUTO);
	}
}

</script>
</head>
<body onload="initial();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=cloudflared" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_cloudflared.asp"/>
<input type="hidden" name="next_page" value="Module_cloudflared.asp"/>
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
                        <table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3"  class="FormTitle" id="FormTitle">
                            <tr>
                                <td bgcolor="#4D595D" colspan="3" valign="top">
                                    <div>&nbsp;</div>
                                    <div style="float:left;" class="formfonttitle">Cloudflared 内网穿透</div>
                                    <div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                                    <div style="margin:30px 0 10px 5px;" class="splitLine"></div>
                                    <div class="formfontdesc">Cloudflare Tunnel 客户端(以前称为 Argo Tunnel)。【项目地址：<a href="https://github.com/cloudflare/cloudflared" target="_blank"><em><u>Github</u></em></a>】【使用文档：<a href="https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-local-tunnel/#2-authenticate-cloudflared" target="_blank"><em><u>创建隧道</u></em></a>】<br/><i>  点击下方参数设置的文字，可查看帮助信息  </i></div>
                                    <div>
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="box-shadow: 3px 3px 10px #000;margin-top: 0px;">
                                       <tr>
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(0)">开启</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="cloudflared_enable">
                                                        <input id="cloudflared_enable" class="switch" type="checkbox" style="display: none;">
                                                        <div class="switch_container" >
                                                            <div class="switch_bar"></div>
                                                            <div class="switch_circle transition_style">
                                                                <div></div>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
												<div>
            <button id="cfd_action_btn" class="cfd_custom_btn"></button>
        </div>
                                            </td>
                                        </tr>
                                        <tr id="cfd_status">
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(1)">运行状态</th>
                                            <td><span id="status">获取中...</span>
                                            </td>
                                        </tr>
                                       
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(2)">定时功能(<i>0为关闭</i>)</a></th>
                                            <td>
                                                每 <input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '')" id="cloudflared_cron_time" name="cloudflared_cron_time" class="input_3_table" maxlength="2" value="0" placeholder="" />
                                                <select id="cloudflared_cron_hour_min" name="cloudflared_cron_hour_min" style="width:60px;margin:3px 2px 0px 2px;" class="input_option">
                                                    <option value="min">分钟</option>
                                                    <option value="hour">小时</option>
                                                </select> 
                                                    <select id="cloudflared_cron_type" name="cloudflared_cron_type" style="width:60px;margin:3px 2px 0px 2px;" class="input_option">
                                                        <option value="watch">检查</option>
                                                        <option value="start">重启</option>
                                                    </select> 一次服务
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(3)">程序日志</th>
                                            <td>
                                                <a type="button" class="info_btn" style="cursor:pointer" href="javascript:void(0);" onclick="open_conf('cloudflared_log');" >查看日志</a>
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(4)">启动参数</a></th>
                                            <td>
                                                <select id="cloudflared_mode" name="cloudflared_mode" style="width:165px;margin:0px 0px 0px 2px;" value="token" class="input_option" >
                                                    <option value="token">常规</option>
                                                    <option value="user_cmd">自定义</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="token" style="display: none;">
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(5)">隧道Token</a></th>
                                            <td>
                                                <textarea type="password" name="cloudflared_token" id="cloudflared_token" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off"  value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);"/></textarea>
                                        </tr>
										<tr id="user_cmd" style="display: none;">
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(6)">自定义启动参数</a></th>
                                            <td>
                                                <textarea  type="text" class="input_ss_table" value="" id="cloudflared_cmd" name="cloudflared_cmd"  value="" placeholder="tunnel --no-autoupdate --logfile /tmp/upload/cloudflared.log --loglevel info run token eyJhIjoiZDIxsjMw2usa9GFFG0vsadhDg4YjU4ZGFlN "></textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(7)">日志等级</a></th>
                                            <td>
                                                <select id="cloudflared_log_level" name="cloudflared_log_level" style="width:165px;margin:0px 0px 0px 2px;"  value="info" class="input_option" >
                                                    <option value="info">info</option>
                                                    <option value="warn">warn</option>
                                                    <option value="error">error</option>
                                                    <option value="debug">debug</option>
													<option value="debug">fatal</option>
                                                </select>
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(8)">自定义程序路径</a></th>
                                            <td>
                                                <input type="text"  class="input_ss_table" id="cloudflared_path" name="cloudflared_path" maxlength="500" value="" placeholder="/tmp/cloudflared"/>
                                            </td>
                                        </tr>
                                    </table>
                                    
                                   
</div>
<div class="apply_gen">
    <span><input class="button_gen" id="cmdBtn" onclick="save()" type="button" value="提交"/></span>
</div>
<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
<div class="formbottomdesc" id="cmdDesc">
    <i>* 注意事项：</i> 第一次使用请先注册CF并创建隧道<br/><br/>
    1、没有CF的隧道<i>token</i>的，请先创建一个隧道，CF官网创建隧道可能需要信用卡，可使用命令行创建<br/>
    &nbsp;&nbsp;&nbsp;&nbsp;在SSH命令行输入<i>cloudflared tunnel login</i> 然后登陆提供的网址，再输入<i>cloudflared tunnel create 隧<br/>&nbsp;&nbsp;&nbsp;&nbsp;道名称</i>创建一个隧道，后再去官网管理，获取隧道token <br/>
    2、<i>点击</i>参数标题的<i>文字</i>，可<i>查看帮助</i>信息。<br/>
	3、若启动失败，请查看<i>程序日志</i>，有报错提示，或者通过SSH命令行启动测试。<br/>
	4、插件会自动从<i>github</i>下载二进制程序，也可以手动上传程序。<br/>
	4、下载的二进制程序大约<i>35M</i>，确保路由的可用空间足够，不够的建议程序路径设置为<i>/tmp/cloudflared</i><br/>
</div>
                                    <div id="cloudflared_log"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">Cloudflared 日志文件 /tmp/upload/cloudflared.log&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('cloudflared_log');" value="关闭"><span class="close"></span></a></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="logtxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node3" class="button_gen" type="button" onclick="close_conf('cloudflared_log');" value="返回主界面">
                                            &nbsp;&nbsp;<input class="button_gen" type="button" onclick="close_conf('cloudflared_log');clear_log();" value="清空日志">
                                        </div>
										</div>

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
</form>
<div id="footer"></div>
</body>
</html>




