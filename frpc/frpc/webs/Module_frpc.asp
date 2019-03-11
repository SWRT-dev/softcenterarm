<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- version: 2.1.12 -->
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - Frp内网穿透</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
<link rel="stylesheet" type="text/css" href="/res/frpc.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/calendar/jquery-ui.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/dbconf?p=frpc&v=<% uptime(); %>"></script>
<script type="text/javascript" src="/res/frpc-menu.js"></script>

<script>
var noChange_status = 0;
var _responseLen;
var $j = jQuery.noConflict();
var $G = function(id) {
    return document.getElementById(id);
};
function E(e) {
    return (typeof(e) == 'string') ? document.getElementById(e) : e;
}
var Base64;
if(typeof btoa == "Function") {
   Base64 = {encode:function(e){ return btoa(e); }, decode:function(e){ return atob(e);}};
} else {
   Base64 ={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=Base64._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9\+\/\=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=Base64._utf8_decode(t);return t},_utf8_encode:function(e){e=e.replace(/\r\n/g,"\n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}}
}
function initial(){
    show_menu(menu_hook);
    get_status();
    toggle_func();
    conf2obj();
    refresh_table();
    version_show();
    buildswitch();
    toggle_switch();
    get_frpc_conf();
    get_stcp_conf();
}
function get_status() {
    $j.ajax({
        url: 'apply.cgi?current_page=Module_frpc.asp&next_page=Module_frpc.asp&group_id=&modified=0&action_mode=+Refresh+&action_script=frpc_status.sh&action_wait=&first_time=&preferred_lang=CN',
        dataType: 'html',
        error: function(xhr) {
            alert("error");
        },
        success: function(response) {
            //alert("success");
            setTimeout("check_FRPC_status();", 1000);
        }
    });
}
var noChange_status=0;
var _responseLen;
function check_FRPC_status(){
    $j.ajax({
        url: '/res/frpc_check.html',
        dataType: 'html',
        error: function(xhr){
            setTimeout("check_FRPC_status();", 1000);
        },
        success: function(response){
            var _cmdBtn = document.getElementById("cmdBtn");
            if(response.search("XU6J03M6") != -1){
                frpc_status = response.replace("XU6J03M6", " ");
                //alert(frpc_status);
                document.getElementById("status").innerHTML = frpc_status;
                return true;
            }
            if(_responseLen == response.length){
                noChange_status++;
            }else{
                noChange_status = 0;
            }
            if(noChange_status > 100){
                noChange_status = 0;
                //refreshpage();
            }else{
                setTimeout("check_FRPC_status();", 400);
            }
            _responseLen = response.length;
        }
    });
}
function get_frpc_conf(){
    $j.ajax({
        url: '/res/frpc_conf.html',
        dataType: 'html',
        error: function(xhr){
            setTimeout("get_frpc_conf();", 400);
        },
        success: function(response){
            document.getElementById("frpctxt").value = response;
            return true;
        }
    });
}
function get_stcp_conf(){
    $j.ajax({
        url: '/res/frpc_stcp_conf.html',
        dataType: 'html',
        error: function(xhr){
            setTimeout("get_stcp_conf();", 400);
        },
        success: function(response){
            document.getElementById("usertxt").value = response;
            return true;
        }
    });
}
function toggle_switch(){ //根据frpc_enable的值，打开或者关闭开关
    var rrt = document.getElementById("switch");
    if (document.form.frpc_enable.value != "1") {
        rrt.checked = false;
    } else {
        rrt.checked = true;
    }
}
function buildswitch(){ //生成开关的功能，checked为开启，此时传递frpc_enable=1
    $j("#switch").click(
    function(){
        if(document.getElementById('switch').checked){
            document.form.frpc_enable.value = 1;
        }else{
            document.form.frpc_enable.value = 0;
        }
    });
}
function conf2obj(){ //表单填写函数，将dbus数据填入到对应的表单中
    if(typeof db_frpc != "undefined") {
        for(var field in db_frpc) {
            var el = document.getElementById(field);
            if(el != null) {
                if (el.getAttribute("type") == "checkbox") {
                    if (db_frpc[field] == "1") {
                        el.checked = true;
                        $G("f_" + field).value = "1";
                    } else {
                        el.checked = false;
                        $G("f_" + field).value = "0";
                    }
                }
                if (field == "frpc_config") {
                    el.value = Base64.decode(db_frpc[field]);
                } else if (field == "frpc_customize_conf") {
                    el.value = db_frpc[field];
                    var menu_active = db_frpc[field];
                    if (menu_active == "1") {
                        $j(".show-btn2").click()
                    } else {
                        $j(".show-btn1").click()
                    }
                } else {
                    el.value = db_frpc[field];
                }
            }
        }
    }
}
function qj2bj(str){
    var tmp = "";
    for(var i=0;i<str.length;i++){
        if(str.charCodeAt(i) >= 65281 && str.charCodeAt(i) <= 65374){
            tmp += String.fromCharCode(str.charCodeAt(i)-65248)
        }else if(str.charCodeAt(i) == 12288){
            tmp += ' ';
        }else{
            tmp += str[i];
        }
    }
    return tmp;
}
function validForm(){
    var temp_frpc = ["frpc_config"];
    for(var i = 0; i < temp_frpc.length; i++) {
        var temp_str = qj2bj(E(temp_frpc[i]).value);
        E(temp_frpc[i]).value = Base64.encode(temp_str);
    }
    return true;
}
function onSubmitCtrl(o, s) { //提交操作，提交时运行config-frpc.sh，显示5秒的载入画面
    var _form = document.form;
    if ($G("frpc_customize_conf").checked){
        if(trim(_form.frpc_config.value)==""){
            alert("提交的表单不能为空!");
            return false;
        }
    } else {
        if(trim(_form.frpc_common_server_addr.value)=="" || trim(_form.frpc_common_server_port.value)=="" || trim(_form.frpc_common_privilege_token.value)=="" || trim(_form.frpc_common_vhost_http_port.value)=="" || trim(_form.frpc_common_vhost_https_port.value)=="" || trim(_form.frpc_common_user.value)=="" || trim(_form.frpc_common_cron_time.value)==""){
            alert("提交的表单不能为空!");
            return false;
        }
    }
    showLoading(5);
    document.form.action_mode.value = s;
    if (validForm()) {
        updateOptions();
    }
}
function updateOptions() {
    document.form.enctype = "";
    document.form.encoding = "";
    document.form.action = "/applydb.cgi?p=frpc_";
    document.form.action_script.value = "config-frpc.sh";
    document.form.submit();
}
function done_validating(action) { //提交操作5秒后刷洗网页
    refreshpage(5);
}
function reload_Soft_Center(){ //返回软件中心按钮
    location.href = "/Main_Soft_center.asp";
}
function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装", "Frpc 内网穿透");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_frpc.asp");
}
function addTr(o) { //添加配置行操作
    var _form_addTr = document.form;
    if(trim(_form_addTr.proto_node.value)=="tcp" || trim(_form_addTr.proto_node.value)=="udp"){
        if(trim(_form_addTr.subname_node.value)=="" || trim(_form_addTr.localhost_node.value)=="" || trim(_form_addTr.localport_node.value)=="" || trim(_form_addTr.remoteport_node.value)==""){
            alert("提交的表单不能为空!");
            return false;
        }
    } else if(trim(_form_addTr.proto_node.value)=="stcp") {
        if(trim(_form_addTr.subname_node.value)=="" || trim(_form_addTr.subdomain_node.value)=="" || trim(_form_addTr.localhost_node.value)=="" || trim(_form_addTr.localport_node.value)=="" || trim(_form_addTr.remoteport_node.value)==""){
            alert("提交的表单不能为空!");
            return false;
        }
    }
    else{
        if(trim(_form_addTr.subname_node.value)=="" || trim(_form_addTr.subdomain_node.value)=="" || trim(_form_addTr.localhost_node.value)=="" || trim(_form_addTr.localport_node.value)=="" || trim(_form_addTr.remoteport_node.value)==""){
            alert("提交的表单不能为空!");
            return false;
        }
    }
    var ns = {};
    var p = "frpc";
    node_max += 1;
    // 定义ns数组，用于回传给dbus
    var params = ["proto_node", "subname_node", "subdomain_node", "localhost_node",  "localport_node", "remoteport_node", "encryption_node", "gzip_node"];
    if(!myid){
        for (var i = 0; i < params.length; i++) {
            ns[p + "_" + params[i] + "_" + node_max] = $j('#' + params[i]).val();
        }
    }else{
        for (var i = 0; i < params.length; i++) {
            ns[p + "_" + params[i] + "_" + myid] = $j('#' + params[i]).val();
        }
    }
    //回传网页数据给dbus接口，此处回传不同于form表单回传
    $j.ajax({
        url: '/applydb.cgi?p=frpc',
        contentType: "application/x-www-form-urlencoded",
        dataType: 'text',
        data: $j.param(ns),
        error: function(xhr) {
            console.log("error in posting config of table");
        },
        success: function(response) {
            //回传成功后，重新生成表格
            refresh_table();
            // 添加成功一个后将输入框清空
            document.form.proto_node.value = "tcp";
            document.form.subname_node.value = "";
            document.form.subdomain_node.value = "none";
            document.form.localhost_node.value = "";
            document.form.localport_node.value = "";
            document.form.remoteport_node.value = "";
            document.form.encryption_node.value = "true";
            document.form.gzip_node.value = "true";
            document.getElementById('remoteport_node').disabled=false;
            document.getElementById('subdomain_node').disabled=true;
        }
    });
    myid=0;
}
function delTr(o) { //删除配置行功能
    if (confirm("你确定删除吗？")) {
        //定位每行配置对应的ID号
        var id = $j(o).attr("id");
        var ids = id.split("_");
        var p = "frpc";
        id = ids[ids.length - 1];
        // 定义ns数组，用于回传给dbus
        var ns = {};
        var params = ["proto_node", "subname_node", "subdomain_node", "localhost_node",  "localport_node", "remoteport_node", "encryption_node", "gzip_node"];
        for (var i = 0; i < params.length; i++) {
            //空的值，用于清除dbus中的对应值
            ns[p + "_" + params[i] + "_" + id] = "";
        }
        //回传删除数据操作给dbus接口
        $j.ajax({
            url: '/applydb.cgi?use_rm=1&p=frpc',
            contentType: "application/x-www-form-urlencoded",
            dataType: 'text',
            data: $j.param(ns),
            error: function(xhr) {
                console.log("error in posting config of table");
            },
            success: function(response) {
                //回传成功后，重新生成表格
                refresh_table();
            }
        });
    }
}
function refresh_table() {
    //获取dbus数据接口，该接口获取dbus list frpc的所有值
    $j.ajax({
        url: '/dbconf?p=frpc',
        dataType: 'html',
        error: function(xhr){
        },
        success: function(response){
            $j.globalEval(response);
            //先删除表格中的行，留下前两行，表头和数据填写行
            $j("#conf_table").find("tr:gt(2)").remove();
            //在表格中增加行，增加的行的内容来自refresh_html()函数生成
            $j('#conf_table tr:last').after(refresh_html());
        }
    });
}
function editlTr(o){ //编辑节点功能，显示编辑面板
    checkTime = 2001; //编辑节点时停止可能在进行的刷新
    var id = $j(o).attr("id");
    var ids = id.split("_");
    confs = getAllConfigs();
    id = ids[ids.length - 1];
    var c = confs[id];
    document.form.proto_node.value = c["proto_node"];
    document.form.subname_node.value = c["subname_node"];
    document.form.subdomain_node.value = c["subdomain_node"];
    document.form.localhost_node.value = c["localhost_node"];
    document.form.localport_node.value = c["localport_node"];
    remoteport=document.form.proto_node.value;
    if (remoteport == "http") {
        document.getElementById('remoteport_node').disabled=true;
        document.getElementById('subdomain_node').disabled=false;
        document.getElementById('encryption_node').disabled=false;
        document.getElementById('gzip_node').disabled=false;
        document.getElementById('remoteport_node').value=c["common_vhost_http_port"];
    } else if(remoteport == "https"){
        document.getElementById('remoteport_node').disabled=true;
        document.getElementById('subdomain_node').disabled=false;
        document.getElementById('encryption_node').disabled=false;
        document.getElementById('gzip_node').disabled=false;
        document.getElementById('remoteport_node').value=c["common_vhost_https_port"];
    } else if(remoteport == "stcp"){
        document.getElementById('remoteport_node').disabled=true;
        document.getElementById('subdomain_node').disabled=false;
        document.getElementById('encryption_node').disabled=true;
        document.getElementById('gzip_node').disabled=true;
        document.getElementById('remoteport_node').value="none";
    } else if(remoteport == "tcp"){
        document.getElementById('remoteport_node').disabled=false;
        document.getElementById('subdomain_node').disabled=true;
        document.getElementById('encryption_node').disabled=false;
        document.getElementById('gzip_node').disabled=false;
        document.getElementById('subdomain_node').value="none";
    } else if(remoteport == "udp"){
        document.getElementById('remoteport_node').disabled=false;
        document.getElementById('subdomain_node').disabled=true;
        document.getElementById('encryption_node').disabled=false;
        document.getElementById('gzip_node').disabled=false;
        document.getElementById('subdomain_node').value="none";
    }
    document.form.remoteport_node.value = c["remoteport_node"];
    document.form.encryption_node.value = c["encryption_node"];
    document.form.gzip_node.value = c["gzip_node"];
    myid=id; //返回ID号
}
var myid;
function getAllConfigs() { //用dbus数据生成数据组，方便用于refresh_html()生成表格
    var dic = {};
    node_max = 0; //定义配置行数，用于每行配置的后缀
    //获取参数，例如frpc_enable，获取到enable字段，frpc_log_level获取到log_level字段，用于下面重新组合生成ofield值
    for (var field in db_frpc) {
        names = field.split("_");
        dic[names[names.length - 1]] = 'ok';
    }
    confs = {};
    var p = "frpc";
    var params = ["proto_node", "subname_node", "subdomain_node", "localhost_node",  "localport_node", "remoteport_node", "encryption_node", "gzip_node"];
    for (var field in dic) {
        var obj = {};
        for (var i = 0; i < params.length; i++) {
            var ofield = p + "_" + params[i] + "_" + field;
            if (typeof db_frpc[ofield] == "undefined") {
                obj = null;
                break;
            }
            obj[params[i]] = db_frpc[ofield];
            //alert(i);
        }
        if (obj != null) {
            var node_i = parseInt(field);
            if (node_i > node_max) {
                node_max = node_i;
            }
            obj["node"] = field;
            confs[field] = obj;
        }
    }
    //总之，最后生成了confs数组
    return confs;
}
function refresh_html() { //用conf数据生成配置表格
    confs = getAllConfigs();
    var n = 0; for(var i in confs){n++;} //获取节点的数目
    var html = '';
    for (var field in confs) {
        var c = confs[field];
        html = html + '<tr>';
        html = html + '<td>' + c["proto_node"] + '</td>';
        if(c["proto_node"]=="stcp"){
            html = html + '<td><a href="javascript:void(0)" onclick="open_conf(\'stcp_settings\');" style="cursor:pointer;"><i><u>' + c["subname_node"] + '</u></i></a></td>';
        }else{
            html = html + '<td>' + c["subname_node"] + '</td>';
        }
        if((c["proto_node"]=="tcp" || c["proto_node"]=="udp") && c["subdomain_node"]=="none"){
            html = html + '<td>' + "-" + '</td>';
        }else{
            html = html + '<td>' + c["subdomain_node"] + '</td>';
        }
        html = html + '<td>' + c["localhost_node"] + '</td>';
        html = html + '<td>' + c["localport_node"] + '</td>';
        if(c["proto_node"]=="stcp" && c["remoteport_node"]=="none"){
            html = html + '<td>' + "-" + '</td>';
        }else{
            html = html + '<td>' + c["remoteport_node"] + '</td>';
        }
        if(c["proto_node"]=="stcp"){
            html = html + '<td>' + "-" + '</td>';
            html = html + '<td>' + "-" + '</td>';
        }else{
            html = html + '<td>' + c["encryption_node"] + '</td>';
            html = html + '<td>' + c["gzip_node"] + '</td>';
        }
        html = html + '<td>';
        html = html + '<input style="margin-left:-3px;" id="dd_node_' + c["node"] + '" class="edit_btn" type="button" onclick="editlTr(this);" value="">'
        html = html + '</td>';
        html = html + '<td>';
        html = html + '<input style="margin-top: 4px;margin-left:-3px;" id="td_node_' + c["node"] + '" class="remove_btn" type="button" onclick="delTr(this);" value="">'
        html = html + '</td>';
        html = html + '</tr>';
    }
    return html;
}
function version_show(){
    $j.ajax({
        url: 'http://sc.paldier.com/frpc/config.json.js',
        type: 'GET',
        dataType: 'jsonp',
        success: function(res) {
            if(typeof(res["version"]) != "undefined" && res["version"].length > 0) {
                if(res["version"] == db_frpc["frpc_version"]){
                    $j("#frpc_version_show").html("插件版本：" + res["version"]);
                   }else if(res["version"] > db_frpc["frpc_version"]) {
                    $j("#frpc_version_show").html("<font color=\"#66FF66\">有新版本：" + res.version + "</font>");
                }
            }
        }
    });
}
function oncheckclick(obj) {
    if (obj.checked) {
        document.form["f_" + obj.id].value = "1";
    } else {
        document.form["f_" + obj.id].value = "0";
    }
}
function open_conf(open_conf){
    $j("#" + open_conf).fadeIn(200);
}
function close_conf(close_conf){
    $j("#" + close_conf).fadeOut(200);
}
$j.fn.smartFloat = function(conf) {
    var position = function(element) {
        var top = element.position().top, pos = element.css("position");
        $j(window).scroll(function() {
            var scrolls = $j(this).scrollTop();
            if (scrolls > top) {
                if (window.XMLHttpRequest) {
                    element.css({
                        position: conf,
                        top: 0
                    });
                } else {
                    element.css({
                        top: scrolls
                    });
                }
            }else {
                element.css({
                    position: pos,
                    top: top
                });
            }
        });
    };
    return $j(this).each(function() {
        position($j(this));
    });
}
function toggle_func() {
    E("simple_table").style.display = "";
    E("conf_table").style.display = "";
    E("customize_conf_table").style.display = "none";
    $j('.show-btn1').addClass('active');
    $j(".show-btn1").click(
        function() {
            $j('.show-btn1').addClass('active');
            $j('.show-btn2').removeClass('active');
            E("simple_table").style.display = "";
            E("conf_table").style.display = "";
            E("customize_conf_table").style.display = "none";
        }
    );
    $j(".show-btn2").click(
        function() {
            $j('.show-btn1').removeClass('active');
            $j('.show-btn2').addClass('active');
            E("simple_table").style.display = "none";
            E("conf_table").style.display = "none";
            E("customize_conf_table").style.display = "";
        }
    );
}
</script>
</head>
<body onload="initial();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=frpc" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_frpc.asp"/>
<input type="hidden" name="next_page" value="Module_frpc.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
<input type="hidden" id="frpc_enable" name="frpc_enable" value='<% dbus_get_def("frpc_enable", "0"); %>'/>

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
                                    <div style="float:left;" class="formfonttitle">软件中心 - Frpc内网穿透</div>
                                    <div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                                    <div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"/></div>
                                    <div class="formfontdesc"><i>* 为了Frpc稳定运行，请开启虚拟内存功能！！！</i>&nbsp;&nbsp;&nbsp;&nbsp;【<a href="http://koolshare.cn/thread-65379-1-1.html"  target="_blank"><i>服务器搭建教程</i></a>】</div>
                                    <div id="frpc_switch_show">
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                        <tr id="switch_tr">
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(0)">开启Frpc</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="switch">
                                                        <input id="switch" class="switch" type="checkbox" style="display: none;">
                                                        <div class="switch_container" >
                                                            <div class="switch_bar"></div>
                                                            <div class="switch_circle transition_style">
                                                                <div></div>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
                                                <div id="frpc_version_show" style="padding-top:5px;margin-left:30px;margin-top:0px;float: left;">
                                                    插件版本：<% dbus_get_def( "frpc_version", "未知"); %>
                                                </div>
                                                <div id="frpc_changelog_show" style="padding-top:5px;margin-right:10px;margin-top:0px;float: right;">
                                                    <a type="button" class="frpc_btn" style="cursor:pointer" href="https://raw.githubusercontent.com/koolshare/merlin_frpc/master/Changelog.txt" target="_blank">更新日志</a> <a type="button" class="frpc_btn" style="cursor:pointer" target="_blank" href="https://github.com/fatedier/frp/blob/master/README_zh.md">自定义配置帮助</a>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="frpc_status">
                                            <th width="20%">运行状态</th>
                                            <td><span id="status">获取中...</span>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(18)">DDNS显示设置</a></th>
                                            <td>
                                                <select id="frpc_common_ddns" name="frpc_common_ddns" style="margin:0px 0px 0px 2px;" class="input_option">
                                                    <option value="2" selected="selected">不做更改</option>
                                                    <option value="1">开启</option>
                                                    <option value="0">关闭</option>
                                                </select>
                                                <input type="text" class="input_ss_table" id="frpc_domain" name="frpc_domain" maxlength="255" value="" placeholder="填入要显示的域名，如:router.xxx.com" style="width:330px;margin-top: 3px;" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(17)">定时注册服务</a>(<i>0为关闭</i>)</th>
                                            <td>
                                                每 <input type="text" id="frpc_common_cron_time" name="frpc_common_cron_time" class="input_3_table" maxlength="2" value="30" placeholder="" />
                                                <select id="frpc_common_cron_hour_min" name="frpc_common_cron_hour_min" style="width:60px;margin:3px 2px 0px 2px;" class="input_option">
                                                    <option value="min" selected="selected">分钟</option>
                                                    <option value="hour">小时</option>
                                                </select> 重新注册一次服务
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%">查看当前配置</th>
                                            <td>
                                                <a type="button" class="frpc_btn" style="cursor:pointer" href="javascript:void(0);" onclick="open_conf('frpc_settings');" >查看当前配置</a>
                                            </td>
                                        </tr>
                                    </table>
                                    </div>

                                    <div id="tablet_show">
                                        <table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
                                            <tr width="235px">
                                             <td colspan="4" cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#000">
                                               <input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="简单设置"/>
                                               <input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="自定义设置"/>
                                             </td>
                                             </tr>
                                        </table>
                                    </div>

                                    <div id="simple_table">
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="box-shadow: 3px 3px 10px #000;margin-top: 0px;">
                                        <thead>
                                            <tr>
                                            <td colspan="2">Frpc 简单设置</td>
                                            </tr>
                                        </thead>
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(1)">服务器</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" value="" id="frpc_common_server_addr" name="frpc_common_server_addr" maxlength="20" value="" placeholder=""/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(2)">端口</a></th>
                                            <td>
                                        <input type="text" class="input_ss_table" id="frpc_common_server_port" name="frpc_common_server_port" maxlength="10" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(20)">底层通信协议</a></th>
                                            <td>
                                                <select id="frpc_common_protocol" name="frpc_common_protocol" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="tcp">tcp</option>
                                                    <option value="kcp">kcp</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(21)">TCP 多路复用</a></th>
                                            <td>
                                                <select id="frpc_common_tcp_mux" name="frpc_common_tcp_mux" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="true">开启</option>
                                                    <option value="false">关闭</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(22)">连接设置</a></th>
                                            <td>
                                                <select id="frpc_common_login_fail_exit" name="frpc_common_login_fail_exit" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="false">失败后重复连接</option>
                                                    <option value="true">失败后退出程序</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(3)">Token</a></th>
                                            <td>
                                                <input type="password" name="frpc_common_privilege_token" id="frpc_common_privilege_token" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="256" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);"/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(4)">HTTP穿透服务端口</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" id="frpc_common_vhost_http_port" name="frpc_common_vhost_http_port" maxlength="6" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(5)">HTTPS穿透服务端口</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" id="frpc_common_vhost_https_port" name="frpc_common_vhost_https_port" maxlength="6" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(19)">Frpc用户名称</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" id="frpc_common_user" name="frpc_common_user" maxlength="50" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(6)">日志记录</a></th>
                                            <td>
                                                <select id="frpc_common_log_file" name="frpc_common_log_file" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="/dev/null">关闭</option>
                                                    <option value="/tmp/frpc.log">开启</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(7)">日志等级</a></th>
                                            <td>
                                                <select id="frpc_common_log_level" name="frpc_common_log_level" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="info">info</option>
                                                    <option value="warn">warn</option>
                                                    <option value="error">error</option>
                                                    <option value="debug">debug</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(8)">日志记录天数</a></th>
                                            <td>
                                                <select id="frpc_common_log_max_days" name="frpc_common_log_max_days" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3" selected="selected">3</option>
                                                    <option value="4">4</option>
                                                    <option value="5">6</option>
                                                    <option value="6">6</option>
                                                    <option value="7">7</option>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>
                                    <table id="conf_table" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" style="box-shadow: 3px 3px 10px #000;margin-top: 10px;">
                                          <thead>
                                              <tr>
                                                <td colspan="10">穿透服务配置</td>
                                              </tr>
                                          </thead>

                                          <tr>
                                            <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(9)">协议类型</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(10)">代理名称</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(11)">域名配置/SK</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(12)">内网主机地址</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(13)">内网主机端口</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(14)">远程主机端口</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(15)">加密</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(16)">压缩</a></th>
                                          <th>修改</th>
                                          <th>添加/删除</th>
                                          </tr>
                                          <tr>
                                        <td>
                                            <select id="proto_node" name="proto_node" style="width:70px;margin:0px 0px 0px 2px;" class="input_option" onchange="proto_onchange()" >
                                                <option value="tcp">tcp</option>
                                                <option value="udp">udp</option>
                                                <option value="stcp">stcp</option>
                                                <option value="http">http</option>
                                                <option value="https">https</option>
                                                <option value="http">router-http</option>
                                                <option value="https">router-https</option>
                                                <option value="tcp">router-ssh</option>
                                                <option value="stcp">router-ssh-stcp</option>
                                            </select>

                                        </td>
                                         <td>
                                            <input type="text" id="subname_node" name="subname_node" class="input_6_table" maxlength="50" style="width:60px;" placeholder=""/>
                                        </td>
                                         <td>
                                            <input type="text" id="subdomain_node" name="subdomain_node" class="input_12_table" maxlength="250" value="none" placeholder="" disabled/>
                                        </td>
                                        <td>
                                            <input type="text" id="localhost_node" name="localhost_node" class="input_12_table" maxlength="20" placeholder=""/>
                                        </td>
                                        <td>
                                            <input type="text" id="localport_node" name="localport_node" class="input_6_table" maxlength="6" placeholder=""/>
                                        </td>
                                        <td>
                                            <input type="text" id="remoteport_node" name="remoteport_node" class="input_6_table" maxlength="6" placeholder=""/>
                                        </td>
                                        <td>
                                            <select id="encryption_node" name="encryption_node" style="width:50px;margin:0px 0px 0px 2px;" class="input_option" >
                                                <option value="true">是</option>
                                                <option value="false">否</option>
                                            </select>
                                        </td>
                                        <td>
                                            <select id="gzip_node" name="gzip_node" style="width:50px;margin:0px 0px 0px 2px;" class="input_option" >
                                                <option value="true">是</option>
                                                <option value="false">否</option>
                                            </select>
                                        </td>
                                        <td width="7%">
                                            <div>
                                            </div>
                                        </td>
                                        <td width="10%">
                                            <div>
                                                <input type="button" class="add_btn" onclick="addTr()" value=""/>
                                            </div>
                                        </td>
                                          </tr>
                                      </table>
                                    </div>

                                    <div id="customize_conf_table">
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" style="box-shadow: 3px 3px 10px #000;margin-top: 0px;">
                                        <thead>
                                            <tr>
                                                <td colspan="10"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(23)">Frpc 高级配置</a></td>
                                            </tr>
                                            <tr>
                                                <th style="width:20%;">
                                                    <label><input type="checkbox" id="frpc_customize_conf" onclick="oncheckclick(this);"><i>自定义配置</i>
                                                    <input type="hidden" id="f_frpc_customize_conf" name="frpc_customize_conf" value="" /></label>
                                                </th>
                                                <td>
                                                    <textarea cols="50" rows="40" id="frpc_config" name="frpc_config" style="width:99%; font-family:'Lucida Console'; font-size:12px; background:#475A5F; color:#FFFFFF; text-transform:none; margin-top:5px; overflow:scroll;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" placeholder="[common]&#13;&#10;server_addr = 127.0.0.1&#13;&#10;server_port = 7000&#10;&#10;[ssh]&#10;type = tcp&#10;local_ip = 127.0.0.1&#10;local_port = 22&#10;remote_port = 6000" ></textarea>
                                                </td>
                                            </tr>
                                        </thead>
                                    </table>
                                    </div>
                                    <div style="margin-left:5px;margin-top:20px;margin-bottom:10px">
                                        <img src="/images/New_ui/export/line_export.png">
                                    </div>
                                    <div class="formbottomdesc" id="cmdDesc">
                                        <i>* 注意事项：</i><br>
                                        <i>1. 请使用虚拟内存！请使用虚拟内存！请使用虚拟内存！重要的事说三遍</i><br>
                                        <i>2. DDNS显示设置功能与系统自带的DDNS设置冲突，frp的DDNS显示设置会覆盖系统自带的DDNS设置！</i><br>
                                        <i>3. 上面所有内容都为必填项，请认真填写，不然无法穿透。</i><br>
                                        <i>4. 每一个文字都可以点击查看相应的帮助信息。</i><br>
                                        <i>5. 穿透设置中添加删除为本地实时生效，请谨慎操作，修改后请提交以便服务器端生效。</i><br>
                                    </div>
                                    <div class="apply_gen">
                                        <span><input class="button_gen_long" id="cmdBtn" onclick="onSubmitCtrl(this, ' Refresh ')" type="button" value="提交"/></span>
                                    </div>
                                </td>
                            </tr>
                        </table>
                                    <!-- this is the popup area for user rules -->
                                    <div id="frpc_settings"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">Frpc 配置文件&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('frpc_settings');" value="关闭"><span class="close"></span></a></div>
                                        <div style="margin-left:15px"><i>1&nbsp;&nbsp;文本框内的内容保存在【/tmp/.frpc.ini】。</i></div>
                                        <div style="margin-left:15px"><i>2&nbsp;&nbsp;请自行保存到本地，并根据实际情况进行修改，如有疑问请到frp官网求助。</i></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="frpctxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" disabled="disabled"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node" class="button_gen" type="button" onclick="close_conf('frpc_settings');" value="返回主界面">
                                        </div>
                                    </div>
                                    <div id="stcp_settings"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">Frpc stcp 配置文件参考&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('stcp_settings');" value="关闭"><span class="close"></span></a></div>
                                        <div style="margin-left:15px"><i>1&nbsp;&nbsp;文本框内的内容保存在【/tmp/.frpc_stcp.ini】。</i></div>
                                        <div style="margin-left:15px"><i>2&nbsp;&nbsp;请自行保存到本地，并根据实际情况进行修改，如有疑问请到frp官网求助。</i></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="usertxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" disabled="disabled"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node" class="button_gen" type="button" onclick="close_conf('stcp_settings');" value="返回主界面">
                                        </div>
                                    </div>
                                    <!-- end of the popouparea -->
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <!--===================================Ending of Main Content===========================================-->
        </td>
        <td width="10" align="center" valign="top"></td>
    </tr>
