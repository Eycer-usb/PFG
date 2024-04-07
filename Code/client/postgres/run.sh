#!/bin/bash

################################################################################
# CONFIGS
################################################################################

# Test config
num_iterations=30
# The empty string is the default optimization (base) with no indexes and no compression
optimizations=("--base" "--index" "--compress" "--index-compress")

# Build config
dependency=src/java/postgresql-42.6.0.jar
pgdb_java=src/java/PGDB.java
query_java=src/java/Query.java
java_program=src.java.Query

# Program config
verbose=false
run_power=false
run_throughput=false
n_query=22
n_streams=2

################################################################################
# BUILD
################################################################################

javac -cp $dependency $pgdb_java $query_java

################################################################################
# TEST
################################################################################
mkdir metrics_old
mv metrics/* metrics_old
rm -rf metrics
mkdir -p metrics


echo "Running each query individually with all optimizations"
for optimization in "${!optimizations[@]}"; do
sudo systemctl restart postgresql
    # DB Setup
    echo "Setting up database with optimization ""${optimizations[$optimization]}"
    ./setup.sh "${optimizations[$optimization]}"

    for i in $(seq 1 $n_query); do
        ./test.sh $num_iterations $dependency "$i" "${optimizations[$optimization]}" $java_program \
            v=$verbose p=$run_power t=$run_throughput q="$i" s=$n_streams
    done
done