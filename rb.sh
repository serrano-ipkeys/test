#!/bin/bash

# IP Keys Relay Board scripts

export slots=/sys/devices/bone_capemgr.*/slots
export pinmux=/sys/kernel/debug/pinctrl/44e10800.pinmux
export pins=/sys/kernel/debug/pinctrl/44e10800.pinmux/pins
export raw=/sys/devices/ocp.3/44e0d000.tscadc/tiadc/iio:device0
export adin=/sys/devices/ocp.3/helper*
export gpio=/sys/class/gpio

# gpio pin numbers for Relay Board I/O
# GPIOn_m pin number = n*32 + m
export relay0=66
export relay1=67
export relay2=68
export relay3=69

export dout0=78
export dout1=79
export dout2=80
export dout3=81

export din0=110
export din1=111
export din2=112
export din3=113
export din4=44
export din5=45
export din6=46
export din7=47

export led0=86
export led1=87
export led2=88
export led3=89

#
# A/D Converters
#
function adc_setup()
{
	echo BB-ADC > $slots
}

function adc_raw()
{
	case $1 in
		[0-3]) ;;
        *) echo "invalid ADC number. Must be 0-3"; return 1;;
	esac

	cat $raw/in_voltage$1_raw
}

function adc()
{
	case $1 in
		[0-3]) ;;
        *) echo "invalid ADC number. Must be 0-3"; return 1;;
	esac

	cat $adin/AIN$1
}

#
# Relays
#
function relay_setup()
{
	echo $relay0 > $gpio/export
	echo $relay1 > $gpio/export
	echo $relay2 > $gpio/export
	echo $relay3 > $gpio/export

	echo out > $gpio/gpio$relay0/direction
	echo out > $gpio/gpio$relay1/direction
	echo out > $gpio/gpio$relay2/direction
	echo out > $gpio/gpio$relay3/direction
}

function toggle_relay()
{
	case $1 in
		0) relay=$relay0;;
		1) relay=$relay1;;
		2) relay=$relay2;;
		3) relay=$relay3;;
        *) echo "invalid relay number. Must be 0-3"; return 1;;
	esac

	#echo relay=$relay
	val=`cat $gpio/gpio$relay/value`
	#echo val=$val
	case $val in
		0) val=1;;
		1) val=0;;
	esac

	#echo val=$val
	echo $val > $gpio/gpio$relay/value

}

#
# Digital outputs
#
function dout_setup()
{
	echo $dout0 > $gpio/export
	echo $dout1 > $gpio/export
	echo $dout2 > $gpio/export
	echo $dout3 > $gpio/export

	echo out > $gpio/gpio$dout0/direction
	echo out > $gpio/gpio$dout1/direction
	echo out > $gpio/gpio$dout2/direction
	echo out > $gpio/gpio$dout3/direction
}

function toggle_dout()
{
	case $1 in
		0) dout=$dout0;;
		1) dout=$dout1;;
		2) dout=$dout2;;
		3) dout=$dout3;;
        *) echo "invalid dout number. Must be 0-3"; return 1;;
	esac

	val=`cat $gpio/gpio$dout/value`
	case $val in
		0) val=1;;
		1) val=0;;
	esac

	echo $val > $gpio/gpio$dout/value

}

function dout()
{
	case $1 in
		0) d=$dout0;;
		1) d=$dout1;;
		2) d=$dout2;;
		3) d=$dout3;;
        *) echo "invalid dout number. Must be 0-3"; return 1;;
	esac

	case $2 in
		0) val=0;;
		*) val=1;;
	esac

	echo $val > $gpio/gpio$d/value
}

#
# Digital inputs
#
function din_setup()
{
	echo $din0 > $gpio/export
	echo $din1 > $gpio/export
	echo $din2 > $gpio/export
	echo $din3 > $gpio/export
	echo $din4 > $gpio/export
	echo $din5 > $gpio/export
	echo $din6 > $gpio/export
	echo $din7 > $gpio/export

	echo in > $gpio/gpio$din0/direction
	echo in > $gpio/gpio$din1/direction
	echo in > $gpio/gpio$din2/direction
	echo in > $gpio/gpio$din3/direction
	echo in > $gpio/gpio$din4/direction
	echo in > $gpio/gpio$din5/direction
	echo in > $gpio/gpio$din6/direction
	echo in > $gpio/gpio$din7/direction
}

function din()
{
	case $1 in
		0) d=$din0;;
		1) d=$din1;;
		2) d=$din2;;
		3) d=$din3;;
		4) d=$din4;;
		5) d=$din5;;
		6) d=$din6;;
		7) d=$din7;;
        *) echo "invalid din number. Must be 0-7"; return 1;;
	esac

	cat $gpio/gpio$d/value
}

#
# LEDs
#
function led_setup()
{
	echo $led0 > $gpio/export
	echo $led1 > $gpio/export
	echo $led2 > $gpio/export
	echo $led3 > $gpio/export

	#echo out > $gpio/gpio$led0/direction
	#echo out > $gpio/gpio$led1/direction
	#echo out > $gpio/gpio$led2/direction
	#echo out > $gpio/gpio$led3/direction
}

