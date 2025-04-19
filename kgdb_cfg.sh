#!/bin/bash

shopt -s expand_aliases

source /home/vbolla/.bashrc

config_set_var () {
	#delete any lines related to this name
	sed -i "/$2=/d" $1
	sed -i "/$2 /d" $1
	echo "$2=$3" >>  $1
}

kgdb_config_apply () {
	#Openwrt config
	config_set_var .config CONFIG_GDB_PYTHON y

	#Linux kernel config
	cd_x86_feeds
	config_set_var lgm/config-default CONFIG_VT y
	config_set_var lgm/config-default CONFIG_VT_CONSOLE y
	config_set_var lgm/config-default CONFIG_KGDB y
	config_set_var lgm/config-default CONFIG_KGDB_KDB y
	config_set_var lgm/config-default CONFIG_PANIC_TIMEOUT 0
	config_set_var lgm/config-default CONFIG_RANDOMIZE_BASE n
	config_set_var lgm/config-default CONFIG_WATCHDOG n
	config_set_var lgm/config-default CONFIG_MAGIC_SYSRG_DEFAULT_ENABLE 1
	config_set_var lgm/config-default CONFIG_DEBUG_KERNEL y
	config_set_var lgm/config-default CONFIG_DEBUG_INFO y
	config_set_var lgm/config-default CONFIG_DEBUG_INFO_DWARF4 y
	config_set_var lgm/config-default CONFIG_FRAME_POINTER y
	config_set_var lgm/config-default CONFIG_GDB_SCRIPTS y
	config_set_var lgm/config-default CONFIG_CONSOLE_TRANSLATIONS y
	config_set_var lgm/config-default CONFIG_VGA_CONSOLE y
	config_set_var lgm/config-default CONFIG_KGDB_SERIAL_CONSOLE y
	config_set_var lgm/config-default CONFIG_KDB_DEFAULT_ENABLE 0x1
	config_set_var lgm/config-default CONFIG_KDB_CONTINUE_CATASTROPHIC 0
	config_set_var lgm/config-default CONFIG_KGDB_HONOUR_BLOCKLIST y
	config_set_var lgm/config-default CONFIG_KPROBE_EVENTS y
	config_set_var lgm/config-default CONFIG_KPROBE_EVENT_GEN_TEST n
	cd -
}

kgdb_config_apply
