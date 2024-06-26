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
# Storing Iteration Intervals
intervals_file=$folder.intervals.csv
echo iteration, start_time, end_time, runtime > "$intervals_file"
for i in $(seq 1 "$num_iterations"); do

	echo "Restarting postgres"
	sudo systemctl restart postgresql

	echo "Running java program at iteration $i"
	echo "$@"
	# Start time in nanoseconds
	start_time=$(date +%s%N)
	sudo java -javaagent:$jar -cp "$dependency":. "$@" &
	java_pid=$!
	wait ${java_pid}
	sudo systemctl restart postgresql
	
	# End time in nanoseconds
	end_time=$(date +%s%N)

	run_time=$(echo "$end_time - $start_time" | bc)

	echo "$i", "$start_time", "$end_time", "$run_time"  >> "$intervals_file"

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

# Giving permission to all files
sudo chmod -R 777 jx_results

env_activate() {
	source ../../env/bin/activate
}

################################################################################
# DATA ANALYSIS
################################################################################
env_activate
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
