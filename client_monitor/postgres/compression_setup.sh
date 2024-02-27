#!/bin/bash

PG_SQUEEZE_EXT=https://github.com/cybertec-postgresql/pg_squeeze/archive/refs/heads/master.zip
PG_SQUEEZE_EXT_LOC=./tpch-pgsql/pg_squeeze
COMPRESS_CONFIG_FILE=tpch-pgsql/query_root/prep_query/compress.conf

main() {
    echo ""
    echo "Resources check"
    echo "--------------------------------"

    if test -d "$PG_SQUEEZE_EXT_LOC"; then
        echo "pg_squeeze extension downloaded"
    else
        echo "Downloading pg_squeeze extension"
        wget -q $PG_SQUEEZE_EXT -O pg_squeeze.zip
        unzip -q pg_squeeze.zip
        mv pg_squeeze-master $PG_SQUEEZE_EXT_LOC
        rm pg_squeeze.zip
    fi

    echo ""
    echo "Install pg_squeeze extension"
    echo "--------------------------------"

    cd $PG_SQUEEZE_EXT_LOC
    make
    # maybe requiere to install postgresql-server-dev-all
    sudo make install
    # if previous command fails, echo "maybe requiere to install postgresql-server-dev-all"
    if [ $? -eq 0 ]; then
        echo "pg_squeeze extension installed"
    else
        echo "maybe requiere to install postgresql-server-dev-all"
    fi

    cd ../..

    echo ""
    echo "Add configuration to postgresql.conf"
    echo "--------------------------------"

    # Get config file location
    PG_CONF=$(PGPASSWORD=******** psql -U tpch -d tpch -t -P format=unaligned -c 'show config_file' -h localhost)
    echo "Config file location: $PG_CONF"

    # Get config file directory
    PG_CONF_DIR=$(dirname $PG_CONF)

    # Add compress.conf to PG_CONF conf.d directory
    if test -f "$PG_CONF/conf.d/compress.conf"; then
        echo "Config file already exists"
    else
        sudo cp $COMPRESS_CONFIG_FILE $PG_CONF_DIR/conf.d/
    fi
}

check_compression() {
    echo ""
    echo "Check if compression/decompression is working"
    echo "--------------------------------"
    PG_EXT=$(PGPASSWORD=******** psql -U tpch -d tpch -t -P format=unaligned -c 'show shared_preload_libraries' -h localhost)
    if [[ $1 == "compress" ]]; then
        if [[ $PG_EXT == *"pg_squeeze"* ]]; then
            echo "pg_squeeze extension loaded, compression success"
        else
            echo "pg_squeeze extension not loaded, compression failed"
        fi
        if [[ $PG_EXT == *"pg_prewarm"* ]]; then
            echo "pg_prewarm extension loaded, compression success"
        else
            echo "pg_prewarm extension not loaded, compression failed"
        fi
    elif [[ $1 == "decompress" ]]; then
        if [[ $PG_EXT == *"pg_squeeze"* ]]; then
            echo "pg_squeeze extension still loaded, decompression failed"
        else
            echo "pg_squeeze extension not loaded, decompression success"
        fi
        if [[ $PG_EXT == *"pg_prewarm"* ]]; then
            echo "pg_prewarm extension still loaded, decompression failed"
        else
            echo "pg_prewarm extension not loaded, decompression success"
        fi
    else
        echo "Error: check_compression function requires a parameter"
    fi
}

decompress() {
    echo ""
    echo "Decompress Database"
    echo "--------------------------------"
    PG_CONF=$(PGPASSWORD=******** psql -U tpch -d tpch -t -P format=unaligned -c 'show config_file' -h localhost)
    PG_CONF_DIR=$(dirname $PG_CONF)

    # Add '#' to compress.conf
    sudo sed -i 's/^/#/' $PG_CONF_DIR/conf.d/compress.conf
    # Decompress database
    # Restart postgresql service
    #sudo service postgresql restart
    sudo systemctl restart postgresql

    # Check if compression is working
    check_compression decompress
}

compress() {
    echo ""
    echo "Compress Database"
    echo "--------------------------------"
    PG_CONF=$(PGPASSWORD=******** psql -U tpch -d tpch -t -P format=unaligned -c 'show config_file' -h localhost)
    PG_CONF_DIR=$(dirname $PG_CONF)

    # Remove '#' from compress.conf
    sudo sed -i 's/^#//' $PG_CONF_DIR/conf.d/compress.conf
    # Compress database
    # Restart postgresql service
    #sudo service postgresql restart
    sudo systemctl restart postgresql

    # Check if compression is working
    check_compression compress
}

# if no arguments, run main
if [ $# -eq 0 ]; then
    main
# else if -c argument, run compress
elif [ $1 = "-c" ]; then
    compress
# else if -d argument, run decompress
elif [ $1 = "-d" ]; then
    decompress
fi
