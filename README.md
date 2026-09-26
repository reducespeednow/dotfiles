# dotfiles

NixOS setup [niri](https://github.com/YaLTeR/niri) compositor

|                                                                              |                                                                                 |
| ---------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| `hosts/nixos/configuration.nix`                                              | the system: packages, services, users, and the `~/.config` symlinks             |
| `hosts/nixos/theme.nix`                                                      | one colour palette + font, written out as a theme file per app in `/etc/theme/` |
| `hosts/nixos/hardware-configuration.nix`                                     | generated for this machine (disks, kernel modules)                              |
| `alacritty` `fish` `fuzzel` `niri` `nvim` `swaync` `tmux` `waybar` `wpaperd` | app configs, each symlinked to `~/.config/<name>`                               |

## install

on fresh install:

```sh
git clone https://github.com/reducespeednow/dotfiles.git ~/dotfiles

# use this machine's hardware config
sudo nixos-generate-config --show-hardware-config > ~/dotfiles/hosts/nixos/hardware-configuration.nix

# point NixOS at the repo
echo 'import /home/<whatever>/dotfiles/hosts/nixos/configuration.nix' | sudo tee /etc/nixos/configuration.nix

# edit swapDevices in configuration.nix to match this machine's swap partition, then:
sudo nixos-rebuild switch
```

then log out and back in: the `~/.config` symlinks are created at login. pick the niri session, and enroll a fingerprint with `fprintd-enroll` (if machine has fingerprint reader).

## day to day

- **app configs** are live symlinks, so edit and reload the app. no rebuild needed.
- **system changes** go in `configuration.nix`, then `rbd` (abbr for `sudo nixos-rebuild switch`).
- **colours** live in `theme.nix`. change the palette or the roles, rebuild, and every app follows.
- **nvim** uses [lazy.nvim](https://github.com/folke/lazy.nvim), which installs itself and all plugins on first launch. `nvim/lazy-lock.json` pins plugin versions. language servers and formatters are installed by Nix, not Mason.
