#!/bin/sh

# config
DISPLAY=":0"

# function
function select_display()
{
	local mode="$(/bin/cat /sys/class/drm/card0-HDMI-A-1/status)"

	case "${mode}"
	in
	"connected")
		/usr/bin/xrandr --output HDMI1 --auto --output LVDS1 --off
		/bin/su ${USER} -c "/usr/bin/pacmd set-card-profile alsa_card.pci-0000_00_1b.0 output:hdmi-stereo+input:analog-stereo"
		;;
	*)
		/usr/bin/xrandr --output LVDS1 --auto --output HDMI1 --off
		/bin/su ${USER} -c "/usr/bin/pacmd set-card-profile alsa_card.pci-0000_00_1b.0 output:analog-stereo+input:analog-stereo"
		;;
	esac
}

# execute
USER="$(/usr/bin/w -husf|/usr/bin/awk "\$2 == \"${DISPLAY}\" {print \$1; exit 3}")"

if [ ${?} -eq 3 ]
then
	XAUTHORITY="/home/${USER}/.Xauthority"
	PULSE_RUNTIME_PATH="$(/bin/ls -ld /tmp/pulse-*|/usr/bin/awk "\$3 == \"${USER}\" {print \$9; exit 3}")"

	if [ ${?} -eq 3 ]
	then
		export DISPLAY XAUTHORITY PULSE_RUNTIME_PATH

		select_display
	fi
fi

exit 0
