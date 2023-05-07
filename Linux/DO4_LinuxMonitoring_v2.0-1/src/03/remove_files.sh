#!/usr/bin/env bash

remove_by_log_file() {
  cat $1 | grep -e "^Started" -v | grep -e "/.*" -o | xargs rm -rf
}

remove_by_creating_date() {
  log_file=$1
  start=$(date -d "$2" +%s)
  end=$(date -d "$3" +%s)
  while read line; do 
    file_date=$(echo $line | grep -E "^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}" -o)
    if [[ -z $file_date ]]; then
      continue
    fi
    file_date=$(date -d "$file_date" +"%s")
    file_path=$(echo $line | grep -e "/.*" -o)
    if (( $file_date >= $start && $file_date <= $end )); then
      rm -rf $file_path
    fi
  done < $1
}

remove_by_chars_mask() {
  char_mask=$(remove_duples_chars $2)
  char_regex=$(make_regex_char $char_mask)
  while read line; do 
    path_file=$(echo $line | grep -e "^Started" -v | grep -e "/.*" -o)
    if [[ -z $path_file ]]; then
      continue
    fi
    file_name=$(echo $path_file | rev | cut -d '/' -f 1 | rev)
    if ! [[ -z $file_name ]]; then
      if [[ $file_name =~ $char_regex ]]; then
        rm -rf $path_file
      fi
    else 
      dir_name=$(echo $path_file | rev | cut -d '/' -f 2 | rev)
      if [[ $dir_name =~ $char_regex ]]; then
        rm -rf $path_file
      fi
    fi
  done < "$1"
}

make_regex_char() {
  gen_regex="^"
  for i in $(seq 1 ${#1}); do 
    gen_regex+=${1:$i-1:1}
    gen_regex+="+"
  done
  gen_regex+="_[0-9]{6}($|.[a-zA-Z]{1,3}$)"
  echo $gen_regex
}

remove_duples_chars () {
  chars=""
  old_char=""
  for (( j=0; j<${#1}; j++ )); do 
    if [[ $old_char != ${1:$j:1} ]]; then
      chars+=${1:$j:1}
      old_char=${1:$j:1}
    fi
  done
  echo $chars
}
