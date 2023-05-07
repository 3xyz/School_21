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
  echo -e "  Tool for removing past trash files"
  echo
  echo -e "${bold}Options:${normal}"
  echo -e "  -1 <log file>"
  echo -e "  -2 >interact<"
  echo -e "  -3 <mask chars>"
}
