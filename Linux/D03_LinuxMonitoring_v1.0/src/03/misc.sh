#!/usr/bin/env bash

setColor() {
  setBG "$1" BG1
  setBG "$3" BG2
  setF "$2" F1
  setF "$4" F2
}

setBG() {
  if [[ $1 -eq 1 ]]; then
    eval "$2='$whiteBG'"
  elif [[ $1 -eq 2 ]]; then
    eval "$2='$redBG'"
  elif [[ $1 -eq 3 ]]; then
    eval "$2='$greenBG'"
  elif [[ $1 -eq 4 ]]; then
    eval "$2='$blueBG'"
  elif [[ $1 -eq 5 ]]; then
    eval "$2='$purpleBG'"
  elif [[ $1 -eq 6 ]]; then
    eval "$2='$blackBG'"
  fi
}

setF() {
  if [[ $1 -eq 1 ]]; then
    eval "$2='$whiteFont'"
  elif [[ $1 -eq 2 ]]; then
    eval "$2='$redFont'"
  elif [[ $1 -eq 3 ]]; then
    eval "$2='$greenFont'"
  elif [[ $1 -eq 4 ]]; then
    eval "$2='$blueFont'"
  elif [[ $1 -eq 5 ]]; then
    eval "$2='$purpleFont'"
  elif [[ $1 -eq 6 ]]; then
    eval "$2='$blackFont'"
  fi
}
