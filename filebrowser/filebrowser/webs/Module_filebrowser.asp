<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="-1" />
    <link rel="shortcut icon" href="/res/icon-filebrowser.png" />
    <link rel="icon" href="/res/icon-filebrowser.png" />
    <title>软件中心 - FileBrowser</title>
    <link rel="stylesheet" type="text/css" href="index_style.css" />
    <link rel="stylesheet" type="text/css" href="form_style.css" />
    <link rel="stylesheet" type="text/css" href="css/element.css">
    <link rel="stylesheet" type="text/css" href="res/softcenter.css">
    <script language="JavaScript" type="text/javascript" src="/state.js"></script>
    <script language="JavaScript" type="text/javascript" src="/help.js"></script>
    <script language="JavaScript" type="text/javascript" src="/general.js"></script>
    <script language="JavaScript" type="text/javascript" src="/popup.js"></script>
    <script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
    <script language="JavaScript" type="text/javascript" src="/validator.js"></script>
    <script type="text/javascript" src="/js/jquery.js"></script>
    <script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
    <script type="text/javascript" src="/res/softcenter.js"></script>
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
					//console.log(response)
					var arr = response.result.split("@");
					E("filebrowser_status").innerHTML = arr[0];
				
					if(E("filebrowser_sslswitch").checked) {
				    $("#fileb").html("<a type='button' href='https://"+ location.hostname + ":"+arr[2]+"' target='_blank' >访问 FileBrowser</a>");
					} else {
					$("#fileb").html("<a type='button' href='http://"+ location.hostname + ":"+arr[2]+"' target='_blank' >访问 FileBrowser</a>");
					}
					
					setTimeout("check_status();", 10000);
				},
				error: function(){
					E("filebrowser_status").innerHTML = "获取运行状态失败";
					setTimeout("check_status();", 5000);
				}
			});
		}
        function start() {
            if (E("filebrowser_watchdog").checked) {
                if ((E("filebrowser_delay_time").value) == "") {
                alert("已开看门狗，请填写时间，或刷新页面拉取默认值，再继续操作!");
                return false;
		        }
	        }
            
            showLoading(2);
            refreshpage(2);
            var id = parseInt(Math.random() * 100000000);
			db_filebrowser["filebrowser_watchdog"] = E("filebrowser_watchdog").checked ? '1' : '0';
            db_filebrowser["filebrowser_publicswitch"] = E("filebrowser_publicswitch").checked ? '1' : '0';
            db_filebrowser["filebrowser_sslswitch"] = E("filebrowser_sslswitch").checked ? '1' : '0';
			db_filebrowser["filebrowser_delay_time"] = E("filebrowser_delay_time").value;
            db_filebrowser["filebrowser_port"] = E("filebrowser_port").value;
            db_filebrowser["filebrowser_cert"] = E("filebrowser_cert").value;
            db_filebrowser["filebrowser_key"] = E("filebrowser_key").value;
            
            var postData = { "id": id, "method": "filebrowser_config.sh", "params": ["start"], "fields": db_filebrowser };
            $.ajax({
                url: "/_api/",
                cache: false,
                type: "POST",
                dataType: "json",
                data: JSON.stringify(postData)
            });
        }

        function close() {
            if (confirm('确定马上关闭吗.?')) {
				showLoading(2);
           		refreshpage(2);
                var id = parseInt(Math.random() * 100000000);
                var postData = { "id": id, "method": "filebrowser_config.sh", "params": ["stop"], "fields": "" };
                $.ajax({
                    url: "/_api/",
                    cache: false,
                    type: "POST",
                    dataType: "json",
                    data: JSON.stringify(postData)
                });
            }
        }
        //导出数据库以及还原
        function down_database() {
            var id = parseInt(Math.random() * 100000000);
            var postData = {"id": id, "method": "filebrowser_downdata.sh", "params":[], "fields": "" };
            $.ajax({
                type: "POST",
                url: "/_api/",
                async: true,
                cache:false,
                data: JSON.stringify(postData),
                dataType: "json",
                success: function(response){
                    if(response.result == id){
                       
                            var downloadA = document.createElement('a');
                            var josnData = {};
                            var a = "http://"+window.location.hostname+"/_temp/"+"filebrowser.db"
                            var blob = new Blob([JSON.stringify(josnData)],{type : 'application/json'});
                            downloadA.href = a;
                            downloadA.download = "filebrowser.db";
                            downloadA.click();
                            window.URL.revokeObjectURL(downloadA.href);
                        
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
            E('database_info').style.display = "none";
            var formData = new FormData();
            var dbname = "filebrowser.db";
            formData.append(dbname, document.getElementById('database').files[0]);

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
            var postData = { "id": id, "method": "filebrowser_config.sh", "params": ["upload"], "fields": db_filebrowser };
            $.ajax({
                url: "/_api/",
                cache: false,
                type: "POST",
                dataType: "json",
                data: JSON.stringify(postData),
                success: function(response){
                    if(response.result == id){
                        E('database_info').style.display = "block";   
                        showLoading(2);
                        refreshpage(2);
                    }
                }
            });    
        }
        function init() {
            show_menu(menu_hook);
			get_dbus_data();
			check_status();
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
					E("filebrowser_watchdog").checked = db_filebrowser["filebrowser_watchdog"] == "1";
                    E("filebrowser_publicswitch").checked = db_filebrowser["filebrowser_publicswitch"] == "1";
                    E("filebrowser_sslswitch").checked = db_filebrowser["filebrowser_sslswitch"] == "1";
					if(db_filebrowser["filebrowser_delay_time"]){					
						E("filebrowser_delay_time").value = db_filebrowser["filebrowser_delay_time"];
					}
                    if(db_filebrowser["filebrowser_port"]){					
						E("filebrowser_port").value = db_filebrowser["filebrowser_port"];
					}
					if(db_filebrowser["filebrowser_cert"]){					
						E("filebrowser_cert").value = db_filebrowser["filebrowser_cert"];
					}
					if(db_filebrowser["filebrowser_key"]){					
						E("filebrowser_key").value = db_filebrowser["filebrowser_key"];
					}
                    	
                }
            });
        }
    function get_log() {
	       $.ajax({
	    	url: '/_temp/filebrowser_lnk.txt',
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
    <div id="LoadingBar" class="popup_bar_bg">
        <table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
            <tr>
                <td height="100">
                    <div id="loading_block3" style="margin: 10px auto; margin-left: 10px; width: 85%; font-size: 12pt;"></div>
                    <div id="loading_block2" style="margin: 10px auto; width: 95%;"></div>
                    <div id="log_content2" style="margin-left: 15px; margin-right: 15px; margin-top: 10px; overflow: hidden">
                        <textarea cols="63" rows="21" wrap="on" readonly="readonly" id="log_content3" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border: 1px solid #000; width: 99%; font-family: 'Courier New', Courier, mono; font-size: 11px; background: #000; color: #FFFFFF;"></textarea>
                    </div>
                    <div id="ok_button" class="apply_gen" style="background: #000; display: none;">
                        <input id="ok_button1" class="button_gen" type="button" onclick="hideKPLoadingBar()" value="确定">
                    </div>
                </td>
            </tr>
        </table>
    </div>
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
                                        <div class="SimpleNote">
                                            FileBrowser 可以在指定目录内提供文件管理界面，可用于上载，删除，预览，重命名和编辑文件。它允许创建多个用户，每个用户可以拥有自己的目录。【获取链接：<a href="https://github.com/filebrowser/filebrowser/releases" target="_blank"><i><u>Releases (Github)</u></i></a>】【<em>注意：</em>运行时耗RAM较多，强烈建议开启虚拟内存！】
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
                                                    <input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>65535)value=65535" id="filebrowser_port" style="width: 50px;" maxlength="5" class="input_3_table" name="filebrowser_port" autocorrect="off" autocapitalize="off" style="background-color: rgb(89, 110, 116);" value="26789"><span><font color=#FFFFFF>&nbsp;&nbsp;&nbsp;&nbsp;若要更改端口，建议先关闭FileBrowser</font></span>
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
													<a type="button" style="vertical-align: middle; cursor:pointer;" id="fileb" class="ks_btn" target="_blank" >访问 FileBrowser</a>					
												</td>
											</tr>
										</table>
										<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="filebrowser_switch_table">
											<thead>
											<tr>
												<td colspan="2">FileBrowser 看门狗</td>
											</tr>
											</thead>
											<tr>
											<th>看门狗开关</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell;float: left;">
														<label for="filebrowser_watchdog">
															<input id="filebrowser_watchdog" class="switch" type="checkbox" style="display: none;">
															<div class="switch_container" >
																<div class="switch_bar"></div>
																<div class="switch_circle transition_style">
																	<div></div>
																</div>
															</div>
														</label>
													</div>
													<div class="SimpleNote" id="head_illustrate">
														<p>进程守护工具，设定时间，周期性检查 filebrowser 进程是否存在，如果丢失则会自动重新拉起。手动关闭插件会重置此开关。</p>
													</div>
												</td>
											</tr>
													<!--看门狗检查间隔-->
											<tr>
													<th>自定义检查时间</th>
														<td colspan="2">
															<div class="SimpleNote" id="head_illustrate">
																<input oninput="this.value=this.value.replace(/[^\d]/g, '').replace(/^0{1,}/g,''); if(value>60)value=60" id="filebrowser_delay_time" maxlength="2" style="color: #FFFFFF; width: 30px; height: 20px; background-color:rgba(87,109,115,0.5); font-family: Arial, Helvetica, sans-serif; font-weight:normal; font-size:12px;" value="2" ><span>&nbsp;分钟</span><span><font color=#FFFFFF>&nbsp;&nbsp;&nbsp;&nbsp;建议：填写60的因数，周期更准</font></span>
															</div>
														</td>		
												</tr>
                                        </table>
                                        <table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                            <thead>
                                            <tr>
                                                <td colspan="2">公网访问设定 -- <em style="color: gold;">【重启插件后生效，建议同时开启TLS/SSL】</em></td>
                                            </tr>
                                            </thead>
                                            <tr id="dashboard">	
                                            <th>开启公网访问</th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                <label for="filebrowser_publicswitch">
                                                    <input id="filebrowser_publicswitch" type="checkbox" name="dashboard" class="switch" style="display: none;">
                                                    <div class="switch_container" >
                                                        <div class="switch_bar"></div>
                                                        <div class="switch_circle transition_style">
                                                            <div></div>
                                                        </div>
                                                    </div>
                                                </label>													
                                            </div>
                                            <div class="SimpleNote" id="head_illustrate">
														<p>开启后使用<em>wan口地址:端口</em>直接访问(支持ipv6)；关闭后，外网访问需手动设置lan口地址对应的<a href="./Advanced_VirtualServer_Content.asp" target="_blank"><i>端口转发</i></a>。手动关闭插件会重置此开关。</p>	
														</div>
                                            </td>
                                            </tr>												                                     
                                        </table>
                                        
                                        <table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                            <thead>
                                            <tr>
                                                <td colspan="2">TLS/SSL设定 -- <em style="color: gold;">【重启插件后生效，开启后，使用https链接访问】</em></td>
                                            </tr>
                                            </thead>
                                            <tr>	
                                            <th>开启TLS/SSL</th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                <label for="filebrowser_sslswitch">
                                                    <input id="filebrowser_sslswitch" type="checkbox" name="filebrowser_sslswitch" class="switch" style="display: none;">
                                                    <div class="switch_container" >
                                                        <div class="switch_bar"></div>
                                                        <div class="switch_circle transition_style">
                                                            <div></div>
                                                        </div>
                                                    </div>
                                                </label>													
                                            </div>
                                            <div class="SimpleNote" id="head_illustrate">
														<p>若文件路径留空或无效，将使用系统证书和密钥(/tmp/etc/cert.pem和key.pem)；若都无效则无法开启FileBrowser。</p>	
														</div>
                                            </td>
                                            </tr>
                                            <tr>
                                                <th>证书文件路径</th>
                                                <td>
                                                    <input type="text" id="filebrowser_cert" style="width: 200px;" maxlength="100" class="input_3_table" name="filebrowser_cert" autocorrect="off" autocapitalize="off" style="background-color: rgb(89, 110, 116);" value="" placeholder="/tmp/etc/cert.pem"><span><font color=#FFFFFF>&nbsp;&nbsp;&nbsp;提示：默认情况下/jffs目录可存档</font></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>密钥文件路径</th>
                                                <td>
                                                    <input type="text" id="filebrowser_key" style="width: 200px;" maxlength="100" class="input_3_table" name="filebrowser_key" autocorrect="off" autocapitalize="off" style="background-color: rgb(89, 110, 116);" value="" placeholder="/tmp/etc/key.pem">
                                                </td>
                                            </tr>
                                        </table>
                                        
                                        <table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="merlinclash_switch_table">
                                            <thead>
                                            <tr>
                                                <td colspan="2">备份/恢复数据库 -- <em style="color: gold;">【数据库储存了设置信息】</em></td>
                                            </tr>
                                            </thead>
                                            <tr>
                                                <th id="btn-open-clash-dashboard" class="btn btn-primary">备份数据库</th>
                                                <td colspan="2">
                                                    <a type="button" style="vertical-align: middle; cursor:pointer;" id="database-btn-download" class="ks_btn" onclick="down_database()" >导出数据库</a>
                                                </td>
                                            </tr>
                                            <tr>
                                            <th id="btn-open-clash-dashboard" class="btn btn-primary">恢复数据库</th>
                                            <td colspan="2">
                                                <div class="SimpleNote" style="display:table-cell;float: left; height: 110px; line-height: 110px; margin:-40px 0;">
                                                    <input type="file" style="width: 200px;margin: 0,0,0,0px;" id="database" size="50" name="file"/>
                                                    <span id="database_info" style="display:none;">完成</span>															
                                                    <a type="button" style="vertical-align: middle; cursor:pointer;" id="database-btn-upload" class="ks_btn" onclick="upload_database()" >恢复数据库</a>
                                                </div>
                                                    <div>
                                                        <br>
                                                        <br>
														<p>数据库位置：<em>/tmp/filebrowser/filebrowser.db</em>，您也可以登录FileBrowser，使用<em>【上传】</em>/<em>【下载】</em>功能操作此文件进行“<em>恢复</em>”/“<em>备份</em>”。</p>	
													</div>
                                            </td>
                                            </tr>														
                                        </table>
                                        <div id="warning" style="font-size: 14px; margin: 20px auto;"></div>
                                        <div style="margin: 10px 0 10px 5px;" class="splitLine"></div>
                                        <div id="DEVICE_note" style="margin:10px 0 0 5px">
                                            <div>说明：<br>
                                            1.FileBrowser的初始用户名和密码均为<em>admin</em>，登陆后可在【Setting】-【Profile Settings】中修改语言为中文；<br>
											2.若开启公网访问，切记在<em>【设置】</em>-<em>【用户管理】</em>中修改掉默认的用户名和密码<em>(大小写字母数字组合，8位以上)</em>；<br>
                                            3.长期开启公网访问有风险，建议同时开启TLS/SSL降低风险。
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                                    <div id="log"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">FileBrowser插件日志</div>
                                        <div style="margin-left:15px"><i>1、文本不会自动刷新，读取自[/tmp/upload/filebrowser_lnk.txt](日志的链接)。</i></div>
                                        <div style="margin-left:15px"><i>2、日志显示“数据库变化，重新备份数据库”的意思：文件已自动从内存备份到闪存，供开机首次启动时调用。</i></div>
                                        <div id="log_view" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="17" wrap="off" id="logtxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="close_file" class="button_gen" type="button" onclick="close_file('log');" value="返回主界面">
                                        </div>
                                    </div>
                    </tr>
                </table>
            </td>
            <td width="10" align="center" valign="top"></td>
        </tr>
    </table>
    <div id="footer"></div>
</body>
</html>

