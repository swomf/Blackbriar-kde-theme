#!/bin/bash
# You may need to change the following based on the location of testing binaries
# on your system. e.g. kscreenlocker_greet might be in /usr/lib64/libexec

declare -A testing_commands
testing_commands=(
  ["lockscreen"]="/usr/lib/kscreenlocker_greet --testing --theme $(pwd)/plasma/look-and-feel/com.github.swomf.Blackbriar"
  ["sddm"]="/usr/bin/sddm-greeter --test-mode --theme sddm/Blackbriar"
)

# color constants
CDEF="\033[0m"                               # default color
CCIN="\033[0;36m"                            # info color
CGSC="\033[0;32m"                            # success color
CRER="\033[0;31m"                            # error color
CWAR="\033[0;33m"                            # warning color
b_CDEF="\033[1;37m"                          # bold default color
b_CCIN="\033[1;36m"                          # bold info color
b_CGSC="\033[1;32m"                          # bold success color
b_CRER="\033[1;31m"                          # bold error color
b_CWAR="\033[1;33m"                          # bold warning color
ITALIC="\033[3m"                             # italic

# dep check
if [ ! command -v fzf &> /dev/null ]; then
  echo "This script requires fzf."
  exit 1
fi

# pick command
selected_command=
if [ -z $1 ]; then
  # prompt user for test, given no args
  selected_command=$(printf "%s\n" "${!testing_commands[@]}" | \
  fzf --reverse --border --prompt='Test what? ' 
  )
else
  # best guess
  selected_command=$(printf "%s\n" "${!testing_commands[@]}" | grep -i $1)
  printf "${b_CCIN}:: ${b_CDEF}Press enter to test ${CCIN}${ITALIC}${selected_command}${b_CDEF}.${CDEF} "
  read
fi

# command must exist
if [ -z "$selected_command" ]; then
  exit 1
fi

# run command
echo -e "${b_CCIN}:: ${b_CDEF}Testing ${CCIN}${ITALIC}${selected_command}${b_CDEF}...${CDEF}"
echo ${testing_commands[$selected_command]} | bash