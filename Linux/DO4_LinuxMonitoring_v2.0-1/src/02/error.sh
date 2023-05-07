#!/usr/bin/env bash

random_emoji() {
  emoji=(👿 👺 😫 😅 🤌)
  echo ${emoji[$RANDOM % ${#emoji[@]}]}
}

error() {
  echo -e " $(random_emoji) ${red}${bold}Error:${normal} $1" >&2
  exit 1
}

help_message() {
  echo -e "${bold}Description:${normal}"
  echo -e "  Tool for generating files"
  echo
  echo -e "${bold}Posiotional args:${normal}"
  echo "  1    is a list of English alphabet letters used in folder names (no more than 7 characters)."
  echo "  2    the list of English alphabet letters used in the file name and extension (no more than 7 characters for the name, no more than 3 characters for the extension)."
  echo "  3    is the file size (in Megabytes, but not more than 100)."
}
