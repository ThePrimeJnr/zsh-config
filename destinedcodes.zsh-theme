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
        if [ -n "$git_status" ]; then
            echo -n "$git_status"
        fi
    fi
}

# Customize your Zsh prompt
PROMPT="
%(?:%{$fg_bold[green]%}╭─:%{$fg_bold[red]%}╭─) %{$fg[cyan]%}%c%{$reset_color%} \$(git_prompt)%(?..%{$reset_color%})  
%(?:%{$fg_bold[green]%}╰─➜ :%{$fg_bold[red]%}╰─➜ )"

