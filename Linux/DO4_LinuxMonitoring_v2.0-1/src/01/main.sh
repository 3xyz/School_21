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
  log_file="$(project_path)/created_files.log"
  source "$(project_path)/generate_files.sh"
  source "$(project_path)/progress_bar.sh"
  source "$(project_path)/error.sh"
  check_input "$@"
  create_files_and_dirs "$@"
}

check_input() {
  regex_int="^[1-9][0-9]*$"
  if [ $# != 6 ]; then
    help_message; exit 1
  elif ! [[ $1 = /* && -d $1 ]]; then
    error "1st argument must be the absolute path to an existing direcory"
  elif ! [[ $2 =~ $regex_int ]]; then
    error "2nd argument must be a integer"
  elif ! [[ $3 =~ ^[a-zA-Z]{1,7}$ ]]; then
    error "3rd argument must consist of 7 characters of the \
English alphabet"
  elif ! [[ $4 =~ $regex_int ]]; then
    error "4th argument must be a integer"
  elif ! [[ $5 =~ ^[a-zA-Z]{1,7}[.][a-zA-Z]{1,3}$ ]]; then
    error "5th argument must consist no more than 7 characters \
of the English alphabet in name of file and 3 characters in \
extention part"
  elif ! [[ ${6,,} =~ ^[1-9][0-9]*kb$ ]] || ! (( ${6:0:-2} <= 100 )); then
    error "6th argument must be a integer and less than 100"
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
