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
  h)
    print_usage
    exit 1
    ;;
  *) print_usage
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

  # Maven Instalation
  mvn -version
  if [ ! $? -eq 0 ]; then
    wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
    sudo mkdir -p /usr/local/apache-maven/
    sudo tar -xvf apache-maven-3.9.6-bin.tar.gz -C /usr/local/apache-maven
    echo "export M2_HOME=/usr/local/apache-maven/apache-maven-3.9.6" >>~/.bashrc
    echo 'export M2=$M2_HOME/bin' >>~/.bashrc
    echo 'export MAVEN_OPTS=-"Xms256m -Xmx512m"' >>~/.bashrc
    echo 'export PATH=$M2:$PATH' >>~/.bashrc
    mvn -version
    if [ ! $? -eq 0 ]; then
      echo "Error Installing Maven try reloading the terminal or check the installation manually"
    fi
    rm apache-maven-3.9.6-bin.tar.gz
  else
    echo "Maven Already Installed"
  fi

fi
