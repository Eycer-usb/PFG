#!/bin/bash

# TPCH Benchmark

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

# Dbgen compilation
cd tpch-dbgen || exit
make
./dbgen -f -s 1
cd ..

echo "Creating Database"
sudo systemctl restart mongod
python3 main.py create