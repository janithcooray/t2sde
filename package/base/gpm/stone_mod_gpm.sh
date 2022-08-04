# --- T2-COPYRIGHT-NOTE-BEGIN ---
# T2 SDE: package/*/gpm/stone_mod_gpm.sh
# Copyright (C) 2004 - 2022 The T2 SDE Project
# Copyright (C) 1998 - 2003 ROCK Linux Project
# 
# This Copyright note is generated by scripts/Create-CopyPatch,
# more information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2.
# --- T2-COPYRIGHT-NOTE-END ---
#
# [MAIN] 40 gpm General Purpose Mouse (GPM) Daemon

write_config() {
	cat << EOT > /etc/conf/gpm
GPM_MOUSE="$GPM_MOUSE"
GPM_ARGS="`echo -t $GPM_TYPE -$GPM_BUTTONS $GPM_ARGS`"
EOT
}

set_port() {
	gui_menu gpm_port \
		"Select the mouse port. (Current: $GPM_MOUSE)" \
		'All input layer events . /dev/input/mice' 'GPM_MOUSE=/dev/input/mice' \
		'Input layer mouse 0 .... /dev/input/mouse0' 'GPM_MOUSE=/dev/input/mouse0' \
		'Input layer mouse 1 .... /dev/input/mouse1' 'GPM_MOUSE=/dev/input/mouse1' \
		'TTS 0 (aka COM 1) ...... /dev/tts/0' 'GPM_MOUSE=/dev/tts/0' \
		'TTS 1 (aka COM 2) ...... /dev/tts/1' 'GPM_MOUSE=/dev/tts/1' \
		'TTS 2 (aka COM 3) ...... /dev/tts/2' 'GPM_MOUSE=/dev/tts/2' \
		'TTS 3 (aka COM 4) ...... /dev/tts/3' 'GPM_MOUSE=/dev/tts/3' \
		'PSAUX (aka PS/2) ....... /dev/misc/psaux' 'GPM_MOUSE=/dev/misc/psaux' \
		'SUNMOUSE (SBUS) ........ /dev/misc/sunmouse' 'GPM_MOUSE=/dev/misc/sunmouse'
	write_config
}

set_type() {
	cmd="gui_menu gpm_type 'Select the mouse type."
	cmd="$cmd (Current: $GPM_TYPE)'" x="'"
	while read type desc ; do
		cmd="$cmd '$type - ${desc//$x/$x\\$x$x}' 'GPM_TYPE=$type'"
	done < <( gpm -m $GPM_MOUSE -t help | grep '^[ \*] [^ ]' | cut -c3- )
	eval "$cmd" ; write_config
}

set_buttons() {
	gui_menu gpm_buttons \
		"Select the number of mouse buttons. (Current: $GPM_BUTTONS)" \
		'This is a mouse with 2 buttons' 'GPM_BUTTONS=2' \
		'This is a mouse with 3 buttons' 'GPM_BUTTONS=3'
	write_config
}

set_args() {
	gui_input "Extra options for the gpm daemon (Current: $GPM_ARGS)" \
		"$GPM_ARGS" "GPM_ARGS"
	write_config
}

main() {
    while
	GPM_MOUSE="/dev/misc/psaux" GPM_ARGS="-t ms -2"
	[ -f /etc/conf/gpm ] && . /etc/conf/gpm

	set -- $GPM_ARGS ; GPM_ARGS=""
	while [ "$1" ] ; do
		if [ "$1" = "-t" ] ; then
			GPM_TYPE="$2" ; shift
		elif [ -z "${1#-[23]}" ] ; then
			GPM_BUTTONS="${1#-}"
		else
			GPM_ARGS="$GPM_ARGS $1"
		fi
		shift
	done

	gui_menu gpm 'General Purpose Mouse (GPM) Daemon Configuration.
Select an item to change the value:' \
		"Mouse Port ........ $GPM_MOUSE"   'set_port' \
		"Mouse Type ........ $GPM_TYPE"    'set_type' \
		"Mouse Buttons ..... $GPM_BUTTONS" 'set_buttons' \
		"Extra Options ..... $GPM_ARGS"    'set_args' \
		'' '' \
		'Edit the /etc/conf/gpm file'				\
			"gui_edit 'GPM Config File' /etc/conf/gpm"	\
		'Configure runlevels for GPM service'			\
			'$STONE runlevel edit_srv gpm'			\
		'(Re-)Start gpm init script'				\
			'$STONE runlevel restart gpm'
    do : ; done
}
