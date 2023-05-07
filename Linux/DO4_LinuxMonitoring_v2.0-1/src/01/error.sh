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
  echo -e "${bold}Positional args:${normal}"
  echo "  1    the absolute path."
  echo "  2 th the number of subfolders."
  echo "  3 a  thlist of English alphabet letters used in folder names (no more than 7 characters)."
  echo "  4 th the number of files in each created folder."
  echo "  5 th the list of English alphabet letters used in the file name and extension (no more than 7 characters for the name, no more than 3 characters for the extension)."
  echo "  6 fi thle size (in kilobytes, but not more than 100)."
}
