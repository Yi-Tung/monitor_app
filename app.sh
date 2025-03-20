#!/bin/sh

function usage() {
  echo "$1 [start | stop]"
}

function trigger() {
  local _condition=true

  [[ "$(date +%S)" = "00" ]] && _condition=true || _condition=false
  echo "$_condition"
  
  if $_condition
  then
    return 1
  else
    return 0
  fi
}

function event() {
  echo "[DO SOMETHING]"
  return 1
}

#======================#
# Function: main       #
#======================#
app_pid_file="/tmp/monitor_app_pid"
action="$1"

case $action in
  'help' | '')
    usage "$(basename $0)"
    ;;
  'start')
    if [ ! -f "$app_pid_file" ] || [[ "`cat $app_pid_file`" = "" ]]
    then
      {
        while true
        do
          if [[ "$(trigger)" = 'true' ]]
          then
            event
          fi
          sleep 1
        done
      } &
      echo "$!" > "$app_pid_file"
    fi
    ;;
  'stop')
    pid=`cat "$app_pid_file"`
    if [ ! -z $pid ]
    then
      echo "kill the process '$pid'"
      kill -9 $pid
      echo "" > "$app_pid_file"
    fi
    ;;
  *)
    ;;
esac
#======================#
# end of main function #
#======================#
