<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- version: 2.9.2 -->
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - DDNSTO远程控制</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/dbconf?p=ddnsto&v=<% uptime(); %>"></script>
<style>
.Bar_container {
    width:85%;
    height:20px;
    border:1px inset #999;
    margin:0 auto;
    margin-top:20px \9;
    background-color:#FFFFFF;
    z-index:100;
}
#proceeding_img_text {
    position:absolute;
    z-index:101;
    font-size:11px;
    color:#000000;
    line-height:21px;
    width: 83%;
}
#proceeding_img {
    height:21px;
    background:#C0D1D3 url(/images/ss_proceding.gif);
}

.ddnsto_btn {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}
.ddnsto_btn:hover {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}

input[type=button]:focus {
    outline: none;
}
.cloud_main_radius_left{
    -webkit-border-radius: 10px 0 0 10px;
    -moz-border-radius: 10px 0 0 10px;
    border-radius: 10px 0 0 10px;
}
.cloud_main_radius_right{
    -webkit-border-radius: 0 10px 10px 0;
    -moz-border-radius: 0 10px 10px 0;
    border-radius: 0 10px 10px 0;
}
.cloud_main_radius{
    -webkit-border-radius: 10px;
    -moz-border-radius: 10px;
    border-radius: 10px;
}
.cloud_main_radius h2 { border-bottom:1px #AAA dashed;}
.cloud_main_radius h3,
.cloud_main_radius h4 { font-size:12px;font-weight:normal;font-style: normal;}
.cloud_main_radius h5 { color:#FFF;font-weight:normal;font-style: normal;}
</style>
<script>
var noChange_status = 0;
var _responseLen;

function E(e) {
    return (typeof(e) == 'string') ? document.getElementById(e) : e;
}

function init() {
    show_menu(menu_hook);
    get_status();
    conf_to_obj();
    buildswitch();
    toggle_switch();
}

function get_status() {
    $.ajax({
        url: '/logreaddb.cgi?p=.ddnsto.log&script=ddnsto_status.sh',
        dataType: 'html',
        error: function(xhr) {
            alert("error");
        },
        success: function(response) {
                E("status").innerHTML = response;
         }
    });
}


function toggle_switch() {
    var rrt = E("switch");
    if (document.form.ddnsto_enable.value != "1") {
        rrt.checked = false;
    } else {
        rrt.checked = true;
    }
}

function buildswitch() {
    $("#switch").click(
        function() {
            if (E('switch').checked) {
                document.form.ddnsto_enable.value = 1;
            } else {
                document.form.ddnsto_enable.value = 0;
            }
        });
}

function conf_to_obj() {
    if (typeof db_ddnsto != "undefined") {
        for (var field in db_ddnsto) {
            var el = E(field);
            if (el != null) {
                el.value = db_ddnsto[field];
            }
        }
    }
}

function onSubmitCtrl() {
    showSSLoadingBar(5);
    document.form.submit();
}

function done_validating(action) {
    return true;
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线下载", "ddnsto 远程控制");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_ddnsto.asp");
}

function openShutManager(oSourceObj, oTargetObj, shutAble, oOpenTip, oShutTip) {
    var sourceObj = typeof oSourceObj == "string" ? E(oSourceObj) : oSourceObj;
    var targetObj = typeof oTargetObj == "string" ? E(oTargetObj) : oTargetObj;
    var openTip = oOpenTip || "";
    var shutTip = oShutTip || "";
    if (targetObj.style.display != "none") {
        if (shutAble) return;
        targetObj.style.display = "none";
        if (openTip && shutTip) {
            sourceObj.innerHTML = shutTip;
        }
    } else {
        targetObj.style.display = "block";
        if (openTip && shutTip) {
            sourceObj.innerHTML = openTip;
        }
    }
}


function showSSLoadingBar(seconds) {
    if (window.scrollTo)
        window.scrollTo(0, 0);

    disableCheckChangedStatus();

    htmlbodyforIE = document.getElementsByTagName("html"); //this both for IE&FF, use "html" but not "body" because <!DOCTYPE html PUBLIC.......>
    htmlbodyforIE[0].style.overflow = "hidden"; //hidden the Y-scrollbar for preventing from user scroll it.

    winW_H();

    var blockmarginTop;
    var blockmarginLeft;
    if (window.innerWidth)
        winWidth = window.innerWidth;
    else if ((document.body) && (document.body.clientWidth))
        winWidth = document.body.clientWidth;

    if (window.innerHeight)
        winHeight = window.innerHeight;
    else if ((document.body) && (document.body.clientHeight))
        winHeight = document.body.clientHeight;

    if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth) {
        winHeight = document.documentElement.clientHeight;
        winWidth = document.documentElement.clientWidth;
    }

    if (winWidth > 1050) {
        winPadding = (winWidth - 1050) / 2;
        winWidth = 1105;
        blockmarginLeft = (winWidth * 0.3) + winPadding - 150;
    } else if (winWidth <= 1050) {
        blockmarginLeft = (winWidth) * 0.3 + document.body.scrollLeft - 160;
    }

    if (winHeight > 660)
        winHeight = 660;

    blockmarginTop = winHeight * 0.5

    E("loadingBarBlock").style.marginTop = blockmarginTop + "px";
    E("loadingBarBlock").style.marginLeft = blockmarginLeft + "px";
    E("loadingBarBlock").style.width = 770 + "px";
    E("LoadingBar").style.width = winW + "px";
    E("LoadingBar").style.height = winH + "px";

    loadingSeconds = seconds;
    progress = 100 / loadingSeconds;
    y = 0;
    LoadingLocalProgress(seconds);
}


