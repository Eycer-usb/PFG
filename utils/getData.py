from prometheus_api_client import PrometheusConnect
import datetime
import sys 
from PrometheusCollector import PrometheusCollector

def calculate_power_consumption(metrics):
    # Perform your power consumption calculation based on the metrics
    # Modify this based on the specific metrics exported by Scaphandre
    # For example, if Scaphandre exports power in watts, you might simply sum them up
    power_consumption = sum(metric['value'][1] for metric in metrics['data']['result'])

    return power_consumption

def help():
    print("Help Message")

def main():

    if( len(sys.argv) < 5 ):
        help()
        sys.exit()

    
    
    prometheus_url = sys.argv[1]  # Update with Prometheus server URL
    prom = PrometheusCollector(prometheus_url)

    query = sys.argv[2]  # Update with the metric name from Scaphandre

    # Set the time range for the query
    start_time = sys.argv[3]    # Analysis start time
    end_time = sys.argv[4]  # Analysis end time

    # Fetch metrics from Prometheus
    metrics = prom.fetch_metric_range(metric=query, start_timestamp=start_time, end_timestamp=end_time)
    print("metrics")
    print(metrics)

    # Calculate power consumption
    # power_consumption = calculate_power_consumption(metrics)

    # print(f"Power Consumption: {power_consumption} watts")

if __name__ == "__main__":
    main()
