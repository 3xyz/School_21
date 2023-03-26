#!/usr/bin/env bash

checkInput() {
  # CHECK FOR EMTY ARG
  if [[ -z $1 ]] || [[ -z $2 ]] || [[ -z $3 ]] || [[ -z $4 ]]; then
    BG1=3; F1=1; BG2=4; F2=1;
  fi
  # CHECK FOR EXPECTED ARG
  for i in $@; do
    if ! [[ $i =~ ^[1-6]$ ]]; then
      error "given arg - \"$i\" whie expected valuve in [1-6]"
    fi
  done
  # CHECK FOR DIFF COLORS
  if [[ $1 = $2 ]] || [[ $3 = $4 ]]; then
    error "background color and font color should be different"
  fi
}

error() {
  echo "Error: $1" >&2; exit 1
}
