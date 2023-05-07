#!/usr/bin/env bash

progress_bar() {
  let _progress=(${1}*100/${2}*100)/100
  let _done=(${_progress}*4)/10
  let _left=40-$_done
  _fill=$(printf "%${_done}s")
  _empty=$(printf "%${_left}s")
  echo -ne "\r ${blue}${_fill// /━}${gray}${_empty// /━} ${normal}${1}/${2}"
}
