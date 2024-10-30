<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - FileBrowser</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/> 
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<script language="JavaScript" type="text/javascript" src="/js/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/js/httpApi.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<style type="text/css">
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
input[type=button]:focus {
	outline: none;
}
</style>
    <script type="text/javascript">
        var db_filebrowser = {}
		function E(e) {
			return (typeof(e) == 'string') ? document.getElementById(e) : e;
		}
		var params_input = ["filebrowser_delay_time", "filebrowser_port", "filebrowser_cert", "filebrowser_key"];
		var params_check = ["filebrowser_watchdog", "filebrowser_publicswitch", "filebrowser_sslswitch"];
		
		function check_status(){
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "filebrowser_status.sh", "params":[], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				async: true,
				data: JSON.stringify(postData),
				dataType: "json",
				success: function (response) {
					E("filebrowser_status").innerHTML = response.result;
					setTimeout("check_status();", 10000);
				},
				error: function(){
					E("filebrowser_status").innerHTML = "获取运行状态失败";
					setTimeout("check_status();", 5000);
				}
			});
		}
	    
	    function get_url() {
            var LINK = "http://";
            var PORT = db_filebrowser["filebrowser_port"];
            if(db_filebrowser["filebrowser_sslswitch"] == "1") {
                LINK = "https://";
            }
            $("#fileb").html("<a type='button' href='"+LINK+location.hostname+":"+PORT+"' target='_blank'>访问 FileBrowser</a>");
        }
        
        function conf2obj(){
            for (var i = 0; i < params_input.length; i++) {
                if(db_filebrowser[params_input[i]]){
                    E(params_input[i]).value = db_filebrowser[params_input[i]];
                }
            }
            for (var i = 0; i < params_check.length; i++) {
                if(db_filebrowser[params_check[i]]){
                    E(params_check[i]).checked = db_filebrowser[params_check[i]] == 1 ? true : false
                }
            }
        }
        function start() {
            if (!E("filebrowser_port").value) {
                alert("端口号不能为空!");
                return false;
                }
            //清空隐藏的表格的值
            if(!E("filebrowser_watchdog").checked){
                E("filebrowser_delay_time").value = ""
            }
            if(!E("filebrowser_sslswitch").checked){
                E("filebrowser_cert").value = ""
                E("filebrowser_key").value = ""
            }    
            
            showLoading(2);
            
			//input
            for (var i = 0; i < params_input.length; i++) {
                if (trim(E(params_input[i]).value) && trim(E(params_input[i]).value) != db_filebrowser[params_input[i]]) {
                    db_filebrowser[params_input[i]] = trim(E(params_input[i]).value);
                }else if (!trim(E(params_input[i]).value) && db_filebrowser[params_input[i]]) {
                    db_filebrowser[params_input[i]] = "";
                }
            }
            // checkbox
            for (var i = 0; i < params_check.length; i++) {
                if (E(params_check[i]).checked != db_filebrowser[params_check[i]]) {
                    db_filebrowser[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
                }
            }
            
            var id = parseInt(Math.random() * 100000000);
            var postData = { "id": id, "method": "filebrowser_start.sh", "params": ["restart"], "fields": db_filebrowser };
            $.ajax({
                url: "/_api/",
                cache: false,
                type: "POST",
                dataType: "json",
                data: JSON.stringify(postData),
                success: function(response) {
			    if (response.result == id){
				refreshpage();
			    }
			}
            });
        }

        function close() {
            if (confirm('确定马上关闭吗.?')) {
				showLoading();
                var id = parseInt(Math.random() * 100000000);
                var postData = { "id": id, "method": "filebrowser_start.sh", "params": ["stop"], "fields": "" };
                $.ajax({
                    url: "/_api/",
                    cache: false,
                    type: "POST",
                    dataType: "json",
                    data: JSON.stringify(postData),
                    success: function(response) {
			        if (response.result == id){
				    refreshpage();
			        }
			    }
                });
            }
        }
        //导出数据库以及还原
        //异常：http网页，Chrome和MacOS safari正常下载，iOS safari会自动添加html后缀并下载，部分安卓手机会自动添加html后缀但下载不下来。
        //异常：https网页，Chrome点击数次可能有一次可以下载，MacOS safari会提示用户名和密码输入框，不输入点击取消或登录可下载，输入正确用户名和密码不能下载？
        function down_database() {
            var id = parseInt(Math.random() * 100000000);
            var postData = {"id": id, "method": "filebrowser_start.sh", "params": ["download"], "fields": db_filebrowser };
            $.ajax({
                type: "POST",
                url: "/_api/",
                async: true,
                cache: false,
                data: JSON.stringify(postData),
                dataType: "json",
                success: function(response){
                    if(response.result == id){
							var b = document.createElement('A')
							b.href = "_temp/filebrowser.db"
							b.download = 'filebrowser.db'
							document.body.appendChild(b);
							b.click();
							document.body.removeChild(b);
                    }
                }
            });	
        }
        function upload_database() {
            var filename = $("#database").val();
            filename = filename.split('\\');
            filename = filename[filename.length - 1];
            var filelast = filename.split('.');
            filelast = filelast[filelast.length - 1];
            //alert(filename);
            if (filelast != "db") {
                alert('上传文件格式非法！只支持上传db后缀的数据库文件');
                return false;
            }
            E("database_info").innerHTML = "处理中";
            E('database_info').style.display = "";
            var formData = new FormData();
            var dbname = filename;
            formData.append(dbname, document.getElementById('database').files[0]);
            <!--showLoading();-->
            
            $.ajax({
                url: '/_upload',
                type: 'POST',
                cache: false,
                data: formData,
                processData: false,
                contentType: false,
                complete: function(res) {
                    if (res.status == 200) {
                        upload_data(dbname);
                    }
                }
            });
        }

        //数据库处理
        function upload_data(dbname) {
            var id = parseInt(Math.random() * 100000000);
            db_filebrowser["filebrowser_uploaddatabase"] = dbname;
            var postData = { "id": id, "method": "filebrowser_start.sh", "params": ["upload"], "fields": db_filebrowser };
            $.ajax({
                url: "/_api/",
                cache: false,
                type: "POST",
                dataType: "json",
                data: JSON.stringify(postData),
                success: function(response){
                    if(response.result == id){
                        E('database_info').style.display = ""; 
						E("database_info").innerHTML = "已完成";
                        <!--refreshpage();-->
                    }
                }
            });    
        }
        function init() {
            show_menu(menu_hook);
			get_dbus_data();
			conf2obj();
			check_status();
			get_url();
        }

        function menu_hook(title, tab) {
            tabtitle[tabtitle.length - 1] = new Array("", "软件中心", "离线安装", "FileBrowser");
            tablink[tablink.length - 1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_filebrowser.asp");
        }

        function get_dbus_data() {
            $.ajax({
                type: "GET",
                url: "/_api/filebrowser",
                dataType: "json",
                async: false,
                success: function (data) {
					db_filebrowser = data.result[0];
                    update_visibility();	
                }
            });
        }
//操作表单时更新显示状态
function show_hide_element(){
	if(E("filebrowser_watchdog").checked){
	    E("delay_time_tr").style.display = "";
	}else{
		E("delay_time_tr").style.display = "none";
		}
	if(E("filebrowser_sslswitch").checked){
	    E("cert_tr").style.display = "";
		E("key_tr").style.display = "";
	}else{
		E("cert_tr").style.display = "none";
		E("key_tr").style.display = "none";
	}
}
//刷新网页时更新显示状态
function update_visibility(){
    if(db_filebrowser["filebrowser_watchdog"] == "1"){
	    E("delay_time_tr").style.display = "";
	}else{
		E("delay_time_tr").style.display = "none";
	}
	if(db_filebrowser["filebrowser_sslswitch"] == "1"){
	    E("cert_tr").style.display = "";
		E("key_tr").style.display = "";
	}else{
		E("cert_tr").style.display = "none";
		E("key_tr").style.display = "none";
	}
}
    function get_log() {
	       $.ajax({
	    	url: '/_temp/filebrowser.txt',
            //url: '/appGet.cgi?hook=nvram_dump(\"/filebrowser/filebrowser.log\",\"\")',   
	    	type: 'GET',
	    	cache:false,
	    	dataType: 'text',
	    	success: function(res) {
			$('#logtxt').val(res);
		    }
	       });
        }
    function open_file(open_file) {
        if (open_file == "log") {
		get_log();
	}
	    $("#" + open_file).fadeIn(200);
    }
    function close_file(close_file) {
	    $("#" + close_file).fadeOut(200);
    }
        
        $(function () {
            $('#btn_Start').click(start);
            $("#btn_Close").click(close);
            //get_dbus_data();
        });
    </script>
</head>
<body onload="init();">
    <div id="TopBanner"></div>
    <div id="Loading" class="popup_bg"></div>
    <iframe name="hidden_frame" id="hidden_frame" width="0" height="0" frameborder="0"></iframe>
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
                                        <div class="formfonttitle">软件中心 - FileBrowser</div>
                                        <div style="float: right; width: 15px; height: 25px; margin-top: -20px">
                                            <img id="return_btn" alt="" onclick="reload_Soft_Center();" align="right" style="cursor: pointer; position: absolute; margin-left: -30px; margin-top: -25px;" title="返回软件中心" src="/images/backprev.png" onmouseover="this.src='/images/backprevclick.png'" onmouseout="this.src='/images/backprev.png'" />
                                        </div>
                                        <div style="margin: 10px 0 10px 5px;" class="splitLine"></div>
                                        <div class="formfontdesc">
                                            FileBrowser 可以在指定目录内提供文件管理界面，可用于上载，删除，预览，重命名和编辑文件。它允许创建多个用户，每个用户可以拥有自己的目录。【更多信息：<a href="https://github.com/filebrowser/filebrowser" target="_blank"><i><u>-GitHub-</u></i></a>】【<em>注意：</em>运行时耗RAM较多，强烈建议开启虚拟内存！】
                                        </div>
                                        <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                            <thead>
                                                <tr>
                                                    <td colspan="2">FileBrowser - 设置</td>
                                                </tr>
                                            </thead>               
                                            <tr id="filebrowser_tr">
                                                <th>开关</th>
                                                <td>
													<button id="btn_Start" class="ks_btn" style="width: 110px; cursor: pointer; float: left; ">开启</button>
                                                    <button id="btn_Close" class="ks_btn" style="width: 110px; cursor: pointer; float: left; margin-left: 5px;">关闭</button>
                                                    <button class="ks_btn" style="width: 110px; cursor: pointer; float: left; margin-left: 5px;" href="javascript:void(0)" onclick="open_file('log');" target="_blank" >查看插件日志</button>
                                                </td>
                                            </tr>
                                            <tr id="filebrowser_port_tr">
                                                <th>端口</th>
                                                <td>
                                                    <input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" id="filebrowser_port" style="width: 60px;" maxlength="5" class="input_3_table" name="filebrowser_port" autocorrect="off" autocapitalize="off" style="background-color: rgb(89, 110, 116);" value="26789">
                                                </td>
                                            </tr>
											<tr>
												<th >状态</th>
												<td colspan="2"  id="filebrowser_status">
												</td>
											</tr>
											<tr>
												<th >访问</th>
												<td colspan="2"  id="filebrowser_access">
													<a type="button" style="vertical-align: middle; cursor:pointer;" id="fileb" class="ks_btn" target="_blank" >点击访问</a>					
												</td>
											</tr>
										</table>
										<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="filebrowser_switch_table">
											<thead>
											<tr>
												<td colspan="2">FileBrowser 看门狗 -- <em style="color: gold;">【周期性检查进程是否存在】</em></td>
											</tr>
											</thead>
											<tr>
											<th>看门狗开关</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell;float: left;">
														<label for="filebrowser_watchdog">
															<input id="filebrowser_watchdog" class="switch" type="checkbox" style="display: none;" onchange="show_hide_element();">
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
											<tr id="delay_time_tr">
													<th>检查时间间隔</th>
														<td colspan="2">
															<div>
													<select id="filebrowser_delay_time"  style="width:60px;margin:0px 0px 0px 2px;" class="input_option" >
                                                        <option value="1">1</option>
                                                        <option value="2">2</option>
                                                        <option value="3">3</option>
                                                        <option value="4">4</option>
                                                        <option value="5">5</option>
                                                        <option value="6">6</option>
                                                        <option value="10" selected="selected">10</option>
                                                        <option value="12">12</option>
                                                        <option value="15">15</option>
                                                        <option value="20">20</option>
                                                        <option value="30">30</option>
                                                        <option value="60">60</option>
                                                    </select>&nbsp;分钟
															</div>
														</td>		
												</tr>
                                        </table>
                                        <table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                            <thead>
                                            <tr>
                                                <td colspan="2">公网访问设定 -- <em style="color: gold;">【同时开启TLS/SSL更安全】</em></td>
                                            </tr>
                                            </thead>
                                            <tr>	
                                            <th>开启公网访问</th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                <label for="filebrowser_publicswitch">
                                                    <input id="filebrowser_publicswitch" type="checkbox" class="switch" style="display: none;">
                                                    <div class="switch_container" >
                                                        <div class="switch_bar"></div>
                                                        <div class="switch_circle transition_style">
                                                            <div></div>
                                                        </div>
                                                    </div>
                                                </label>													
                                            </div>
                                            <div class="SimpleNote" id="head_illustrate">
														<p>开启后使用<em>WAN口地址+端口</em>直接访问(支持ipv6)；关闭后，外网访问需设置LAN口地址的<a href="./Advanced_VirtualServer_Content.asp" target="_blank"><i>端口转发</i></a></p>	
														</div>
                                            </td>
                                            </tr>												                                     
                                        </table>
                                        
                                        <table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                            <thead>
                                            <tr>
                                                <td colspan="2">TLS/SSL设定 -- <em style="color: gold;">【使用HTTPS访问】</em></td>
                                            </tr>
                                            </thead>
                                            <tr>	
                                            <th>开启TLS/SSL</th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                <label for="filebrowser_sslswitch">
                                                    <input id="filebrowser_sslswitch" type="checkbox" class="switch" style="display: none;" onchange="show_hide_element();">
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
                                            <tr id="cert_tr">
                                                <th>证书文件路径</th>
                                                <td>
                                                    <input type="text" id="filebrowser_cert" style="width: 200px;" maxlength="100" class="input_3_table" name="filebrowser_cert" autocorrect="off" autocapitalize="off" style="background-color: rgb(89, 110, 116);" value="" placeholder="/tmp/etc/cert.pem">&nbsp;留空默认/tmp/etc/cert.pem
                                                </td>
                                            </tr>
                                            <tr id="key_tr">
                                                <th>密钥文件路径</th>
                                                <td>
                                                    <input type="text" id="filebrowser_key" style="width: 200px;" maxlength="100" class="input_3_table" name="filebrowser_key" autocorrect="off" autocapitalize="off" style="background-color: rgb(89, 110, 116);" value="" placeholder="/tmp/etc/key.pem">&nbsp;留空默认/tmp/etc/key.pem
                                                </td>
                                            </tr>
                                        </table>
                                        
                                        <table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="merlinclash_switch_table">
                                            <thead>
                                            <tr>
                                                <td colspan="2">备份/恢复数据库 -- <em style="color: gold;">【储存了设置信息，位置：/jffs/softcenter/bin/filebrowser.db】</em></td>
                                            </tr>
                                            </thead>
                                            <tr>
                                                <th class="btn btn-primary">备份数据库</th>
                                                <td colspan="2">
                                                    <a type="button" style="vertical-align: middle; cursor:pointer;" id="database-btn-download" class="ks_btn" onclick="down_database()" >备份数据库</a>
                                                </td>
                                            </tr>
                                            <tr>
                                            <th class="btn btn-primary">恢复数据库</th>
                                            <td colspan="2">
                                                <div class="SimpleNote" style="display:table-cell;float: left; height: 110px; line-height: 110px; margin:-40px 0;">
                                                    <input type="file" style="width: 200px;margin: 0,0,0,0px;" id="database" size="50" name="file"/>
                                                    <a type="button" style="vertical-align: middle; cursor:pointer;" id="database-btn-upload" class="ks_btn" onclick="upload_database()" >恢复数据库</a>&nbsp;<span id="database_info" style="display:none;">过程</span>
                                                </div>
                                            </td>
                                            </tr>														
                                        </table>
                                        <div id="warning" style="font-size: 14px; margin: 20px auto;"></div>
                                        <div style="margin: 10px 0 10px 5px;" class="splitLine"></div>
                                            <div class="formbottomdesc">说明：<br>
                                            1、FileBrowser的初始用户名和密码均为<em>admin</em>，登陆后可在【Setting】-【Profile Settings】中修改语言为中文；<br>
											2、若开启公网访问，务必在<em>【设置】</em>-<em>【用户管理】</em>中修改掉默认的用户名和密码<em>(大小写字母数字组合，8位以上)</em>；<br>
                                            3、本页“<em>备份数据库</em>”按钮，仅在HTTP环境下的Chrome内核浏览器测试，可能不兼容其他浏览器或HTTPS环境；<br>
                                            4、备份或恢复数据库，也可登录FileBrowser，使用<em>【下载】</em>或<em>【上传】</em>功能进行。注意恢复操作时，先删除旧 filebrowser.db 再上传备份然后重启服务（直接上传替换可能失败）。
                                            </div>
                                    </td>
                                </tr>
                            </table>
                                    <div id="log"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">FileBrowser插件日志</div>
                                        <div style="margin-left:15px"><i>文本不会自动刷新，读取自[/tmp/upload/filebrowser.txt]。</i></div>
                                        <div id="log_view" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="logtxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="close_file" class="button_gen" type="button" onclick="close_file('log');" value="返回主界面">
                                        </div>
                                    </div>
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

