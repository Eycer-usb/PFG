#!/bin/bash

################################################################################
# CONFIGS
################################################################################

# Test config
num_iterations=30
# The empty string is the default optimization (base) with no indexes and no compression
optimizations=("--base" "--index" "--compress" "--index-compress")

# Build config
dependency=benchmark/postgresql-42.6.0.jar
pgdb_java=benchmark/PGDB.java
query_java=benchmark/Query.java
java_program=benchmark.Query

# Program config
verbose=false
run_power=true
run_throughput=true
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

if [ -n "$1" ]; then
    arg1=$1
    re='^[0-9]+$'

    if [ $arg1 = "--all" ] || [ $arg1 = "-a" ] || [ $arg1 = "0" ]; then
        echo "Running all queries with all optimizations"
        for optimization in "${!optimizations[@]}"; do
            # DB Setup
            ./setup.sh ${optimizations[$optimization]}
            ./test.sh $num_iterations $dependency 0 $optimization $java_program \
                v=$verbose p=$run_power t=$run_throughput q=0 s=$n_streams
        done
    elif [[ $arg1 =~ $re ]] && [ $arg1 -ge 1 ] && [ $arg1 -le 22 ]; then
        echo "Running query $arg1 with optimizations"
        for optimization in "${!optimizations[@]}"; do
            echo "Running query $arg1 with optimization "${optimizations[$optimization]}""
            # DB Setup
            ./setup.sh ${optimizations[$optimization]}
            ./test.sh $num_iterations $dependency $1 $optimization $java_program \
                v=$verbose p=$run_power t=$run_throughput q=$1 s=$n_streams
        done
    else
        echo "Invalid query number"
    fi
else
    echo "Running each query individually with all optimizations"
    for optimization in "${!optimizations[@]}"; do
	sudo systemctl restart postgresql
        # DB Setup
        echo "Setting up database with optimization "${optimizations[$optimization]}""
        ./setup.sh ${optimizations[$optimization]}

        for i in $(seq 1 $n_query); do
            ./test.sh $num_iterations $dependency $i "${optimizations[$optimization]}" $java_program \
                v=$verbose p=$run_power t=$run_throughput q=$i s=$n_streams
        done
    done
fi

################################################################################
# JAVA PROGRAM ARGUMENT DOCUMENTATION
################################################################################

# Enable verbose mode
# v={0, 1, true, false}

# Disable powerTest
# p={0, 1, true, false}

# Disable throughputTest
# t={0, 1, true, false}

# Set query to test, 0 runs all
# q={0, 1, ..., 22}

# Number of streams for throughputTest. That is, number of concurrent process
# s={0, 1, ..., 11}
