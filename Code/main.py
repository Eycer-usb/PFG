import sys
import postgres.console.client as postgres_client
import postgres.console.server as cserver
import projects.observer.observer as lib
import json

def print_help():
    print("Required at least one argument")
    print("client  --- Run as client")
    print("server  --- Run as server")


def client_postgres():
    try:
        postgres_client.download_resources()
        postgres_client.prepare_resources()
        postgres_client.start()
    except:
        print("Error Starting Postgres Client")


def server_postgres():
    pass


def get_config(filepath):
    config = {}
    with open(filepath) as f:
        config = json.load(f)
    return config
        

if __name__ == '__main__':
    if(len(sys.argv) <= 3):
        print_help()
        exit(-1)
    elif(not (sys.argv[1] == "client" or sys.argv[1] == "server" )):
        print_help()
        exit(-1)
    elif(not (sys.argv[2] == "postgres" or sys.argv[1] == "mongo" )):
        print_help()
        exit(-1)

    config = get_config(sys.argv[3])
    observer_config = {
        "observer_port": "",
        "collector_endpoint": config["collector"]["metrics"]
    }
    if(sys.argv[1] == "client"):
        observer_config["observer_port"] = config["clientObserver"]["port"]
        client_postgres()
    else:
        observer_config["observer_port"] = config["serverObserver"]["port"]
        server_postgres()
    observer_process = lib.start_observer(observer_config)
    observer_process.wait()
