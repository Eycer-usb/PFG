#!/bin/bash

# Preparing Postgresql
echo Preparing Postgresql Database...

sudo -u $database_user psql <<PSQL
DROP DATABASE IF EXISTS $database_name;
DROP USER IF EXISTS $database_name;
CREATE USER $database_name SUPERUSER;
CREATE DATABASE $database_name;
PSQL

    sudo -u $database_user psql <<PSQL
ALTER USER $database_name WITH ENCRYPTED PASSWORD '$database_password';
GRANT ALL PRIVILEGES ON DATABASE $database_name TO $database_name;
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