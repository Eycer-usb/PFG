#!/bin/bash
JOULARJX_INSTALLATION_PATH=/opt/joularjx

# This Script is for instalation before running
# Given execution permision to files
chmod +x ./*.sh

# Utils Tools
sudo apt install -y postgresql-common postgresql-client-14 postgresql-14 postgresql-server-dev-14 postgresql-contrib
sudo apt install -y openjdk-17-jdk openjdk-17-jre
sudo apt install -y bc

# Joularjx Installation
cd ../joularjx/install || exit 
sudo cp joularjx-*.jar ${JOULARJX_INSTALLATION_PATH}/joularjx.jar
sudo cp config.properties ${JOULARJX_INSTALLATION_PATH}/
cp ${JOULARJX_INSTALLATION_PATH}/config.properties ../../
cd - || exit

# Preparing Postgresql
echo Preparing Postgresql Database...

DB_NAME=tpch
sudo -u postgres psql <<PSQL
DROP DATABASE IF EXISTS $DB_NAME;
DROP USER IF EXISTS $DB_NAME;
CREATE USER $DB_NAME SUPERUSER;
CREATE DATABASE $DB_NAME;
PSQL

    sudo -u postgres psql <<PSQL
ALTER USER $DB_NAME WITH ENCRYPTED PASSWORD '********';
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_NAME;
\q
PSQL


# TPCH Benchmark

cd tpch-pgsql || exit
DATA_FILE=./tpch-dbgen
DATA_URL_REPO=https://github.com/electrum/tpch-dbgen
DATA_URL_FILE=archive/32f1c1b92d1664dba542e927d23d86ffa57aa253.zip
DATA_URL=$DATA_URL_REPO/$DATA_URL_FILE

if test -d "$DATA_FILE"; then
    echo "Benchmark downloaded"
else
    echo "Downloading Benchmark"
    wget -q $DATA_URL -O tpch-dbgen.zip
    unzip -q tpch-dbgen.zip
    mv tpch-dbgen-32f1c1b92d1664dba542e927d23d86ffa57aa253 tpch-dbgen
    rm tpch-dbgen.zip
fi

sudo chmod -R 777 .
pip3 install -r requirements.txt


python3 tpch_pgsql.py prepare