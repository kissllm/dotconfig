#! /bin/sh

# color variables
# INACTIVE_BORDER_COLOR='#444444'
INACTIVE_BORDER_COLOR='default'
ACTIVE_BORDER_COLOR='#00afff'
RED='#d70000'
YELLOW='#ffff00'
GREEN='#5fff00'

# read args
for i in "$@"; do
	case $i in
		--pane-current-path=*)
			pane_current_path="${i#*=}"
			shift # past argument=value
			;;
		--pane-active=*)
			pane_active="${i#*=}"
			shift # past argument=value
			;;
		*) # unknown option
			;;
	esac
done
#
# replace full path to home directory with ~
# PRETTY_PATH=$(sed "s:^$HOME:~:" <<< $pane_current_path)
PRETTY_PATH="$(echo $pane_current_path | sed "s:^$HOME:~:")"


# calculate reset color
RESET_BORDER_COLOR="$(
[ "$pane_active" -eq "1" ] && echo $ACTIVE_BORDER_COLOR ||
	echo $INACTIVE_BORDER_COLOR)"

color () {
	local intent="$1"
	echo $([ "$pane_active" -eq "1" ] && echo $intent ||
		echo $INACTIVE_BORDER_COLOR)
}

# tmux list-panes -F '#F' | grep -q Z &&
# 	PRETTY_PATH="#[fg=$(color $YELLOW)]Z#[fg=$RESET_BORDER_COLOR] \
# 	$(echo $pane_current_path | sed "s:^$HOME:~:")" ||
# 	PRETTY_PATH="$(echo $pane_current_path | sed "s:^$HOME:~:")"

# git functions adapted from the bureau zsh theme
# https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/bureau.zsh-theme

git_prompt_prefix="["
git_prompt_suffix="] "
git_prompt_clean="#[fg=$(color $GREEN)]✓#[fg=$RESET_BORDER_COLOR]"
git_prompt_ahead="↑"
git_prompt_behind="↓"
git_prompt_staged="#[fg=$(color $GREEN)]●#[fg=$RESET_BORDER_COLOR]"
git_prompt_unstaged="#[fg=$(color $YELLOW)]●#[fg=$RESET_BORDER_COLOR]"
git_prompt_untracked="#[fg=$(color $RED)]●#[fg=$RESET_BORDER_COLOR]"
git_prompt_unmerged=""

gitbranch () {
	local ref=
	ref="$(command git symbolic-ref HEAD 2> /dev/null)" ||
	ref="$(command git rev-parse --short HEAD 2> /dev/null)" ||
	return 0
	echo "${ref#refs/heads/}"
}

gitstatus () {
	local status=""

	# check status of files
	local index=$(command git status --porcelain 2> /dev/null)
	if [ -n "$index" ]; then
		if $(echo "$index" | command grep -q '^[AMRD]. '); then
			status="$status$git_prompt_staged"
		fi
		if $(echo "$index" | command grep -q '^.[MTD] '); then
			status="$status$git_prompt_unstaged"
		fi
		if $(echo "$index" | command grep -q -E '^\?\? '); then
			status="$status$git_prompt_untracked"
		fi
		if $(echo "$index" | command grep -q '^UU '); then
			status="$status$git_prompt_unmerged"
		fi
	else
		status="$status$git_prompt_clean"
	fi

	# check status of local repository
	index=$(command git status --porcelain -b 2> /dev/null)
	if $(echo "$index" | command grep -q '^## .*ahead'); then
		status="$status$git_prompt_ahead"
	fi
	if $(echo "$index" | command grep -q '^## .*behind'); then
		status="$status$git_prompt_behind"
	fi

	echo $status
}

git_prompt () {
	local branch=$(gitbranch)
	local status=$(gitstatus)
	local result=""
	if [ "${branch}x" != "x" ]; then
		result="$git_prompt_prefix$branch"
		if [ "${status}x" != "x" ]; then
			result="$result $status"
		fi
		result="$result$git_prompt_suffix"
	fi
	echo $result
}

# final output
echo "$PRETTY_PATH $(cd $pane_current_path && git_prompt)"
# echo "$(cd $pane_current_path && git_prompt)"
# https://github.com/tmux/tmux/issues/1852
tmux refresh-client -S
