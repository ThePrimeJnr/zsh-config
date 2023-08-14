
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Which plugins would you like to load?
plugins=(git zsh-autosuggestions zsh-syntax-highlighting history dirhistory copypath copybuffer copyfile web-search sudo git-auto-fetch)

source $ZSH/oh-my-zsh.sh

# Define functions to check Git status
function parse_git_status {
	local git_status
	git_status="$(git status 2> /dev/null)"

	if [ -n "$git_status" ]; then
		if echo "$git_status" | grep -q 'Untracked files' || echo "$git_status" | grep -q 'Changes not staged for commit'; then
			echo -e "\033[31m ✗\033[00m"  # Red
		elif echo "$git_status" | grep -q 'Changes to be committed'; then
			echo -e "\033[33m ✗\033[00m"  # Yellow
		elif echo "$git_status" | grep -q 'branch is ahead' || echo "$git_status" | grep -q 'branch is behind'; then
			echo -e "\033[34m ✔\033[00m"  # Blue
		else
			echo -e "\033[32m ✔\033[00m"  # Green
		fi
	fi
}

function git_prompt {
	local g
	g=$(git rev-parse --git-dir 2>/dev/null)
	if [ -n "$g" ]; then
		local git_status
		git_status=$(parse_git_status)
		local branch_name
		branch_name=$(git branch 2>/dev/null | grep '\*' | sed 's/\* //')
		if [ -n "$git_status" ]; then
			echo -n "($branch_name) $git_status"
		fi
	fi
}

function time_prompt {
    timer=$(date +'%H:%M:%S')
    dir_name=$(basename "$PWD")

    if [ "$dir_name" = "$(basename "$HOME")" ]; then
        padding=$((COLUMNS - ${#timer} - 4))
    elif git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	branch_name=$(git branch 2>/dev/null | grep '\*' | sed 's/\* //')
        padding=$((COLUMNS - ${#timer} - ${#dir_name} - ${#branch_name} - 8))
    else
        padding=$((COLUMNS - ${#timer} - ${#dir_name} - 3))
    fi
    
    echo -e "$(printf "%*s" $padding)\033[90m$timer\033[0m"
}

function precmd() {
    # Check if the command is "clear" or Ctrl+L
    if [[ -z "$NEW_LINE_BEFORE_PROMPT" && "$READLINE_LINE" != "clear" && "$READLINE_LINE" != "\014" ]]; then
        NEW_LINE_BEFORE_PROMPT=1
    elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
        echo ""
    fi
}

# Customize your Zsh prompt
PROMPT="$fg[cyan]%}%c%{$reset_color%} \$(git_prompt)\$(time_prompt)%(?..%{$reset_color%})  
%(?:%{$fg[green]%}❯ :%{$fg[red]%}❯ )"

alias clear="unset NEW_LINE_BEFORE_PROMPT && clear"
alias reset="unset NEW_LINE_BEFORE_PROMPT && reset"
alias ls='ls -CF --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias vi='nvim'
alias vim='nvim'

alias emacs='emacs -nw'

export TERM=xterm-256color

export PATH="$PATH:."
export ANDROID_HOME="/home/destiny/Android/Sdk/cmdline-tools/latest/bin/sdkmanager"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
. "$HOME/.cargo/env"
export PATH="$PATH":"$HOME/.local/share/nvim/"
export PATH="$PATH":"$HOME/.pub-cache/bin"

export PATH="$JAVA_HOME/bin:$PATH"
export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"

export PATH="$HOME/fvm/default/bin:$PATH"

export PATH="$PATH:/home/destiny/Downloads/fvm"

alias py='python3'
alias python='python3'
export PATH="$HOME/.local/bin:$PATH"
alias pep='pycodestyle'
alias clr='clear'
