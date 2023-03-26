#!/usr/bin/env bash

topDirs() {
  out=$(du -h "$1" | sort -rh | tail +2 | head -5 | awk '{print "- "$2", "$1}')
  IFS=$'\n'
  count=0
  for line in $out; do
    ((count +=1))
    echo "$count $line"
  done
}

topExe() {
  out="$(find "$1" -type f -executable -not -path '*/\.*' -exec du -h {} +  2>/dev/null | sort -hr | head -n 10 )"
  IFS=$'\n'
  count=0
  for line in $out; do
    ((count += 1))
    path=$(echo "$line" | awk '{print $2}')
    size=$(echo "$line" | awk '{print $1}' | sed -e 's:K: Kb:g' | sed 's:M: Mb:g' | sed 's:G: Gb:g' )
    md5=$(md5sum "$path" |  awk '{print $1}')
    printf "%d - %s, %s, %s\n" $count "$path" "$size" "$md5"
  done
}

topFiles() {
  out="$(find "$1" -type f -not -path '*/\.*' -exec du -h {} + 2>/dev/null | sort -hr | head -n 10 )"
  IFS=$'\n'
  count=0
  for line in $out; do
    ((count += 1))
    file=$(echo "$line" | awk '{print $2}')
    size=$(echo "$line" | awk '{print $1}' | sed -e 's:K: Kb:g' | sed 's:M: Mb:g' | sed 's:G: Gb:g')
    type=$(echo "$line" | awk '{tp=split($2,type,".") ; print type[tp]}')
    printf "$count - $file, $size, $type\n"
  done
}

