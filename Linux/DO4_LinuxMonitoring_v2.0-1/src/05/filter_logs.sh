#!/bin/bash


filter_logs() {
  for i in $@; do
    case $i in
      1)
        echo 1
        filter_by_response_code
        ;;
      2)
        filter_by_unique_ips
        ;;
      3)
        filter_by_error_resp_codes
        ;;
      4)
        filter_by_unique_ips
        ;;
    esac
  done
}

filter_by_response_code() {
  temp="nginx_records.tmp"
  for (( i=1; i<=5; i++ )); do
    log_file="../04/nginx_logs/$i.log"
    if [[ -f $log_file ]]; then
      cat $log_file >> $temp
    fi
  done
  sort -k 10 $temp
  rm $temp
}

filter_by_unique_ips() {
  temp="ips.tmp"
  for (( i=1; i<=5; i++ )); do
    log_file="../04/nginx_logs/$i.log"
    if [[ -f $log_file ]]; then
      cat $log_file >> $temp
    fi
  done
  awk "{print $1}" $temp | uniq
  rm $temp
}

filter_by_error_resp_codes() {
  for (( i=1; i<=5; i++ )); do
    log_file="../04/nginx_logs/$i.log"
    if [[ -f $log_file ]]; then
      ark 'print $10' $log_file
      awk '$10 ~ /[45][0-9][0-9]/' $log_file
    fi
  done
}

filter_by_unique_ips() {
  temp="nginx_records.tmp"
  for (( i=1; i<=5; i++ )); do
    log_file="../04/nginx_logs/$i.log"
    if [[ -f $log_file ]]; then
      cat $log_file >> $temp
    fi
  done
  awk '$10 ~ /[45][0-9][0-9]/' $temp | awk '{print $1}' | uniq
  rm $temp
}
