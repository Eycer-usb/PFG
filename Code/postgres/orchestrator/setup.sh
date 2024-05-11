#!/bin/bash

################################################################################
# CONFIGS AND ARGUMENTS
################################################################################

DB_NAME=$database_name
INDEX_RESET_PATH=optimization/reset.sql
INDEX_OPTIMIZATION_PATH=optimization/index.sql

initialize_db() {

    sudo -u $database_user psql <<PSQL
DROP DATABASE IF EXISTS $DB_NAME;
DROP USER IF EXISTS $DB_NAME;
CREATE USER $DB_NAME SUPERUSER;
CREATE DATABASE $DB_NAME;
PSQL

    sudo -u $database_user psql <<PSQL
ALTER USER $DB_NAME WITH ENCRYPTED PASSWORD '$database_password';
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_NAME;
\q
PSQL
}

reset_indexes() {
    sudo -u $database_user psql <<PSQL
\c tpch;
$(cat $INDEX_RESET_PATH);
\q
PSQL
}

create_indexes() {

    sudo -u $database_user psql <<PSQL
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
        echo "--------------------------------"
        echo "Load Database (with compression)"
        echo "--------------------------------"
        ./compression_setup.sh -c
        cd tpch-pgsql || exit
        python3 tpch_pgsql.py load
        PGPASSWORD=$database_password psql -U tpch -d tpch -h localhost -f query_root/prep_query/force_compress.sql -t
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
    queries_folder="../queries"
    if [ ! -d "$queries_folder" ]; then
        mkdir -p $queries_folder
    fi
    cp -r query_root/perf_query_gen/* $queries_folder
    echo "Copied"

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
