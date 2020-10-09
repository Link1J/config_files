if command -v colorls &> /dev/null; then
	alias ls="colorls"
else
	alias ls="ls --color"
fi

alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"

alias suedit="sudo -e $argv"

alias reload="source ~/.bashrc"
