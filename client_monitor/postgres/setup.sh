#!/bin/bash

################################################################################
# CONFIGS AND ARGUMENTS
################################################################################

DB_NAME=tpch
INDEX_RESET_PATH=src/optimization/reset.sql
INDEX_OPTIMIZATION_PATH=src/optimization/index.sql

initialize_db() {

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
}

reset_indexes() {
    sudo -u postgres psql <<PSQL
\c tpch;
$(cat $INDEX_RESET_PATH);
\q
PSQL
}

create_indexes() {

    sudo -u postgres psql <<PSQL
\c tpch;
$(cat $INDEX_OPTIMIZATION_PATH);
\q
PSQL
}

main() {

    ./compression_setup.sh

    # if compression is enabled, then compress database
    echo "Compression: $2"
    if [ "$2" = "compress" ]; then
        echo ""
        echo "Load Database (with compression)"
        echo "--------------------------------"
        ./compression_setup.sh -c
        cd tpch-pgsql || exit
        python3 tpch_pgsql.py load
        PGPASSWORD=******** psql -U tpch -d tpch -h localhost -f query_root/prep_query/force_compress.sql -t
    else
        echo ""
        echo "Load Database (without compression)"
        echo "--------------------------------"
        ./compression_setup.sh -d
        cd tpch-pgsql || exit
        python3 tpch_pgsql.py load '-z'
    fi

    echo ""
    echo "Copy Queries"
    echo "--------------------------------"
    queries_folder="../src/queries"
    if [ ! -d "$queries_folder" ]; then
        mkdir -p $queries_folder
    fi
    cp -r query_root/perf_query_gen/* $queries_folder
    echo "Copied"
    cd ..

    ################################################################################
    # OPTIMIZATIONS
    ################################################################################

    if [ "$1" = "index" ]; then
        echo "Index optimization enabled"
        create_indexes
    else
        echo "No optimization, removing all default indexes ..."
        reset_indexes
    fi

    ################################################################################
    # POSTGRESQL DISK USAGE
    ################################################################################

    cd .. | exit
    folder="metrics"
    if [ ! -d "$folder" ]; then
        mkdir -p $folder
    fi
    if [ ! -f "$folder/postgresql_disk_usage.csv" ]; then
        echo "optimization,size" >${folder}/postgresql_disk_usage.csv
    fi
    size_mb=$(PGPASSWORD=******** psql -U tpch -d tpch -h localhost -t -c "SELECT pg_size_pretty(pg_database_size(datname)) as db_usage FROM pg_database WHERE datname = 'tpch';")
    echo "size_mb: $size_mb"
    if [ "$2" = "compress" ]; then
        if [ "$1" = "index" ]; then
            echo "compress-index,$size_mb" >>${folder}/postgresql_disk_usage.csv
        else
            echo "compress-no_index,$size_mb" >>${folder}/postgresql_disk_usage.csv
        fi
    else
        if [ "$1" = "index" ]; then
            echo "no_compress-index,$size_mb" >>$folder/postgresql_disk_usage.csv
        else
            echo "no_compress-no_index,$size_mb" >>$folder/postgresql_disk_usage.csv
        fi
    fi

    echo "Done"

}

# default argument values
INDEX="none"
COMPRESS="none"
# process arguments if -b or --base is passed
for arg in "$@"; do
    case $arg in
    -i | --index)
        INDEX="index"
        shift # Remove --index from processing
        ;;
    -c | --compress)
        COMPRESS="compress"
        shift # Remove --compress from processing
        ;;
    -ic | --index-compress)
        INDEX="index"
        COMPRESS="compress"
        shift # Remove --index-compress from processing
        ;;
    -b | --base)
        INDEX="none"
        COMPRESS="none"
        shift # Remove --base from processing
        ;;
    *) ;;
    esac
done
echo "Index: $INDEX"
echo "Compress: $COMPRESS"
main $INDEX $COMPRESS
