#!/usr/bin/env bash

# Create a function to generate a random IP address
rand_ip() {
  echo $((RANDOM%223+1)).$((RANDOM%255)).$((RANDOM%255)).$((RANDOM%255))
}

create_logs() {
  mkdir -p nginx_logs
  # Create arrays for response codes, methods, agents, and URLs
  response_codes=(200 201 400 401 403 404 500 501 502 503)
  methods=("GET" "POST" "PUT" "PATCH" "DELETE")
  agents=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")
  urls=("/about" "/contact" "/services" "/blog" "/products")

  # Loop through each of the five days
  for i in {1..5}; do
    # Create a file for today's logs
    log_file="./nginx_logs/$i.log"
    touch $log_file

    # Generate a random number of entries for today
    num_entries=$((RANDOM%900+100))

    # Loop through each entry and write to the log file
    for (( j=1; j<=$num_entries; j++ )); do
      # Generate a random IP address
      ip=$(rand_ip)
      # Choose a random response code from the array
      response_code=${response_codes[$RANDOM % ${#response_codes[@]} ]}
      # Choose a random method from the array
      method=${methods[$RANDOM % ${#methods[@]} ]}

      # Generate a random date within the specified log day
      hour=$((RANDOM%23))
      [[ ${#hour} < 2 ]] && hour="0$hour"
      minute=$((RANDOM%59))
      [[ ${#minute} < 2 ]] && minute="0$minute"
      second=$((RANDOM%59))
      [[ ${#second} < 2 ]] && second="0$second"
      day=$(printf "%02d" $i)
      month="April"
      year="2023"
      date="$year/$month/$day $hour:$minute:$second"

      # Choose a random agent from the array
      agent=${agents[$RANDOM % ${#agents[@]}]}

      # Choose a random URL from the array
      url=${urls[$RANDOM % ${#urls[@]}]}

      # Write the log entry to the file in combined format
      echo "$ip - [$date] - \"$method $url HTTP/1.1\" - $response_code - \"$agent\"" >> $log_file
    done
  done
}
