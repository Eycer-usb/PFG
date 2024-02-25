from prometheus_api_client import PrometheusConnect
import datetime
import sys 

def fetch_metrics(prometheus_url, query, start_time, end_time):
    # Connect to Prometheus server
    prom = PrometheusConnect(url=prometheus_url, disable_ssl=True)

    # Query Prometheus for the metric
    result = prom.custom_query_range(query, start_time=start_time, end_time=end_time)

    return result

def calculate_power_consumption(metrics):
    # Perform your power consumption calculation based on the metrics
    # Modify this based on the specific metrics exported by Scaphandre
    # For example, if Scaphandre exports power in watts, you might simply sum them up
    power_consumption = sum(metric['value'][1] for metric in metrics['data']['result'])

    return power_consumption

def main():

    if( len(sys.argv) < 4 ):
        help()
        sys.exit()

    
    
    prometheus_url = sys.argv[1]  # Update with Prometheus server URL
    query = 'your_metric_name'  # Update with the metric name from Scaphandre

    # Set the time range for the query
    start_time = sys.argv[2]    # Analysis start time
    end_time = sys.argv[3]  # Analysis end time

    # Fetch metrics from Prometheus
    metrics = fetch_metrics(prometheus_url, query, start_time, end_time)

    # Calculate power consumption
    power_consumption = calculate_power_consumption(metrics)

    print(f"Power Consumption: {power_consumption} watts")

if __name__ == "__main__":
    main()
