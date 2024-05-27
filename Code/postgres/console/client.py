import requests
import zipfile
import os
import subprocess

directory = "./postgres/client/tpch-pgsql"
folder_name = "tpch-dbgen"
zipname = "dbgen.zip"
library = "./library"
postgres_orchestrator_dir = "./postgres/client"
postgres_orchestrator_jar = "./postgres/client/target/" + \
    "postgres-orchestrator-1.0-SNAPSHOT-jar-with-dependencies.jar"

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

def prepare_postgres_orchestrator():
    print("Preparing Postgres orchestrator...")
    make_process = subprocess.run(["mvn", "clean", "install", "-DskipTests", "package" ], 
                     cwd=postgres_orchestrator_dir, 
                     capture_output=True )
    if make_process.returncode != 0:
        print("Error installing postgres orchestrator")

def prepare_resources():
    prepare_dbgen()
    prepare_library()
    prepare_postgres_orchestrator()

def start():
    proc = subprocess.run(["java", "-jar", postgres_orchestrator_jar],
                          cwd="./"
                          )




