#!/bin/sh

# config
DISPLAY=":0"

LOG="/tmp/udev_display_switcheroo"

# function
function select_display()
{
	local mode="default"

	# add tests for other cards and combinations
	if [ "connected" == "$(/bin/cat /sys/class/drm/card0-HDMI-A-1/status)" ]
	then
		mode="hdmi"
	#elif [ other card(s) ]
	fi

	echo "mode: ${mode}" >> ${LOG} 2>&1

	case "${mode}"
	in
	"hdmi")
		#while [ "disabled" == "$(/bin/cat /sys/class/drm/card0-HDMI-A-1/enabled)" ]
		#do
			echo "hdmi: set primary" >> ${LOG} 2>&1
			/usr/bin/xrandr --output HDMI1 --auto --primary >> ${LOG} 2>&1

			sleep 2
		#done

		#while [ "enabled" == "$(/bin/cat /sys/class/drm/card0-LVDS-1/enabled)" ]
		#do
			echo "lvds: set off" >> ${LOG} 2>&1
			/usr/bin/xrandr --output LVDS1 --off >> ${LOG} 2>&1

			sleep 2
		#done

		/bin/su ${USER} -c "/usr/bin/pacmd set-card-profile alsa_card.pci-0000_00_1b.0 output:hdmi-stereo+input:analog-stereo" >> ${LOG} 2>&1
		;;
	*)
		#while [ "disabled" == "$(/bin/cat /sys/class/drm/card0-LVDS-1/enabled)" ]
		#do
			echo "lvds: set primary" >> ${LOG} 2>&1
			/usr/bin/xrandr --output LVDS1 --auto --primary >> ${LOG} 2>&1

			sleep 2
		#done

		#while [ "enabled" == "$(/bin/cat /sys/class/drm/card0-HDMI-A-1/enabled)" ]
		#do
			echo "hdmi: set off" >> ${LOG} 2>&1
			/usr/bin/xrandr --output HDMI1 --off >> ${LOG} 2>&1

			sleep 2
		#done

		/bin/su ${USER} -c "/usr/bin/pacmd set-card-profile alsa_card.pci-0000_00_1b.0 output:analog-stereo+input:analog-stereo" >> ${LOG} 2>&1
		;;
	esac
}

# execute
USER="$(/usr/bin/w -husf|/usr/bin/awk "\$3 == \"${DISPLAY}\" {print \$1; exit 3}")"

if [ ${?} -eq 3 ]
then
	XAUTHORITY="/home/${USER}/.Xauthority"
	PULSE_RUNTIME_PATH="/run/user/$(id -g ${USER})/pulse/"

	export DISPLAY XAUTHORITY PULSE_RUNTIME_PATH

	select_display
fi

exit 0
