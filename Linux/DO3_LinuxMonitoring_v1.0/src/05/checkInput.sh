#!/usr/bin/env bash

checkInput() {
  if [[ $# == 1 ]]; then
    if [[ $1 =~ /$ ]]; then
      if ! [[ -d "$1" ]]; then
          error "no such directory '$1'"
      fi
    else
        error "path must be ended with -> /"
    fi
  else
      error "expected 1 arg but given $#"
  fi
}

error() {
  redTag="\033[31m"
  n="\033[0m"
  echo -e "${redTag}Error:${n} $1" >&2; exit 1
}

