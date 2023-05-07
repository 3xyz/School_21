#!/usr/bin/env bash

red="\033[31m"
blue="\033[34m"
gray="\033[1;30m"
bold="\033[1m"
normal="\033[0m"

trap terminate INT
trap terminate QUIT
trap terminate TSTP

main() {
  start=$(date +%s)

  log_file="$(project_path)/noised_files.log"
  source "$(project_path)/generate_files.sh"
  source "$(project_path)/progress_bar.sh"
  source "$(project_path)/error.sh"
  check_input "$@"
  create_files_and_dirs "$@"

  end=$(date +%s)
  echo "Started $(date +'%F %T' -d @$start) \
- Ended $(date +'%F %T' -d @$end) \
- Time took $(date +'(Min/Sec: %M:%S)' -d @$((end-start)))" | tee -a $log_file
}

check_input() {
  if [ $# != 3 ]; then
    help_message; exit 1
  elif ! [[ $1 =~ ^[a-zA-Z]{1,7}$ ]]; then
    error "1sd argument must consist of 7 characters of the \
English alphabet"
  elif ! [[ $2 =~ ^[a-zA-Z]{1,7}[.][a-zA-Z]{1,3}$ ]]; then
    error "2nd argument must consist no more than 7 characters \
of the English alphabet in name of file and 3 characters in \
extention part"
  elif ! [[ ${3,,} =~ ^[1-9][0-9]*mb$ ]] || ! (( ${3:0:-2} <= 100 )); then
    error "3rd argument must be a integer which less than 100 and ended with mb"
  elif [[ $(pwd) =~ .*/(bin|sbin)(/.*|$) ]]; then
    error "Can't create files inside ${bold}bin, sbin$normal directories"
  fi
}

project_path() {
  SOURCE=${BASH_SOURCE[0]}
  while [ -L "$SOURCE" ]; do
    DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
    SOURCE=$(readlink "$SOURCE")
    [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE
  done
  DIR=$( cd -P "$( dirname "$SOURCE" )" > /dev/null 2>&1 && pwd )
  echo $DIR
}

terminate() {
  printf "\n ${bold}${red}Terminated\n"
  remove_temp
  exit 1
}

main "$@"
