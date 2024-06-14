#!/bin/bash

maven=false
postgres=false
client=false
mongo=false


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
while getopts 'cpmgh' flag; do
  case "${flag}" in
  c) client=true ;;
  p) postgres=true ;;
  g) mongo=true ;;
  m) maven=true ;;
  h)
    print_usage
    exit 1
    ;;
  *) print_usage
    exit 1 ;;
  esac
done

# Install Maven

if [ $maven  = true]; then
  mvn -version
  if [ ! $? -eq 0 ]; then
    wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
    sudo mkdir -p /usr/local/apache-maven/
    sudo tar -xvf apache-maven-3.9.6-bin.tar.gz -C /usr/local/apache-maven
    echo "export M2_HOME=/usr/local/apache-maven/apache-maven-3.9.6" >>~/.bashrc
    echo 'export M2=$M2_HOME/bin' >>~/.bashrc
    echo 'export MAVEN_OPTS=-"Xms256m -Xmx512m"' >>~/.bashrc
    echo 'export PATH=$M2:$PATH' >>~/.bashrc
    bash
    mvn -version
    if [ ! $? -eq 0 ]; then
      echo "Error Installing Maven try reloading the terminal or check the installation manually"
    fi
    rm apache-maven-3.9.6-bin.tar.gz
  else
    echo "Maven Already Installed"
  fi
fi

# Client Side Dependencies Instalation
if [ ${client} = true ]; then
  sudo apt install -y openjdk-17-jdk \
    openjdk-17-jre \
    bc \
    libcurl4-openssl-dev

  cd ../../library
  mvn clean install package

  pip3 install pymongo # For Mongo benchmark generator
fi


# Postgres Dependencies Instalation
if [ ${postgres} = true ]; then
  sudo apt install -y postgresql-common \
    postgresql-client-14 \
    postgresql-14 \
    postgresql-server-dev-14 \
    postgresql-contrib \
    postgresql-server-dev-all
fi

# Mongodb Installation

if [ ${mongo} = true ]; then 
  sudo apt install -y gnupg curl
  curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
  echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.org/apt/debian bullseye/mongodb-org/7.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
  sudo apt-get update
  sudo apt-get install -y mongodb-org
  sudo systemctl start mongod
fi