</table>
</form>

<div id="footer"></div>
</body>
<script type="text/javascript">
function proto_onchange()
{
var remoteport="";
var obj=document.getElementById('proto_node');
var index=obj.selectedIndex; //序号，取当前选中选项的序号
var r_https_port="<%  nvram_get(https_lanport); %>"
var r_ssh_port="<%  nvram_get(sshd_port); %>"
var r_computer_name="<%  nvram_get(computer_name); %>"
var r_lan_ipaddr="<% nvram_get(lan_ipaddr); %>"
var r_subname_node_http= r_computer_name + '-http';
var r_subname_node_https= r_computer_name + '-https';
var r_subname_node_ssh= r_computer_name + '-ssh';
//alert(r_https_port);
vhost_http_port=document.getElementById("frpc_common_vhost_http_port").value;
vhost_https_port=document.getElementById("frpc_common_vhost_https_port").value;
remoteport=obj.options[index].text;
if (remoteport == "http") {
        document.getElementById('remoteport_node').disabled=true;
        document.getElementById('subdomain_node').disabled=false;
        document.getElementById('encryption_node').disabled=false;
        document.getElementById('gzip_node').disabled=false;
        document.getElementById('subdomain_node').value="";
        document.getElementById('remoteport_node').value=vhost_http_port;
    } else if(remoteport == "https"){
        document.getElementById('remoteport_node').disabled=true;
        document.getElementById('subdomain_node').disabled=false;
        document.getElementById('encryption_node').disabled=false;
        document.getElementById('gzip_node').disabled=false;
        document.getElementById('subdomain_node').value="";
        document.getElementById('remoteport_node').value=vhost_https_port;
    } else if(remoteport == "tcp"){
        document.getElementById('remoteport_node').disabled=false;
        document.getElementById('subdomain_node').disabled=true;
        document.getElementById('encryption_node').disabled=false;
        document.getElementById('gzip_node').disabled=false;
        document.getElementById('subdomain_node').value="none";
    } else if(remoteport == "udp"){
        document.getElementById('remoteport_node').disabled=false;
        document.getElementById('subdomain_node').disabled=true;
        document.getElementById('encryption_node').disabled=false;
        document.getElementById('gzip_node').disabled=false;
        document.getElementById('subdomain_node').value="none";
    } else if(remoteport == "stcp"){
        document.getElementById('remoteport_node').disabled=true;
        document.getElementById('subdomain_node').disabled=false;
        document.getElementById('encryption_node').disabled=true;
        document.getElementById('gzip_node').disabled=true;
        document.getElementById('subdomain_node').value="";
        document.getElementById('remoteport_node').value="none";
    } else if(remoteport == "router-http"){
        document.getElementById('remoteport_node').disabled=true;
        document.getElementById('subdomain_node').disabled=false;
        document.getElementById('encryption_node').disabled=false;
        document.getElementById('gzip_node').disabled=false;
        document.getElementById('subdomain_node').value="";
        document.getElementById('remoteport_node').value=vhost_http_port;
        document.getElementById('subname_node').value=r_subname_node_http;
        document.getElementById('localhost_node').value="127.0.0.1";
        document.getElementById('localport_node').value="80";
    } else if(remoteport == "router-https"){
        document.getElementById('remoteport_node').disabled=true;
        document.getElementById('subdomain_node').disabled=false;
        document.getElementById('encryption_node').disabled=false;
        document.getElementById('gzip_node').disabled=false;
        document.getElementById('subdomain_node').value="";
        document.getElementById('remoteport_node').value=vhost_https_port;
        document.getElementById('subname_node').value=r_subname_node_https;
        document.getElementById('localhost_node').value="127.0.0.1";
        document.getElementById('localport_node').value=r_https_port;
    } else if(remoteport == "router-ssh"){
        document.getElementById('remoteport_node').disabled=false;
        document.getElementById('remoteport_node').value="";
        document.getElementById('subdomain_node').disabled=true;
        document.getElementById('subdomain_node').value="none";
        document.getElementById('encryption_node').disabled=false;
        document.getElementById('gzip_node').disabled=false;
        document.getElementById('subname_node').value=r_subname_node_ssh;
        document.getElementById('localhost_node').value=r_lan_ipaddr;
        document.getElementById('localport_node').value=r_ssh_port;
    } else if(remoteport == "router-ssh-stcp"){
        document.getElementById('remoteport_node').disabled=true;
        document.getElementById('subdomain_node').disabled=false;
        document.getElementById('encryption_node').disabled=false;
        document.getElementById('gzip_node').disabled=false;
        document.getElementById('subdomain_node').value="";
        document.getElementById('remoteport_node').value="none";
        document.getElementById('subname_node').value=r_subname_node_ssh;
        document.getElementById('localhost_node').value=r_lan_ipaddr;
        document.getElementById('localport_node').value=r_ssh_port;
    }
}
$j("#frpc_settings").smartFloat("frpc_settings");
$j("#stcp_settings").smartFloat("stcp_settings");
</script>
</html>
