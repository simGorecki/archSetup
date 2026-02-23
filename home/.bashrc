#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

ii() {
	cosmic-files "$(pwd)" > /dev/null 2>&1 &
}

export PS1='\[\e]133;k;start_kitty\a\]\[\e]133;D;$?\a\]\[\e]133;A\a\]\[\e]133;k;end_kitty\a\]\[\e]133;k;start_suffix_kitty\a\]\[\e[5 q\]\[\e]2;\w\a\]\[\e]133;k;end_suffix_kitty\a\]\[\e[97m\][\t]\[\e[0m\] \[\e[94m\]\u@\h\[\e[0m\] \[\e[38;2;255;170;170m\]\w\[\e[0m\]\n >'

help() {
    cat ~/.config/help/memo.txt
}
