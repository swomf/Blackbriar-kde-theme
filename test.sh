# Constants for testing. This may change between systems.

test_lockscreen="/usr/lib/kscreenlocker_greet --testing --theme plasma/look-and-feel/com.github.swomf.Blackbriar"
test_sddm="sddm-greeter --test-mode --theme sddm/Blackbriar"

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

usage() {
  echo -e "$(cat << EOF
${b_CDEF}USAGE:${CDEF} ./test.sh [component]
Test a QML KDE theme component.

${b_CDEF}EXAMPLES${CDEF}
  ./test.sh l           # test lockscreen component
  ./test.sh sddm        # test sddm component

${b_CDEF}COMPONENTS${CDEF}
  l lockscreen : Lockscreen (usually bound to Super+L)
  s sddm       : SDDM theme (the actual login screen)

${b_CDEF}OPTIONS${CDEF}
  -h, --help            Print this help message

${b_CDEF}NOTES${CDEF}
  The location of the actual binaries used for testing depends on your system.
  Edit the constants at the top of the script if an error occurs.
EOF
  )"
}

main() {
  local action=
  case "$1" in
    "l"|"lockscreen")
      echo -e "Testing component ${CCIN}lockscreen${CDEF}..."
      $test_lockscreen
      ;;
    "s"|"sddm")
      echo -e "Testing component ${CCIN}sddm${CDEF}..."
      $test_sddm
      ;;
    "h"|"-h"|"--help"|*)
      usage
      exit 0
      ;;
  esac
}

main $1