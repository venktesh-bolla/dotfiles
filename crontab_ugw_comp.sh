#!/bin/bash

shopt -s expand_aliases

source /home/vbolla/.bashrc

#PATH=/local/vbollax/dpm_for_PRs/svn/bin:/nfs/site/proj/chdsw_ci/common/kw/klocwork_2020_1/user/bin:/nfs/site/proj/chdsw_ci/common/env/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/local/bin/:/nfs/site/proj/chdsw_ci/common/quilt/bin/:/home/vbollax/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/sbin:/local/vbollax/neo_vim/nvim-linux64/bin

bb_path="/local/vbollax/buildbot"

kgdb=0
if [ "$2" != "" ]; then
	kgdb=1
	bb_path+="/kgdb"
fi

#$1 filename
#$2 variable name
#%3 variable value
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
	cfg_file="lgm/config-default"
	cd_x86_feeds
	config_set_var $cfg_file CONFIG_VT y
	config_set_var $cfg_file CONFIG_VT_CONSOLE y
	config_set_var $cfg_file CONFIG_KGDB y
	config_set_var $cfg_file CONFIG_KGDB_KDB y
	config_set_var $cfg_file CONFIG_PANIC_TIMEOUT 0
	config_set_var $cfg_file CONFIG_RANDOMIZE_BASE n
	config_set_var $cfg_file CONFIG_WATCHDOG n
	config_set_var $cfg_file CONFIG_MAGIC_SYSRG_DEFAULT_ENABLE 1
	config_set_var $cfg_file CONFIG_DEBUG_KERNEL y
	config_set_var $cfg_file CONFIG_DEBUG_INFO y
	config_set_var $cfg_file CONFIG_DEBUG_INFO_DWARF4 y
	config_set_var $cfg_file CONFIG_FRAME_POINTER y
	config_set_var $cfg_file CONFIG_GDB_SCRIPTS y
	config_set_var $cfg_file CONFIG_CONSOLE_TRANSLATIONS y
	config_set_var $cfg_file CONFIG_VGA_CONSOLE y
	config_set_var $cfg_file CONFIG_KGDB_SERIAL_CONSOLE y
	config_set_var $cfg_file CONFIG_KDB_DEFAULT_ENABLE 0x1
	config_set_var $cfg_file CONFIG_KDB_CONTINUE_CATASTROPHIC 0
	config_set_var $cfg_file CONFIG_KGDB_HONOUR_BLOCKLIST y
	config_set_var $cfg_file CONFIG_KPROBE_EVENTS y
	config_set_var $cfg_file CONFIG_KPROBE_EVENT_GEN_TEST n
	cd -
}

dir_handle () {
	mkdir -p $bb_path/$1.x
	cd $bb_path/$1.x
	/bin/rm -rf yestr
	[[ -d today ]] && mv today yestr && [[ -f ugw_build.log ]] && mv ugw_build.log yestr
	mkdir -p $bb_path/$1.x/today
}

build_ugw_ver ()
{
	echo "======> Build start at $(date)"
	
	cd $bb_path/$1.x/today

	d=$(date | sed 's/-//g')
	echo "$d" > buildstamp

	eval "pull_ugw$1"

	if [[ $1 == "9" ]]; then
		set_lgmd
		unset PYTHONPATH
		# As latest all pkgs are ported to python 3.6 and
		# during repo init PYTHONPATH must be empty.
		export PYTHONPATH=/nfs/site/proj/chdsw_ci/common/env/bin/python3.6/:/usr/lib/python3.6/
		if [ "$kgdb" == "1" ]; then
			#Apply KGDB config
			kgdb_config_apply
		fi
	elif [[ $1 == "8" ]]; then
		set_prxd
		if [ "$kgdb" == "1" ]; then
			#Apply KGDB config
			echo ""
		fi
	fi

	make -j32
	if [ "$?" != "0" ]; then
		echo ""
		echo "Seems build is failed !!"
		echo ""
		echo "==================> Re-triggered with verbose <============="
		echo ""
		make -j1 V=sc
	fi

	d=$(date | sed 's/-//g')
	echo "$d" >> buildstamp
	
	echo "======> Build end at $(date)"
}

/bin/rm -rf /local/vbollax/Recycle_Bin
dir_handle $1
build_ugw_ver $1 | tee $bb_path/$1.x/today/ugw_build.log
