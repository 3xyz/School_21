#!/usr/bin/env bash

create_files_and_dirs() {
  path=$(pwd)

  dir_chars=$1
  file_chars=$(echo $2 | cut -d '.' -f 1)
  file_extention=$(echo $2 | cut -d '.' -f 2)
  size=${3:0:-2}
  unit=${6: -2}

  dirs_count=100
  files_count_max=100

  date=$(date +"%d%m%y")
  log_date=$(date +'%Y-%m-%d %R')

  dir_names="$(project_path)/temp_dir_names.txt"
  file_names="$(project_path)/temp_file_names.txt"
  echo $(get_dir_names $dir_chars $dirs_count) > $dir_names
  echo $(get_file_names $file_chars $files_count_max) > $file_names
  check_file_names_length $dir_names $file_names

  for i in $(seq 1 $dirs_count); do 
    dir_name="$(create_dir $i)"
    for j in $(seq 1 $(shuf -i 1-$files_count_max -n 1)); do 
      check_memory
      create_file $j
    done
    progress_bar $i $dirs_count
  done

  printf "\n ${bold}All done!\n"
  remove_temp
}

create_dir() {
  dir_name="$(cut $dir_names -d ':' -f $1)"
  path_to_dir="$path/$dir_name"
  mkdir -p "$path_to_dir"
  log "$log_date" "4kb" "$path_to_dir/"
  echo $dir_name
}

create_file() {
  file_name="$(cut $file_names -d ':' -f $1)"
  path_to_file="$path/$dir_name/$file_name"
  touch "$path_to_file"
  fallocate -l ${size}MB "$path_to_file"
  log "$log_date" "${size}mb" "$path_to_file"
}

get_dir_names() {
  echo $(gen_prefixes $dir_chars $dirs_count) \
    | xargs -d ":" -I {} echo -n "{}_$date:"
}

get_file_names() {
  echo $(gen_prefixes $file_chars $files_count_max) \
    | xargs -d ":" -I {} echo -n "{}_$date.$file_extention:"
}

check_memory() {
  stop_mb_size=1000
  local free_space=$(df -m / | head -2 | tail +2 | awk '{printf $4}')
  if (( $free_space < $stop_mb_size )); then
    printf "\n ${red}Less than $stop_mb_size MB left in the system"
    terminate
  fi
}

check_file_names_length() {
  length_of_names=$(cat $@ | xargs -n1 -d ':' sh -c 'echo ${#0}')
  for i in $length_of_names; do 
    if (( i > 255 )); then
      printf " ${red}With that input, file names become longer than linux limit (255)"
      terminate
    fi
  done
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

# EXPECTED ARGS -> CHARS, COUNT
gen_prefixes() {
  names=""
  default=1
  default_other=1
  count_names=0
  i=-1
  old_name=""
  while (( $count_names != $2 )); do
    let i+=1
    break=0
    let char_index=$i%${#1}
    let cycles_count=$i/${#1}%${#1}
    name=""
    for (( j=0; j<${#1}; j++ )); do
      # CHECK FOR DUPLES PART
      if (( $default_other != 1 )); then
        if (( $char_index <= $cycles_count )); then
          break;
        fi
      fi
      # ADDING ADDITIONAL CHAR -> aabBc, aabcC
      if (( $j == $char_index && $j != $cycles_count )); then
        if (( $default_other != $default )); then
          for (( k=0; k < default_other; k++ )); do
            name+="${1:$j:1}"
          done
        elif (( $char_index > $cycles_count )); then
          for (( k=0; k < default_other; k++ )); do
            name+="${1:$j:1}"
          done
        fi
      fi
      # ADDING DEFAULT CHAR -> aAbc, abBc, abcC
      if (( $j == $cycles_count )); then
        for (( k=0; k < default; k++ )); do
          name+="${1:$j:1}"
        done
      fi
      # ADDING DEFAULT CHARS -> ABC
      name+="${1:$j:1}"
      # WE CAN INCREASE VARIATIONS BY ADDING DEFAULT ADDITIONAL CHARS -> aAbBcC
      # for (( k=0; k < default_other; k++ )); do
      #   name+="${1:$j:1}"
      # done
    done
    # APPEND GENERATED NAME
    if (( $break == 0 )); then
      if (( $char_index == ${#1}-1 && $cycles_count == ${#1}-1 )); then
        if (( $default_other < $default )); then
          let default_other++
        else
          default_other=1
          let default++
        fi
      fi
      if (( ${#name} < 4 )); then
        continue
      fi
      if [[ $old_name != $name ]]; then
        let count_names+=1
        names+="$name:"
        old_name=$name
      fi
    fi
  done
  echo $names
}

# EXPECTED ARGS -> ABSOLUT_PATH, DATE, FILE_SIZE
log() {
  echo "$1 - $2 - $3" >> "$log_file"
}

remove_temp() {
  rm -f $dir_names $file_names
}

