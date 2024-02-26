<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - VNT 异地组网、内网穿透工具</title>
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
.show-btn1, .show-btn2, .show-btn3 {
    border: 1px solid #222;
    background: #576d73;
	background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss*/
    font-size:10pt;
    color: #fff;
    padding: 10px 3.75px;
    border-radius: 5px 5px 0px 0px;
    width:15%;
    border: 1px solid #91071f; /* W3C rogcss*/
    background: none; /* W3C rogcss*/
    }
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
.vnt_custom_btn {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #003333 0%, #000000 100%);
	background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss*/
    font-size: 10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px;
    width: auto;
}

.vnt_custom_btn:hover {
    background: linear-gradient(to bottom, #27c9c9 0%, #279fd9 100%);
	background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss*/
}
</style>
<script>
var db_vnt = {};
var params_input = ["vnt_cron_time", "vnt_cron_hour_min","vnts_cron_time", "vnts_cron_hour_min", "vnt_token", "vnts_token","vnt_ipmode", "vnt_static_ip", "vnt_desvice_id", "vnt_desvice_name", "vnt_localadd", "vnt_peeradd", "vnt_serveraddr", "vnt_stunaddr", "vnt_tun_mode", "vnt_udp_mode", "vnt_ipv4_mode", "vnt_cron_type", "vnts_cron_type", "vnt_port", "vnts_port","vnt_mtu", "vnt_par", "vnt_passmode", "vnt_key", "vnt_path", "vnts_path", "vnts_mask", "vnts_gateway"]
var params_check = ["vnt_enable","vnts_enable","vnt_proxy_enable","vnt_W_enable","vnt_finger_enable","vnt_relay_enable","vnt_first_latency_enable","vnt_mn_enable","vnts_finger_enable"]
function initial() {
	show_menu(menu_hook);
	get_dbus_data();
	get_vnt_status();
	toggle_func();
	conf2obj();
	buildswitch();
	get_installog();
}
function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/vnt",
		dataType: "json",
		async: false,
		success: function(data) {
			db_vnt = data.result[0];
			conf2obj();
			update_visibility();
			toggle_func();
		}
	});
}

function conf2obj() {
	//input
	for (var i = 0; i < params_input.length; i++) {
		if(db_vnt[params_input[i]]){
			E(params_input[i]).value = db_vnt[params_input[i]];
		}
	}
	// checkbox
	for (var i = 0; i < params_check.length; i++) {
		if(db_vnt[params_check[i]]){
			E(params_check[i]).checked = db_vnt[params_check[i]] == 1 ? true : false
		}
	}
}
function get_vnt_status() {
		var postData = {
			"id": parseInt(Math.random() * 100000000),
			"method": "vnt_status.sh",
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
				if (typeof response.result === "string" && response.result) {
        var resultArray = response.result.split('|'); 
        if (resultArray.length >= 2) {
            E("status1").innerHTML = resultArray[0]; 
            E("status2").innerHTML = resultArray[1]; 
        }
    }
    setTimeout("get_vnt_status();", 10000);
},
			error: function() {
				setTimeout("get_vnt_status();", 5000);
			}
		});
	}


