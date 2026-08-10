#!/bin/bash

set -e

USER_NAME="sara"

echo "-------------------- Starting Arch Linux setup --------------------"

echo "-------------------- Updating system and installing base-devel, git, and stow --------------------"
sudo pacman -Syu --noconfirm --needed base-devel git stow

if ! command -v yay &> /dev/null; then
    echo "-------------------- AUR helper 'yay' not found. Installing... --------------------"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
else
    echo "-------------------- 'yay' is already installed. Skipping --------------------"
fi

echo "-------------------- Enabling multilib... --------------------"
if grep -q "^#\[multilib\]" /etc/pacman.conf; then
    sudo sed -i '/^#\[multilib\]/{s/^#//;n;s/^#//}' /etc/pacman.conf
    echo "Successfully enabled [multilib] repo."
    sudo pacman -Sy
else
    echo "Info: [multilib] is already enabled or missing."
fi

echo "-------------------- Installing packages... --------------------"
sudo pacman -S --noconfirm --needed - < pkglist.txt

echo "-------------------- Installing packages from the AUR... --------------------"
yay -S --noconfirm --needed - < pkglist-aur.txt

echo "-------------------- Removing unnecessary packages... --------------------"
orphans=$(pacman -Qdtq || true)
if [ -n "$orphans" ]; then
    echo "-------------------- Found orphaned packages to remove --------------------"
    echo "$orphans"
    echo "$orphans" | sudo pacman -Rns -
else
    echo "-------------------- No orphaned packages found --------------------"
fi

if command -v brave &> /dev/null; then
    CURRENT_BROWSER=$(xdg-settings get default-web-browser)

    if [ "$CURRENT_BROWSER" == "brave-browser.desktop" ]; then
        echo "-------------------- Brave is already default. Skipping --------------------"
    else
    	echo "-------------------- Setting Brave as default browser... --------------------"
        xdg-settings set default-web-browser brave-browser.desktop || echo "Warning: Could not set default browser"
    fi
fi

echo "-------------------- Symlinking dotfiles... --------------------"
sudo chown -R "$USER_NAME:$USER_NAME" "$HOME/.config"

for app in nvim tmux fastfetch wpaperd niri kitty swaync waybar fuzzel yazi fish swaylock xdg-desktop-portal xdg-desktop-portal-termfilechooser; do
    rm -rf "$HOME/.config/$app"
    ln -s "$HOME/dotfiles/$app" "$HOME/.config"
done

rm -f "$HOME/.config/starship.toml"
ln -s "$HOME/dotfiles/starship.toml" "$HOME/.config"

echo "-------------------- Enabling essential systemd services... --------------------"
sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service

if [[ "$SHELL" != *"/bin/fish"* ]]; then
    echo "-------------------- Changing default shell to Fish for $USER_NAME... --------------------"
    sudo chsh -s "$(which fish)" "$USER_NAME"
    echo "-------------------- Default shell changed. Log out and log back in for change to take effect --------------------"
else
    echo "-------------------- Default shell is already Fish. Skipping --------------------"
fi

echo "-------------------- Enrolling fingerprint... --------------------"
# Only run sed commands if fprintd hasn't been configured in system-local-login to prevent duplicate entries
if ! grep -q "pam_fprintd.so" /etc/pam.d/system-local-login; then
    echo "-------------------- Adding fprintd PAM rules... --------------------"
    sudo sed -i \
        -e '2i\auth       [success=1 default=ignore]  pam_succeed_if.so    service in sudo:su:su-l tty in :unknown' \
        -e '2i\auth sufficient pam_fprintd.so' \
        "/etc/pam.d/system-local-login"

    sudo sed -i -e '2i\auth sufficient pam_fprintd.so' "/etc/pam.d/login"
    sudo sed -i -e '2i\auth sufficient pam_fprintd.so' "/etc/pam.d/system-auth"
    sudo sed -i -e '2i\auth sufficient pam_fprintd.so' "/etc/pam.d/su"
    sudo sed -i -e '2i\auth sufficient pam_fprintd.so' "/etc/pam.d/sudo"
else
    echo "-------------------- Fingerprint PAM rules already exist. --------------------"
fi

if ! fprintd-list "$(whoami)" | grep -q "finger"; then
    echo "-------------------- No fingerprints found for user $(whoami). Enrolling... --------------------"
    fprintd-enroll
else
    echo "-------------------- Fingerprint already enrolled --------------------"
fi

fprintd-verify

echo "-------------------- All done. Reboot system for changes to take effect --------------------"
