# Softcenter for ARM

本软件中心是基于armv7l平台路由器的软件中心,适用于linux内核为2.6.36.4的armv7l架构的路由器！

## 兼容机型

支持的机型：
1. 华硕 `RT-AC56U` `RT-AC68U` `RT-AC66U-B1` `RT-AC1900P` `RT-AC87U` `RT-AC88U` `RT-AC3100` `RT-AC3200` `RT-AC5300`
2. 网件 `R6300V2` `R6400` `R6900` `R7000` `R7000P` `R8000` `R8500`
3. 斐讯 `K3`
4. 其他 `XWR3100` `SBRAC1900P` `SBRAC3200P` `EA6700` `DIR868L`

## 开发须知：

如果你是开发者，想要开发新的插件，并用离线包的方式进行传播，请了解以下内容：

1. 在程序方面：由于固件采用了版本为2.6.36.4的linux内核，和armv7的编译器，所以请确保你编译的程序是armv7架构的。

2. [工具链等](https://github.com/SWRT-dev/softcenter_tools)

**软件中心各架构列表：**

|  软件中心   |                        mips软件中心                        |                 arm软件中心                  |                      arm64软件中心                       |                    armng软件中心                    |            mipsle软件中心             |
| :---------: | :----------------------------------------------------------: | :---------------------------------------------: | :----------------------------------------------------------: | :-----------------------------------------------: |:-----------------------------------------------: |
|  项目名称   | [softcenter](https://github.com/SWRT-dev/softcenter) | [softcenterarm](https://github.com/SWRT-dev/softcenterarm) |       [softcenterarm64](https://github.com/SWRT-dev/softcenterarm64)        | [softcenterarmng](https://github.com/SWRT-dev/softcenterarmng) |[softcentermipsle](https://github.com/SWRT-dev/softcentermipsle) |
|  适用架构   |                            mips                            |                     armv7l                      |                       aarch64                     |                        armv7l                        |                mipsle             |
|  linux内核  |               3.10/4.9               |                2.6.36.4             |             4.1/4.4/4.19/5.x           |             3.x/4.x/5.x            |         3.10/4.4/5.x          |
|     CPU     |                          grx500                           |                    bcm4708/9                    |                          [bcm490x ][ipq5/6/80xx][mt7622/3]                          |                     [bcm675x][ipq4/5/6/80xx][mt7622/3/9]                    |               mtk7621              |
|     FPU     |                          soft                          |                    no                    |                         hard                           |                     hard                     |               soft              |
|  固件版本   |                    MerlinR 5.0.0+                     |              MerlinR 5.0.0+              |                     MerlinR 5.0.0+                      |                  MerlinR 5.0.0+                    |                MerlinR 5.0.0+                    |
| 软件中心api |                          **1.1/1.5** 代                          |                   **1.1/1.5** 代                    |                          **1.1/1.5** 代                          |                    **1.1/1.5** 代                     |                **1.1/1.5** 代                     |
| 代表机型-1  | [BLUECAVE](https://github.com/SWRT-dev/bluecave-asuswrt) |              [RT-AC68U](https://github.com/SWRT-dev/rtac68u)               | [RT-AC86U](https://github.com/SWRT-dev/86u-asuswrt) |                         [TUF-AX3000](https://github.com/SWRT-dev/tuf-ax3000)                        |          [RT-AC85P](https://github.com/SWRT-dev/ac85p-asuswrt) | 
| 代表机型-2  | [K3C](https://github.com/SWRT-dev/K3C-merlin) |              [K3](https://github.com/SWRT-dev/K3-merlin.ng)              | [GT-AC2900](https://github.com/SWRT-dev/gt-ac2900) |                         [RT-AX58U](https://github.com/SWRT-dev/rt-ax58u)                        |         [RT-AX53U](https://github.com/SWRT-dev/rtax53u) |
| 代表机型-3  | [RAX40](https://github.com/SWRT-dev/rax40-asuswrt) |         [SBRAC1900P](https://github.com/SWRT-dev/sbrac1900p)                                        | [R8000P](https://github.com/SWRT-dev/r8000p) |                        [RT-AX89X](https://github.com/SWRT-dev/rtax89x)                         |         [R6800](https://github.com/SWRT-dev/ac85p-asuswrt)         |
| 代表机型-4  | DIR2680 |  [RT-AC5300](https://github.com/SWRT-dev/rt-ac5300)                              | RAX80 |                       [RT-ACRH17](https://github.com/SWRT-dev/acrh17-asuswrt)                         |            [RM-AC2100](https://github.com/SWRT-dev/ac85p-asuswrt)              |