function buildswitch() {
	$("#vnt_enable").click(
	function() {
		if (E('vnt_enable').checked) {
			document.form.vnt_enable.value = 1;
		} else {
			document.form.vnt_enable.value = 0;
		}
	});
	$("#vnts_enable").click(
	function() {
		if (E('vnts_enable').checked) {
			document.form.vnts_enable.value = 1;
		} else {
			document.form.vnts_enable.value = 0;
		}
	});
	$("#vnt_proxy_enable").click(
	function() {
		if (E('vnt_proxy_enable').checked) {
			document.form.vnt_proxy_enable.value = 1;
		} else {
			document.form.vnt_proxy_enable.value = 0;
		}
	});
	$("#vnt_W_enable").click(
	function() {
		if (E('vnt_W_enable').checked) {
			document.form.vnt_W_enable.value = 1;
		} else {
			document.form.vnt_W_enable.value = 0;
		}
	});
	$("#vnt_finger_enable").click(
	function() {
		if (E('vnt_finger_enable').checked) {
			document.form.vnt_finger_enable.value = 1;
		} else {
			document.form.vnt_finger_enable.value = 0;
		}
	});
	$("#vnt_relay_enable").click(
	function() {
		if (E('vnt_relay_enable').checked) {
			document.form.vnt_relay_enable.value = 1;
		} else {
			document.form.vnt_relay_enable.value = 0;
		}
	});
	$("#vnt_first_latency_enable").click(
	function() {
		if (E('vnt_first_latency_enable').checked) {
			document.form.vnt_first_latency_enable.value = 1;
		} else {
			document.form.vnt_first_latency_enable.value = 0;
		}
	});
	$("#vnt_mn_enable").click(
	function() {
		if (E('vnt_mn_enable').checked) {
			document.form.vnt_mn_enable.value = 1;
		} else {
			document.form.vnt_mn_enable.value = 0;
		}
	});
	$("#vnts_finger_enable").click(
	function() {
		if (E('vnts_finger_enable').checked) {
			document.form.vnts_finger_enable.value = 1;
		} else {
			document.form.vnts_finger_enable.value = 0;
		}
	});
}
function save() {
		if (trim(E("vnt_enable").value) == "1" && trim(E("vnt_token").value) == "") {
			alert("客户端token未填写!");
			return false;
		}
		if (trim(E("vnt_cron_time").value) == "") {
			alert("客户端定时功能不能为空!不使用请填0");
			return false;
		}
		if (trim(E("vnts_cron_time").value) == "") {
			alert("服务端定时功能不能为空!不使用请填0");
			return false;
		}
		if (trim(E("vnt_enable").value) == "1" && trim(E("vnt_ipmode").value) == "static" && trim(E("vnt_static_ip").value) == "") {
			alert("选择静态分配IP，必须填写分配的虚拟IP地址！");
			return false;
		}
		if (trim(E("vnts_enable").value) == "1" && trim(E("vnts_port").value) == "") {
			alert("服务端监听端口未填写!");
			return false;
		}
		if(E("vnt_cron_time").value == "0"){
		    E("vnt_cron_hour_min").value = "";
		    E("vnt_cron_type").value = "";
		}
		if(E("vnts_cron_time").value == "0"){
		    E("vnts_cron_hour_min").value = "";
		    E("vnts_cron_type").value = "";
		}
		//清空隐藏表单的值
		if(E("vnt_ipmode").value == "dhcp"){
            E("vnt_static_ip").value = "";
		}
		if(E("vnt_passmode").value == "off"){
            E("vnt_key").value = "";
		}
	
	showLoading(3);

	//input
	for (var i = 0; i < params_input.length; i++) {
		if (trim(E(params_input[i]).value) && trim(E(params_input[i]).value) != db_vnt[params_input[i]]) {
			db_vnt[params_input[i]] = trim(E(params_input[i]).value);
		}else if (!trim(E(params_input[i]).value) && db_vnt[params_input[i]]) {
			db_vnt[params_input[i]] = "";
            }
	}
	// checkbox
	for (var i = 0; i < params_check.length; i++) {
        if (E(params_check[i]).checked != db_vnt[params_check[i]]){
            db_vnt[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
        }
	}
	
	// post data
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "vnt_config.sh", "params": [1], "fields": db_vnt };
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
function clear_vntlog() {
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "vnt_config.sh", "params": ["clearvntlog"], "fields": db_vnt };
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
function clear_vntslog() {
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "vnt_config.sh", "params": ["clearvntslog"], "fields": db_vnt };
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
	tabtitle[tabtitle.length - 1] = new Array("", "软件中心", "离线安装", "VNT");
	tablink[tablink.length - 1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_vnt.asp");
}

function get_vnt_log() {
	$.ajax({
		url: '/_temp/vnt-cli.log',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
            if (res.length == 0){
            E("vnt_logtxt").value = "日志文件为空或程序未启动"; 
            get_vnt_log();
			}else{ $('#vnt_logtxt').val(res); }
		}
	});
}
function get_vnt_info() {
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "vnt_config.sh", "params": ["vinfo"], "fields": db_vnt };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
			$.ajax({
		url: '/_temp/vnt_info.log',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
            if (res.length == 0){
            E("vnt_infotxt").value = "未获取到本机设备信息或程序未启动"; 
            get_vnt_info();
			}else{ $('#vnt_infotxt').val(res); }
		}
	});
			}
		}
	});
}
function get_vnt_all() {
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "vnt_config.sh", "params": ["all"], "fields": db_vnt };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
				$.ajax({
		url: '/_temp/vnt_all.log',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
            if (res.length == 0){
            E("vnt_alltxt").value = "未获取到所有设备信息或程序未启动"; 
            get_vnt_all();
			}else{ $('#vnt_alltxt').val(res); }
		}
	});
			}
		}
	});
}
function get_vnt_list() {
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "vnt_config.sh", "params": ["list"], "fields": db_vnt };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
				$.ajax({
		url: '/_temp/vnt_list.log',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
            if (res.length == 0){
            E("vnt_listtxt").value = "未获取到所有列表信息或程序未启动"; 
            get_vnt_list();
			}else{ $('#vnt_listtxt').val(res); }
		}
	});
			}
		}
	});
}
function get_vnt_route() {
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "vnt_config.sh", "params": ["route"], "fields": db_vnt };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
				$.ajax({
		url: '/_temp/vnt_route.log',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
            if (res.length == 0){
            E("vnt_routetxt").value = "未获取到路由转发信息或程序未启动"; 
            get_vnt_route();
			}else{ $('#vnt_routetxt').val(res); }
		}
	});
			}
		}
	});
}
function get_vnt_cmd() {
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "vnt_config.sh", "params": ["vnt_cli"], "fields": db_vnt };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
				$.ajax({
		url: '/_temp/vnt_cmd.log',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
            if (res.length == 0){
            E("vnt_cmdtxt").value = "未获取到程序启动参数或程序未启动"; 
            get_vnt_cmd();
			}else{ $('#vnt_cmdtxt').val(res); }
		}
	});
			}
		}
	});
}
function get_vnts_log() {
	$.ajax({
		url: '/_temp/vnts.log',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
            if (res.length == 0){
            E("vnts_logtxt").value = "日志文件为空或程序未启动"; 
            get_vnts_log();
			}else{ $('#vnts_logtxt').val(res); }
		}
	});
}
function get_vnts_cmd() {
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "vnt_config.sh", "params": ["vnts"], "fields": db_vnt };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
				$.ajax({
		url: '/_temp/vnts_cmd.log',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
            if (res.length == 0){
            E("vnts_cmdtxt").value = "未获取到程序启动参数或程序未启动"; 
            get_vnts_cmd();
			}else{ $('#vnts_cmdtxt').val(res); }
		}
	});
			}
		}
	});
}
function open_conf(open_conf) {
	if (open_conf == "vnt_info") {
		get_vnt_info();
		console.log("vnt_info")
	}
	if (open_conf == "vnt_all") {
		get_vnt_all();
		console.log("vnt_all")
	}
	if (open_conf == "vnt_list") {
		get_vnt_list();
		console.log("vnt_list")
	}
	if (open_conf == "vnt_route") {
		get_vnt_route();
		console.log("vnt_route")
	}
	if (open_conf == "vnt_cmd") {
		get_vnt_cmd();
		console.log("vnt_cmd")
	}
	if (open_conf == "vnts_cmd") {
		get_vnts_cmd();
		console.log("vnts_cmd")
	}
	if (open_conf == "vnt_log") {
		get_vnt_log();
	}
	if (open_conf == "vnts_log") {
		get_vnts_log();
	}
	$("#" + open_conf).fadeIn(200);
}
function close_conf(close_conf) {
	$("#" + close_conf).fadeOut(200);
}
function toggle_func() {
	E("simple_table").style.display = "";
	E("conf_table").style.display = "none";
	E("customize_conf_table").style.display = "none";
	$('.show-btn1').addClass('active');
	$(".show-btn1").click(
		function() {
			$('.show-btn1').addClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').removeClass('active');
			E("simple_table").style.display = "";
			E("conf_table").style.display = "none";
			E("customize_conf_table").style.display = "none";
			$('.apply_gen').show();
			
		}
	);
	$(".show-btn2").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn2').addClass('active');
			$('.show-btn3').removeClass('active');
			E("simple_table").style.display = "none";
			E("conf_table").style.display = "none";
			E("customize_conf_table").style.display = "";
			$('.apply_gen').show();
			
		}
	);
	$(".show-btn3").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').addClass('active');
			E("simple_table").style.display = "none";
			E("conf_table").style.display = "";
			E("customize_conf_table").style.display = "none";
			$('.apply_gen').hide();
		}
	);
	
	$("#vnt_ipmode").change(
		function(){
		if(E("vnt_ipmode").value == "static"){
			E("static_ip").style.display = "";
		}else{
		    E("static_ip").style.display = "none";
		}
	});
	
	$("#vnt_passmode").change(
		function(){
		if(E("vnt_passmode").value == "off"){
			E("vnt_key").style.display = "none";
		}else{
		    E("vnt_key").style.display = "";
		}
	});
}

