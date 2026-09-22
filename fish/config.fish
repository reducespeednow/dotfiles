set -gx EDITOR nvim
set -gx VISUAL nvim

if status is-interactive
    set -g fish_greeting
    fish_vi_key_bindings

    if not set -q TMUX; and not set -q NVIM
        fastfetch
    end

    alias vim nvim
    abbr rebuild "sudo nixos-rebuild switch --flake ~/dotfiles"
    abbr gst "git status"
    abbr gaa "git add ."
    abbr ga "git add"
    abbr gd "git diff"
    abbr gp "git push"
    abbr gcmsg "git commit -m"
end