function toggle_led()
{
	case $1 in
		0) led=$led0;;
		1) led=$led1;;
		2) led=$led2;;
		3) led=$led3;;
        *) echo "invalid led number. Must be 0-3"; return 1;;
	esac

	val=`cat $gpio/gpio$led/value`
	case $val in
		0) val=1;;
		1) val=0;;
	esac

	echo $val > $gpio/gpio$led/value

}

function led()
{
	case $1 in
		0) d=$led0;;
		1) d=$led1;;
		2) d=$led2;;
		3) d=$led3;;
        *) echo "invalid led number. Must be 0-3"; return 1;;
	esac

	case $2 in
		0) val=0;;
		*) val=1;;
	esac

	echo $val > $gpio/gpio$d/value
}

function usr()
{
	case $1 in
		[0-3]) ;;
            *) echo "invalid led number. Must be 0-3"; return 1;;
	esac

	usr_led=usr$1
	if [ $2 == "stop" ]; then
		echo none > /sys/class/leds/beaglebone:green:$usr_led/trigger
	else
		case $1 in
			0) echo heartbeat > /sys/class/leds/beaglebone:green:$usr_led/trigger;;
			1) echo mmc0 > /sys/class/leds/beaglebone:green:$usr_led/trigger;;
			2) echo cpu0 > /sys/class/leds/beaglebone:green:$usr_led/trigger;;
			3) echo mmc1 > /sys/class/leds/beaglebone:green:$usr_led/trigger;;
		esac
	fi
}

#
# pinmux
#
function mux_reg()
{
	base=0x44e10800

	# takes 1 argument = mux pin number
	if [ -z $1 ]; then
		echo $base
		return
	fi

	reg=$((base+($1*4)))
	echo $reg
}

function mux_addr()
{
	# takes 1 argument = mux pin number (default = 0)
	reg_addr=`mux_reg $1`
	printf "%X\n" $reg_addr
}

function mux_peek_pin()
{
	# takes 1 argument = mux pin number (default = 0)
	reg_addr=`mux_reg $1`
	reg_addr=`printf "%X" $reg_addr`
	cat $pins | grep -i $reg_addr
}

function mux_peek_off()
{
	# takes 1 argument = mux pin reg offset (hex) from mux ctrl base (default = 0)
	pin=`echo "ibase=16; $1" | bc`
	pin=$(($pin/4))
	reg_addr=`mux_reg $pin`
	reg_addr=`printf "%X" $reg_addr`
	cat $pins | grep -i $reg_addr
}

function rtc_setup()
{
	ntpdate -b -s -u pool.ntp.org
	hwclock -w
}

function date_pt()
{
	TZ='America/Los_Angeles' date
}

#
# setup everything
#
function rb_setup()
{
	adc_setup
	relay_setup
	dout_setup
	din_setup
	led_setup
}

function update_flash()
{
	if [ ! -e is_sd_card ]; then
		echo not on sdcard!!
		return
	fi

	./mkcard.sh /dev/mmcblk1
	mkdir /mnt/boot
	mkdir /mnt/root
	mount -t vfat /dev/mmcblk1p1 /mnt/boot
	mount /dev/mmcblk1p2 /mnt/root
	cp u-boot.img /mnt/boot
	cp MLO /mnt/boot
	tar -xvf Cloud9-IDE-GNOME-beaglebone.tar.xz -C /mnt/root
	sync
	cp rb.sh /mnt/root/home/root/
	umount /mnt/boot
	umount /mnt/root
}

function rbhelp()
{
	echo ""
	echo "IP Keys Relay Board commands:"
	echo "  rb_setup          --- setup all relay board I/O (not rtc)"
	echo "  adc_setup         --- setup ADC input"
	echo "  relay_setup       --- setup relay outputs"
	echo "  dout_setup        --- setup digital outputs"
	echo "  din_setup         --- setup digital inputs"
	echo "  led_setup         --- setup led outputs"
	echo "  rtc_setup         --- setup rtc"
    echo ""
	echo "  din <n>           --- read din n           - example: din 1             reads din1"
	echo "  dout <n> {1|0}    --- set dout n to 0 or 1 - example: dout 3 0          sets dout3 = 0"
	echo "  usr <n> {start|stop} --- enable/disable normal function for usr led  <n> - ex: usr 0 stop"
	echo "  led <n> {1|0}     --- set led n to 0 or 1  - example: led 2 1           turns led2 on"
	echo "  toggle_dout <n>   --- toggle dout n        - example: toggle_dout 1     toggles dout1"
	echo "  toggle_led <n>    --- toggle led n         - example: toggle_led 0      toggles led0"
	echo "  toggle_relay <n>  --- toggle relay n       - example: toggle_relay 1    toggles relay1"
	echo "  adc <n>           --- read ADC n           - example: adc 0             reads ADC0"
	echo "  adc_raw <n>       --- read ADC n raw       - example: adcraw 0          reads ADC0 raw"
	echo ""
	echo "  mux_addr <n>      --- mux pin n register address, n=0-141"
	echo "  mux_peek_pin <n>  --- mux pin n register value,   n=0-141"
	echo "  mux_peek_off <offset>  --- mux pin reg offset (hex) from mux ctrl base,   n=0-234"
	echo ""
	echo "  date_pt            --- display date/time in U.S. Pacific timezone "
	echo ""
	echo " update_flash        --- update firmware on internal flash - all existing files on flash are erased!"
}
