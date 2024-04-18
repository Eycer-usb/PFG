#!/bin/bash
database_optimizations=("--base" "--index" "--compress" "--index-compress")

echo "Running each query individually with all optimizations"
for optimization in "${!database_optimizations[@]}"; do
sudo systemctl restart $database_service_name
    echo "Setting up database with optimization ""${database_optimizations[$optimization]}"
    ./prepare.sh
    ./setup.sh "${database_optimizations[$optimization]}"
    for query in $(seq 1 $number_benchmark_queries); do
        for iteration in $(seq 1 $number_iterations); do
            ./generate_config_file.sh "${database_optimizations[$optimization]}" $query $iteration $config_file
            sudo systemctl restart $database_service_name
            echo Optimization: "${database_optimizations[$optimization]}", Query: "$query", Iteration: "$iteration", 
            java -jar $jar_file $config_file
            sudo systemctl restart $database_service_name
        done
    done
done


