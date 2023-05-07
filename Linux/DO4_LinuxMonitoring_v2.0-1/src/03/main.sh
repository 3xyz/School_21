#!/usr/bin/env bash

red="\033[31m"
blue="\033[34m"
gray="\033[1;30m"
bold="\033[1m"
normal="\033[0m"

main() {
  source "$(project_path)/remove_files.sh"
  source "$(project_path)/error.sh"
  source "$(project_path)/log_file.conf"
  read_args "$@"
}

read_args() {
  for i in $(seq 1 $#); do
    case ${@:$i:1} in
      -1)
        LOG_FILE="${@:$i+1:1}"
        check_log_file "$LOG_FILE"
        remove_by_log_file $LOG_FILE
        shift
        ;;
      -2)
        echo "We'll parse file data from $log_file u can change that in log_file.conf"
        read -p " Enter start date (YYYY-MM-DD HH:MM): " START_DATE
        check_date "$START_DATE"
        read -p " Enter end date (YYYY-MM-DD HH:MM): " END_DATE
        check_date "$END_DATE"
        remove_by_creating_date "$log_file" "$START_DATE" "$END_DATE"
        ;;
      -3)
        echo "We'll parse file data names from $log_file u can change that in log_file.conf"
        CHARS_MASK="${@:$i+1:1}"
        check_chars_mask "$CHARS_MASK"
        remove_by_chars_mask "$log_file" "$CHARS_MASK"
        shift
        ;;
      -h|--help)
        help_message
        ;;
      -*|--*)
        error "unknown option ${bold}${@:$i:1}"
        help_message
        ;;
      *)
        ;;
    esac
  done
}

check_log_file() {
  if ! [[ -f $1 ]]; then
    error "no such file '$1'"
  fi
}

check_date() {
  if ! [[ $1 =~ [0-9]{4}-[0-9]{2}-[0-9]{2}[[:space:]][0-9]{2}:[0-9]{2} ]]; then
    error "date format must be like '2022-04-24 13:45' not like '$1'"
  fi
}

check_chars_mask() {
  if ! [[ $1 =~ ^[a-zA-Z]+$ ]]; then
    error "chars mask must contain only english alphabet chars"
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

main "$@"
