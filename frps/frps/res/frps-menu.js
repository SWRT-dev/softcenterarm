function openssHint(itemNum){
    statusmenu = "";
    width="350px";

    if(itemNum == 0){
        statusmenu ="如果发现开关不能开启，那么请检查<a href='Advanced_System_Content.asp'><u><font color='#00F'>系统管理 -- 系统设置</font></u></a>页面内Enable JFFS custom scripts and configs是否开启。";
        _caption = "服务说明";
    }
    else if(itemNum == 1){
        statusmenu ="此处填入frp服务器的监控面板端口，仅在设定端口后才可使用面板功能";
        _caption = "[common]的dashboard_port字段";
    }
    else if(itemNum == 2){
        statusmenu ="此处填入你的frp服务器的服务端口。注：这个参数是默认的，是tcp端口，客户端可以根据需要配置是否连接(依据指定的底层通信协议类型)。";
        _caption = "[common]的bind_port字段";
    }
    else if(itemNum == 3){
        statusmenu ="此处填入你的frp服务器的特权授权码，客户端必须配置相同才能连接。<br/><font color='#F46'>注意：</font>使用带有特殊字符的密码，可能会导致frpc链接不上服务器。";
        _caption = "[common]的token字段";
    }
    else if(itemNum == 4){
        statusmenu ="对应服务器虚拟主机HTTP和HTTPS端口，可以与bind_port相同，留空即表示不开启http/https。Frps对于http/https服务支持基于域名的虚拟主机，支持自定义域名绑定，使多个域名可以共用一个端口。";
        _caption = "[common]的vhost_http_port和vhost_https_port字段";
    }
    else if(itemNum == 5){
        statusmenu ="此处显示Frps是否正常运行，并显示进程PID";
        _caption = "运行状态";
    }
    else if(itemNum == 6){
        statusmenu ="此处填写日志文件保存路径，请使用已存在的、有读写权限的目录，填写绝对路径，例如：/tmp/frps.log，若留空表示日志不写入文件。";
        _caption = "[common]的log_file字段";
    }
    else if(itemNum == 7){
        statusmenu ="此处选择日志记录等级。<br/>可选内容：trace,debug,info(默认值),warn,error。";
        _caption = "[common]的log_level字段";
    }
    else if(itemNum == 8){
        statusmenu ="此处输入要保留日志记录文件的天数(不含当天)，留空，不设置即默认3天。在log文件目录可以找到按日期命名的文件，一天一个。";
        _caption = "[common]的log_max_days字段";
    }
    else if(itemNum == 9){
        statusmenu ="最大连接池数量，不配置即默认5。<br/>当为指定的代理启用连接池后，frp 会预先和后端服务建立起指定数量的连接，每次接收到用户请求后，会从连接池中取出一个连接和用户连接关联起来，避免了等待与后端服务建立连接以及 frpc 和 frps 之间传递控制信息的时间";
        _caption = "[common]的max_pool_count字段";
    }
    else if(itemNum == 10){
        statusmenu ="定时执行操作，<font color='#F46'>检查：</font>检查frp的进程是否存在，若不存在则重新启动；<font color='#F46'>启动：</font>重新启动frp进程，而不论当时是否在正常运行。重新启动服务可能导致活动中的连接短暂中断.<br/><font color='#F46'>注意：</font>填写内容为 0 关闭定时功能！建议：选择分钟填写“60的因数”，选择小时填写“24的因数”。";
        _caption = "定时功能";
    }
    else if(itemNum == 11){
        statusmenu ="面板登录用户名";
        _caption = "[common]的dashboard_user字段";
    }
    else if(itemNum == 12){
        statusmenu ="面板登录密码";
        _caption = "[common]的dashboard_pwd字段";
    }
    else if(itemNum == 13){
        statusmenu ="该功能默认启用，如需关闭，可以在 frps 和 frpc 中配置，该配置项在服务端和客户端必须一致.<br/>多路复用:不再需要为每一个用户请求创建一个连接，使连接建立的延迟降低，并且避免了大量文件描述符的占用，使 frp 可以承载更高的并发数。";
        _caption = "[common]的tcp_mux字段";
    }
    else if(itemNum == 14){
        statusmenu ="强制frps只接受开启TLS加密的frpc连接，默认关闭";
        _caption = "[common]的tls_only字段";
    }
    else if(itemNum == 15){
        statusmenu ="监听UDP端口，用于接收采用quic协议的frpc，可以与bind_port相同，若不设置，表示frps不启用quic（quic/kcp/udp打洞端口不要冲突）。此功能，从 v0.46.0 版本开始支持，理论上速度更快，实际效果请自行测试（可能被运营商udp策略影响）";
        _caption = "[common]的quic_bind_port字段";
    }
    else if(itemNum == 16){
        statusmenu ="监听UDP端口，用于接收采用KCP协议的frpc，可以与bind_port相同，若不设置，表示frps不启用kcp（quic/kcp/udp打洞端口不要冲突）.";
        _caption = "[common]的kcp_bind_port字段";
    }
    else if(itemNum == 17){
        statusmenu ="监听UDP端口，用于辅助创建P2P连接（udp打洞）；可留空，可按需设置（quic/kcp/udp打洞端口不要冲突）。";
        _caption = "[common]的bind_udp_port字段";
    }
    else if(itemNum == 18){
        statusmenu ="输入完整语句，格式：参数 = 值 ，然后换行继续添加。内容将追加到frps配置文件的后面，不要与上述已存在的参数相同，不要在参数行结尾输入字符，若要注释，请在行首使用 # 符号；具体参看frp官方配置文件。";
        _caption = "附加其他参数";
    }
    else if(itemNum == 19){
        statusmenu ="打开备用tcp端口，是frps参数之外的端口，用于客户端tcp连接时配置远程端口取用；留空即不配置。设置时端口号<font color='#F46'>中间英文逗号隔开连续填写，不要输入多余的空格或其他字符</font>。例如“8080,443,992”（不含引号）。注意：此处使用iptables -m multiport模块，如果系统不支持则即使设置了，也不能打开端口。";
        _caption = "打开备用tcp端口";
    }
    else if(itemNum == 20){
        statusmenu ="插件脚本将打开所设置的端口的通信通过防火墙入站，<font color='#F46'>建议在此修改端口类型之前，或在修改下述各项目的端口号之前，先停用frps服务</font>，修改完成之后再启用；默认是开启ipv4端口的iptables规则，也可选支持ipv6，或者不开启。";
        _caption = "开启端口通过防火墙";
    }
    else if(itemNum == 21){
        statusmenu ="若subdomain_host不为空，例如frps.com；可在frpc中对类型为http/https的代理设置subdomain，若设为test，路由将使用test.frps.com。";
        _caption = "[common]的subdomain_host字段";
    }
        //return overlib(statusmenu, OFFSETX, -160, LEFT, DELAY, 200);
        //return overlib(statusmenu, OFFSETX, -160, LEFT, STICKY, WIDTH, 'width', CAPTION, " ", FGCOLOR, "#4D595D", CAPCOLOR, "#000000", CLOSECOLOR, "#000000", MOUSEOFF, "1",TEXTCOLOR, "#FFF", CLOSETITLE, '');
        return overlib(statusmenu, OFFSETX, -160, LEFT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');

    var tag_name= document.getElementsByTagName('a');
    for (var i=0;i<tag_name.length;i++)
        tag_name[i].onmouseout=nd;

    if(helpcontent == [] || helpcontent == "" || hint_array_id > helpcontent.length)
        return overlib('<#defaultHint#>', HAUTO, VAUTO);
    else if(hint_array_id == 0 && hint_show_id > 21 && hint_show_id < 24)
        return overlib(helpcontent[hint_array_id][hint_show_id], FIXX, 270, FIXY, 30);
    else{
        if(hint_show_id > helpcontent[hint_array_id].length)
            return overlib('<#defaultHint#>', HAUTO, VAUTO);
        else
            return overlib(helpcontent[hint_array_id][hint_show_id], HAUTO, VAUTO);
    }
}
