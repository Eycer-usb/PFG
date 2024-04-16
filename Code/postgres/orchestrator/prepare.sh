#!/bin/bash

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
python3 tpch_pgsql.py prepare
cd ..