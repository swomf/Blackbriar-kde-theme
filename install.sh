#!/bin/bash

ROOT_UID=0

THEME_NAME=Blackbriar
SRC_DIR=$(cd $(dirname $0) && pwd)

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  AURORAE_DIR="/usr/share/aurorae/themes"
  SCHEMES_DIR="/usr/share/color-schemes"
  PLASMA_DIR="/usr/share/plasma/desktoptheme"
  LOOKFEEL_DIR="/usr/share/plasma/look-and-feel"
  KVANTUM_DIR="/usr/share/Kvantum"
  WALLPAPER_DIR="/usr/share/wallpapers"
else
  AURORAE_DIR="$HOME/.local/share/aurorae/themes"
  SCHEMES_DIR="$HOME/.local/share/color-schemes"
  PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
  LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
  KVANTUM_DIR="$HOME/.config/Kvantum"
  WALLPAPER_DIR="$HOME/.local/share/wallpapers"
fi

# COLORS
CDEF="\033[0m"                                     # default color
CCIN="\033[0;36m"                                  # info color
CGSC="\033[0;32m"                                  # success color
CRER="\033[0;31m"                                  # error color
CWAR="\033[0;33m"                                  # warning color
b_CDEF="\033[1;37m"                                # bold default color
b_CCIN="\033[1;36m"                                # bold info color
b_CGSC="\033[1;32m"                                # bold success color
b_CRER="\033[1;31m"                                # bold error color
b_CWAR="\033[1;33m"                                # bold warning color

installer() {
  local action=$1 # install or uninstall

  local name=$THEME_NAME

  local AURORAE_THEME="${AURORAE_DIR}/${name}"
  local PLASMA_THEME="${PLASMA_DIR}/${name}"
  local LOOKFEEL_THEME="${LOOKFEEL_DIR}/com.github.swomf.${name}"
  local SCHEMES_THEME="${SCHEMES_DIR}/${name}.colors"
  local KVANTUM_THEME="${KVANTUM_DIR}/${name}"
  local WALLPAPER_THEME="${WALLPAPER_DIR}/${name}"

  mkdir -p                                                                                   ${AURORAE_DIR}
  mkdir -p                                                                                   ${SCHEMES_DIR}
  mkdir -p                                                                                   ${PLASMA_DIR}
  mkdir -p                                                                                   ${LOOKFEEL_DIR}
  mkdir -p                                                                                   ${KVANTUM_DIR}
  mkdir -p                                                                                   ${WALLPAPER_DIR}

  [[ -d ${AURORAE_THEME} ]] && rm -rf ${AURORAE_THEME}
  [[ -d ${PLASMA_THEME} ]] && rm -rf ${PLASMA_THEME}
  [[ -d ${LOOKFEEL_THEME} ]] && rm -rf ${LOOKFEEL_THEME}
  [[ -f ${SCHEMES_THEME} ]] && rm -rf ${SCHEMES_THEME}
  [[ -d ${KVANTUM_THEME} ]] && rm -rf ${KVANTUM_THEME}
  [[ -d ${WALLPAPER_THEME} ]] && rm -rf ${WALLPAPER_THEME}
  [[ -d ${WALLPAPER_DIR}/${name} ]] && rm -rf ${WALLPAPER_DIR}/${name}

  if [[ $action == "uninstall" ]]; then
    echo -e "${b_CGSC}Uninstalled.${CDEF}"
    exit 0
  fi

  cp -r ${SRC_DIR}/aurorae/${name}                                                           ${AURORAE_DIR}

  cp -r ${SRC_DIR}/color-schemes/${name}.colors                                              ${SCHEMES_DIR}
  cp -r ${SRC_DIR}/Kvantum/${name}                                                           ${KVANTUM_DIR}

  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}                                               ${PLASMA_DIR}
  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}                                               ${PLASMA_THEME}

  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}/*                                             ${PLASMA_THEME}
  cp -r ${SRC_DIR}/color-schemes/${name}.colors                                              ${PLASMA_THEME}/colors
  cp -r ${SRC_DIR}/plasma/look-and-feel/com.github.swomf.${name}                             ${LOOKFEEL_DIR}
  cp -r ${SRC_DIR}/wallpaper/${name}                                                         ${WALLPAPER_DIR}

  echo -e "${b_CGSC}Installed.${CDEF}"
}

usage() {
  cat << EOF
Usage: ./install.sh [OPTION]
Install Blackbriar KDE into the current user HOME directory.
If no argument is specified, install the theme.

  -i, --install         Install theme (default action)
  -u, --uninstall       Uninstall theme
  -h, --help            Print this help message
EOF
}

main() {
  local action=
  case "$1" in
    ""|"-i"|"--install")
      echo -e "${b_CGSC}Installing${CDEF} theme in ${CCIN}${HOME}${CDEF}."
      action="install"
      ;;
    "-u"|"--uninstall")
      echo -e "${b_CRER}Uninstalling${CDEF} theme in ${CCIN}${HOME}${CDEF}."
      action="uninstall"
      ;;
    "-h"|"--help")
      usage
      exit 0
      ;;
    *)
      echo -e "${CRER}Error: Invalid option.${CDEF}"
      exit 1
      ;;
  esac

  read -n 1 -p "Continue? [y/N] " input
  echo
  if [ "$input" != "y" ] && [ "$input" != "Y" ]; then
    echo -e "${CRER}Error: Aborted by user.${CDEF}"
    exit 1
  fi

  installer $action
}

main $1