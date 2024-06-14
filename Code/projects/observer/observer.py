import subprocess
import os

observer_dir = "projects/observer"

def make():
    print("Preparing Juliet Observer")
    make_process = subprocess.run(["make"], 
                                  cwd=observer_dir)
    if(make_process.returncode != 0):
        print("Error compiling JulietX Observer")
        exit(-1)

def start(config, console_command):
    print("Starting JulietX Observer")
    os.environ["COLLECTOR_ENDPOINT"]=config["collector_endpoint"]
    os.environ["SOCKET_PORT"]=config["observer_port"]

    make_process = subprocess.Popen(["sudo", "-E", "./julietX"], 
                                  cwd=observer_dir)
    if not (make_process.poll() is None):
        print("Error starting Observer")
        exit(-1)
    return make_process

def start_observer(config, console_command):
    make()
    return start(config, console_command)