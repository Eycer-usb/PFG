#!/bin/bash

################################################################################
# CONFIGS AND ARGUMENTS
################################################################################

num_iterations=$1
shift
dependency=$1
shift
query_number=$1
shift
query_optimization=$1
shift

echo "query_optimization: $query_optimization"

jar="/opt/joularjx/joularjx.jar"

directories=(
	"jx_results"
	"jx_results/energy"
	"jx_results/energy/methods"
	"jx_results/energy/calltrees"
	"jx_results/energy_filtered"
	"jx_results/energy_filtered/methods"
	"jx_results/energy_filtered/calltrees"
	"jx_results/power"
	"jx_results/power/methods"
	"jx_results/power/calltrees"
	"jx_results/power_filtered"
	"jx_results/power_filtered/methods"
	"jx_results/power_filtered/calltrees"
)

################################################################################
# JOULARJX TEST
################################################################################

# Clear previous test data
rm -rf joularjx-result jx_graphs jx_results/*
for dir in "${directories[@]}"; do
	mkdir -p "$dir"
done

# Create metrics folder and files
query_folder="metrics/query_${query_number}"

case $query_optimization in
base)
	query_optimization="none"
	;;
-i | --index)
	query_optimization="index"
	;;
-c | --compress)
	query_optimization="compression"
	;;
-ic | -ci | --index-compress)
	query_optimization="index-and-compression"
	;;
*) ;;
esac

echo "query_optimization rename: $query_optimization"

folder="${query_folder}/${query_optimization}"

if [ ! -d "$query_folder" ]; then
	mkdir -p "$query_folder"
fi

echo "timestamp,pid,cpu_usage_mean,cpu_usage_std,cpu_usage_ci_l,cpu_usage_ci_u,read_count_mean,read_count_std,read_count_ci_l,read_count_ci_u" >${folder}_client_metrics.csv
echo "timestamp,pg_cpu_usage_mean,pg_cpu_usage_std,pg_cpu_usage_ci_l,pg_cpu_usage_ci_u,pg_read_count_mean,pg_read_count_std,pg_read_count_ci_l,pg_read_count_ci_u" >${folder}_postgres_metrics.csv
echo "runtime" >"${folder}"_runtime.csv
echo "Iterations, Energy (Joules)" >"${folder}"_juliet_postgres.csv
echo "Iterations, Energy (Joules)" >"${folder}"_juliet_java.csv


# Retrive files funtion
retrieve_files() {
	file_name=$1
	destination=$2
	file="joularJX-*-$file_name"

	find joularjx-result -name "$file" -type f -print0 | while IFS= read -r -d '' f; do
		if [ -s "$f" ]; then
			echo Moving "$f" to "jx_results/$destination"
			mv "$f" "jx_results/$destination"
		else
			rm -f "$f"
		fi
	done
}

# Run test
echo "########################################################################"
for i in $(seq 1 $num_iterations); do

	echo "Restarting postgres"
	sudo systemctl restart postgresql

	echo "Running java program at iteration $i"
	echo $@
	# Start time in nanoseconds
	start_time=$(date +%s%N)
	echo "Starting Server Power consumption analysis"
	echo "" >>${folder}_juliet_postgres.txt
	echo "########### Iteration $i #######" >>${folder}_juliet_postgres.txt
	echo "########### Iteration $i #######" >>${folder}_juliet_java.txt
	sudo ./juliet/juliet postgres >>${folder}_juliet_postgres.txt &
	sudo ./juliet/juliet java >>${folder}_juliet_java.txt &
	sudo java -javaagent:$jar -cp $dependency:. $@ &
	java_pid=$!
	python3 python/os_metrics.py ${java_pid} >>${folder}_client_metrics.csv &
	python3 python/os_metrics.py -p >>${folder}_postgres_metrics.csv 2>>log_mos.txt &
	wait ${java_pid}
	sudo systemctl restart postgresql
	sudo pkill -10 juliet
	tail -n 1 ${folder}_juliet_postgres.txt | sed -e "s/Energy consumed by process: /$i,/" -e "s/ J//" >>${folder}_juliet_postgres.csv
	tail -n 1 ${folder}_juliet_java.txt | sed -e "s/Energy consumed by process: /$i,/" -e "s/ J//" >>${folder}_juliet_java.csv
	
	# End time in nanoseconds
	end_time=$(date +%s%N)

	# signal interrupt to os_metrics
	# kill -INT $cs_pid

	# Run time in nanoseconds
	run_time=$(echo "$end_time - $start_time" | bc)
	# store run time
	echo $run_time >>${folder}_runtime.csv

	# Files to retrieve
	declare -A files
	files["all-methods-energy.csv"]="energy/methods"
	files["all-call-trees-energy.csv"]="energy/calltrees"
	files["filtered-methods-energy.csv"]="energy_filtered/methods"
	files["filtered-call-trees-energy.csv"]="energy_filtered/calltrees"
	files["all-methods-power.csv"]="power/methods"
	files["all-call-trees-power.csv"]="power/calltrees"
	files["filtered-methods-power.csv"]="power_filtered/methods"
	files["filtered-call-trees-power.csv"]="power_filtered/calltrees"

	# Retrieve test data
	for file in "${!files[@]}"; do
		destination="${files[$file]}"
		retrieve_files "$file" "$destination"
	done
done

# Givin permission to all files
sudo chmod -R 777 jx_results

# trap "trap - SIGTERM && kill -- -$$ > /dev/null 2>&1" SIGINT SIGTERM EXIT
echo "########################################################################"

################################################################################
# DATA ANALYSIS
################################################################################

# Used to gather power and engery consumption data using JoularJX and save it
# CSV file.
python3 jx_gatherData.py "jx_results/"

# Used to generate graphs from the power and engery consumption data saved in
# the CSV file generated by jx_gatherData.py.
#python3 jx_plot.py "jx_results/joularJX_methods.csv" "jx_graphs"

# Used to analyze the power consumption data at the method level, i.e., it
# breaks down the data into individual methods and calculates the energy and
# power consumed by each method.
python3 jx_process_level_methods.py "metrics/query_${query_number}/${query_optimization}-jx_process_level_methods.csv"

# Used to perform a Shapiro-Wilk test on the energy consumption data to check
# for normality.
#python3 shapiro_wilk_test_energy.py

# Used to perform a Shapiro-Wilk test on the power consumption data to check
# for normality.
#python3 shapiro_wilk_test_power.py

################################################################################
# DATA STORE
################################################################################

#query_result_dir=${query_dir}/${query_optimization}
#mkdir -p $query_result_dir
#mkdir -p $query_result_dir/graphs

#cp jx_graphs/* $query_result_dir/graphs
