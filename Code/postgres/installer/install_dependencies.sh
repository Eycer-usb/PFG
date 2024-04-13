#!/bin/bash


server=false
client=false


# Usage Instructions
print_usage() {
  printf "Usage: \
  $ ./install_dependencies [option]\n
  Options:\n
  -c : Install client dependencies\n
  -s : Install server dependencies\n"
}

if [[ $# -eq 0 ]]; then
    print_usage
    exit 1
fi

# Options Processor
while getopts 'csh' flag; do
  case "${flag}" in
    c) client=true ;;
    s) server=true ;;
    h) print_usage
       exit 1 ;;
  esac
done

# Server Side Dependencies Instalation
if [ ${server} = true ]; then
    sudo apt install -y postgresql-common \
        postgresql-client-14 \
        postgresql-14 \
        postgresql-server-dev-14 \
        postgresql-contrib \
        postgresql-server-dev-all
fi

# Client Side Dependencies Instalation
if [ ${client} = true ]; then
    sudo apt install -y openjdk-17-jdk \
    openjdk-17-jre \
    bc
fi