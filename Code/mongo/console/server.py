import requests
import os
import zipfile
import subprocess

directory = "mongo/server"
folder_name = "pg_squeeze"
zipname = "pg_squeeze.zip"


def prepare_resources():
    print("Preparing Resources Mongo")
    pass

def start():
    print("Starting mongo service")
    p = subprocess.run(["sudo", "systemctl", "restart", "mongod"], capture_output=True, text=True)
    if(p.returncode != 0):
        print("Error Starting service")
    