# Initialisation

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

autoload -Uz compinit
compinit

# Plugin Manager
antidote bundle < .zsh_plugins.txt > .zsh_plugins.zsh
source .zsh_plugins.zsh

# Environment Variables

export EDITOR='nvim'
export PATH="$HOME/Applications:$PATH"
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"
export SSH_ASKPASS='/usr/bin/ksshaskpass'
export GIT_ASKPASS='/usr/bin/ksshaskpass'
export SSH_ASKPASS_REQUIRE='prefer'
export MANPAGER="less --use-color -Dd+218 -Du+183"
export MANROFFOPT="-c"

# Keybindings & Shell Integrations

bindkey -v
if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
fi
eval "$(starship init zsh)"
eval $(thefuck --alias fuck)

# Aliases

alias ls='lsd'
alias vim='nvim'
alias grep='grep --color=auto'

# On Startup
clear && fastfetch
