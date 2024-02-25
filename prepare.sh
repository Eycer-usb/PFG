#!/bin/bash

###########################################################################################
#                           INSTALLATION CONFIGURATION AND RUN SCRIPT                     #
#           This script is for system configuration and tools installation                #
#                   Also run the scaphandre exporter and prometheus service               #
###########################################################################################

export PATH="/opt/scaphandre:$PATH"

install(){
    cd scaphandre || exit
    cargo build

    sudo mkdir /opt/scaphandre
    sudo mv target/debug/scaphandre /opt/scaphandre
    sudo chmod +x /opt/scaphandre/scaphandre
    cd - || exit
    
    # Uncomment line bellow to store in path
}

run() {
    echo "Starting Running process..."
    cd scaphandre || exit
    sudo chmod +x init.sh
    ./init.sh
    cd - || exit

    scaphandre prometheus >> /dev/null &
    scaphandreId=$!
    echo "Scaphandre exporter process started with id: $scaphandreId"

    docker run --network="host" -v "$(pwd)"/prometheus:/etc/prometheus prom/prometheus >> /dev/null &
    prometheusId=$!
    echo "Prometheus process started with id: $prometheusId"
}


while getopts ":rih" opt; do
  case $opt in
    r)
      run
      ;;
    i)
      install
      ;;
    h)
      echo "Usage: $0 [-r] [-i] [-h]"
      echo "  -r     run mode"
      echo "  -i     installation mode"
      echo "  -h     Display this help message"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done