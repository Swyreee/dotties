#!/usr/bin/bash

# CMDs
lastlogin="`last $USER | head -n1 | tr -s ' ' | cut -d' ' -f5,6,7`"
uptime="`uptime -p | sed -e 's/up //g'`"
host=`hostnamectl --static`

# Options
hibernate=''
shutdown=''
reboot=''
lock=''
suspend=''
logout=''
yes=''
no=''

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p " $USER@$host" \
		-mesg " Last Login: $lastlogin |  Uptime: $uptime" \
		-theme config_powermenu.rasi
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$suspend\n$logout\n$hibernate\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
		if [[ $1 == '--shutdown' ]]; then
			notify-send "System" "Shutting down" --expire-time=500 && systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			notify-send "System" "Preparing to reboot" --expire-time=500 && systemctl reboot
		elif [[ $1 == '--hibernate' ]]; then
			notify-send "System" "Entering hibernate" --expire-time=500 && systemctl hibernate
		elif [[ $1 == '--suspend' ]]; then
            playerctl pause
			amixer set Master mute
			notify-send "System" "Preparing to hibernate" --expire-time=500 && systemctl suspend
		elif [[ $1 == '--logout' ]]; then
			notify-send "System" "Logging out" --expire-time=500 && bspc quit
		fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $hibernate)
		run_cmd --hibernate
        ;;
    $lock)
		if [[ -x '/usr/bin/betterlockscreen' ]]; then
			betterlockscreen -l
		elif [[ -x '/usr/bin/i3lock' ]]; then
			i3lock
		fi
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
