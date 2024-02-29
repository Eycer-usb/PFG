from prometheus_api_client import PrometheusConnect
from datetime import datetime

class PrometheusCollector:
    def __init__(self, host, headers= {}, disable_ssl=False):
        self._host = host
        self._disable_ssl = disable_ssl
        self._connection = PrometheusConnect(self._host, headers=headers, disable_ssl=self._disable_ssl)
    
    def get_connection(self):
        return self._connection
    
    def fetch_metric(self, metric):
        return self.get_connection().custom_query(metric)
    
    def fetch_metric_range(self, metric, start_timestamp, end_timestamp):
        start_datetime = datetime.fromtimestamp(float(start_timestamp))
        end_datetime = datetime.fromtimestamp(float(end_timestamp))
        print(start_datetime, end_datetime)
        return self.get_connection().custom_query_range(query=metric, 
                                                   start_time=start_datetime, 
                                                   end_time=end_datetime,
                                                   step=1)
    
    def get_power_metrics_pid(self, pid ):
        return self.get_connection().custom_query(
            "scaph_process_power_consumption_microwatts{pid='" + pid + "'}"
            )
    
    def get_power_metrics_pid_range(self, pid, start_timestamp, end_timestamp):
        query = "scaph_process_power_consumption_microwatts{pid='" + pid + "'}"
        print("Query: " + query)
        return self.fetch_metric_range(query,
                                        start_timestamp, 
                                        end_timestamp)
    

        