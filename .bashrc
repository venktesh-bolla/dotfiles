# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# Larger bash history (default is 500)
export HISTFILESIZE=100000
export HISTSIZE=100000
export HISTCONTROL=ignoreboth:erasedups
PROMPT_COMMAND="${PROMPT_COMMAND}${PROMPT_COMMAND:+;}history -a; history -n"


# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias la='ls $LS_OPTIONS -a'
alias l='ls $LS_OPTIONS -lA'

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
export PATH=$PATH:/sbin

tssh () {
	[[ -z $TMUX ]] && tmux a -t 0
}

tnew () {
	[[ -z $TMUX ]] && tmux
}

goto () {
	case $1 in

		israel)
			sshpass -p 123456 ssh ftp_tmp@israel
		;;
		doch)
			sshpass -p a ssh root@doch
		;;
		doc1)
			sshpass -p a ssh root@doch -p 8022
		;;
		doc2)
			sshpass -p a ssh root@doch -p 8023
		;;
		b03h)
			sshpass -p caveo123 ssh vbolla@b03h
		;;
		b03s1)
			sshpass -p caveo123 ssh vbolla@b03s1
		;;
		b03s2)
			sshpass -p a ssh root@b03s2 -p 8022
		;;
		b03gw2)
			sshpass -p a ssh root@b03gw2
		;;
		b03)
			sshpass -p v ssh root@b03
		;;
		*)
			echo "Invalid argument argument"
		;;
	esac
}
