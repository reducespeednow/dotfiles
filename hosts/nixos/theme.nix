{ lib, pkgs, ... }:

let
  # ── Palette: Catppuccin Mocha + your pink extras ──────────────────
  # Hex without '#'. To retheme, change these (and/or the roles below).
  p = {
    crust = "11111b";
    mantle = "181825";
    base = "1e1e2e";
    surface0 = "313244";
    surface1 = "45475a";
    surface2 = "585b70";
    overlay0 = "6c7086";
    overlay2 = "9399b2";
    subtext0 = "a6adc8";
    subtext1 = "bac2de";
    text = "cdd6f4";
    rosewater = "f5e0dc";
    flamingo = "f2cdcd";
    pink = "f5c2e7";
    hotpink = "fb6f92";
    mauve = "cba6f7";
    red = "f38ba8";
    peach = "fab387";
    yellow = "f9e2af";
    green = "a6e3a1";
    teal = "94e2d5";
    blue = "89b4fa";
    lavender = "b4befe";
  };

  # ── Roles: what the apps actually reference ──────────────────────
  c = {
    accent = p.pink; # main highlight: active workspace, borders, cursor
    accent2 = p.hotpink; # secondary highlight: gradients, matches, keywords
    accent3 = p.flamingo; # soft third pink
    bg = p.base; # main background
    bgDark = p.crust; # text on top of accent-coloured backgrounds
    panel = p.surface0; # pills, bars, cards
    hover = p.surface1; # hover / selection
    dim = p.surface2; # inactive borders, separators
    muted = p.overlay0; # comments, disabled text
    subtle = p.subtext0; # secondary text
    fg = p.text; # main text
    good = p.green;
    warn = p.yellow;
    bad = p.red;
  };

  font = {
    mono = "CaskaydiaCove Nerd Font";
    cjk = "Noto Sans CJK SC";
    termSize = 11;
  };

  hexByte = h: i: lib.fromHexString (builtins.substring i 2 h);
  rgbWith =
    sep: h:
    lib.concatMapStringsSep sep (i: toString (hexByte h i)) [
      0
      2
      4
    ];
  # ──────────────────────────────────────────────────────────────────
