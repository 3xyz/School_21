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
  echo -e "  Tool for sorting nginx logs"
  echo
  echo -e "${bold}Options:${normal}"
  echo -e "  -1    All entries sorted by response code"
  echo -e "  -2    All unique IPs found in the entries"
  echo -e "  -3    All requests with errors (response code - 4xx or 5xxx)"
  echo -e "  -4    All unique IPs found among the erroneous requests"
}
