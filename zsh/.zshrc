#!/usr/bin/env zsh

# History
HISTFILE="$HOME/.local/state/zsh/history"
[[ -d ${HISTFILE:h} ]] || mkdir -p "${HISTFILE:h}"
HISTSIZE=50000
SAVEHIST=50000

setopt share_history
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify

# Cache
zsh_cache=$HOME/.cache/zsh
[[ -d $zsh_cache ]] || mkdir -p $zsh_cache

autoload -Uz compinit
compinit -d $zsh_cache/zcompdump

# Plugin Manager
source /usr/share/zsh-antidote/antidote.zsh
plugins=$ZDOTDIR/.zsh_plugins
[[ ! -s $plugins.zsh || $plugins.txt -nt $plugins.zsh ]] && antidote bundle <$plugins.txt >|$plugins.zsh
source $plugins.zsh

unset plugins zsh_cache

# Environment Variables

export EDITOR='nvim'
export VISUAL='nvim'
path=("$HOME/.local/bin" "$HOME/Applications" $path)
export PATH
export SSH_ASKPASS='/usr/bin/ksshaskpass'
export GIT_ASKPASS='/usr/bin/ksshaskpass'
export SSH_ASKPASS_REQUIRE='prefer'
export MANPAGER="less --use-color -Dd+218 -Du+183"
export MANROFFOPT="-c"

# Keybindings & Shell Integrations

bindkey -v
KEYTIMEOUT=15
if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
fi
eval "$(starship init zsh)"
if (($+commands[thefuck])); then
    fuck() {
        unfunction fuck
        eval "$(thefuck --alias fuck)"
        fuck "$@"
    }
fi

# Aliases

alias ls='lsd'
alias vim='nvim'
alias grep='grep --color=auto'

update-pkglists() {
    echo "Generating package lists..."
    pacman -Qqen >| ~/dotfiles/pkglist.txt || return 1
    pacman -Qqem >| ~/dotfiles/pkglist-aur.txt || return 1

    (
        cd ~/dotfiles || exit 1
        if [[ -z $(git status --porcelain pkglist.txt pkglist-aur.txt) ]]; then
            echo "No changes detected in package lists."
            exit 0
        fi

        echo "Committing to git..."
        git add pkglist.txt pkglist-aur.txt &&
        git commit -m "update package lists" &&
        git push &&
        echo "Lists updated and committed!"
    )
}

if ((SHLVL == 1)); then
    clear && fastfetch
fi