//网页重载时更新显示样式
function update_visibility(){
	if( db_vnt["vnt_ipmode"] == "static"){
	    E("static_ip").style.display = "";
	}else{
        E("static_ip").style.display = "none";
    }
	if(db_vnt["vnt_passmode"] == "off"){
	    E("vnt_key").style.display = "none";
	}else{
		E("vnt_key").style.display = "";
	}
}
document.addEventListener('DOMContentLoaded', function() {
    var vntEnableCheckbox = document.getElementById('vnt_enable');
    var vntActionBtn = document.getElementById('vnt_action_btn');
    var feedbackMessage = document.createElement('div'); // 创建一个新的 div 元素用于显示反馈消息
    feedbackMessage.style.display = 'none'; // 初始时隐藏反馈消息
    feedbackMessage.style.marginLeft = '10px'; // 设置反馈消息的左边距
    feedbackMessage.style.transition = 'opacity 0.5s ease'; // 添加渐变效果
	// 将反馈消息添加到按钮旁边的父元素中
    vntActionBtn.parentNode.appendChild(feedbackMessage);
    // 根据复选框的初始状态设置按钮文本
    updateButtonLabel(vntEnableCheckbox.checked);

    // 监听复选框状态变化
    vntEnableCheckbox.addEventListener('change', function() {
        updateButtonLabel(this.checked);
    });

    // 监听按钮点击事件
    vntActionBtn.addEventListener('click', function() {
        var buttonText = vntActionBtn.textContent.trim();
        if (buttonText === '重启') {
            restate(); // 执行重启函数
        } else if (buttonText === '更新') {
            update(); // 执行更新函数
        }
    });

    function updateButtonLabel(isChecked) {
        // 根据复选框的状态更新按钮文本
        vntActionBtn.textContent = isChecked ? '重启' : '更新';
    }

    function restate() {
        // 执行重启
        var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "vnt_config.sh", "params": ["restartvnt"], "fields": db_vnt };
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
	var postData = {"id": uid, "method": "vnt_config.sh", "params": ["updatevnt"], "fields": db_vnt };
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


document.addEventListener('DOMContentLoaded', function() {
    var vntsEnableCheckbox = document.getElementById('vnts_enable');
    var vntsActionBtn = document.getElementById('vnts_action_btn');
    var sfeedbackMessage = document.createElement('div'); 
    sfeedbackMessage.style.display = 'none'; 
    sfeedbackMessage.style.marginLeft = '10px'; 
    sfeedbackMessage.style.transition = 'opacity 0.5s ease'; 
    vntsActionBtn.parentNode.appendChild(sfeedbackMessage);

    // 根据复选框的初始状态设置按钮文本
    updateButtonLabel(vntsEnableCheckbox.checked);

    // 监听复选框状态变化
    vntsEnableCheckbox.addEventListener('change', function() {
        updateButtonLabel(this.checked);
    });
    // 监听按钮点击事件
    vntsActionBtn.addEventListener('click', function() {
        var buttonText = vntsActionBtn.textContent.trim();
        if (buttonText === '重启') {
            restates(); // 执行重启函数
        } else if (buttonText === '更新') {
            updates(); // 执行更新函数
        }
    });
    function updateButtonLabel(isChecked) {
        // 根据复选框的状态更新按钮文本
        vntsActionBtn.textContent = isChecked ? '重启' : '更新';
    }
    function restates() {
    // 执行重启
        var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "vnt_config.sh", "params": ["restartvnts"], "fields": db_vnt };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
				showFeedbacks('重启执行成功');
			}
		}
	});
    }

    function updates() {
    // 执行更新
        var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "vnt_config.sh", "params": ["updatevnts"], "fields": db_vnt };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
				showFeedbacks('更新执行成功');
			}
		}
	});
    }
   function showFeedbacks(message) {
        sfeedbackMessage.textContent = message; 
        sfeedbackMessage.style.display = 'block'; 
        setTimeout(function() {
            sfeedbackMessage.style.opacity = '0'; 
            setTimeout(function() {
                sfeedbackMessage.style.display = 'none';
                sfeedbackMessage.style.opacity = '1'; 
            }, 500); 
        }, 3000); 
    }
});
function openssHint(itemNum) {
	statusmenu = "";
	width = "350px";
	if (itemNum == 0) {
		statusmenu = "开启vnt-cli客户端选项,更新按钮为在线更新客户端程序版本，重启会同时重启客户端服务端";
		_caption = "客户端服务说明";
	} else if (itemNum == 1) {
		statusmenu = "需要连接的vnts服务器的IP:端口。留空，默认使用内置的公共服务器 。";
		_caption = "vnts服务器地址";
	} else if (itemNum == 2) {
		statusmenu = "自定义打洞stun服务器，使用stun服务探测客户端NAT类型，不同类型有不同的打洞策略，已内置谷歌 QQ 可不填<br>多个stun服务器地址，请使用英文|进行分隔";
		_caption = "stun服务器地址";
	} else if (itemNum == 3) {
		statusmenu = " 这是必填项！一个虚拟局域网的标识，连接同一服务器时，相同VPN名称的设备才会组成一个局域网（这是 -k 参数）<br><font color='#F46'>注意：</font>某些特殊字符的密码，可能会无法验证。";
		_caption = " 客户端 token ";
	} else if (itemNum == 4) {
		statusmenu = "显示程序的进程状态及 pid";
		_caption = "运行状态";
	} else if (itemNum == 6) {
		statusmenu = "当前设备网卡生成的虚拟的IP地址，由服务器自动分配还是手动指定";
		_caption = "接口模式";
	} else if (itemNum == 7) {
		statusmenu = "手动指定虚拟IP地址，请输入有效的IP地址，若服务端指定了虚拟网段，则这里的IP地址也要和服务器相同网段";
		_caption = " 指定虚拟IP地址";
	} else if (itemNum == 8) {
		statusmenu = "设定当前设备的硬件ID标识，若设定必须每台客户端的设备ID不能相同！";
		_caption = " 设备ID";
	} else if (itemNum == 9) {
		statusmenu = "指定当前设备的名称，方便在虚拟局域网里区分哪个客户端是哪个设备";
		_caption = "设备名称";
	} else if (itemNum == 10) {
		statusmenu = "指定对端可以访问当前局域网里设备的网段<br>例如：当前设备的lan网段为192.168.2.1 则填写192.168.2.0/24 <br> 多个网段请使用英文的|分隔 192.168.2.0/24|192.168.3.0/24 <br>开放所有网段 请填 0.0.0.0/0";
		_caption = "本地网段";
	} else if (itemNum == 11) {
		statusmenu = "指定访问对端局域网设备，如对端lan IP是192.168.4.1 虚拟IP是 10.26.0.4 <br>则填192.168.4.0/24,10.26.0.4 多个网段也使用英文|分隔 <br>例如 192.168.4.0/24,10.26.0.4|192.168.5.0/24,10.26.0.5";
		_caption = "对端网段";
	} else if (itemNum == 12) {
		statusmenu = "默认使用tun网卡，tun网卡效率更高";
		_caption = "TUN TAP网卡类型";
	} else if (itemNum == 13) {
		statusmenu = "有些网络提供商对UDP限制比较大，这个时候可以选择使用TCP模式，提高稳定性。一般来说udp延迟和消耗更低";
		_caption = "TCP UDP模式";
	} else if (itemNum == 14) {
		statusmenu = "选择只使用IPV4进行连接，还是只使用IPV6进行连接，默认都使用";
		_caption = "地址类型选择";
	} else if (itemNum == 15) {
		statusmenu = "指定客户端的端口，默认随机";
		_caption = "客户端打洞端口";
	} else if (itemNum == 16) {
		statusmenu = "设置虚拟网卡的mtu值，大多数情况下（留空）使用默认值效率会更高，也可根据实际情况进行微调，默认值：不加密1450，加密1410 ";
		_caption = "MTU值";
	} else if (itemNum == 17) {
		statusmenu = "定时执行操作。<font color='#F46'>检查：</font>检查vnt的进程是否存在，若不存在则重新启动；<font color='#F46'>启动：</font>重新启动vnt进程，而不论当时是否在正常运行。重新启动服务会导致活动中的连接短暂中断.<br><font color='#F46'>注意：</font>填写内容为 0 关闭定时功能！<br/>建议：选择分钟填写“60的因数”【1、2、3、4、5、6、10、12、15、20、30、60】，选择小时填写“24的因数”【1、2、3、4、6、8、12、24】。";
		_caption = "定时功能";
	} else if (itemNum == 18) {
		statusmenu = "默认留空，任务并行度(必须为正整数),默认值为1,该值表示处理网卡读写的任务数,组网设备数较多、处理延迟较大时可适当调大此值";
		_caption = " 并行任务数";
	} else if (itemNum == 19) {
		statusmenu = "设定客户端之间的加密连接使用的加密模式<br>默认off不加密，通常情况aes_gcm安全性高、aes_ecb性能更好，在低性能设备上aes_ecb速度最快";
		_caption = " 加密模式";
	} else if (itemNum == 20) {
		statusmenu = "选择加密模式后，填写的加密密钥，启用后所有客户端必须填写一样的密钥才能连接";
		_caption = "加密密钥";
	} else if (itemNum == 21) {
		statusmenu = "设定当前程序的存放路径，确保填写完整的路径及客户端或服务端的文件名";
		_caption = " 程序路径";
	} else if (itemNum == 22) {
		statusmenu = "内置的代理较为简单，而且一般来说直接使用网卡NAT转发性能会更高,所以默认开启IP转发关闭内置的ip代理";
		_caption = " IP转发";
	} else if (itemNum == 23) {
		statusmenu = "<strong>vnt-cli客户端设置</strong>：可以单独使用客户端，无需启用服务端，客户端程序内置有公共服务器<br/><strong>vnts服务端设置</strong>：支持自建服务器，启用服务端后所有客户端填此设备的IP或者域名: 端口（须为公网IP，新版支持V4和V6公网）";
		_caption = "客户端服务端选择";
	} else if (itemNum == 24) {
		statusmenu = "用服务端通信的数据加密，采用rsa+aes256gcm加密客户端和服务端之间通信的数据可以避免token泄漏、中间人攻击，<br>这是服务器和客户端之间的加密";
		_caption = " 客户端与服务端之间的加密";
	} else if (itemNum == 25) {
		statusmenu = "开启数据指纹校验，可增加安全性，如果服务端开启指纹校验，则客户端也必须开启，开启会损耗一部分性能。<br>注意：默认情况下服务端不会对中转的数据做校验，如果要对中转的数据做校验，则需要客户端、服务端都开启此参数";
		_caption = " 数据指纹校验";
	} else if (itemNum == 26) {
		statusmenu = "在网络环境很差时，不使用p2p只使用服务器中继转发效果可能更好（可以配合tcp模式一起使用）";
		_caption = "禁用P2P直连";
	} else if (itemNum == 27) {
		statusmenu = "启用后优先使用低延迟通道，默认情况下优先使用p2p通道，某些情况下可能p2p比客户端中继延迟更高，可启用此参数进行优化传输";
		_caption = "优化传输";
	} else if (itemNum == 28) {
		statusmenu = "模拟组播，高频使用组播通信时，可以尝试开启此参数，默认情况下会把组播当作广播发给所有节点。<br>1.默认情况(组播当广播发送)：稳定性好，使用组播频率低时更省流量。<br>2.模拟组播：高频使用组播时防止广播泛洪，客户端和中继服务器会维护组播成员等信息，注意使用此选项时，虚拟网内所有成员都需要开启此选项";
		_caption = "模拟组播";
	} else if (itemNum == 29) {
		statusmenu = "开启vnts服务端选项，更新按钮为在线更新服务端程序版本，重启会同时重启客户端服务端";
		_caption = "服务端服务说明";
	} else if (itemNum == 30) {
		statusmenu = "查看程序的信息和运行日志";
		_caption = "运行日志";
	} else if (itemNum == 31) {
		statusmenu = "设定白名单token，若填写只有这指定的token名称才能连接，不填则所有客户端都可以连接<br>多个token请使用英文的|进行分隔";
		_caption = "服务器token";
	} else if (itemNum == 32) {
		statusmenu = "设定服务器的监听端口，客户端将使用此端口连接服务器";
		_caption = "服务器端口";
	} else if (itemNum == 33) {
		statusmenu = "设定服务器分配的虚拟IP网段，默认10.26.0.0  ，若设定则客户端必须填写此网段才能连接";
		_caption = "服务器DHCP网关";
	} else if (itemNum == 34) {
		statusmenu = "设定服务器的子网掩码";
		_caption = "服务器网络掩码";
	} else if (itemNum == 35) {
		statusmenu = "这里可以上传以<font color='#F46'>.tar.gz</font>结尾的程序压缩包会自动解压<br>也可以上传<font color='#F46'>vnt-cli</font> 或 <font color='#F46'>vnts</font> 二进制程序文件<br>已有的程序将会被替换<br>客户端程序文件名请包含<font color='#F46'>vnt-cli</font>  服务端文件名请包含<font color='#F46'>vnts</font>";
		_caption = "上传程序选择文件";
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
function upload_bin() {
    var filename = $("#file").val();
    if (!filename) {
        alert("没有选择文件！");
        return false;
    }
    filename = filename.split('\\');
    filename = filename[filename.length - 1];
    document.getElementById('file_info').style.display = "none";
    var formData = new FormData();
    formData.append(filename, $('#file')[0].files[0]);

    $.ajax({
        url: '/_upload',
        type: 'POST',
        cache: false,
        data: formData,
        processData: false,
        contentType: false,
        success: function(response) {
            // 上传成功后的处理
            var vntbin = {
                "vnt_name": filename,
            };
            
            install_now(vntbin);
        },
        error: function(xhr, status, error) {
            // 上传失败后的处理
            alert("上传失败: " + error);
        }
    });
}

function install_now(vntbin) {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "vnt_tar_install.sh", "params": [], "fields": vntbin};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(response.result == id){
			    document.getElementById('file_info').style.display = "block";
				get_installog(1);
			}
		}
	});
}
var _responseLen;
function get_installog(s) {
	var retArea = E("soft_log_area");
	$.ajax({
		url: '/_temp/installvnt_log.txt',
		type: 'GET',
		dataType: 'text',
		cache: false,
		success: function(response) {
			if (response.search("LBL8603") != -1) {
				retArea.value = response.myReplace("LBL8603", " ");
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
				setTimeout("get_installog(1);", 1000);
			}
			retArea.value = response;
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		},
		error: function(xhr, status, error) {
			if (s) {
				E("soft_log_area").value = "没有找到上传记录";
			}
		}
	});
}
</script>
</head>
<body onload="initial();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=vnt" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_vnt.asp"/>
<input type="hidden" name="next_page" value="Module_vnt.asp"/>
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
                                    <div style="float:left;" class="formfonttitle">VNT  异地组网、内网穿透工具</div>
                                    <div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                                    <div style="margin:30px 0 10px 5px;" class="splitLine"></div>
                                    <div class="formfontdesc">VNT 是一个简便高效的异地组网、内网穿透工具。【仓库链接：<a href="https://github.com/lbl8603/vnt" target="_blank"><em><u>Github</u></em></a>】【使用文档：<a href="https://github.com/lbl8603/vnt/blob/main/vnt-cli/README.md" target="_blank"><em><u>客户端</u></em></a>&nbsp;&nbsp;<a href="https://github.com/lbl8603/vnts?tab=readme-ov-file#vnts" target="_blank"><em><u>服务端</u></em></a>】【QQ群：<a href="http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=o3Rr9xUWwAAnV9TkU_Nyj3yHNLs9k5F5&authKey=l1FKvqk7%2F256SK%2FHrw0PUhs%2Bar%2BtKYx0pLb7aiwBN9%2BKBCY8sOzWWEqtl4pdXAT7&noverify=0&group_code=1034868233" target="_blank"><em><u>vnt组网交流群</u></em></a>】<br/><i>  点击下方参数设置的文字，可查看帮助信息  </i></div>
                                    <div id="tablet_show">
                                        <table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
                                            <tr width="235px">
                                             <td colspan="4" cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#000">
                                               <input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="客户端"/>
                                               <input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="服务端"/>
											   <input id="show_btn3" class="show-btn3" style="cursor:pointer" type="button" value="上传程序"/>
                                             </td>
                                             </tr>
                                        </table>
                                    </div>

                                    <div id="simple_table">
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="box-shadow: 3px 3px 10px #000;margin-top: 0px;">
                                        <thead>
                                            <tr>
                                            <td colspan="2"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(23)">vnt-cli 客户端设置</a></td>
                                            </tr>
                                        </thead>
										 <tr id="vnt-cli">
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(0)">开启客户端</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="vnt_enable">
                                                        <input id="vnt_enable" class="switch" type="checkbox" style="display: none;">
                                                        <div class="switch_container" >
                                                            <div class="switch_bar"></div>
                                                            <div class="switch_circle transition_style">
                                                                <div></div>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
												<div>
            <button id="vnt_action_btn" class="vnt_custom_btn"></button>
        </div>
                                            </td>
                                        </tr>
                                        <tr id="vnt_status">
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(4)">运行状态</th>
                                            <td><span id="status1">获取中...</span>
                                            </td>
                                        </tr>
                                       
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(17)">定时功能(<i>0为关闭</i>)</a></th>
                                            <td>
                                                每 <input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '')" id="vnt_cron_time" name="vnt_cron_time" class="input_3_table" maxlength="2" value="0" placeholder="" />
                                                <select id="vnt_cron_hour_min" name="vnt_cron_hour_min" style="width:60px;margin:3px 2px 0px 2px;" class="input_option">
                                                    <option value="min">分钟</option>
                                                    <option value="hour">小时</option>
                                                </select> 
                                                    <select id="vnt_cron_type" name="vnt_cron_type" style="width:60px;margin:3px 2px 0px 2px;" class="input_option">
                                                        <option value="watch">检查</option>
                                                        <option value="start">重启</option>
                                                    </select> 一次服务
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(30)">设备信息和日志</th>
                                            <td>
                                                <a type="button" class="info_btn" style="cursor:pointer" href="javascript:void(0);" onclick="open_conf('vnt_info');" >当前设备信息</a>&nbsp;
												<a type="button" class="info_btn" style="cursor:pointer" href="javascript:void(0);" onclick="open_conf('vnt_all');" >所有设备信息</a>&nbsp;
												<a type="button" class="info_btn" style="cursor:pointer" href="javascript:void(0);" onclick="open_conf('vnt_list');" >所有设备列表</a><br><br>
												<a type="button" class="info_btn" style="cursor:pointer" href="javascript:void(0);" onclick="open_conf('vnt_route');" >路由转发信息</a>&nbsp;
												<a type="button" class="info_btn" style="cursor:pointer" href="javascript:void(0);" onclick="open_conf('vnt_cmd');" >状态参数信息</a>&nbsp;
                                                <a type="button" class="info_btn" style="cursor:pointer" href="javascript:void(0);" onclick="open_conf('vnt_log');" >程序运行日志</a>
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(3)">token</a></th>
                                            <td>
                                                <input type="password" name="vnt_token" id="vnt_token" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="64" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);" placeholder="必填" />
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(6)">接口模式</a></th>
                                            <td>
                                                <select id="vnt_ipmode" name="vnt_ipmode" style="width:165px;margin:0px 0px 0px 2px;" value="dhcp" class="input_option" >
                                                    <option value="dhcp">动态分配</option>
                                                    <option value="static">静态指定</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="static_ip" style="display: none;">
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(7)">指定虚拟IP</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" value="" id="vnt_static_ip" name="vnt_static_ip" value="" placeholder="必填，请输入有效的IP地址！"/>
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(8)">设备ID</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" value="" id="vnt_desvice_id" name="vnt_desvice_id" value="" placeholder=""/>
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(9)">设备名称</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" value="" id="vnt_desvice_name" name="vnt_desvice_name" value="" placeholder=""/>
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(10)">本地网段(<i>多个以 | 隔开</i>)</a></th>
                                            <td>
                                                <textarea  type="text" class="input_ss_table" value="" id="vnt_localadd" name="vnt_localadd"  value="" placeholder=""></textarea>
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(11)">对端网段(<i>多个以 | 隔开</i>)</a></th>
                                            <td>
                                                <textarea  type="text" class="input_ss_table" value="" id="vnt_peeradd" name="vnt_peeradd"  value="" placeholder=""></textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(1)">服务器地址</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" value="" id="vnt_serveraddr" name="vnt_serveraddr" maxlength="100" value="" placeholder=""/>
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(2)">STUN服务地址(<i>多个以 | 隔开</i>)</a></th>
                                            <td>
                                                <textarea  type="text" class="input_ss_table" value="" id="vnt_stunaddr" name="vnt_stunaddr"  value="" placeholder=""></textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(12)">TUN/TAP</a></th>
                                            <td>
                                                <select id="vnt_tun_mode" name="vnt_tun_mode" style="width:165px;margin:0px 0px 0px 2px;" value="tun" class="input_option" >
                                                    <option value="tun">TUN网卡</option>
                                                    <option value="tap">TAP网卡</option>
                                                </select>
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(13)">UDP/TCP</a></th>
                                            <td>
                                                <select id="vnt_udp_mode" name="vnt_udp_mode" style="width:165px;margin:0px 0px 0px 2px;" value="udp" class="input_option" >
                                                    <option value="udp">UDP模式</option>
                                                    <option value="tcp">TCP模式</option>
                                                </select>
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(14)">IPV4/IPV6</a></th>
                                            <td>
                                                <select id="vnt_ipv4_mode" name="vnt_ipv4_mode" style="width:165px;margin:0px 0px 0px 2px;" value="auto" class="input_option" >
                                                    <option value="auto">V4-V6都使用</option>
													<option value="ipv4">只使用IPV4</option>
                                                    <option value="ipv6">只使用IPV6</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(15)">监听端口</a></th>
                                            <td>
                                        <input type="text" oninput="this.value=this.value.replace(/[^\d]/g, ''); if(value>65535)value=65535" class="input_ss_table" id="vnt_port" name="vnt_port" maxlength="6" value="" placeholder="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(16)">MTU</a></th>
                                            <td>
                                        <input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '')" class="input_ss_table" id="vnt_mtu" name="vnt_mtu" value="" placeholder="" />
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(18)">并行任务数</a></th>
                                            <td>
                                        <input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '')" class="input_ss_table" id="vnt_par" name="vnt_par" value="" placeholder="" />
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(19)">加密模式</a></th>
                                            <td>
                                                <select id="vnt_passmode" name="vnt_passmode" style="width:165px;margin:0px 0px 0px 2px;" value="off" class="input_option" >
                                                    <option value="off">不加密</option>
                                                    <option value="aes_ecb">aes_ecb</option>
													<option value="sm4_cbc">sm4_cbc</option>
													<option value="aes_cbc">aes_cbc</option>
													<option value="static">aes_gcm</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="vnt_key" style="display: none;">
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(20)">加密密钥</a></th>
                                            <td>
                                                <input type="password" name="vnt_key" id="vnt_key" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);" placeholder="" />
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(21)">自定义程序路径</a></th>
                                            <td>
                                                <input type="text"  class="input_ss_table" id="vnt_path" name="vnt_path" maxlength="500" value="" placeholder=" "/>
                                            </td>
                                        </tr>
										<tr>
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(22)">开启IP转发</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="vnt_proxy_enable">
                                                        <input id="vnt_proxy_enable" class="switch" type="checkbox" style="display: none;">
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
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(24)">开启客户端服务端加密</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="vnt_W_enable">
                                                        <input id="vnt_W_enable" class="switch" type="checkbox" style="display: none;">
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
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(25)">开启数据指纹校验</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="vnt_finger_enable">
                                                        <input id="vnt_finger_enable" class="switch" type="checkbox" style="display: none;">
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
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(26)">禁用P2P</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="vnt_relay_enable">
                                                        <input id="vnt_relay_enable" class="switch" type="checkbox" style="display: none;">
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
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(27)">开启优化传输</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="vnt_first_latency_enable">
                                                        <input id="vnt_first_latency_enable" class="switch" type="checkbox" style="display: none;">
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
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(28)">开启模拟组播</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="vnt_mn_enable">
                                                        <input id="vnt_mn_enable" class="switch" type="checkbox" style="display: none;">
                                                        <div class="switch_container" >
                                                            <div class="switch_bar"></div>
                                                            <div class="switch_circle transition_style">
                                                               
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                    </div>
                                    <div id="customize_conf_table">
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="box-shadow: 3px 3px 10px #000;margin-top: 0px;">
                                        <thead>
                                            <tr>
                                            <td colspan="2"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(23)">vnts 服务器设置</a></td>
                                            </tr>
                                        </thead>
                                           <tr id="vnts">
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(29)">开启服务器</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="vnts_enable">
                                                        <input id="vnts_enable" class="switch" type="checkbox" style="display: none;">
                                                        <div class="switch_container" >
                                                            <div class="switch_bar"></div>
                                                            <div class="switch_circle transition_style">
                                                                <div></div>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
                                                <div> <button id="vnts_action_btn" class="vnt_custom_btn"></button></div>
                                            </td>
                                        </tr>
                                        <tr id="vnts_status">
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(4)">运行状态</th>
                                            <td><span id="status2">获取中...</span>
                                            </td>
                                        </tr>
                                       
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(17)">定时功能(<i>0为关闭</i>)</a></th>
                                            <td>
                                                每 <input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '')" id="vnts_cron_time" name="vnts_cron_time" class="input_3_table" maxlength="2" value="0" placeholder="" />
                                                <select id="vnts_cron_hour_min" name="vnts_cron_hour_min" style="width:60px;margin:3px 2px 0px 2px;" class="input_option">
                                                    <option value="min">分钟</option>
                                                    <option value="hour">小时</option>
                                                </select> 
                                                    <select id="vnts_cron_type" name="vnts_cron_type" style="width:60px;margin:3px 2px 0px 2px;" class="input_option">
                                                        <option value="watch">检查</option>
                                                        <option value="start">重启</option>
                                                    </select> 一次服务
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(30)">程序运行日志</th>
                                            <td>
											    
												<a type="button" class="info_btn" style="cursor:pointer" href="javascript:void(0);" onclick="open_conf('vnts_cmd');" >状态信息</a>&nbsp;
                                                <a type="button" class="info_btn" style="cursor:pointer" href="javascript:void(0);" onclick="open_conf('vnts_log');" >查看日志</a>
                                            </td>
                                        </tr>
										
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(31)">token白名单(<i>多个以 | 隔开</i>)</a></th>
                                            <td>
                                               <textarea  type="text" class="input_ss_table" value="" id="vnts_token" name="vnts_token"  value="" placeholder="test|abcd"></textarea>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(32)">监听端口</a></th>
                                            <td>
                                        <input type="text" oninput="this.value=this.value.replace(/[^\d]/g, ''); if(value>65535)value=65535" class="input_ss_table" id="vnts_port" name="vnts_port" maxlength="6" value="" placeholder="" />
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(33)">指定DHCP网关</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" value="" id="vnts_gateway" name="vnts_gateway" maxlength="100" value="" placeholder="10.26.0.1"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(34)">指定子网掩码</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" value="" id="vnts_mask" name="vnts_mask" maxlength="100" value="" placeholder="225.225.225.0"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(21)">自定义程序路径</a></th>
                                            <td>
                                                <input type="text"  class="input_ss_table" id="vnts_path" name="vnts_path" maxlength="500" value="" placeholder=" "/>
                                            </td>
                                        </tr>
                                         <tr>
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(25)">开启数据指纹校验</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="vnts_finger_enable">
                                                        <input id="vnts_finger_enable" class="switch" type="checkbox" style="display: none;">
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
                                    </table>
                                    </div>
									<div id="conf_table">
    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable_table" style="box-shadow: 3px 3px 10px #000;margin-top: 0px;">
        <thead>
            <tr>
                <td colspan="2"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(35)">上传程序</a></td>
            </tr>
        </thead>
        <tr>
            <th><a sclang class="hintstyle" href="javascript:void(0);" onclick="openssHint(35)">选择文件</a></th>
            <td>
                <input sclang type="button" id="upload_btn" class="button_gen" onclick="upload_bin();" value="上传"/>
                <input style="color:#FFCC00;*color:#000;width: 200px;" id="file" type="file" name="file"/>
                <img id="loadingicon" style="margin-left:5px;margin-right:5px;display:none;" src="/images/InternetScan.gif">
                <span sclang id="file_info" style="display:none;">上传完成</span>
            </td>
        </tr>
    </table>
    <div id="log_content" class="soft_setting_log">
											<textarea cols="63" rows="40" wrap="on" readonly="readonly" id="soft_log_area" class="soft_setting_log1" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
    </div>
