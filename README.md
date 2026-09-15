# dotfiles
my config files for Arch Linux with the [niri](https://github.com/YaLTeR/niri) Wayland compositor

## installation
assuming a fresh Arch install with a working internet connection and `git`

```bash
git clone https://github.com/reducespeednow/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
chsh -s /usr/bin/fish
```

log out and pick **niri-session** at the login screen

## nvim
config uses [lazy.nvim](https://github.com/folke/lazy.nvim) as its plugin manager

- `nvim/init.lua` is the entry point.
- `nvim/lua/saraabdullahi/` holds the core settings: `set.lua` (options), `remap.lua` (keymaps), and `lazy.lua` (plugin manager bootstrap).
- `nvim/lua/plugins/` has one file per plugin.
- `nvim/lazy-lock.json` pins every plugin to an exact version.

on first launch, lazy.nvim installs itself and all plugins automatically
