import sys
import postgres.console.client as postgres_client
import postgres.console.server as cserver
import projects.observer.observer as lib
import json

def print_help():
    print("Required at least three arguments")
    print("client or server  --- Run as client or server")
    print("postgres or mongo  --- Run postgres or mongo")
    print("config.json  --- File with configuration")


def client_postgres(config):
    try:
        postgres_client.download_resources()
        postgres_client.prepare_resources()
        return postgres_client.start(config)
    except:
        print("Error Starting Postgres Client")


def server_postgres(config):
    pass


def get_config(filepath):
    config = {}
    with open(filepath) as f:
        config = json.load(f)
    return config
        

if __name__ == '__main__':
    # Input Validation
    if(len(sys.argv) <= 3):
        print_help()
        exit(-1)
    elif(not (sys.argv[1] == "client" or sys.argv[1] == "server" )):
        print_help()
        exit(-1)
    elif(not (sys.argv[2] == "postgres" or sys.argv[1] == "mongo" )):
        print_help()
        exit(-1)

    
    config = get_config(sys.argv[3]) # Retrieval configuration from file
    
    # Setting up observer configuration
    observer_config = {
        "observer_port": "",
        "collector_endpoint": config["collector"]["metrics"]
    }

    # Client Process
    client_process = None

    # Preparing and running orchestrators in each case
    if(sys.argv[1] == "client" and sys.argv[2] == "postgres" ):
        observer_config["observer_port"] = config["clientObserver"]["port"]
        client_process = client_postgres(config)
    elif(sys.argv[1] == "server" and sys.argv[2] == "postgres"):
        observer_config["observer_port"] = config["serverObserver"]["port"]
        server_postgres(config)
    elif(sys.argv[1] == "client" and sys.argv[2] == "mongo"):
        pass
    elif(sys.argv[1] == "server" and sys.argv[2] == "mongo"):
        pass

    # Starting observer
    observer_process = lib.start_observer(observer_config,
                                          console_command=config["consoleCommand"])
    observer_process.wait()
    client_process.wait()
