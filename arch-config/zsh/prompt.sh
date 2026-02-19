setopt PROMPT_SUBST
export PROMPT='%1~ ✨ '

_prompt() {
	local emoji="✅"
	local string="$BASH_COMMAND"
	local cmd=${1%% *}

	case $cmd in
		cd | ls | pwd | mkdir | mv) emoji="📂" ;;
		vi | nano | vim | emacs | hx) emoji="✏️" ;;
		clang | make | 'clang++') emoji="🛠️";;
		python | py | python3) emoji="🐍";;
		brew) emoji="🍺";;
		rm | trash) emoji="🔥";;
		git) emoji="🔶";;
		sudo) emoji="🔑";;
		awk | sed | grep | egrep) emoji="🔍";;
		ftp | sftp | ssh | ping | nc) emoji="🌐";;
		cat | more | less) emoji="📚";;
		touch) emoji="✋";;
		rustc | cargo | rustfmt) emoji="🦀";;
		lldb) emoji="🔧";;
		echo) emoji="📢";;
		bash | sh | ksh | csh | tcsh | zsh) emoji="🐚";;
		*) emoji="✅";;
	esac

	local pth=$(pwd)
	local sliced="${pth##*/}"
	local len=${#sliced}
	if [[ $pth == $HOME ]]; then
		local len=1
	fi
	printf "\e[s\e[1A\e[$(expr $len + 2)G$emoji \e[u"

}

# hook to every prompt

autoload -Uz add-zsh-hook
add-zsh-hook preexec _prompt
