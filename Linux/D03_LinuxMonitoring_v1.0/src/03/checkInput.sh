#!/usr/bin/env bash

checkInput() {
  if [[ $# = 4 ]]; then
    for i in "$@"; do
      if ! [[ $i =~ ^[1-6]$ ]]; then
        error "given arg - \"$i\" while expected valuve in [1-6]"
      fi
    done
    if [[ $1 = "$2" ]] || [[ $3 = "$4" ]]; then
      error "background color and font color should be different"
    fi
  else
    error "expected 4 args but given $#"
  fi
}

error() {
  echo "Error: $1" >&2; exit 1
}
