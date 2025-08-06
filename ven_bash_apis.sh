#!/bin/bash

shopt -s expand_aliases

alias setenv="set"
export HISTCONTROL=ignoreboth:erasedups
export HISTFILE=~/.bash_history
export HISTSIZE=
export HISTFILESIZE=
shopt -s histappend
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

## My custom fuctions for easy life at office
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W\$ '
#neovim path
export PATH=$PATH:~/neo_vim/nvim-linux64/bin
alias v="nvim"
alias n="nvim"
alias vimm="nvim"
alias vin="nvim"
alias vim="vim"

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

bash_set_color ()
{
	color=$1
	echo "${!color}"
}

bash_unset_color ()
{
	echo "$Color_off"
}

bash_color_print ()
{
	#usage: bash_color_print Red "abcd efgh"
	clr="$1"
	shift
	echo -e "$(bash_set_color $clr)$@$(bash_unset_color)"
}

PS_set_color ()
{
	echo "\[$1\]"
}

PS_unset_color ()
{
	echo "\[$Color_Off\]"
}

set_ps1 ()
{
	PS1="$(PS_set_color $BIGreen)"
	PS1+="["
	PS1+="$(PS_unset_color)"
	PS1+="$(PS_set_color $Cyan)"
	PS1+="\u"
	PS1+="$(PS_unset_color)"
	PS1+="$(PS_set_color $Yellow)"
	PS1+="@"
	PS1+="$(PS_unset_color)"
	PS1+="$(PS_set_color $Purple)"
	PS1+="\h"
	PS1+="$(PS_unset_color)"
	PS1+="$(PS_set_color $BIYellow)"
	PS1+=":"
	PS1+="$(PS_unset_color)"
	PS1+="$(PS_set_color $Blue)"
	PS1+=" \W"
	PS1+="$(PS_unset_color)"
	PS1+="$(PS_set_color $BIGreen)"
	PS1+="]"
	PS1+="$(PS_unset_color)"
	PS1+="$(PS_set_color $Yellow)"
	PS1+="\\$ "
	PS1+="$(PS_unset_color)"
}

tssh () {
	[[ -z $TMUX ]] && tmux a -t 0
}

otssh () {
	if [ ! -z $TMUX ]; then
		echo "Tmux already running $TMUX"
		return 1;
	fi
	#clear all tmux instances
	while true; do
		pid=$(ps -Af | grep "tmux a" | grep -v grep | head -n 1 | awk '{print $2}')
		if [ -z $pid ]; then
			break
		fi
		kill -9 $pid
	done

	#attach
	tmux a -t 0
}

tnew () {
	[[ -z $TMUX ]] && tmux
}

vrxtags () {

	rm -rf tags
	rm -rf /tmp/cscope.files
	ctags --language-force=C    -R -f tags grx500 1>/dev/null 2>/dev/null
	rm -rf cscope.*
	find grx500 -name '*.c' -o -name '*.h' > /tmp/cscope.files 2>/dev/null
	cscope -qvRkb -i /tmp/cscope.files
	rm -rf /tmp/cscope.files
}

ugwtags () {
	linux_dir_name="linux_lgm"
	cdir=$(vget_cdir)
	if [ $cdir != "gwdpa-dpm" ]; then
		echo "Error: CWD is not gwdpa-dpm!!"
		return 1;
	fi
	gwdpa_path="$PWD"
	cd ../$linux_dir_name
	if [ $? != 0 ]; then
		echo "Error: ../$linux_dir_name not found from $cdir"
		return 2;
	fi
	linux_path="$PWD"
	tags_path="$linux_path/.."

	echo $gwdpa_path $linux_path $tags_path
	cd $tags_path
	rm -rf tags
	#ctags --language-force=C    -R -f tags feeds 1>/dev/null 2>/dev/null
	#ctags --language-force=C -a -R -f tags source/dc_dp_drv 1>/dev/null 2>/dev/null
	#ctags --language-force=C -a -R -f tags source/dp_dp_drv 1>/dev/null 2>/dev/null
	ctags --language-force=C -a -R -f tags $linux_path/include/net/datapath*.h 1>/dev/null 2>/dev/null
	ctags --language-force=C -a -R -f tags $linux_path/include/net/mxl*.h 1>/dev/null 2>/dev/null
	ctags --language-force=C -a -R -f tags $linux_path/drivers/net/datapath 1>/dev/null 2>/dev/null
	ctags --language-force=C -a -R -f tags $gwdpa_path 1>/dev/null 2>/dev/null

	rm -rf cscope.*
	rm -rf .cscope.files
#	find feeds -name '*.c' -o -name '*.h' > /tmp/cscope.files 2>/dev/null
#	find source/dc_dp_drv -name '*.c' -o -name '*.h' >> /tmp/cscope.files 2>/dev/null
#	find source/dp_dp_drv -name '*.c' -o -name '*.h' >> /tmp/cscope.files 2>/dev/null
#	find source/linux -name '*.c' -o -name '*.h' >> /tmp/cscope.files 2>/dev/null
	find $linux_path/include/net -name 'datapath*.c' -o -name 'datapath*.h' >> .cscope.files 2>/dev/null
	find $linux_path/include/net -name 'mxl*.c' -o -name 'mxl*.h' >> .cscope.files 2>/dev/null
	find $linux_path/drivers/net/datapath -name '*.c' -o -name '*.h' >> .cscope.files 2>/dev/null
	find $gwdpa_path -name '*.c' -o -name '*.h' >> .cscope.files 2>/dev/null
	cscope -qvRkb -i .cscope.files
	rm -rf .cscope.files

	cd $cdir
}

_ugwtags () {

	if [ -z "$1" ]; then
		echo "Error: Please provide the input path to dir to gen tags for"
		echo "Usage: $FUNCNAME <src-path> <optional-tag-dir>"
		return 1
	fi

	tags_gen_dir=.
	if [ ! -z "$2" ]; then
		tags_gen_dir=$2
	fi

	if [ "${1:0:1}" == "/" ]; then
		dir=$1
	else
		dir=$PWD/$1
	fi

	if [ ! -d $dir ] || [ ! -d $tags_gen_dir ]; then
		echo "Error: Given path does not exist"
		echo "Usage: $FUNCNAME <src-path> <optional-tag-dir>"
		return 1
	fi

	#all good generate tags
	tags_gen_dir="$tags_gen_dir/tag_files"
	mkdir -p $tags_gen_dir
	ctags --language-force=C -a -R -f $tags_gen_dir/tags $dir 1>/dev/null 2>/dev/null
	find $dir -name '*.c' -o -name '*.h' >> $tags_gen_dir/cscope.files 2>/dev/null
	rm -rf $tags_gen_dir/cscope.out $tags_gen_dir/cscope.in
	cscope -qvRkb -i $tags_gen_dir/cscope.files

}

vgrep () {
	if [ ! -z $1 ]; then
		git fetch --all --tags
		if [ ! -z $2 ]; then
			#git branch -a | grep -i $1 | cut -d '/' -f 3 | head -n $2 | tail -n 1 | sed 's/* //g'
			git branch -a | grep -i $1 | sed 's/\// /g' | awk '{print $(NF)}' | head -n $2 | tail -n 1 | sed 's/* //g'
		else
			#git branch -a | grep -i $1 | cut -d '/' -f 3 | sed 's/* //g'
			git branch -a | grep -i $1 | sed 's/\// /g' | awk '{print $(NF)}' | sed 's/* //g'
		fi
	fi
}

vmk_absolute_path () {
	if [ "${1:0:1}" == "/" ]; then
		dir=$1
	else
		dir=$PWD/$1
	fi
	echo $dir
}

vsed_newline_to_achar ()
{
	str="$1"
	char="$2"
	echo -e $str | sed ":a;N;\$!ba;s/\\n/$char/g"
}

#$1 branch string
#$2 item num from head
vcheckout () {
	if [ ! -z $1 ]; then
		git fetch --all --tags
		if [ ! -z $2 ]; then
			bra=$(git branch -a | grep -i $1 | cut -d '/' -f 3 | head -n $2 | tail -n 1 | sed 's/* //g')
		else
			bra=$(git branch -a | grep -w "$1$" | grep remotes | cut -c 18-)
			if [ -z "$bra" ]; then
				bra=$(git branch -a | grep -i $1 | grep remotes	| cut -c 18-)
			fi
			if [ -z "$bra" ]; then
				echo "Branch $1 not found"
				return 1
			fi
			if [ $(echo "$bra" | wc -l) -ge 2 ]; then
				echo "More than 1 branch found as below, change string"
				echo "$bra"
				return 1
			fi
			#bra=$(git branch -a | grep -i $1 | cut -d '/' -f 3 | head -n 1 | sed 's/* //g')
		fi
		git checkout $bra
	fi

	return 0
}

vcur_branch () {
	git branch | grep "*" | sed 's/* //g'
}
alias vcb="vcur_branch"

## Get current directory by removing '/' and absolute path
vget_cdir () {
	arr=($(echo $PWD | sed 's/\// /g' | sed 's/^.//g'))
	echo -n "${arr[-1]}"
}

vgit_clean () {
	git clean -fdxxx
	git reset
}

