#!/usr/bin/env sh
# setfont /usr/share/kbd/consolefonts/ter-132n.psf.gz
# setfont /usr/share/kbd/consolefonts/LatGrkCyr-12x22.psfu.gz
# Set font when running in console. For hidpi screen
# if [ $TERM = linux ]; then
    # terminus-font
    # if [ -f "/mnt/setfont/consolefonts/ter-124b.psf.gz" ]; then
    #     setfont /mnt/setfont/consolefonts/ter-124b.psf.gz
    # elif [ -f "/usr/share/consolefonts/ter-124b.psf.gz" ]; then
    #     setfont /usr/share/consolefonts/ter-124b.psf.gz
    # elif [ -f "/usr/share/kbd/consolefonts/ter-124b.psf.gz" ]; then
    #     setfont /usr/share/kbd/consolefonts/ter-124b.psf.gz
    # elif [ -f "/usr/share/consolefonts/LatGrkCyr-12x22.psfu.gz" ]; then
    #     setfont /usr/share/consolefonts/LatGrkCyr-12x22.psfu.gz
    # elif [ -f "/usr/share/kbd/consolefonts/LatGrkCyr-12x22.psfu.gz" ]; then
    #     setfont /usr/share/kbd/consolefonts/LatGrkCyr-12x22.psfu.gz
    # fi
# fi
#
#
#
set_font() {
	local font_size="$1"
# Set font when running in console. For hidpi screen
# If you want to change font in tmux, just detach it and attach again
	# { [ "$TERM" = "linux" ] || [ -z "${TERM##*"vt"*}" ]; } || return 0
	# [ -z "${TMUX+x}" ] || return 0
	# case "$(tty)" in
	case "${TTY:="$(tty)"}" in
		*"tty"*)
			# This case doesn't mean it is realy a tty, jist can run setfont on it
			# Bright(and fat face)  Normal
			# ter-v${font_size}b.psf.gz       ter-v${font_size}n.psf.gz
			font=
			# terminus-font
			if [ -f "/mnt/setfont/ter-v${font_size}n.psf.gz" ]; then
				font="/mnt/setfont/ter-v${font_size}n.psf.gz"
			elif [ -f "/mnt/setfont/consolefonts/ter-v${font_size}n.psf.gz" ]; then
				font="/mnt/setfont/consolefonts/ter-v${font_size}n.psf.gz"
			else
				fonts_dir="$(find /mnt/setfont -type d -name \
					"consolefonts" 2> /dev/null)"
				[ -n "${fonts_dir:+x}" ] ||
				# Might be permission denied
				fonts_dir="$(find /usr/share -type d -name \
					"consolefonts" 2> /dev/null)"
				# fonts_dir="/usr/share/consolefonts"
				# fonts_dir="/usr/share/kdb/consolefonts"

				[ -n "${fonts_dir:+x}" ] || return 0
				if  [ -f "$fonts_dir/ter-v${font_size}n.psf.gz" ]; then
					font="$fonts_dir/ter-v${font_size}n.psf.gz"
					# font="${fonts_dir}/ter-v28b.psf.gz"
					# Use default font
				elif [ -f "$fonts_dir/LatGrkCyr-12x22.psfu.gz" ]; then
					font="$fonts_dir/LatGrkCyr-12x22.psfu.gz"
				fi
			fi
			[ -z "${font:+x}" ] || {
				setfont "$font" ||
				printf 'Font %s setting failed\n' "$font"
			}
		#     ;;
		# *"not"*|*"Not"*)
		# *)
		#     printf '%s\n' "Not a tty" ;;
	esac
}

set_font 22

