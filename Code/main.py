import sys
import postgres.console.client as postgres_client
import postgres.console.server as cserver
import projects.collector.collector as collector
import projects.observer.observer as lib
import json

def print_help():
    print("Required at least three arguments")
    print("config.json  --- File with configuration")
    print("client or server  --- Run as client or server")
    print("postgres or mongo  --- Run postgres or mongo")


def client_postgres(config):
    try:
        postgres_client.download_resources()
        postgres_client.prepare_resources()
        return postgres_client.start(config)
    except:
        print("Error Starting Postgres Client")


def server_postgres(config):
    pass

def set_analyst(config):
    pass

def set_collector(config):
    collector.prepare_resources(config)
    return collector.start(config)

def get_config(filepath):
    config = {}
    with open(filepath) as f:
        config = json.load(f)
    return config
        

if __name__ == '__main__':
    # Options Available
    options = [
        "client", "server", "analyst", "collector"
    ]
    observable_options = [
        "client", "server"
    ]

    # Input Validation
    if(len(sys.argv) <= 2):
        print_help()
        exit(-1)
    elif(not (sys.argv[2] in options )):
        print_help()
        exit(-1)
    
    config = get_config(sys.argv[1]) # Retrieval configuration from file
    
    # Setting up observer configuration
    observer_config = {
        "observer_port": "",
        "collector_endpoint": ""
    }

    # Client Process
    client_process = None

    # Preparing and running orchestrators in each case
    if(sys.argv[2] == "collector"):
        print("Running as Collector")
        client_process = set_collector(config)
    elif(sys.argv[2] == "analyst"):
        print("Running as Analyst")
        set_analyst(config)
    elif(sys.argv[2] == "client" and sys.argv[3] == "postgres" ):
        print("Running as Postgres Client")
        observer_config["observer_port"] = config["clientObserver"]["port"]
        observer_config["collector_endpoint"] = config["collector"]["client-metrics"]
        client_process = client_postgres(config)
    elif(sys.argv[2] == "client" and sys.argv[3] == "mongo"):
        print("Running as Mongo Client")
    elif(sys.argv[2] == "server" and sys.argv[3] == "postgres"):
        print("Running as Postgres Server")
        observer_config["observer_port"] = config["serverObserver"]["port"]
        observer_config["collector_endpoint"] = config["collector"]["server-metrics"]
        server_postgres(config)
    elif(sys.argv[2] == "server" and sys.argv[3] == "mongo"):
        print("Running as Mongo Server")

    # Starting observer
    if(sys.argv[2] in observable_options):
        observer_process = lib.start_observer(observer_config,
                                          console_command=config["consoleCommand"])
        observer_process.wait()
        
    if(sys.argv[2] == "client"):
        client_process.wait()
