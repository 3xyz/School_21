#!/usr/bin/env bash

str='^-?[0-9]+([.][0-9]+)?$'

if [[ $1 =~ $str ]]; then
  echo "Error: args must be string not '$1'" >&2; exit 1
elif (( $# != 1 )); then
  echo "Error: expected 1 arg but given $#" >&2; exit 1
else
  echo $1
fi

