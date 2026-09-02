# -----------------------------------------------------------------------------
# Environment Variables & PATH
# -----------------------------------------------------------------------------
fish_add_path -g ~/.local/bin

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx MANPAGER "less --use-color -Dd+218 -Du+183"
set -gx MANROFFOPT "-c"

# -----------------------------------------------------------------------------
# Interactive Session Configs
# -----------------------------------------------------------------------------
if status is-interactive
    set -g fish_greeting
    fish_vi_key_bindings
    starship init fish | source
    zoxide init fish | source
    if type -q thefuck
        thefuck --alias | source
    end
    if not set -q TMUX; and not set -q NVIM
        clear
        fastfetch
    end

    alias ls="lsd"
    alias vim="nvim"
    alias grep="grep --color=auto"
    abbr gst "git status"
    abbr gaa "git add ."
    abbr ga "git add"
    abbr gd "git diff"
    abbr gp "git push"
    abbr gcmsg "git commit -m"
end

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------
function update-pkglists --description "Backup installed packages to dotfiles"
    echo "Generating package lists..."
    pacman -Qqen > ~/dotfiles/pkglist.txt; or return 1
    pacman -Qqem > ~/dotfiles/pkglist-aur.txt; or return 1
    pushd ~/dotfiles; or return 1
    if test -z "$(git status --porcelain pkglist.txt pkglist-aur.txt)"
        echo "No changes detected in package lists."
        popd
        return 0
    end
    echo "Committing to git..."
    git add pkglist.txt pkglist-aur.txt
    and git commit -m "update package lists"
    and git push
    and echo "Lists updated and committed!"

    popd
end

# KDB-X Installation Configuration - Fri 14 Aug 16:56:25 BST 2026
set -gx PATH "/home/sara/.kx/bin" $PATH
# End KDB-X Installation Configuration