function LoadingLocalProgress(seconds) {
    E("LoadingBar").style.visibility = "visible";
    if (document.form.ddnsto_enable.value != "1") {
        E("loading_block3").innerHTML = "ddnsto关闭中 ..."
    } else {
        E("loading_block3").innerHTML = "ddnsto启用中 ..."
    }

    y = y + progress;
    if (typeof(seconds) == "number" && seconds >= 0) {
        if (seconds != 0) {
            E("proceeding_img").style.width = Math.round(y) + "%";
            E("proceeding_img_text").innerHTML = Math.round(y) + "%";

            if (E("loading_block1")) {
                E("proceeding_img_text").style.width = E("loading_block1").clientWidth;
                E("proceeding_img_text").style.marginLeft = "175px";
            }
            --seconds;
            setTimeout("LoadingLocalProgress(" + seconds + ");", 1000);
        } else {
            E("proceeding_img_text").innerHTML = "完成";
            y = 0;
            setTimeout("hideSSLoadingBar();", 1000);
            refreshpage();
        }
    }
}

</script>
</head>
<body onload="init();">
    <div id="TopBanner"></div>
    <div id="Loading" class="popup_bg"></div>
    <div id="LoadingBar" class="popup_bar_bg">
        <table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
            <tr>
                <td height="100">
                    <div id="loading_block3" style="margin:10px auto;width:85%; font-size:12pt;"></div>
                    <div id="loading_block1" class="Bar_container"> <span id="proceeding_img_text"></span>
                        <div id="proceeding_img"></div>
                    </div>
                    <div id="loading_block2" style="margin:10px auto; width:85%;">进度条走动过程中请勿刷新网页，请稍后...</div>
                </td>
            </tr>
        </table>
    </div>
    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
    <form method="POST" name="form" action="/applydb.cgi?p=ddnsto_" target="hidden_frame">
        <input type="hidden" name="current_page" value="Module_ddnsto.asp">
        <input type="hidden" name="next_page" value="Module_ddnsto.asp">
        <input type="hidden" name="group_id" value="">
        <input type="hidden" name="modified" value="0">
        <input type="hidden" name="action_mode" value="start">
        <input type="hidden" name="action_script" value="ddnsto_config.sh">
        <input type="hidden" name="action_wait" value="1">
        <input type="hidden" name="first_time" value="">
        <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get(" preferred_lang "); %>">
        <input type="hidden" name="firmver" value="<% nvram_get(" firmver "); %>">
        <input type="hidden" id="ddnsto_enable" name="ddnsto_enable" value='<% dbus_get_def("ddnsto_enable", "0"); %>' />
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
                                            <div class="formfonttitle">软件中心 - ddnsto远程控制</div>
                                            <div style="float:right; width:15px; height:25px;margin-top:-20px">
                                                <img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
                                            </div>
                                            <div style="margin-left:5px;margin-top:10px;margin-bottom:10px">
                                            </div>
                                            <div class="SimpleNote">
                                              <table width="100%" height="150px" style="border-collapse:collapse;">
                                                <tr bgcolor="#444f53">
                                                    <td colspan="5" bgcolor="#444f53" class="cloud_main_radius">
                                                        <div style="padding:10px;width:95%;font-style:italic;">
                                                            <br/><br/>
                                                          <table width="100%" >
                                                              <tr>
                                                                  <td>
                                                                      <ul style="margin-top:-50px;padding-left:15px;" >
                                                                          <li style="margin-top:-5px;">
                                                                              <h2 id="push_titile"><em>欢迎使用DDNSTO</em></h2>
                                                                          </li>
                                                                          <li style="margin-top:-5px;">
                                                                              <h4 id="push_content1" >ddnsto远程控制是koolshare小宝开发的，支持http2的远程控制。<em>仅支持远程管理路由器+nas+windows远程桌面（暂未开放）！</em></h4>
                                                                          </li>
                                                                          <li  style="margin-top:-5px;">
                                                                              <h4 id="push_content2"><i>【注意】：请保护好你的DDNSTO/EasyExplorer的Token，如果被其他人获知，那么下一个摄影大师可能就是你！！！</i></h4>
                                                                          </li>
                                                                          <li  style="margin-top:-5px;">
                                                                              <h4 id="push_content3">DDNSTO仅提供给koolshare固件用户维护路由器使用，请勿用于反动、不健康等用途！！！</h4>
                                                                          </li>
                                                                          <li id="push_content4_li" style="margin-top:-5px;display: none;">
                                                                              <h4 id="push_content4"></h4>
                                                                          </li>
                                                                          <li id="push_content5_li" style="margin-top:-5px;display: none;">
                                                                              <h4 id="push_content5"></h4>
                                                                          </li>
                                                                      </ul>
                                                                  </td>
                                                              </tr>
                                                          </table>
                                                        </div>
                                                      </td>
                                                  </tr>
                                                  <tr height="10px">
                                                      <td colspan="3"></td>
                                                  </tr>
                                              </table>
                                            </div>
                                            <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                                <thead>
                                                    <tr>
                                                        <td colspan="2">ddnsto - 高级设置</td>
                                                    </tr>
                                                </thead>
                                                <tr id="switch_tr">
                                                    <th>
                                                        <label>开关</label>
                                                    </th>
                                                    <td colspan="2">
                                                        <div claddnsto="switch_field" style="display:table-cell;float: left;">
                                                            <label for="switch">
                                                                <input id="switch" class="switch" type="checkbox" style="display: none;">
                                                                <div class="switch_container">
                                                                    <div class="switch_bar"></div>
                                                                    <div class="switch_circle transition_style">
                                                                        <div></div>
                                                                    </div>
                                                                </div>
                                                            </label>
                                                        </div>
                                                          <div id="ddnsto_changelog_show" style="padding-top:5px;margin-right:50px;margin-top:0px;float: right;">
                                                            <a type="button" class="ddnsto_btn" style="cursor:pointer" href="https://raw.githubusercontent.com/koolshare/merlin_ddnsto/master/Changelog.txt" target="_blank">更新日志</a>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr id="ddnsto_status">
                                                    <th>运行状态</th>
                                                    <td><span id="status">获取中...</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>ddnsto Token</th>
                                                    <td>
                                                        <input style="width:300px;background-image: none;background-color: #576d73;border:1px solid gray" type="password" class="input_ss_table" id="ddnsto_token" name="ddnsto_token" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="100" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);">
                                                    </td>
                                                </tr>
                                                <tr id="rule_update_switch">
                                                    <th>管理/帮助</th>
                                                    <td>
                                                        <a type="button" class="ddnsto_btn" style="cursor:pointer" target="_blank" href="https://www.ddnsto.com">https://www.ddnsto.com</a>
                                                        <a type="button" class="ddnsto_btn" style="cursor:pointer" onclick="openShutManager(this,'NoteBox',false,'关闭使用说明','ddnsto使用说明') ">ddnsto使用说明</a>
                                                    </td>
                                                </tr>
                                            </table>
                                            <div id="warning" style="font-size:14px;margin:20px auto;"></div>
                                            <div class="apply_gen">
                                                <input class="button_gen" id="cmdBtn" onClick="onSubmitCtrl()" type="button" value="提交" />
                                            </div>
                                            <div style="margin-left:5px;margin-top:10px;margin-bottom:10px">
                                            </div>
                                            <div id="NoteBox" style="display:none">
                                                <li>ddnsto远程控制目前处于测试阶段，仅提供给koolshare固件用户使用，提供路由界面的穿透，请勿用于反动、不健康等用途；</li>
                                                <li>穿透教程：<a id="gfw_number" href="http://koolshare.cn/thread-116500-1-1.html" target="_blank"><i>DDNSTO远程控制使用教程</i></a>
                                                </li>
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