</div>
<div class="apply_gen">
    <span><input class="button_gen" id="cmdBtn" onclick="save()" type="button" value="提交"/></span>
</div>
<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
<div class="formbottomdesc" id="cmdDesc">
    <i>* 注意事项：</i> 请先仔细查阅程序使用文档<br/><br/>
    1、客户端的<i>token</i>为必填项，没有服务器也可单独使用客户端，已内置公共服务器<br/>
    2、<i>点击</i>参数标题的<i>文字</i>，可<i>查看帮助</i>信息。<br/>
	3、若启动失败，请查看<i>系统记录</i>，有报错提示，或者通过SSH命令行启动测试。<br/>
	4、插件会自动下载二进制程序，也可以手动上传程序。<br/>
</div>
                                    <div id="vnts_log"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">VNTS 日志文件 / 标准输出&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('vnts_log');" value="关闭"><span class="close"></span></a></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="vnts_logtxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node1" class="button_gen" type="button" onclick="close_conf('vnts_log');" value="返回主界面">
                                            &nbsp;&nbsp;<input class="button_gen" type="button" onclick="close_conf('vnts_log');clear_vntslog();" value="清空日志">
                                        </div>
                                    </div>

									<div id="vnts_cmd"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">VNTS 状态参数 / 标准输出&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('vnts_cmd');" value="关闭"><span class="close"></span></a></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="vnts_cmdtxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node2" class="button_gen" type="button" onclick="close_conf('vnts_cmd');" value="返回主界面">
                                        </div>
                                    </div>

                                    <div id="vnt_log"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">VNT 日志文件 / 标准输出&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('vnt_log');" value="关闭"><span class="close"></span></a></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="vnt_logtxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node3" class="button_gen" type="button" onclick="close_conf('vnt_log');" value="返回主界面">
                                            &nbsp;&nbsp;<input class="button_gen" type="button" onclick="close_conf('vnt_log');clear_vntlog();" value="清空日志">
                                        </div>
										</div>

										<div id="vnt_info"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">VNT 本机设备信息 / 标准输出&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('vnt_info');" value="关闭"><span class="close"></span></a></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="vnt_infotxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node4" class="button_gen" type="button" onclick="close_conf('vnt_info');" value="返回主界面">
                                        </div></div>

										<div id="vnt_all"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">VNT 所有设备信息/ 标准输出&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('vnt_all');" value="关闭"><span class="close"></span></a></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="vnt_alltxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node5" class="button_gen" type="button" onclick="close_conf('vnt_all');" value="返回主界面">
                                        </div></div>

										<div id="vnt_list"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">VNT 所有设备列表 / 标准输出&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('vnt_list');" value="关闭"><span class="close"></span></a></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="vnt_listtxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node6" class="button_gen" type="button" onclick="close_conf('vnt_list');" value="返回主界面">
                                        </div></div>

										<div id="vnt_route"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">VNT 路由转发信息 / 标准输出&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('vnt_route');" value="关闭"><span class="close"></span></a></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="vnt_routetxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node7" class="button_gen" type="button" onclick="close_conf('vnt_route');" value="返回主界面">
                                        </div></div>

										<div id="vnt_cmd"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">VNT 状态参数 / 标准输出&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('vnt_cmd');" value="关闭"><span class="close"></span></a></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="vnt_cmdtxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node8" class="button_gen" type="button" onclick="close_conf('vnt_cmd');" value="返回主界面">
                                        </div></div>


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




