#! bin/bash

# =============================================================================
# This basically allows you to standardize your log messages. 
# You don't have to format them like this if you don't want to, you could just 
# use `echo`.
# I like being able to see what process ID is associated with the script and 
# the time of the message.
# =============================================================================
function log() {
  PID=$1
  MESSAGE=$2
  TIME=$(date +%F_%H.%M.%S_%Z)
  echo -e "${TIME}|${PID}|${MESSAGE}"
}

# =============================================================================
# This basically allows you to standardize your error messages. 
# You don't have to format them like this if you don't want to, you could just 
# use `echo`.
# I like being able to see what process ID is associated with the script and 
# the time of the message.
# =============================================================================
function log_error() {
  # Colors:
  TEXT_RESET='\033[0m' 
  TEXT_RED='\033[0;31m'
  TEXT_RED_BOLD='\033[1;31m'

  PID=$1
  MESSAGE=$2
  TIME=$(date +%F_%H.%M.%S_%Z)
  echo -e "${TIME}|${PID}|${TEXT_RED_BOLD}ERROR: ${TEXT_RED}${MESSAGE}${TEXT_RESET}\n"
}
