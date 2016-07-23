#!/bin/sh

# description: kernel event > udev action
# - spawn shell script: detect user's X session
# - spawn shell script in user context and detach process
# > then, and only then, xrandr does its magic!
#
# ... would anyone be so kind to explain this brlliancy to me?! :-)

# config
DISPLAY=":0"

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

	echo "mode: ${mode}"

	case "${mode}"
	in
	"hdmi")
		echo "hdmi: set primary"
		/usr/bin/xrandr --output HDMI1 --auto --left-of LVDS1

		sleep 2

		echo "lvds: set off"
		/usr/bin/xrandr --output LVDS1 --off

		sleep 2

		/usr/bin/pacmd set-card-profile alsa_card.pci-0000_00_1b.0 output:hdmi-stereo+input:analog-stereo
		;;
	*)
		echo "lvds: set primary"
		/usr/bin/xrandr --output LVDS1 --auto --right-of HDMI1

		sleep 2

		echo "hdmi: set off"
		/usr/bin/xrandr --output HDMI1 --off

		sleep 2

		/usr/bin/pacmd set-card-profile alsa_card.pci-0000_00_1b.0 output:analog-stereo+input:analog-stereo
		;;
	esac
}

# execute
USER="$(/usr/bin/w -husf|/usr/bin/awk "\$3 == \"${DISPLAY}\" {print \$1; exit 3}")"

if [ ${?} -eq 3 ]
then
	if [ "${UID}" == "$(id -u ${USER})" ]
	then
		XAUTHORITY="/home/${USER}/.Xauthority"
		PULSE_RUNTIME_PATH="/run/user/$(id -g ${USER})/pulse/"

		export DISPLAY XAUTHORITY PULSE_RUNTIME_PATH

		select_display
	else
		echo "spawn user process: switcheroo"
		/bin/su ${USER} -c "/usr/bin/nohup ${0} > /tmp/${USER}_switcheroo 2>&1 &"
	fi
fi

exit 0
