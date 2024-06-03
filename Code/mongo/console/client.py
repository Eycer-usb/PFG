import requests
import zipfile
import os
import subprocess
import json

directory = "./mongo/client/tpch-mongo"
folder_name = "tpch-dbgen"
zipname = "dbgen.zip"
library = "./library"
mongo_orchestrator_dir = "./mongo/client"
mongo_orchestrator_jar = "./mongo/client/target/" + \
    "mongo-orchestrator-1.0-SNAPSHOT-jar-with-dependencies.jar"


def compile_dbgen():
    print("Compiling DB-gen...")
    make_process = subprocess.Popen(["make"], 
                     stdout=subprocess.PIPE, 
                     cwd=directory + "/" + folder_name,
                     stderr=subprocess.STDOUT )
    if make_process.wait() != 0:
        print("Error Compiling dbgen")

def download_resources():
    if(os.path.exists(directory + "/" + folder_name)):
        return
    print("Downloading TPCH-DBGen")    
    dbgen_url = "https://github.com/electrum/tpch-dbgen/" + \
                "archive/32f1c1b92d1664dba542e927d23d86ffa57aa253.zip"
    request = requests.get(dbgen_url, allow_redirects=True)
    open("dbgen.zip", 'wb').write(request.content)


def prepare_dbgen():
    old_name = "tpch-dbgen-32f1c1b92d1664dba542e927d23d86ffa57aa253"

    if(os.path.exists(directory + "/" + folder_name)):
        compile_dbgen()
        return
    with zipfile.ZipFile(zipname, 'r') as zip_ref:
        zip_ref.extractall(directory)
    os.rename(directory + "/" + old_name,
              directory + "/" + folder_name)
    os.remove(zipname)
    compile_dbgen()

def prepare_library():
    print("Preparing Library...")
    make_process = subprocess.run(["mvn", "clean", "install", "-DskipTests"], 
                     cwd=library, 
                     capture_output=True )
    if make_process.returncode != 0:
        print("Error installing library")

def prepare_mongo_orchestrator():
    print("Preparing mongo orchestrator...")
    make_process = subprocess.run(["mvn", "clean", "install", "-DskipTests", "package" ], 
                     cwd=mongo_orchestrator_dir, 
                     capture_output=True )
    if make_process.returncode != 0:
        print("Error installing mongo orchestrator")

def prepare_resources():
    prepare_dbgen()
    prepare_library()
    prepare_mongo_orchestrator()


def create_orchestrator_config_file(general_config, target_file):
    config = {
        "database": general_config["databases"]["mongo"],
        "executor": {
            "clientObserver": general_config["clientObservers"]["mongo"],
            "serverObserver": general_config["serverObservers"]["mongo"],
            "collector": {
                "endpoint": general_config["collector"]["directive"]
            }
        }
    }
    with open(target_file, 'w') as f:
        json.dump(config, f)
        return True        

def start(config):
    orchestrator_config = "orchestrator_config.json"
    port = config["orchestrators"]["mongo"]["port"]
    if (create_orchestrator_config_file(config, orchestrator_config)):
        proc = subprocess.Popen([config["consoleCommand"], "--", "java", "-jar", 
                               mongo_orchestrator_jar, orchestrator_config, port ],
                            cwd="./")
        return proc




