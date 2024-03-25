## Blackbriar KDE theme

![1](Blackbriar-preview.png)

Blackbriar-KDE is a sleek design theme for KDE Plasma desktop, focusing
on the contrast between black backgrounds and white outlines. Borrows from many
themes (see licensing/attribution).

In this repository you'll find:

- Aurorae Themes
- Kvantum Themes (I don't use this.)
- Plasma Color Schemes
- Plasma Desktop Themes
- Plasma Global Themes
- Wallpapers

## Installation

### For the main theme, use these.

```sh
$ ./install.sh --help

Usage: ./install.sh [OPTION]
Install Blackbriar KDE into the current user HOME directory.
If no argument is specified, install the theme.

  -i, --install         Install theme (default action)
  -u, --uninstall       Uninstall theme
  -h, --help            Print this help message
```

Install theme for all users
```sh
sudo ./install.sh
```

Uninstall for current user
```sh
./install.sh --uninstall
```

### For recommended additions, use these.

- Use [Blackbriar GTK theme](https://github.com/swomf/Blackbriar-gtk-theme)
- Use [Qogir cursors](https://github.com/vinceliuice/Qogir-icon-theme/tree/master/src/cursors)
  and [ePapirus-Dark](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) icons.
- [Kvantum engine](https://github.com/tsujan/Kvantum/tree/master/Kvantum)
  provides `kvantummanager`. I don't use it; this is here for posterity.

## Licensing/Attribution

GNU GPL v3

**Assets taken from:**
- [Graphite-gtk-theme](https://github.com/vinceliuice/Graphite-gtk-theme)
- [Materia KDE](https://github.com/PapirusDevelopmentTeam/materia-kde)
- Wallpaper is from an unknown source. Raise an issue if found.