import requests
import os
import zipfile
import subprocess

directory = "postgres/server"
folder_name = "pg_squeeze"
zipname = "pg_squeeze.zip"

def download_pg_squeeze():
    if(pg_squeeze_is_load()):
        return
    print("Downloading pg_squeeze")
    pg_squeeze_url = "https://github.com/cybertec-postgresql/pg_squeeze/" + \
                "archive/refs/heads/master.zip"
    request = requests.get(pg_squeeze_url, allow_redirects=True)
    open(zipname, 'wb').write(request.content)

def prepare_pg_squeeze():
    if(pg_squeeze_is_load()):
        return
    old_name = "pg_squeeze-master"

    if(os.path.exists(directory + "/" + folder_name)):
        compile_pg_squeeze()
        return
    with zipfile.ZipFile(zipname, 'r') as zip_ref:
        zip_ref.extractall(directory)
    os.rename(directory + "/" + old_name,
              directory + "/" + folder_name)
    os.remove(zipname)


def compile_pg_squeeze():
    print("Compiling PG-Squeeze...")
    make_process = subprocess.Popen(["make"], 
                     stdout=subprocess.PIPE, 
                     cwd=directory + "/" + folder_name,
                     stderr=subprocess.STDOUT )
    if make_process.wait() != 0:
        print("Error Compiling pg squeeze")

def install_dependencies():
    print("Installing postgresql-server-dev-all")
    install_process = subprocess.Popen([
        "sudo", "apt", "install", "-y", "postgresql-server-dev-all" ], 
                     stdout=subprocess.PIPE, 
                     stderr=subprocess.STDOUT )
    if install_process.wait() != 0:
        print("Error installing postgresql-server-dev-all")

def install_pg_squeeze():
    print("Installing PG-Squeeze...")
    make_process = subprocess.Popen(["sudo", "make", "install"], 
                     stdout=subprocess.PIPE, 
                     cwd=directory + "/" + folder_name,
                     stderr=subprocess.STDOUT )
    if make_process.wait() != 0:
        print("Error installing pg squeeze")

def locate_config_folder():
    print("Locating postgres config file...")
    pg_conf = subprocess.check_output(["sudo", "-u", "postgres", "psql", "-c", "SHOW config_file"],
                                    stderr=subprocess.STDOUT ).decode("utf-8")
    location = os.path.dirname(str(pg_conf.splitlines()[2]).strip())
    
    folder = os.path.join(location, "conf.d")
    print(folder)
    assert(os.path.exists(location))
    if(not os.path.exists(folder)):
        os.makedirs(folder)
    return folder, str(pg_conf.splitlines()[2]).strip()

def update_config(location, pg_conf):
    # Allowing external connections
    p = subprocess.run(["sudo", 'sed', '-i', 
                        "s/^#listen_addresses = .*/listen_addresses = '\*'/g", 
                        pg_conf], 
                   capture_output=True, text=True,
                    cwd="/" )
    # Copping compress config file
    if(os.path.exists(os.path.join(location, "compress.conf"))):
        print("Config Already set")
        return
    print("Updating Postgres config")
    compress_config = "postgres/server/compress.conf"
    p = subprocess.run(["sudo", 'cp', compress_config, location ], 
                   capture_output=True, text=True,
                    cwd="./" )
    if p.returncode != 0:
        print("Error setting compression configuration")




def prepare_resources():
    download_pg_squeeze()
    prepare_pg_squeeze()
    compile_pg_squeeze()
    install_dependencies()
    install_pg_squeeze()
    update_config(*locate_config_folder())

def start():
    print("Starting postgres service")
    p = subprocess.run(["sudo", "systemctl", "restart", "postgresql"], capture_output=True, text=True)
    if(p.returncode != 0):
        print("Error Starting service")
    
def pg_squeeze_is_load():
    if(os.path.exists(directory + "/" + folder_name)):
        return True
    return False