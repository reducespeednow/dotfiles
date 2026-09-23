mkdir -p ~/.config
for d in niri fish nvim tmux waybar wpaperd; do
  [ -e ~/.config/$d ] && [ ! -L ~/.config/$d ] && mv ~/.config/$d ~/.config/$d.orig
  ln -sfn ~/dotfiles/$d ~/.config/$d
done
