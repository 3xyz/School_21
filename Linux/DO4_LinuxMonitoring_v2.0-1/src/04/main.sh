#!/usr/bin/env bash

red="\033[31m"
blue="\033[34m"
gray="\033[1;30m"
bold="\033[1m"
normal="\033[0m"

main() {
  source "$(project_path)/generate_logs.sh"
  create_logs
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