vcheckout_force () {
	fix_branch=$1
	tmp_branch_name=temp
	if [ $# -ne 1 ]; then
		echo "Usage: $FUNCNAME <fix-branch>"
		return 1
	fi

	git reset
	git fetch --all --tags
	git branch -D ${tmp_branch_name} 2>>/dev/null 1>>/dev/null
	git checkout -b ${tmp_branch_name}
	git checkout .
	git branch -D ${fix_branch}
	git checkout ${fix_branch}
	git pull
	git branch -D ${tmp_branch_name}
}

vrebase_force () {
	## Parent branch/base branch
	bbranch=$1
	fix_branch=$2
	tmp_branch_name=temp
	upstream=1
	if [ $# -ne 2 ]; then
		echo "Usage: $FUNCNAME <base-branch> <fix-branch>"
		return 1
	fi

	[[ $fix_branch == $bbranch ]] && return 1
	git reset
	git fetch --all --tags
	#git rebase --abort

	# Check if the fix branch has upstream flag
	git checkout .
	git checkout ${fix_branch}
	vis_upstream
	if [ $? == 0 ]; then
		# upstream is not found. meaning local branch
		upstream=0
	fi
	_origin=`git remote -v | grep "fetch" | awk '{print $1}'`

	git branch -D ${tmp_branch_name} 2>>/dev/null 1>>/dev/null
	git checkout -b ${tmp_branch_name}
	git checkout .
	git branch -D ${fix_branch}
	#Author=$(git for-each-ref --format='%(authorname) %09 %(refname)' --sort=committerdate | grep $2 | grep remote | awk '{print $1$2}')
	#if [ $Author == "VenkateshBolla" ]; then
	#       echo "=================> Delete the branch in the remote <====="
	#       #git push $_origin --delete ${fix_branch}
	#fi

	git branch -D ${bbranch}
	git checkout ${bbranch}
	git pull

	git checkout -b ${fix_branch}
	if [ "$upstream" == "1" ]; then
		git branch -u $_origin/`vcb`
	fi
	git branch -D ${tmp_branch_name}
	#XXX Venkatesh this could be the reason for PR auto decline problem
	#git push --set-upstream $_origin ${fix_branch} -f
}

vgit_tag () {
	#check whether this tag exist already or not
	if [ -z $1 ]; then
		echo "Error: tag is missing!!"
		echo "Usage: vgit_tag <tag>"
		return 1
	fi
	_origin=`git remote -v | grep "fetch" | awk '{print $1}'`
	_tag=$1
	git tag -d "$_tag" 1>>/dev/null 2>>/dev/null
	git fetch --all --tags
	result=`git tag -l $_tag`
	if [ "$result" != "" ]; then
		echo "version $_tag already exist via tag $result!!!"

		echo "###############################################"
		git log $_tag -1 --pretty=fuller
		echo "###############################################"

		yes_no_iterate "Do you want to overwrite the tag" "" "" "Stopped this tag script command now !" ""
		[[ $? -ne $(yesORno_to_num "yes") ]] && return 1

		git tag -d $_tag
		git push --delete $_origin "$_tag" 1>>/dev/null 2>>/dev/null
		echo Existing tag "$_tag" is deleted now. 

		git tag $_tag -a -m "Manually tagged"
		echo "tag $_tag is created now"
		cmd="git push $_origin $_tag -f"
		echo "cmd=$cmd"
		yes_no_iterate "Do you want to execute it to push $_tag" "tag $_tag is modifed and pushed" "$cmd" "" ""
		return 0
	fi

	yes_no_iterate "Do you want to create tag $_tag" "" "" "Stopped this tag script command now !" ""
	[[ $? -ne $(yesORno_to_num "yes") ]] && return 1

	##Create a new tag when remote doesnot have one
	git tag $_tag -a -m "Manually tagged"
	echo "tag $_tag is created now"
	cmd="git push $_origin $_tag"
	echo "cmd=$cmd"
	yes_no_iterate "Do you want to execute it to push $_tag to remote" "new tag $_tag is pushed" "$cmd" "" ""
	return 0
}

# Tells you the current branch is upstreamed or not
vis_upstream ()
{
	cbranch=`vcur_branch`
	up="No Upstream"
	ret=0
	_origin=`git remote -v | grep "fetch" | awk '{print $1}'`
	git status -sb | grep "##" | grep $_origin 1>>/dev/null
	if [ $? == 0 ]; then
		up="Upstream"
		ret=1
	fi
	echo "$cbranch: $up"

	return "$ret"
}

#Tag is given by user
vset_rel_tag () {
	cmd=""
	given_tag=""

	cdir=$(vget_cdir)
	if [ $cdir != "gwdpa-dpm" ]; then
		echo "Oops! Please execute this cmd in the gwdpa-dpm root dir"
		return 1
	fi

	if [[ $# != 2 ]]; then
		echo "Error: nargs: $#, args: $@"
		echo "Usage: $FUNCNAME <branch-str> <full-tag>"
		return 1
	fi

	GWDPA_DPM_ROOT=$PWD
	if [[ -z $1 ]]; then
		echo "Usage: $FUNCNAME <branch-str> <full-tag>"
		return 2
	fi

	if [[ $2 != "" ]]; then
		given_tag="$2"
	fi

	branch=$1
	vc $branch
	if [[ $? != 0 ]]; then
		echo "Error: Given branch is not exist"
		return 3
	fi

	cd ../feed_gwdpa-dpm
	if [ $? != 0 ]; then
		echo "Ohoh! no feed_gwdpa-dpm found"
		#return 1
		rm -rf feed_gwdpa-dpm
		git clone ssh://git@mbitbucket.maxlinear.com:29418/sw_ugw/feed_gwdpa-dpm.git
		[[ $? != 0 ]] && echo "Error: Clone failed" && return 1
		cd feed_gwdpa-dpm
	fi
	FEED_GWDPA_DPM_ROOT=$PWD
	vc $branch
	if [[ $? != 0 ]]; then
		echo "Error: Given branch is not exist"
		cd ..
		rm -rf feed_gwdpa-dpm
		return 4
	fi

	#GWDPA-DPM update master latest of origin/remote and check our branch is uptodate
	#with master
	cd $GWDPA_DPM_ROOT
	cbranch=`vcur_branch`
	if [ $cbranch == master ]; then
		echo "Fatal: Hey!! you are on master branch"
		return 5
	fi
	#Replace the ver.h
	ver=$(echo $given_tag | awk -F'.' '{print $4}' | awk -F_ '{print $1}')
	suffix=$(echo $given_tag | sed "s/${ver}_/X/g" | awk -F'X' '{print $2}')
	sed -i "/DP_VER_TAG/c\#define DP_VER_TAG ${ver}_${suffix}" datapath_ver.h

	
	echo ">>>>>>>>>> INFO:  new srcver: $given_tag,  new feedver: $given_tag <<<<<<<<<<"

	#push the version gwdpa-dpm in ver.h file to remote
	cd $GWDPA_DPM_ROOT
	if [ `vget_cdir` != "gwdpa-dpm" ]; then
		echo "Error: $LINENO, Current dir is not gwdpa-dpm"
		return 1
	fi

	# This condition checks whether the branch is upstreamed one or not
	# if not upstreamed it will set upstream flag
	_origin=`git remote -v | grep "fetch" | awk '{print $1}'`
	vis_upstream
	if [ "$?" == "0" ]; then
		git branch -u $_origin/`vcb`
	fi

	git add datapath_ver.h
	git commit -s --amend --no-edit
	git push -f

	##get commit msg from gwdpa-dpm and copy it feed_gwdpa-dpm
	rm -rf feed_commit_msg; git log -1 --pretty=format:"%s" >> feed_commit_msg; echo -e "\n" >> feed_commit_msg; git log -1 --pretty=format:"%b" >> feed_commit_msg; echo "" >> feed_commit_msg; git log -1 --pretty=format:"%N" >> feed_commit_msg
	feed_commit_msg_data=$(cat feed_commit_msg)
	rm -rf feed_commit_msg

	#Veirfy the tag and if exist then verify the commit id for the tag
	cd $GWDPA_DPM_ROOT
	git checkout $cbranch
	branch_commitid=$(git log -1 --pretty=format:"%H")
	#check if tag exist in remote or not
	_origin=`git remote -v | grep "fetch" | awk '{print $1}'`
	tag_commitid=$(git ls-remote --tags $_origin | grep $given_tag | tail -n 1 | awk '{print $1}')
	if [[ -z $branch_commitid ]] || [[ -z $tag_commitid ]] || [[ $branch_commitid != $tag_commitid ]]; then
		git fetch --all --tags
		#create the tag and push to remote
		vgit_tag $given_tag
		echo "$cbranch: $branch_commitid"
		echo "$given_tag: $tag_commitid"
	fi
	#Veirfy the tag and if exist then verify the commit id for the tag
	cd $GWDPA_DPM_ROOT
	git checkout $cbranch
	branch_commitid=$(git log -1 --pretty=format:"%H")
	tag_commitid=$(git log $given_tag -1 --pretty=format:"%H")
	if [[ -z $branch_commitid ]] || [[ -z $tag_commitid ]] || [[ $branch_commitid != $tag_commitid ]]; then
		echo "$cbranch: $branch_commitid"
		echo "$given_tag: $tag_commitid"
		echo "Error: Tag may not be yours! branch & tag commit ids not match"
		return 1
	else
		echo "Tag is intact and exist in remote"
		echo "======> $cbranch: $branch_commitid   <========"
		echo "======> $given_tag: $tag_commitid  <========"
	fi

	#generate & update the hash in feed dpm/Makefile
	cd $GWDPA_DPM_ROOT
	new_hash_line=$(vhash dpm "${given_tag}")
	new_hash=$(echo $new_hash_line | awk '{print $5}')
	tarball_name=$(echo $new_hash_line | awk '{print $3}')

	#check the tarball name
	if [[ $tarball_name != gwdpa-dpm-${given_tag}.tar.xz ]]; then
		echo "Error1: The tagged tarball is not correct, Hash may be wrong"
		echo "Error1: $new_hash_line"
		echo "Error1: $tarball_name :: gwdpa-dpm-${given_tag}.tar.xz"
		return 1
	fi

	cd $FEED_GWDPA_DPM_ROOT
	if [ $? != 0 ]; then
		echo "Ohoh! no feed_gwdpa-dpm found"
		return 1
	fi
	git checkout $cbranch
	
	# Reading the feed version
	FEED_VER=$(grep -r "^PKG_SOURCE_VERSION:=" dpm/Makefile | tail -n 1)
	FEED_VER=${FEED_VER:20}
	# Replacing the feed version
	sed -i "s/$FEED_VER/${given_tag}/g" dpm/Makefile

	# Replacing the hash in the feeds
	sed -i "/PKG_MIRROR_HASH:=/c\PKG_MIRROR_HASH:=${new_hash}" dpm/Makefile
	echo ">>>>>>>>>> NEW GEN PKG_MIRROR_HASH: $new_hash tarball: $tarball_name <<<<<<<<<<"
	git add dpm/Makefile
	if [[ ! -z "$feed_commit_msg_data" ]]; then
		rm -rf feed_commit_msg
		echo "$feed_commit_msg_data" >> feed_commit_msg
		if [[ -f feed_commit_msg ]]; then
			cmd="-eF feed_commit_msg"
		fi
	fi
	git commit -s $cmd
	_origin=`git remote -v | grep "fetch" | awk '{print $1}'`
	git push --set-upstream $_origin ${cbranch} -f
	rm -rf feed_commit_msg
	
	cd ${GWDPA_DPM_ROOT}
	rm -rf ${GWDPA_DPM_ROOT}/feed_gwdpa-dpm

	vprint_mxl_PR_notes
}

vprint_mxl_PR_notes () {
	cb=$(vcur_branch)
	PR_notes_title=$cb
	PR_notes_title_arr=($(echo $PR_notes_title | sed 's/-/ /g' | sed 's/lgm-5//g' | sed 's/-/ /g'))
	PR_notes_title_arr[0]=
	PR_notes_title_arr[1]=
	PR_notes_title=$(echo ${PR_notes_title_arr[@]} | sed 's/  //g' | sed 's/\.//g')
	PR_notes_issue="$(echo $cb | sed 's/\// /g' | awk '{print $(NF)}' | sed 's/-/ /g' | awk '{printf "%s-%s", $1, $2}')"

	echo ""
	echo "============================ PR notes ============================"
	echo "Title: DPM $PR_notes_title"
	echo "Issue: $PR_notes_issue"
	echo "System Impact: new feature/fix"
	echo "Resolution: DPM new feature/enhancement/fix"
	echo "Signed-off-by: Venkatesh Bolla <vbolla@maxlinear.com>"
	echo ""
}

yesORno_to_num () {
	if [[ $1 == "yes" ]]; then
		echo 111
	elif [[ $1 == "no" ]]; then
		echo 112
	else
		echo 123
	fi
}

yes_no_iterate() {
	msg="$1"
	yesMsg="$2"
	yesFunc="$3"
	noMsg="$4"
	noFunc="$5"

	while true; do
		echo ""
		read -p "$msg [Y/N]: " -n 1 -r
		if [[ $REPLY =~ ^[Nn]$ ]]; then
			echo ""
			echo "$noMsg"
			#exec function
			[[ "$noFunc" != "" ]] && eval "$noFunc"
			return $(yesORno_to_num "no")
		elif [[ $REPLY =~ ^[Yy]$ ]]; then
			echo ""
			echo "$yesMsg"
			#exec function
			[[ "$yesFunc" != "" ]] && eval "$yesFunc"
			return $(yesORno_to_num "yes")
		else
			echo ""
			echo "Invalid input, only Y/y/N/n are allowed"
		fi
	done

	return $(yesORno_to_num "invalid")
}

## Create/update the tag and hash for release push(for PR)
## Tag is auto generated
vgen_rel_tag () {
	need_src_update=0
	cmd=""
	pulled=0
	tmp_tag_flag=0
	jira_id=""

	cdir=$(vget_cdir)
	if [ $cdir != "gwdpa-dpm" ]; then
		echo "Oops! Please execute this cmd in the gwdpa-dpm root dir"
		return 1
	fi

	if [[ $# != 2 ]] && [[ $# != 1 ]]; then
		echo "Error: nargs: $#, args: $@"
		echo "Usage: $FUNCNAME <branch-str> <optional:tmp>"
		return 1
	fi

	GWDPA_DPM_ROOT=$PWD
	if [[ -z $1 ]]; then
		echo "Usage: $FUNCNAME <branch-str> <optional:tmp>"
		return 2
	fi

	if [[ $2 == "tmp" ]]; then
		tmp_tag_flag=1
	fi

	branch=$1
	vc $branch
	if [[ $? != 0 ]]; then
		echo "Error: Given branch is not exist"
		return 3
	fi

	cd ../feed_gwdpa-dpm
	if [ $? != 0 ]; then
		echo "Ohoh! no feed_gwdpa-dpm found"
		#return 1
		rm -rf feed_gwdpa-dpm
		git clone ssh://git@mbitbucket.maxlinear.com:29418/sw_ugw/feed_gwdpa-dpm.git
		[[ $? != 0 ]] && echo "Error: Clone failed" && return 1
		pulled=1
		cd feed_gwdpa-dpm
	fi
	FEED_GWDPA_DPM_ROOT=$PWD
	vc $branch
	if [[ $? != 0 ]]; then
		echo "Error: Given branch is not exist"
		return 4
	fi

	jira_id="$(echo $branch | sed 's/\// /g' | awk '{print $(NF)}' | sed 's/-/ /g' | awk '{printf "%s-%s", $1, $2}')"
	#GWDPA-DPM update master latest of origin/remote and check our branch is uptodate
	#with master
	cd $GWDPA_DPM_ROOT
	cbranch=`vcur_branch`
	if [ $cbranch == master ]; then
		echo "Fatal: Hey!! you are on master branch"
		return 5
	fi
	echo "Force updating master from origin"
	vcheckout_force master
	src_master_branch_commitid=$(git log -1 --pretty=format:"%H")
	git checkout $cbranch
	echo "Rebasing $cbranch to master..."
	git rebase master
	if [ $? != 0 ]; then
		echo "Error: Rebase $cbranch to latest master Failed"
		return 6
	fi
	src_PR_branch_commitid=$(git log -1 --pretty=format:"%H")
	if [[ $src_master_branch_commitid == $src_PR_branch_commitid ]]; then
		echo "Error: There is master HEAD and PR-branch HEAD are same, meaning no PR changes found"
		return 1
	fi
	## Always get the tag from the master
	git checkout master
	SRC_VER=$(grep "DP_VER" datapath_ver.h | awk '{print $3}' | sed ':a;N;$!ba;s/\n/./g')
	git checkout $cbranch

	#FEED GWDPA_DPM update master
	cd $FEED_GWDPA_DPM_ROOT
	vcheckout_force master
	feed_master_branch_commitid=$(git log -1 --pretty=format:"%H")
	git checkout $cbranch
	feed_PR_branch_commitid=$(git log -1 --pretty=format:"%H")
	#if [[ $feed_master_branch_commitid != $feed_PR_branch_commitid ]]; then
		# There is a commit msg, save it to automate the feed tag update
		#Save the git commit message for new commit usage
	#	rm -rf glog; git log -1 --pretty=format:"%s" >> glog; echo -e "\n" >> glog; git log -1 --pretty=format:"%b" >> glog; echo "" >> glog; git log -1 --pretty=format:"%N" >> glog
	#	git_commit_msg=$(cat glog)
	#	rm -rf glog
	#fi
	
	#FEED GWDPA_DPM force copy as equal to latest master
	echo "Force rebasing feeds $cbranch to master"
	vrebase_force master $cbranch 2>>/dev/null 1>>/dev/null
	FEED_VER=$(grep -r "PKG_SOURCE_VERSION:=" dpm/Makefile | tail -n 1)
	FEED_VER=${FEED_VER:20}

	if [ ${FEED_VER} != ${SRC_VER} ]; then
		echo ""
		echo "Error: RelativeLineNo:$LINENO, FEED_VER: ${FEED_VER} and SRC_VER: $SRC_VER is not match"
		yes_no_iterate "Do you want to change SRC_VER to $FEED_VER" "Changing SRC_VER to $FEED_VER .." "SRC_VER=$FEED_VER" "Aborted" "cd -"
		[[ $? -ne $(yesORno_to_num "yes") ]] && return 1
	fi
	echo ">>>>>>>>>> INFO: master curr srcver: $SRC_VER, curr feedver: $FEED_VER <<<<<<<<<<"

	#calc the new tag for feed and src
	SRC_TAG=$(echo $SRC_VER | sed 's/\./ /g' | awk '{print $4}')
	SRC_NEW_TAG=$(($SRC_TAG + 1))
	#Create tmp flag by adding "jira_id" at the end
	if [[ $tmp_tag_flag == 1 ]]; then
		SRC_NEW_TAG="$SRC_NEW_TAG-$jira_id"
	fi
	SRC_NEW_VER=$(echo $SRC_VER | sed 's/\./\n/g' | head -n 3 | sed ':a;N;$!ba;s/\n/./g')
	SRC_NEW_VER="$SRC_NEW_VER.$SRC_NEW_TAG"
	FEED_TAG_ARR=($(echo $FEED_VER | sed 's/\./ /g'))
	FEED_TAG=${FEED_TAG_ARR[-1]}
	FEED_NEW_TAG=$(($FEED_TAG + 1))
	#Create tmp flag by adding "jira_id" at the end
	if [[ $tmp_tag_flag == 1 ]]; then
		FEED_NEW_TAG="$FEED_NEW_TAG-$jira_id"
	fi
	FEED_TAG_ARR[-1]=$FEED_NEW_TAG
	FEED_NEW_VER=$(echo ${FEED_TAG_ARR[@]} | sed 's/ /./g')
	#checking version match for feed and src
	if [ $FEED_NEW_VER != $SRC_NEW_VER ]; then
		echo "Error: FEED_NEW_VER: $FEED_NEW_VER and SRC_NEW_VER: $SRC_NEW_VER is not match"
		return 1
	fi

	# Get the PR branch versions
	cd $FEED_GWDPA_DPM_ROOT
	git checkout $cbranch
	FEED_PR_VER=$(grep -r "^PKG_SOURCE_VERSION:=" dpm/Makefile | tail -n 1)
	FEED_PR_VER=${FEED_PR_VER:20}
	cd $GWDPA_DPM_ROOT
	git checkout $cbranch
	SRC_PR_VER=$(grep "DP_VER" datapath_ver.h | awk '{print $3}' | sed ':a;N;$!ba;s/\n/./g')
	
	# Check the whether the update is needed or not for src ver
	if [ $SRC_PR_VER != $SRC_NEW_VER ]; then
		need_src_update=1
		sed -i "/DP_VER_TAG/c\#define DP_VER_TAG $SRC_NEW_TAG" datapath_ver.h
	else
		need_src_update=0
		echo "SRC_VER=$SRC_NEW_VER is already updated in the file"
	fi
	# Reading back if the file has intended version or not
	SRC_PR_VER=$(grep "DP_VER" datapath_ver.h | awk '{print $3}' | sed ':a;N;$!ba;s/\n/./g')
	if [ $SRC_PR_VER != $SRC_NEW_VER ]; then
		echo "Error: SRC version could not updated!!" 
		return 1
	fi

	# check if the update is needed for the feeds dpm/Makefile
	cd $FEED_GWDPA_DPM_ROOT
	if [ $? != 0 ]; then
		echo "Ohoh! no feed_gwdpa-dpm found"
		return 1
	fi
	git checkout $cbranch
	if [ $FEED_PR_VER != $FEED_NEW_VER ]; then
		sed -i "s/$FEED_VER/${FEED_NEW_VER}/g" dpm/Makefile
	else
		echo "FEED_VER=$FEED_NEW_VER is already updated in the file"
	fi
	# Reading back if the file has intended version or not
	FEED_PR_VER=$(grep -r "^PKG_SOURCE_VERSION:=" dpm/Makefile | tail -n 1)
	FEED_PR_VER=${FEED_PR_VER:20}
	if [ $FEED_PR_VER != $FEED_NEW_VER ]; then
		echo "Error: FEED version could not updated!!" 
		return 1
	fi

	echo ">>>>>>>>>> INFO:  new srcver: $SRC_NEW_VER,  new feedver: $FEED_NEW_VER <<<<<<<<<<"

	#push the version gwdpa-dpm in ver.h file to remote
	cd $GWDPA_DPM_ROOT
	if [ `vget_cdir` != "gwdpa-dpm" ]; then
		echo "Error: $LINENO, Current dir is not gwdpa-dpm"
		return 1
	fi

	# This condition checks whether the branch is upstreamed one or not
	# if not upstreamed it will set upstream flag
	vis_upstream
	if [ "$?" == "0" ]; then
		_origin=`git remote -v | grep "fetch" | awk '{print $1}'`
		git branch -u $_origin/`vcb`
	fi

	# This condition added because, if you ammend even there is no change
	# the commit id will change (even there are no changes)
	# This inturn causes the gwdpa_feed hash mis-match
	if [ $need_src_update == 1 ]; then
		git add datapath_ver.h
		git commit -s --amend --no-edit
		git push -f
	fi

	##get commit msg from gwdpa-dpm and copy it feed_gwdpa-dpm
	rm -rf feed_commit_msg; git log -1 --pretty=format:"%s" >> feed_commit_msg; echo -e "\n" >> feed_commit_msg; git log -1 --pretty=format:"%b" >> feed_commit_msg; echo "" >> feed_commit_msg; git log -1 --pretty=format:"%N" >> feed_commit_msg
	feed_commit_msg_data=$(cat feed_commit_msg)
	rm -rf feed_commit_msg

	#Veirfy the tag and if exist then verify the commit id for the tag
	cd $GWDPA_DPM_ROOT
	git checkout $cbranch
	branch_commitid=$(git log -1 --pretty=format:"%H")
	#check if tag exist in remote or not
	_origin=`git remote -v | grep "fetch" | awk '{print $1}'`
	tag_commitid=$(git ls-remote --tags $_origin | grep $SRC_NEW_VER | tail -n 1 | awk '{print $1}')
	if [[ -z $branch_commitid ]] || [[ -z $tag_commitid ]] || [[ $branch_commitid != $tag_commitid ]]; then
		#delete if any "jira_id" tag exist for this version.
		git fetch --all --tags
		git tag -d "$_tag-$jira_id" 1>>/dev/null 2>>/dev/null
		git push --delete $_origin "$_tag-$jira_id" 1>>/dev/null 2>>/dev/null
		#create the tag and push to remote
		vgit_tag $SRC_NEW_VER
		echo "$cbranch: $branch_commitid"
		echo "$SRC_NEW_VER: $tag_commitid"
	fi
	#Veirfy the tag and if exist then verify the commit id for the tag
	cd $GWDPA_DPM_ROOT
	git checkout $cbranch
	branch_commitid=$(git log -1 --pretty=format:"%H")
	tag_commitid=$(git log $SRC_NEW_VER -1 --pretty=format:"%H")
	if [[ -z $branch_commitid ]] || [[ -z $tag_commitid ]] || [[ $branch_commitid != $tag_commitid ]]; then
		echo "$cbranch: $branch_commitid"
		echo "$SRC_NEW_VER: $tag_commitid"
		echo "Error: Tag may not be yours! branch & tag commit ids not match"
		return 1
	else
		echo "Tag is intact and exist in remote"
		echo "======> $cbranch: $branch_commitid   <========"
		echo "======> $SRC_NEW_VER: $tag_commitid  <========"
	fi
	#generate & update the hash in feed dpm/Makefile
	cd $GWDPA_DPM_ROOT
	# TO gen hash, all it matters is tag should be(pushed) in remote repo
	# and -b branch HEAD be at the commit-id of your change, branch name
	# does not matter
	## XXX OLD WAY
	#new_hash_line=$(populate_mirror_hash.sh -n "feed_gwdpa-dpm" -b "${cbranch}" -t "${FEED_NEW_VER}" -l "master" | tail -n 1)
	#new_hash=$(echo $new_hash_line | awk '{print $1}')
	#tarball_name=$(echo $new_hash_line | awk '{print $2}')
	## XXX NEW WAY
	new_hash_line=$(vhash dpm "${FEED_NEW_VER}")
	new_hash=$(echo $new_hash_line | awk '{print $5}')
	tarball_name=$(echo $new_hash_line | awk '{print $3}')
	tarball_name=${tarball_name::-1}

	#check the tarball name
	if [[ $tarball_name != gwdpa-dpm-${SRC_NEW_VER}.tar.xz ]]; then
		echo "Error2: The tagged tarball is not correct, Hash may be wrong"
		echo "Error2: $new_hash_line"
		echo "Error2: $tarball_name :: gwdpa-dpm-${SRC_NEW_VER}.tar.xz"
		return 2
	fi

	# Verify the gen hash and PR hash
	cd $FEED_GWDPA_DPM_ROOT
	git checkout $cbranch
	PR_hash=$(grep "PKG_MIRROR_HASH" dpm/Makefile | sed 's/=/ /g' | awk '{print $NF}')
	if [[ $new_hash != $PR_hash ]]; then
		sed -i "/PKG_MIRROR_HASH:=/c\PKG_MIRROR_HASH:=${new_hash}" dpm/Makefile
	fi
	echo ">>>>>>>>>> NEW GEN PKG_MIRROR_HASH: $new_hash tarball: $tarball_name <<<<<<<<<<"
	git add dpm/Makefile
	if [[ ! -z "$feed_commit_msg_data" ]]; then
		rm -rf feed_commit_msg
		echo "$feed_commit_msg_data" >> feed_commit_msg
		if [[ -f feed_commit_msg ]]; then
			cmd="-eF feed_commit_msg"
		fi
	fi
	git commit -s $cmd
	_origin=`git remote -v | grep "fetch" | awk '{print $1}'`
	git push --set-upstream $_origin ${cbranch} -f
	rm -rf feed_commit_msg
	
	cd ${GWDPA_DPM_ROOT}
	rm -rf ${GWDPA_DPM_ROOT}/feed_gwdpa-dpm

	vprint_mxl_PR_notes
}

vgen_hash_on_tag () {
	#I think branch name is not compulsory
	#but tag is mandatory as it downloads the tarball
	cbra=`vcur_branch`
	TMP_BRANCH="tmp_hash_cal"
	cdir=$(vget_cdir)
	if [ $cdir != "gwdpa-dpm" ]; then
		echo "Oops! Please execute this cmd in the gwdpa-dpm root dir"
		return 1
	fi
	GWDPA_DPM_ROOT=$PWD
	if [[ -z $1 ]]; then
		echo "Usage: $FUNCNAME <tag>"
		return 1
	fi
	tagname=$1

	#check if tag exist in remote or not
	_origin=`git remote -v | grep "fetch" | awk '{print $1}'`
	tag_commitid=$(git ls-remote --tags $_origin | grep $tagname | tail -n 1 | awk '{print $1}')
	if [[ -z $tag_commitid ]]; then
		echo "Error: Tag does not exists in remote"
		return 1
	fi
	
	#Tag exists, checkout and create a temp branch
	git checkout .
	git checkout master
	git branch -D $TMP_BRANCH
	git checkout $tagname -b $TMP_BRANCH
	if [[ $? != 0 ]]; then
		echo "Error: Given tag is not exist"
		return 1
	fi
	#push for tag cal
	_origin=`git remote -v | grep "fetch" | awk '{print $1}'`
	git push --set-upstream $_origin ${TMP_BRANCH} -f

	#generate the hash
	# TO gen hash, all it matters is tag should be(pushed) in remote repo
	# and -b branch HEAD be at the commit-id of your change, branch name
	# does not matter
	new_hash_line=$(populate_mirror_hash.sh -n "feed_gwdpa-dpm" -b "${TMP_BRANCH}" -t "${tagname}" -l "master" | tail -n 1)
       	new_hash=$(echo $new_hash_line | awk '{print $1}')
	tarball_name=$(echo $new_hash_line | awk '{print $2}')

	#delete the tmp branch
	git checkout .
	git checkout $cbra
	git branch -D $TMP_BRANCH
	_origin=`git remote -v | grep "fetch" | awk '{print $1}'`
	git push $_origin --delete $TMP_BRANCH
	echo ">>>>>>>>> tag: $tagname, hash: $new_hash <<<<<<<<<<<<"
	
	#check the tarball name
	if [[ $tarball_name != gwdpa-dpm-${tagname}.tar.xz ]]; then
		echo "Error3: The tagged tarball is not correct, Hash may be wrong"
		echo "Error3: $tarball_name :: gwdpa-dpm-${tagname}.tar.xz"
		return 3
	fi
}

vsrc_cmp () {
	src1=$1
	src2=$2

	if [[ -z $src1 ]] || [[ -z $src2 ]]; then
		echo "Usage: $FUNCNAME <src1> <src2>"
		return 1
	elif [[ $src1 == $src2 ]]; then
		echo "$src1 == $src2"
		return 0
	elif [[ ! -e $src1 ]] || [[ ! -e $src2 ]]; then
		echo "Error: $src1 or $src2 not exist"
		return 2
	fi

	if [[ -f $src1 ]] && [[ -f $src2 ]]; then
		mode="file"
	elif [[ -d $src1 ]] && [[ -d $src2 ]]; then
		mode="dir"
		rm -rf $src1/.*.swp $src1/.*.un~
		rm -rf $src2/.*.swp $src2/.*.un~
		if [[ `find $src1 -type f | wc -l` -ne `find $src2 -type f | wc -l` ]]; then
			echo "Number of files check: count mismatch"
			echo "$src1 != $src2"
			return 0
		fi
	else
		echo "$src1 and $src2 type mismatch"
		echo "Both should be of same type"
		return 3
	fi

	#make src1 and src2 as absolute paths(if not already abs path)
	src1=$(vmk_absolute_path $src1)
	src2=$(vmk_absolute_path $src2)

	if [[ $mode == "dir" ]]; then
		#For dir mode, both src1 and src2 should have same file name
		cd $src1
		for i in `find . -type f`; do
			if [[ ! -f $src2/$i ]]; then
				echo "Not exist: $src2/$i"
				echo "$src1 != $src2"
				cd - 1>>/dev/null
				return 0
			fi
			if [[ "$(md5sum $i | awk '{print $1}')" != "$(md5sum $src2/$i | awk '{print $1}')" ]]; then
				echo "$i: differ";
				echo "$src1 != $src2"
				cd - 1>>/dev/null
				return 0
			fi
		done
		cd - 1>>/dev/null
	else
		#For file mode, file name doesnot matter, as long as both have
		#same contents
		if [[ "$(md5sum $src1 | awk '{print $1}')" != "$(md5sum $src2 | awk '{print $1}')" ]]; then
			echo "File mismatched"
			echo "$src1 != $src2"
			return 0
		fi
	fi

	echo "$src1 == $src2"
	return 0
}

vgen_hash_on_tag_optimized () {

	if [ -z $2 ] || [ -z $1 ]; then
		echo "Usage: $FUNCNAME <dpm|dbg> <remote-git-tag>"
		return 1
	fi

	if [ "$1" == "dpm" ]; then
		PKG=gwdpa-dpm   # as per feeds Makefile
		URL=ssh://git@mbitbucket.maxlinear.com:29418/sw_ugw/$PKG.git
	elif [ "$1" == "dbg" ]; then
		PKG=dp_dbg      # as per feeds Makfile
		URL=ssh://git@mbitbucket.maxlinear.com:29418/sw_tcbootrom/dpm_bsp_test.git
	else
		echo "Error: Unknow package: $1"
		return 39
	fi
	PKG_TAG=$2
	DIR=$PKG-$PKG_TAG
	PKG_NAME=$DIR.tar.xz
	
	git clone $URL $DIR 2>>/dev/null 1>>/dev/null
	cd $DIR

	git fetch --all --tags 2>>/dev/null 1>>/dev/null

	#check if tag exist or not
	_origin=`git remote -v | grep "fetch" | awk '{print $1}'`
	tag_commitid=$(git ls-remote --tags $_origin | grep $PKG_TAG | tail -n 1 | awk '{print $1}')
	if [[ -z $tag_commitid ]]; then
		echo "Error: Tag does not exists in remote"
		cd -
		rm -rf $PKG_NAME
		rm -rf $DIR
		return 1
	fi
	git checkout $PKG_TAG 2>>/dev/null 1>>/dev/null
	if [ $? != 0 ]; then
		echo "Error: Tag checkout($PKG_TAG) failed"
		cd -
		rm -rf $PKG_NAME
		rm -rf $DIR
		return 1
	fi

	TAR_TIMESTAMP=`git log -1 --format='@%ct'`
	commitid=$(git log -1 --pretty=format:"%h")
	rm -rf gated_check_in.json .git*
	cd .. 2>>/dev/null 1>>/dev/null

	#For doing tar, 2 major inputs are git log timestamp of last commit and
	#-c directory name, if $DIR must be $PKG-$PKG_TAG --> PKG must match
	#with the feeds package name., any mismatch in the inputs, then hash
	#will be different
	tar --numeric-owner --owner=0 --group=0 --mode=a-s --sort=name ${TAR_TIMESTAMP:+--mtime="$TAR_TIMESTAMP"} -c $DIR | xz -zc -7e > ${PKG_NAME}

	hash_str=$(sha256sum $PKG_NAME)

	echo "=====>>>>> pkg: $PKG_NAME, hash: $hash_str commitid: $commitid"
	
	rm -rf $PKG_NAME
	rm -rf $DIR
}

#This is on master, for already commited
#This takes the gwdpa-dpm-feeds master branch
#and find out the hash pushed for the given tag in the makefile
#by iterating all the commits and verify.
vgen_hash_on_tag_optimized_verify () {
	
	if [ -z $1 ]; then
		echo "Usage: $FUNCNAME <remote-git-tag>"
		return 1
	fi
	
	src_tag=$1
	src_hash=$(vgen_hash_on_tag_optimized dpm $src_tag | awk '{print $5}')
	if [ -z $src_hash ]; then
		echo "Error: tag($src_tag) may be wrongly given."
		return 1
	fi	

	DIR_name="feed_gwdpa-dpm"
	git clone ssh://git@mbitbucket.maxlinear.com:29418/sw_ugw/feed_gwdpa-dpm.git $DIR_name 2>>/dev/null 1>>/dev/null
	cd $DIR_name
	git checkout master 2>>/dev/null 1>>/dev/null
	
	while true; do
		feed_tag=$(grep "^PKG_SOURCE_VERSION" dpm/Makefile | sed 's/=/ /g' | awk '{print $NF}')
		if [[ $feed_tag == $src_tag ]]; then
			#found the tag
			feed_commitid=$(git log -1 --pretty=format:"%H")
			break;
		fi
		
		#walking down by commits, till it matches
		git reset --hard HEAD~1 2>>/dev/null 1>>/dev/null
		if [ $? != 0 ]; then
			echo "Error: Could not find the given tag."
			break;
		fi
	done
	feed_hash=$(grep "^PKG_MIRROR_HASH" dpm/Makefile | sed 's/=/ /g' | awk '{print $NF}')
	echo -e "tag: $src_tag \nfeed_hash: $feed_hash \nsrc_hash: $src_hash \nfeed_commitid for tag: $feed_commitid"
	if [[ $feed_hash != $src_hash ]]; then
		echo "Error: feed hash and src hash did not match"
	else
		echo "Success: feed hash and src hash matched!!"
	fi
	
	cd ..
	rm -rf $DIR_name
}

#Verify the generated rel tag on PR, its on still PR
vgen_verify_rel_tag () {
	cdir=$(vget_cdir)
	if [ $cdir != "gwdpa-dpm" ]; then
		echo "Oops! Please execute this cmd in the gwdpa-dpm root dir"
		return 1
	fi
	GWDPA_DPM_ROOT=$PWD
	if [[ -z $1 ]]; then
		echo "Usage: $FUNCNAME <branch-str>"
		return 1
	fi
	branch=$1
	git checkout $branch
	if [[ $? != 0 ]]; then
		echo "Error: Given branch is not exist"
		return 1
	fi
	cd ../feed_gwdpa-dpm
	if [ $? != 0 ]; then
		echo "Ohoh! no feed_gwdpa-dpm found"
		return 1
	fi
	FEED_GWDPA_DPM_ROOT=$PWD
	git checkout $branch

	#GWDPA-DPM update master latest of origin/remote and check our branch is uptodate
	#with master
	cd $GWDPA_DPM_ROOT
	cbranch=`vcur_branch`
	if [ $cbranch == master ]; then
		echo "Fatal: Hey!! you are on master branch"
		return 1
	fi
	echo "Force updating master from origin"
	vcheckout_force master
	git checkout $cbranch
	echo "Rebasing $cbranch to master..."
	git rebase master
	if [ $? != 0 ]; then
		echo "Error: Rebase $cbranch to latest master Failed"
		return 1
	fi
	## Always get the tag from the master
	git checkout master
	SRC_VER=$(grep "DP_VER" datapath_ver.h | awk '{print $3}' | sed ':a;N;$!ba;s/\n/./g')
	git checkout $cbranch

	#FEED GWDPA_DPM get version
	cd $FEED_GWDPA_DPM_ROOT
	git checkout master
	FEED_VER=$(grep -r "PKG_SOURCE_VERSION:=" dpm/Makefile | tail -n 1)
	FEED_VER=${FEED_VER:20}
	git checkout $cbranch

	if [ ${FEED_VER} != ${SRC_VER} ]; then
		echo "Error: $LINENO FEED_VER: ${FEED_VER} and SRC_VER: $SRC_VER is not match"
		return 1
	fi
	echo ">>>>>>>>>> INFO: master: curr srcver: $SRC_VER, curr feedver: $FEED_VER <<<<<<<<<<"

	#get the new tag for feed and src
	SRC_TAG=$(echo $SRC_VER | sed 's/\./ /g' | awk '{print $4}')
	#SRC_TAG=$(echo $SRC_VER | awk -F"." '{print $4}')
	SRC_NEW_TAG=$(($SRC_TAG + 1))
	FEED_TAG_ARR=($(echo $FEED_VER | sed 's/\./ /g'))
	FEED_TAG=${FEED_TAG_ARR[-1]}
	FEED_NEW_TAG=$(($FEED_TAG + 1))
	FEED_TAG_ARR[-1]=$FEED_NEW_TAG
	FEED_NEW_VER=$(echo ${FEED_TAG_ARR[@]} | sed 's/ /./g')

	cd $GWDPA_DPM_ROOT
	SRC_NEW_VER=$(grep "DP_VER" datapath_ver.h | grep -v TAG | awk '{print $3}' | sed ':a;N;$!ba;s/\n/./g')
	SRC_NEW_VER+="."$((SRC_NEW_TAG))

	# Get PR versions
	cd $FEED_GWDPA_DPM_ROOT
	git checkout $cbranch
	FEED_PR_VER=$(grep -r "PKG_SOURCE_VERSION:=" dpm/Makefile | tail -n 1)
	FEED_PR_VER=${FEED_PR_VER:20}
	cd $GWDPA_DPM_ROOT
	git checkout $cbranch
	SRC_PR_VER=$(grep "DP_VER" datapath_ver.h | awk '{print $3}' | sed ':a;N;$!ba;s/\n/./g')

	#check
	if [[ $FEED_NEW_VER != $SRC_NEW_VER ]] || [[ $FEED_NEW_VER != $FEED_PR_VER  ]] ||
		[[ $SRC_NEW_VER != $SRC_PR_VER ]]; then
		echo "Error: Some below did not match"
		echo "FEED_NEW_VER: $FEED_NEW_VER and SRC_NEW_VER: $SRC_NEW_VER"
		echo "FEED_PR_VER : $FEED_PR_VER  and SRC_PR_VER : $SRC_PR_VER"
		return 1
	fi
	echo ">>>>>>>>>> INFO:   PR srcver: $SRC_PR_VER,  PR feedver: $FEED_PR_VER <<<<<<<<<<"


	#Veirfy the tag and if exist then verify the commit id for the tag
	cd $GWDPA_DPM_ROOT
	git checkout $cbranch
	branch_commitid=$(git log -1 --pretty=format:"%H")
	_origin=`git remote -v | grep "fetch" | awk '{print $1}'`
	tag_commitid=$(git ls-remote --tags $_origin | grep $SRC_NEW_VER | tail -n 1 | awk '{print $1}')
	if [[ -z $tag_commitid ]]; then
		echo "Error: Tag does not exists in remote"
		return 1
	elif [[ $branch_commitid != $tag_commitid ]]; then
		echo "$cbranch: $branch_commitid"
		echo "$SRC_NEW_VER: $tag_commitid"
		echo "Error: Tag may not be yours! branch & tag commit ids not match"
		return 1
	else
		echo "Tag is intact and exist in remote"
		echo "======> $cbranch: $branch_commitid   <========"
		echo "======> $SRC_NEW_VER: $tag_commitid  <========"
	fi


	#generate the hash
	cd $GWDPA_DPM_ROOT
	git checkout $cbranch
	# TO gen hash, all it matters is tag should be(pushed) in remote repo
	# and -b branch HEAD be at the commit-id of your change, branch name
	# does not matter
	new_hash_line=$(populate_mirror_hash.sh -n "feed_gwdpa-dpm" -b "${cbranch}" -t "${FEED_NEW_VER}" -l "master" | tail -n 1)
       	new_hash=$(echo $new_hash_line | awk '{print $1}')
	tarball_name=$(echo $new_hash_line | awk '{print $2}')
	#check the tarball name
	if [[ $tarball_name != gwdpa-dpm-${SRC_NEW_VER}.tar.xz ]]; then
		echo "Error4: The tagged tarball is not correct, Hash may be wrong"
		echo "Error4: $tarball_name :: gwdpa-dpm-${given_tag}.tar.xz"
		return 4
	fi

	#verify gen hash and PR hash
	cd $FEED_GWDPA_DPM_ROOT
	git checkout $cbranch
	PR_tag=$(grep "^PKG_SOURCE_VERSION" dpm/Makefile | sed 's/=/ /g' | awk '{print $NF}')
	PR_hash=$(grep "^PKG_MIRROR_HASH" dpm/Makefile | sed 's/=/ /g' | awk '{print	$NF}')
	if [[ $FEED_NEW_VER != $PR_tag ]]; then
		echo "Error: PR tag and feed tag did not match"
		return 1
	fi
	if [[ $new_hash != $PR_hash ]]; then
		echo "Error: PR hash and new hash did not match"
		return 1
	fi
	
	echo ">>>>>>>>>> GEN tag: $FEED_NEW_VER PKG_MIRROR_HASH: $new_hash tarball: $tarball_name <<<<<<<<<<"
	cd ${GWDPA_DPM_ROOT}
}

## Create temp tag for CI builds
vgen_tmp_tag () {
	vgen_rel_tag "$1" "tmp"
}

kwenvset () {
	cdir=$(vget_cdir)
	if [ $cdir != "openwrt" ]; then
		echo "Error: CWD is not openwrt!!"
		return -1
	fi

	if [ -z $1 ]; then
		echo "Usage: $FUNCNAME <UGW_8.x_prx321_sfu/UGW_8_x_lgm>"
		return -1
	fi
	rm -rf .kw*
	#echo "Enter your phoenix username and password when prompted.."
	kwauth --url https://ilklocwork.maxlinear.com:8080 #-> phoenix login/password
	kwcheck create --url https://ilklocwork.maxlinear.com:8080/$1
}

kwenvdel () {
	[[ -z $KW_INJECT_SOCK ]] && \
		echo "=======> Error: Shud be executed in \"kwshell\" <========" && \
	       	return
	#rm -rf /home/$USER/.klocwork
	exit 0
}

is_kw_shell () {

	if [[ -z $KW_INJECT_SOCK ]]; then
		echo "No"
	else
		echo "Yes"
	fi
}

kwrun () {
	severity="1,2"
	if [[ ! -z $1 ]]; then
		severity=$1
	fi
	[[ `is_kw_shell` == "No" ]] && \
		echo "=======> Error: Shud be executed in \"kwshell\" <========" && \
	       	return
	cdir=$(vget_cdir)
	if [ $cdir != "openwrt" ]; then
		echo "Error: Kshell: CWD is not openwrt!!"
		return
	fi
	echo "Compiling GWDPA-DPM...!"
	make package/feeds/ugw_soc/gwdpa-dpm/{clean,compile} 2>>/dev/null 1>>/dev/null
	[[ $? != 0 ]] && echo "GWDPA-DPM: Compilation failed" && return

	echo "Running Klockwork tool...!"
	rm -rf /tmp/kw_*

	kwcheck import /nfs/site/proj/chdsw_ci/common/kw/config/kw_override_new.h
	kwcheck import /nfs/site/proj/chdsw_ci/common/kw/config/klocwork_database.kb
	kwcheck import /nfs/site/proj/chdsw_ci/common/kw/config/analysis_profile.pconf

	kwcheck run -j10 2>>/tmp/kw_err.txt 1>>/tmp/kw_log.txt
	echo "=========> Considering severity levels: $severity <============"
	kwcheck list -y -F detailed --severity $severity --status 'Analyze','Fix' --report /tmp/kw_results.txt
	echo "=========> $(tail -n 1 /tmp/kw_results.txt) <============"
	echo "Done!!.. Results are stored at \"/tmp/kw_results.txt\""
}

cd_custom_gwdpa () {
	cdir=$(vget_cdir)
	if [ $cdir != "openwrt" ]; then
		echo "Error: CWD is not openwrt!!"
		return 1
	fi
	#sed line replacement
	sed -i "/CONFIG_kmod-gwdpa-dpm_USE_CUSTOM_SOURCE_DIR/c\CONFIG_kmod-gwdpa-dpm_USE_CUSTOM_SOURCE_DIR=y" .config
	(echo "") | make oldconfig
	#sed -i "/CONFIG_kmod-gwdpa-dpm_CUSTOM_SOURCE_DIR/c\CONFIG_kmod-gwdpa-dpm_CUSTOM_SOURCE_DIR=\"${PWD}/../source/gwdpa-dpm\"" .config
	find -name gwdpa-dpm-* | xargs rm -rf

	#Verify
	p=$(cat .config | grep CONFIG_kmod-gwdpa-dpm_CUSTOM_SOURCE_DIR | sed 's/"//g' | awk -F= '{print $2}' | sed 's/\.\./ /g' | awk '{print $1}')
	if [ "$p" == "" ]; then
		return 0
	fi
	#remove last char '/' in the variable
	p=${p::-1}
	if [ "$p" != "`pwd`" ]; then
		echo "Warning: Set wrongly: $p `pwd`"
		echo "Expecting: `pwd`/../source/gwdpa-dpm"
	fi
}

ugw_reset () {
	cdir=$(vget_cdir)
	if [ $cdir != "ugw_sw" ]; then
		echo "Error: CWD is not ugw_sw!!"
		return 1
	fi
	(echo "y") | ./ugw-prepare-all.sh -U
	(echo "y") | ./ugw-prepare-all.sh -o
	./ugw-prepare-all.sh
}

kern_auto_conf_change () {
	
	if [ $# != 3 ]; then
		echo "Usage: $FUNCNAME <CONFIG_XXX> <en/dis> <flm/lgm>"
		return 1
	fi

	cdir=$(vget_cdir)
	if [ $cdir != "openwrt" ]; then
		echo "Error: CWD is not openwrt!!"
		return 1
	fi

	## check if lgm append "_lgm" at the end - to make linux_lgm
	dir="linux"
	if [ $3 == "lgm" ]; then
		dir="linux_lgm"
	fi

	## Check the given $1/CONFIG_XXX macro is valid config macro or not
	grep -w "$1" ../source/$dir/.config >> /dev/null
	if [ $? != 0 ]; then
		echo "Hey!! given $1 is not valid CONFIG Macro!!"
		return 1
	fi

	present=0
	grep -rn "$1" ../source/$dir/include/config/auto.conf >> /dev/null
	if [ $? == 0 ]; then
		present=1
	fi

	## This is for config macro visibility in build Makefiles
	if [ $2 == "en" ]; then
		if [[ $present == 0 ]]; then
			echo "$1=y" >> ../source/$dir/include/config/auto.conf
		else
			echo "auto.conf: $1 Already enabled.."
		fi
	elif [ $2 == "dis" ]; then
		if [[ $present == 1 ]]; then 
			sed -i "/$1/d" ../source/$dir/include/config/auto.conf
		else
			echo "auto.conf: $1 Already disabled.."
		fi
	else
		echo "Usage: $FUNCNAME <CONFIG_XXX> <en/dis>"
		return 1
	fi


	present=0
	grep -rn "$1" ../source/$dir/include/generated/autoconf.h >> /dev/null
	if [ $? == 0 ]; then
		present=1
	fi

	## This is for macro visibility in Linux C code/drivers/headerfiles
	val=0
	if [ $2 == "en" ]; then
		val=1
	elif [ $2 == "dis" ]; then
		val=0
	else
		echo "Usage: $FUNCNAME <CONFIG_XXX> <en/dis>"
		return 1
	fi
		
	if [[ $present == 0 ]]; then
		echo "#define $1 $val" >> ../source/$dir/include/generated/autoconf.h
	else
		sed -i "/$1/c\#define $1 $val" ../source/$dir/include/generated/autoconf.h
	fi

	# Verification
	verif1="FAIL"
	verif2="FAIL"
	str=$(grep -r "$1" ../source/$dir/include/config/auto.conf)
	if [ $2 == "en" ]; then
		if [[ $str == "$1=y" ]]; then
			verif1="PASS"
		fi
	elif [ $2 == "dis" ]; then
		if [ -z $str ]; then
			verif1="PASS"
		fi
	fi

	str=$(grep -r "$1" ../source/$dir/include/generated/autoconf.h)
	if [[ $str == "#define $1 $val" ]]; then
		verif2="PASS"
	fi

	echo "Verify cfg change: auto.conf: $verif1, autoconf.h: $verif2"

}

dpm_compile () {
	if [[ `vget_cdir` != openwrt ]]; then
		echo "Error: CWD is not openwrt!!"
		return 1
	fi

	sub_cmd1="{clean,compile}"
	sub_cmd2="-j32"

	while [[ $# -gt 0 ]]; do
		case "$1" in
			v | V)
				sub_cmd2="-j1 V=sc"
				shift
				;;
			compile | comp | c)
				sub_cmd1=compile
				shift
				;;
			clean | cl)
				sub_cmd1=clean
				shift
				;;
			*)
				shift
				;;
		esac
	done

	#make package/feeds/ugw_soc/gwdpa-dpm/$sub_cmd1 $sub_cmd2
	make package/feeds/ugw_soc/dpm/$sub_cmd1 $sub_cmd2
}

vget_config_str2num ()
{
	str=$1
	if [ -z "$str" ]; then
		echo "Invalid string"
		return 1
	fi

	./scripts/ltq_change_environment.sh list > .cfg
	num=$(grep -rn "${str}$" .cfg | awk -F: '{print $1}')
	if [ -z "$str" ]; then
		echo "Invalid string"
		return 2
	fi
	#num=$((num - 1))
	echo $num
}

vdpm_for_each_file ()
{
	cmd="$1"
	pattern="find . | grep "
	if [ "x$cmd" == "x" ]; then
		echo "Usage: vdpm_for_each_file <cmd> <opt:pattern>"
		return 4
	fi
	if [ "x$2" == "x" ]; then
		pattern+="datapath"
	else
		pattern+="$2"
	fi

	# only search .c and .h files
	pattern+=".*.[ch]$"

	for i in `eval "$pattern"`; do
		eval "$cmd $i"
		#sed -i 's/%p/%px/g' $i;
	done

}
#source /etc/profile.d/modules.sh

alias okmcfg="make kernel_menuconfig CONFIG_TARGET=subtarget"
alias okoldcfg="make kernel_oldconfig CONFIG_TARGET=subtarget"
alias omcfg="make menuconfig"
alias dpks="[[ `vget_cdir` == openwrt ]] && cd build_dir/target-mips*/linux-*/linux-*/drivers/net/datapath/dpm"
alias dpcc="dpm_compile"
alias dpccv="dpm_compile V"
alias dpc="dpm_compile compile"
alias dpcl="dpm_compile clean"
alias dpcv="dpm_compile compile V"
alias okcfg="kern_auto_conf_change"

#export PATH=/home/$USER/bin:/local/$USER/svn_dpm_repo/ppa/bin:/nfs/site/proj/chdsw_ci/common/kw/klocwork_2020_1/user/bin:$PATH
alias vrepo="~/bin/repo"
alias pull_ugw8="rm -rf .repo ugw_sw; vrepo init -u ssh://git@mbitbucket.maxlinear.com:29418/sw_ugw/manifest.git -b 8.x && vrepo sync -j32 && cd ugw_sw && ./ugw-prepare-all.sh -u && ./ugw-prepare-all.sh"
alias pull_ugw9="rm -rf .repo ugw_sw; unset PYTHONPATH; PYTHONPATH=""; vrepo init -u ssh://git@mbitbucket.maxlinear.com:29418/sw_ugw/manifest.git -b 9.x && vrepo sync -j32 && cd ugw_sw && ./ugw-prepare-all.sh -u && ./ugw-prepare-all.sh"
alias set_prxd="cd openwrt; (vget_config_str2num PRX300_DEBUG) | ./scripts/ltq_change_environment.sh switch"
alias set_prxcpe="cd openwrt; (vget_config_str2num PRX321_CPE) | ./scripts/ltq_change_environment.sh switch"
alias set_prxsfu="cd openwrt; (vget_config_str2num PRX321_SFU) | ./scripts/ltq_change_environment.sh switch"
alias set_lgm="cd openwrt; (vget_config_str2num URX851_HE_CPE) | ./scripts/ltq_change_environment.sh switch"
alias set_lgmd="cd openwrt; (vget_config_str2num URX851_HE_CPE_DEBUG) | ./scripts/ltq_change_environment.sh switch"
alias set_axe="cd openwrt; (vget_config_str2num AXEPOINT_GW_SEC) | ./scripts/ltq_change_environment.sh switch"
alias set_axed="cd openwrt; (vget_config_str2num AXEPOINT_GW_SEC_DEBUG) | ./scripts/ltq_change_environment.sh switch"
alias vfetch="git fetch --all --tags"
alias gd="git diff"
alias gdc="git diff --cached"
alias glog="git log --pretty=fuller"

_gc () {

	[[ ! -d .git ]] && echo "Not a git repository" && return
	hyphen=0
	file=".gitoldbranch"
	curr_branch=`vcur_branch`
	old_branch=""
	[[ $# -eq 0 ]] && return
	[[ "$1" == "-" ]] && hyphen=1

	if [[ $hyphen -eq 1 ]]; then
		#need to switch to old branch
		[[ ! -f $file ]] && return
		old_branch=$(cat ${file})
		[[ $curr_branch == $old_branch ]] && return
		args="$old_branch"
	else
		args="$@"
	fi

	#Save to $file in the curret git repo
	echo `vcur_branch` > $file
	git checkout $args
}
alias gc="_gc"
alias gco="_gco"
alias gb="git branch"
alias gba="git branch -a"
alias gt="git tag -l"
alias gst="git status"
alias gv="grep -v tags | grep -v cscope | grep -v Binary | grep -v cmd | grep -v .git | grep -v \"\.su\" | grep -v Module.symvers | grep -v \"\.orig\" | grep -v \".*.un~\" | grep -v grep"
alias vhash="vgen_hash_on_tag_optimized"
alias vhashv="vgen_hash_on_tag_optimized_verify"
alias grh1="git reset --hard HEAD~1"
alias grc="git rebase --continue"
kw1 () {
	kwenvset $1
	[ $? != 0 ] && return -1
	echo $PWD > /tmp/.kw_cdpath ; kwshell
}
alias kw2="cd \$(cat /tmp/.kw_cdpath); kwrun 1,2"
alias kw3="exit"

alias sshconn_list="ps -Af  | grep $USER | grep ssh | grep pts | grep -v grep"
sshconn_kill () {
	kill -9 $(sshconn_list | awk '{print $2}' | head -n 1)
}
alias vc=vcheckout
alias vcf=vcheckout_force
alias vrf=vrebase_force
alias vtags="rm -rf tags; rm -rf cscope*; ctags -R; cscope -vRkb"
alias cd_mips_feeds="cd ../feeds/ugw/targets/intel_mips"
alias cd_x86_feeds="cd ../feeds/ugw/targets/intel_x86/intel_x86"
alias cd_dpm_feeds="cd ../feeds/ugw/soc/mxl/gwdpa-dpm"
alias checkpatch_onf="~/dotfiles/checkpatch/checkpatch.pl --no-tree -f --strict"
alias cleanfile_onf="~/dotfiles/checkpatch/cleanfile"
alias vedit="vim ~/dotfiles/ven_bash_apis.sh && vs"
alias vs="source ~/.bashrc"
alias vgr="vgen_rel_tag \`vcb\`"
alias vgt="vgen_tmp_tag \`vcb\`"
alias vsr="vset_rel_tag \`vcb\`"
alias vst="vset_tmp_tag \`vcb\`"
vis_synced () {
	[[ ! -d .git ]] && echo "Not a git repository" && return
	cb=$(vcur_branch)
	_origin=`git remote -v | grep "fetch" | awk '{print $1}'`
	localb=$cb
	remoteb=$_origin/$cb
	nclAr=$(git log --pretty=oneline $remoteb..$localb | wc -l)
	nclBr=$(git log --pretty=oneline $localb..$remoteb | wc -l)

	if [[ $nclAr -eq 0 ]] && [[ $nclBr -eq 0 ]]; then
		echo "Local branch is up-to-date with repo"
	elif [[ $nclAr -ge 0 ]]; then
		echo "Local branch is ahead of repo by $nclAr commits"
	elif [[ $nclBr -ge 0 ]]; then
		echo "Local branch is behind of repo by $nclBr commits"
	else
		echo "Something wrong!!"
	fi
}

vadd () {
	ARGS="$@"
	cmd="git add"
	for i in $(git status | grep 'modified\|deleted' | sed 's/ //g' | awk -F: '{print $2}');
	do 
		eval "$cmd $i"
	done
	if [ "$ARGS" != "" ]; then
		eval "$cmd $ARGS"
	fi
}

alias vrm="/bin/rm"

RB=~/Recycle_Bin
RM () {
	#Dont delete files directly, just move to RB
	VOLDPWD=$OLDPWD
	mkdir -p $RB
	nargs=$#
	i=0
	args=""
	while [ $# -gt 0 ]; do
		if [ "${1:0:1}" != "-" ]; then
			args+="$1 "
		fi
		shift
	done

	cd $RB 1>>/dev/null
	vrm -rf $args
	cd - 1>>/dev/null
	OLDPWD=$VOLDPWD
	eval "(echo y) | mv $args $RB 2>>/dev/null 1>>/dev/null"
}
alias rm="RM"


#Print bash function definitaion to console
define () {
	if [ $# != 1 ]; then
		echo "Usage: $FUNCNAME <symbol-name>"
		return 1
	fi
	type $1
}
export -f define
set_ps1

is_ssh_shell () {
	curr_tty=$(tty)
	[ "x$curr_tty" == "x" ] && return
	curr_tty=${curr_tty:5}

	from=$(w | grep -w "$curr_tty" | grep $USER | awk '{print $3}')
	[ "x$from" == "x" ] && return

	if [[ "$from" == ":0" ]]; then
		echo "No"
	else
		echo "Yes"
	fi
	
}

alias sgb016="ssh vbolla@sgb016 -t bash"
alias setup2_wanPC="ssh root@10.226.45.19"
alias dummy="vc DRV_DPM_SW-587"
alias dummy1="vc DRV_DPM_SW-687"

mk_dummy () {
	old_branch="$(vcur_branch)"
	stash_msg=$(git stash)
	if [ "$stash_msg" == "" ]; then
		stashed=1
	else
		stashed=0
	fi
	dummy
	curr_branch="$(vcur_branch)"
	vrf master $curr_branch
	sed -i 's/this/This/g' datapath_ver.h
	vadd
	git commit -s -m "DRV_DPM_SW-587: temp commit for dry-run"
	git push -f
	vgt
	gc $old_branch
	if [ $stashed -eq 1 ]; then
	        git stash pop
	fi
}

mk_dummy1 () {
	old_branch="$(vcur_branch)"
	stash_msg=$(git stash)
	if [ "$stash_msg" == "" ]; then
		stashed=1
	else
		stashed=0
	fi
	dummy1
	curr_branch="$(vcur_branch)"
	vrf master $curr_branch
	sed -i 's/this/This/g' datapath_ver.h
	vadd
	git commit -s -m "DRV_DPM_SW-687: temp commit for dry-run"
	git push -f
	vgt
	gc $old_branch
	if [ $stashed -eq 1 ]; then
	        git stash pop
	fi
}

dut_uart () {
	if [ "$1" == "" ]; then
		echo "Usage: $FUNCNAME <IP addr last byte>"
		return
	fi
	telnet 10.226.45.$1 4440
}

alias kgdb_dut_uart="dut_uart"

mk_kgdb_dir () {
	cdir=$(vget_cdir)
	if [ $cdir != "openwrt" ]; then
		echo "Error: CWD is not openwrt!!"
		return -1
	fi

	/bin/rm -rf kgdb_dir
	mkdir -p kgdb_dir/{log,scripts,dut/{uboot,fullimage}}
	#fullimages dir
	cp -Rfp	bin/targets/intel_x86/lgm/urx851_he_cpe_debug/openwrt-intel_x86-lgm-URX851_UGW_DEBUG-lgp_b0_fullimage.img kgdb_dir/dut/fullimage
	cp -Rfp	bin/targets/intel_x86/lgm/urx851_he_cpe_debug/uboot-lgp-urx851-p34x-phy-emmc/u-boot-emmc.bin kgdb_dir/dut/uboot
	cp -Rfp bin/targets/intel_x86/lgm/urx851_he_cpe_debug/uboot-lgp-urx851-p34x-phy-emmc/u-boot-recovery.* kgdb_dir/dut/uboot

	#vmlinux image
	cp -Rfp ../source/linux_lgm/vmlinux* kgdb_dir
	cp -Rfp ../source/linux_lgm/scripts/gdb kgdb_dir/scripts/gdb

	#modules
	cp -Rfp $(find build_dir | grep "/target-dir-.*/lib/modules" | head -n 2 | tail -n 1) kgdb_dir/modules

	#toolchain
	cp -Rfp staging_dir/toolchain-*_musl kgdb_dir/toolchain

	#Kernel config and openwrt config
	cp -Rfp active_config kgdb_dir/log/openwrt_active_config
	cp -Rfp .config kgdb_dir/log/openwrt_dot_config
	cp -Rfp ../source/linux_lgm/.config kgdb_dir/log/linux_lgm_kernel_dot_config
	cp -Rfp buildstamp version* ugw_version ../ugw_tag ../../ugw_build.log kgdb_dir/log

	#create symlink properly
	cd kgdb_dir
	rm -rf vmlinux-gdb.py
	ln -sf scripts/gdb/vmlinux-gdb.py .
	cd -

	#Create start script for gdb
	cat > kgdb_dir/gdb_start.sh << EOF
#!/bin/bash

gdb_server_ip=10.226.45.5
gdb_server_port=4441

if [ "\$(basename \$PWD)" != "kgdb_dir" ]; then
	echo "Error: you must be in the kgdb_dir which is created by cmd 'mk_kgdb_dir'"
	exit 1
fi

touch breakpoints.gdb
gdb_break_points_list=\$(cat breakpoints.gdb)
cat > cmds.gdb << EOI
#This is a auto-generated file
#Please dont edit it, it will get overwritten once
#you execute gdb_start.sh

set print pretty on
set pagination off
target remote \$gdb_server_ip:\$gdb_server_port
lx-symbols modules
\${gdb_break_points_list}
EOI

./toolchain/bin/x86_64-openwrt-linux-gdb -q -ex 'add-auto-load-safe-path .' -ex 'file vmlinux' --command=cmds.gdb
EOF
	
	chmod +x kgdb_dir/gdb_start.sh
	touch kgdb_dir/breakpoints.gdb

cat > kgdb_dir/uboot_kernel_params.txt << EOF
setenv vaddmisc 'setenv bootargs ${bootargs} earlycon=lantiq,mmio32,0xe0a00000 console=ttyLTQ0,115200n8r kgdboc=ttyLTQ0,115200n8r dp_dbg=gdb nokaslr ethaddr=${ethaddr} maxcpus=4 mem=2048M memmap=31M$1M,0x${filesystem_size}!0x${rootfs_loadaddr} initcall_debug=0 loglevel=8 intel_idle.max_cstate=2 max_cpufreq=2028000 init_cstate_margin=1 init_pstate_threshold=20 epu_table_ver=${epu_table_ver}'
EOF

	if [ ! -d ~/kgdb_dir ]; then
		mv kgdb_dir ~/
	else
		echo "Error: one kgdb_dir is already there at ~/!, Please delete and redo"
		return
	fi
	echo "mk_kgdb_dir: Success, kept at ~/"
}

#bracketed paste mode - disable
alias disable_backtraced_mode='printf "\e[?2004l"'
disable_backtraced_mode
#bind 'set enable-bracketed-paste off'

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

