#!/usr/bin/env bash

# shell is funny

echo "显示摄像机的启用和检测状态:"
vcgencmd get_camera

echo "显示系统的限制状态:"
vcgencmd get_throttled

echo "显示由板载温度传感器测量的SoC温度:"
vcgencmd measure_temp

echo "显示指定时钟的当前频率:"
vcgencmd measure_clock arm
vcgencmd measure_clock core
vcgencmd measure_clock H264
vcgencmd measure_clock isp
vcgencmd measure_clock v3d
vcgencmd measure_clock uart
vcgencmd measure_clock pwm
vcgencmd measure_clock emmc
vcgencmd measure_clock pixel
vcgencmd measure_clock vec
vcgencmd measure_clock hdmi
vcgencmd measure_clock dpi

echo "显示特定块使用的当前电压:"
vcgencmd measure_volts core
vcgencmd measure_volts sdram_c
vcgencmd measure_volts sdram_i
vcgencmd measure_volts sdram_p

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
