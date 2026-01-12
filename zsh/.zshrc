# Initialisation

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

autoload -Uz compinit
compinit

# Plugin Manager
source /usr/share/zsh-antidote/antidote.zsh
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

update-pkglists() {
    echo "Generating package lists..." 
    pacman -Qqen > ~/dotfiles/pkglist.txt
    pacman -Qqem > ~/dotfiles/pkglist-aur.txt
    
    echo "Committing to git..."
    local current_dir=$(pwd)
    
    cd ~/dotfiles
    if [[ -n $(git status --porcelain pkglist.txt pkglist-aur.txt) ]]; then
        git add pkglist.txt pkglist-aur.txt
        git commit -m "update package lists"
        git push
        echo "Lists updated and committed!"
    else
        echo "No changes detected in package lists."
    fi
    
    cd "$current_dir"
}

clear && fastfetch
