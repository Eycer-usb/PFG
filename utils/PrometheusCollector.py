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
        return self._connection.custom_query(metric)
    
    def fetch_metric_range(self, metric, start_timestamp, end_timestamp):
        print(start_timestamp, end_timestamp)
        start_datetime = datetime.fromtimestamp(float(start_timestamp))
        end_datetime = datetime.fromtimestamp(float(end_timestamp))
        return self._connection.custom_query_range(query=metric, 
                                                   start_time=start_datetime, 
                                                   end_time=end_datetime,
                                                   step=1)