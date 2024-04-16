#!/bin/bash

################################################################################
# CONFIGS
################################################################################

optimizations=("--base" "--index" "--compress" "--index-compress")
n_query=22
num_iterations=30
jar_file=executor.jar
config_file=config.json

generate_config_file() {
    cat <<EOF > $config_file
    {
        
    }
    EOF
}


echo "Running each query individually with all optimizations"
for optimization in "${!optimizations[@]}"; do
sudo systemctl restart postgresql
    echo "Setting up database with optimization ""${optimizations[$optimization]}"
    ./setup.sh "${optimizations[$optimization]}"
    for query in $(seq 1 $n_query); do
        for iteration in $(seq 1 $num_iterations); do
            generate_config_file "${optimizations[$optimization]}" query_$query $iteration
            sudo systemctl restart postgresql
            echo Optimization: "${optimizations[$optimization]}", Query: "$query", Iteration: "$iteration", 
            java -jar $jar_file
            sudo systemctl restart postgresql
        done
    done
done


