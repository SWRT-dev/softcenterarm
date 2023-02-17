<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>天翼云盘提速</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<script type="text/javascript" src="/js/jquery.js"></script>
<script src="/state.js"></script>
<script src="/help.js"></script>
</head>
<body>
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<table class="content" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td width="17">&nbsp;</td>
        <td valign="top" width="202">
            <div id="mainMenu"></div>
            <div id="subMenu"></div>
        </td>
        <td valign="top">
            <div id="tabMenu" class="submenuBlock"></div>
			<!--=====Beginning of Main Content=====-->
            <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0" style="display: block;">
				<tr>
					<td align="left" valign="top">
						<div>
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
                						<div style="float:left;" class="formfonttitle" style="padding-top: 12px">天翼云盘提速 - 设置</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="SimpleNote" id="head_illustrate"><i></i>欢迎使用【<em>天翼云盘提速</em>】 提速电信宽带。<div><a href="https://cloud.189.cn/" target="blank">天翼云盘APP下载地址: https://cloud.189.cn/</a></div><div><a href="http://koolshare.cn/thread-159179-1-1.html" target="blank">抓取代码教程:http://koolshare.cn/thread-159179-1-1.html</a></div></div>
                						<table style="margin:20px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">设置面板</td>
											</tr>
											</thead>
											<tr id="switch_tr">
												<th>
													<label>开启提速</label>
												</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell">
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
													<div id="koolproxy_install_show" style="padding-top:5px;margin-left:80px;margin-top:-30px;float: left;"></div>	
												</td>
											</tr>
	                                        <tr>
	                                            <td colspan="2">提速代码设置</td>
	                                        </tr>
		                                    <tr>
		                                        <th>AccessToken代码:</th>
		                                        <td>
                						            <input type="text" id="speedup_AccessToken" value="<% dbus_get_def("speedup_AccessToken", ""); %>" class="input_ss_table" placeholder="32位长度字符串">
		                                        </td>
		                                    </tr>
                						</table>
                						<div class="apply_gen">
                						    <input class="button_gen" type="button" value="提交">
                						</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"/></div>
										<div class="KoolshareBottom" style="margin-top:540px;">
											论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
											Github项目： <a href="https://github.com/koolshare/koolshare.github.io/tree/acelan_softcenter_ui" target="_blank"> <i><u>github.com/koolshare</u></i> </a> <br/>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
			<!--=====end of Main Content=====-->
        </td>
    </tr>
</table>
<div id="footer"></div>
<script>
$(function () {
    show_menu(menu_hook);
    var enable = "<% dbus_get_def("speedup_enable", "0"); %>";
    $('#switch').prop('checked', enable === "1");
    buildswitch();
    update_visibility();
    var posting = false;
	var inputs = ['AccessToken'];
    $('.button_gen').click(function () {
        if(posting) return;
        posting = true; // save
		var data = {
			speedup_enable: $('#switch').prop('checked') | 0,
			action_mode: ' Refresh ',
			current_page: 'Module_speedup.asp',
			next_page: 'Module_speedup.asp',
			action_script: 'speedup.sh'
		};
		for(var i = 0; i< inputs.length; i++) {
			var key = 'speedup_' + inputs[i];
			data['speedup_' + inputs[i]] = $('#speedup_' + inputs[i]).val()
		}
        $.ajax({
            type: 'POST',
            url: 'applydb.cgi?p=speedup_',
            data: $.param(data)
        }).then(function () {
            posting = false;
            alert('saved');
        }, function () {
            posting = false;
           alert('failed'); 
        })
    })
})

var enable_ss = "<% nvram_get("enable_ss"); %>";
var enable_soft = "<% nvram_get("enable_soft"); %>";
function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装", "天翼云盘提速");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_speedup.asp");
}

function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}

function buildswitch(){
	$("#switch").click(
	function(){
		update_visibility();
	});
}

function update_visibility(){
	if(document.getElementById('switch').checked){

		
	}else{

	}
}

</script>
</body>
</html>

