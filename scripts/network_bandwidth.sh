#!/usr/bin/env bash
export LC_ALL=en_US.UTF-8

# current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# source "$current_dir"/utils.sh
INTERVAL="1" # update interval in seconds

# network_name=$(tmux show-option -gqv "@dracula-network-name")
network_name="enp38s0"
main() {
  # network_name=$(get_tmux_option "@dracula-network-name", "enp38s0")
  # if [[ -z "$network_name" ]]; then
  #   network_name="enp38s0"
  #   # echo "Network name not set"
  #   # exit 1
  # fi
  while true; do
    output_download=""
    output_upload=""
    output_download_unit=""
    output_upload_unit=""
    initial_download=$(cat /sys/class/net/"$network_name"/statistics/rx_bytes)
    initial_upload=$(cat /sys/class/net/"$network_name"/statistics/tx_bytes)

    sleep $INTERVAL

    final_download=$(cat /sys/class/net/"$network_name"/statistics/rx_bytes)
    final_upload=$(cat /sys/class/net/"$network_name"/statistics/tx_bytes)
    echo $final_download >> './log.txt'
    total_download_bps=$(expr "$final_download" - "$initial_download")
    total_upload_bps=$(expr "$final_upload" - "$initial_upload")

    if [ "$total_download_bps" -gt 1073741824 ]; then
      output_download=$(echo "$total_download_bps 1024" | awk '{printf "%.2f \n", $1/($2 * $2 * $2)}')
      output_download_unit="gB/s"
    elif [ "$total_download_bps" -gt 1048576 ]; then
      output_download=$(echo "$total_download_bps 1024" | awk '{printf "%.2f \n", $1/($2 * $2)}')
      output_download_unit="mB/s"
    else
      output_download=$(echo "$total_download_bps 1024" | awk '{printf "%.2f \n", $1/$2}')
      output_download_unit="kB/s"
    fi

    if [ "$total_upload_bps" -gt 1073741824 ]; then
      output_upload=$(echo "$total_download_bps 1024" | awk '{printf "%.2f \n", $1/($2 * $2 * $2)}')
      output_upload_unit="gB/s"
    elif [ "$total_upload_bps" -gt 1048576 ]; then
      output_upload=$(echo "$total_upload_bps 1024" | awk '{printf "%.2f \n", $1/($2 * $2)}')
      output_upload_unit="mB/s"
    else
      output_upload=$(echo "$total_upload_bps 1024" | awk '{printf "%.2f \n", $1/$2}')
      output_upload_unit="kB/s"
    fi
    echo "??? $output_download $output_download_unit ??? ??? $output_upload $output_upload_unit" >>'./log.txt'
    echo "??? $output_download $output_download_unit ??? ??? $output_upload $output_upload_unit"
  done
}
main
