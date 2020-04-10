#!/usr/bin/env bash

# shell is funny

echo "显示摄像机的启用和检测状态:"
vcgencmd get_camera

echo "显示系统的限制状态:"
vcgencmd get_throttled

echo "显示由板载温度传感器测量的SoC温度:"
vcgencmd measure_temp

echo "显示指定时钟的当前频率:"
printf "%s\t%s\t\n" \
"ARM"   $(vcgencmd measure_clock arm)   \
"Core"  $(vcgencmd measure_clock core)  \
"H264"  $(vcgencmd measure_clock H264)  \
"ISP"   $(vcgencmd measure_clock isp)   \
"V3D"   $(vcgencmd measure_clock v3d)   \
"UART"  $(vcgencmd measure_clock uart)  \
"PWM"   $(vcgencmd measure_clock pwm)   \
"eMMC"  $(vcgencmd measure_clock emmc)  \
"Pixel" $(vcgencmd measure_clock pixel) \
"VEC"   $(vcgencmd measure_clock vec)   \
"HDMI"  $(vcgencmd measure_clock hdmi)  \
"DPI"   $(vcgencmd measure_clock dpi)

echo "显示特定块使用的当前电压:"
printf "%s\t%s\t\n" \
"core"    $(vcgencmd measure_volts core)    \
"sdram_c" $(vcgencmd measure_volts sdram_c) \
"sdram_i" $(vcgencmd measure_volts sdram_i) \
"sdram_p" $(vcgencmd measure_volts sdram_p)

echo "显示分配给GPU的内存量:"
vcgencmd get_mem gpu

echo "显示任何连接的显示器的分辨率和颜色深度:"
vcgencmd get_lcd_info

echo "环形振荡器的当前速度电压和温度:"
vcgencmd read_ring_osc

echo "显示当前显示电源状态:"
vcgencmd display_power

echo "列出可用的显示ID:"
tvservice -l

echo "显示USB设备排列方式及其分配的速度:"
lsusb -t