in
{
  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    noto-fonts
    noto-fonts-cjk-sans
  ];
  fonts.fontconfig.defaultFonts = {
    monospace = [
      font.mono
      font.cjk
    ];
    sansSerif = [
      "Noto Sans"
      font.cjk
    ];
  };

  environment.etc = {

    # ── waybar (GTK3): @define-color names ──
    "theme/waybar.css".text = ''
      @define-color bg_dark #${c.bgDark};
      @define-color bar_bg  alpha(#${c.bg}, 0.85);
      @define-color hover   #${c.hover};
      @define-color fg      #${c.fg};
      @define-color subtle  #${c.subtle};
      @define-color accent  #${c.accent};

      * { font-family: "${font.mono}", "${font.cjk}"; }
    '';

    # ── swaync (GTK4): CSS variables ──
    "theme/swaync.css".text = ''
      @import url("file://${pkgs.swaynotificationcenter}/etc/xdg/swaync/style.css");

      :root {
        --cc-bg: alpha(#${c.bg}, 0.85);
        --noti-bg: ${rgbWith ", " c.panel};
        --noti-bg-alpha: 0.8;
        --noti-bg-darker: #${p.mantle};
        --noti-bg-hover: #${c.hover};
        --noti-bg-focus: alpha(#${c.hover}, 0.6);
        --noti-border-color: #${c.accent};
        --noti-close-bg: alpha(#${c.fg}, 0.1);
        --noti-close-bg-hover: alpha(#${c.fg}, 0.15);
        --text-color: #${c.fg};
        --text-color-disabled: #${c.muted};
        --bg-selected: #${c.accent};
      }

      * { font-family: "${font.mono}", "${font.cjk}", sans-serif; }
    '';

    # ── niri: pink gradient border ──
    "theme/niri.kdl".text = ''
      layout {
          border {
              active-gradient from="#${c.accent}" to="#${c.accent2}" angle=45
              inactive-color "#${c.dim}aa"
          }
      }
    '';

    # ── alacritty ──
    "theme/alacritty.toml".text = ''
      [font]
      normal = { family = "${font.mono}" }
      size = ${toString font.termSize}.0

      [colors.primary]
      background = "#${c.bg}"
      foreground = "#${c.fg}"

      [colors.cursor]
      text   = "#${c.bgDark}"
      cursor = "#${c.accent}"

      [colors.selection]
      text       = "#${c.bgDark}"
      background = "#${c.accent}"

      [colors.normal]
      black   = "#${p.surface1}"
      red     = "#${p.red}"
      green   = "#${p.green}"
      yellow  = "#${p.yellow}"
      blue    = "#${p.blue}"
      magenta = "#${p.pink}"
      cyan    = "#${p.teal}"
      white   = "#${p.subtext1}"

      [colors.bright]
      black   = "#${p.surface2}"
      red     = "#${p.red}"
      green   = "#${p.green}"
      yellow  = "#${p.yellow}"
      blue    = "#${p.blue}"
      magenta = "#${p.hotpink}"
      cyan    = "#${p.teal}"
      white   = "#${p.subtext0}"
    '';

    # ── fuzzel ──
    "theme/fuzzel.ini".text = ''
      [main]
      font=${font.mono}:size=12

      [colors]
      background=${c.bg}f2
      text=${c.fg}ff
      prompt=${c.accent}ff
      placeholder=${c.muted}ff
      input=${c.fg}ff
      match=${c.accent2}ff
      selection=${c.hover}ff
      selection-text=${c.accent}ff
      selection-match=${c.accent2}ff
      border=${c.accent}ff
    '';

    # ── fish (globals override universal vars) ──
    "theme/colors.fish".text = ''
      set -g fish_color_normal ${c.fg}
      set -g fish_color_command ${c.accent}
      set -g fish_color_keyword ${c.accent2}
      set -g fish_color_param ${c.fg}
      set -g fish_color_quote ${c.good}
      set -g fish_color_redirection ${c.accent3}
      set -g fish_color_operator ${c.accent3}
      set -g fish_color_end ${c.accent2}
      set -g fish_color_error ${c.bad}
      set -g fish_color_comment ${c.muted}
      set -g fish_color_autosuggestion ${c.muted}
      set -g fish_color_valid_path --underline
      set -g fish_color_selection --background=${c.hover}
      set -g fish_color_search_match --background=${c.hover}
      set -g fish_pager_color_prefix ${c.accent} --bold
      set -g fish_pager_color_completion ${c.fg}
      set -g fish_pager_color_description ${c.subtle}
      set -g fish_pager_color_progress ${c.muted}
      set -g fish_pager_color_selected_background --background=${c.hover}
            set -g fish_color_user ${c.accent}
      set -g fish_color_host ${c.accent3}
      set -g fish_color_host_remote ${c.warn}
      set -g fish_color_cwd ${c.accent2}
      set -g fish_color_cwd_root ${c.bad}
      set -g fish_color_status ${c.bad}

      set -gx LS_COLORS "di=1;38;2;${rgbWith ";" c.accent}:ln=38;2;${rgbWith ";" c.accent3}:ex=1;38;2;${rgbWith ";" c.accent2}:or=38;2;${rgbWith ";" c.bad}"
    '';

    # ── tmux ──
    "theme/tmux.conf".text = ''
      set -g status-style "bg=#${c.panel},fg=#${c.subtle}"
      set -g window-status-style "fg=#${c.subtle}"
      set -g window-status-current-style "bg=#${c.accent},fg=#${c.bgDark},bold"
      set -g pane-border-style "fg=#${c.dim}"
      set -g pane-active-border-style "fg=#${c.accent}"
      set -g message-style "bg=#${c.panel},fg=#${c.accent}"
      set -g mode-style "bg=#${c.accent},fg=#${c.bgDark}"
    '';
  };
}
