# st — simple terminal

A custom build of [st](https://st.suckless.org/), the simple terminal emulator for X that sucks less.

## Features / Applied Patches

| Patch | File | Description |
|-------|------|-------------|
| **alpha** | `st-alpha-20220206-0.8.5.diff` | Background transparency support via the `alpha` float in `config.h` (default: `0.8`). Requires a compositor. |
| **scrollback** | `st-scrollback-0.8.5.diff` | Scroll back through terminal output using `Shift+PageUp` / `Shift+PageDown`. |
| **boxdraw v2** | `st-boxdraw_v2-0.8.5.diff` | Renders box-drawing and braille characters (U2500–U259F, U28XX) natively without relying on the font, ensuring pixel-perfect alignment. |
| **xresources + signal reloading** | `st-xresources-signal-reloading-20220407-ef05519.diff` | Read colors and settings from `~/.Xresources`. Reload on-the-fly by sending `SIGUSR1` to the process. |
| **anysize** | `st-expected-anysize-0.9.diff` | Allows st to resize to any pixel size (not just multiples of cell dimensions), preventing gaps when tiling. |
| **font2** | `st-font2-20190326-f64c2f8.diff` | Adds a secondary/fallback font (`font2`) used for glyphs not present in the primary font. |
| **font2 array** | `st-font2-array.diff` | Extends the font2 patch to accept an array of fallback fonts instead of a single one. |

## Configuration

Copy `config.def.h` to `config.h` and edit to taste before building.

### Fonts

```c
static char *font = "JetBrainsMono Nerd Font Propo:pixelsize=15:antialias=true:autohint=true";
static const char *font2[] = {
    "DejaVu Sans Mono:pixelsize=15:antialias=true:autohint=true",
    "Noto Sans Mono CJK JP:pixelsize=15:antialias=true:autohint=true",
    "NotoColorEmoji:pixelsize=11:antialias=true:autohint=true",
};
```

- Primary font: JetBrainsMono Nerd Font Propo
- Fallback fonts (in order): DejaVu Sans Mono (broad glyph coverage), Noto Sans Mono CJK JP (CJK characters), NotoColorEmoji (emoji)

### Transparency

```c
float alpha = 0.8;
```

Requires a running compositor (e.g. picom, compton).

### Key Bindings

| Shortcut | Action |
|----------|--------|
| `Ctrl+Shift+C` | Copy to clipboard |
| `Ctrl+Shift+V` | Paste from clipboard |
| `Ctrl+Shift+Y` | Paste from primary selection |
| `Shift+Insert` | Paste from primary selection |
| `Shift+PageUp` | Scroll up |
| `Shift+PageDown` | Scroll down |
| `Ctrl+Shift+Home` | Reset zoom |
| `PageUp` | Zoom in |
| `PageDown` | Zoom out |

## Requirements

- Xlib header files
- libXft
- fontconfig
- A compositor for transparency (optional)

## Installation

```sh
# Edit config.mk for your local setup, then:
make clean install
```

## Running Without Installing

If st was not installed via `make install`, register the terminfo entry first:

```sh
tic -sx st.info
```

## Credits

Based on the [suckless st](https://st.suckless.org/) source.
Original bt source by Aurélien APTEL.
