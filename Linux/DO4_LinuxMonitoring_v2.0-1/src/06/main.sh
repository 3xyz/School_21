#!/usr/bin/env bash

main() {
  format='%h - [%x] - "%m %U %H" - %s - "%u"'
  datetime_format='%Y/%B/%d %H:%M:%S'
  # Check for having GUI installed
  if [[ $(dpkg -l | grep xserver) ]]; then 
    goaccess ../04/nginx_logs/*.log \
      --datetime-format="$datetime_format" \
      --log-format="$format" \
      > index.html; open index.html
  else
      goaccess ../04/nginx_logs/*.log \
    --datetime-format="$datetime_format" \
    --log-format="$format"
  fi
}

main "$@"
