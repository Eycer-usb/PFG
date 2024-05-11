from pymongo import MongoClient
import csv
import json
import threading

"""
Mongo TPCH class to manage every aspect of TPCH benchmark generation

Methods:
- generate          Create the data base with the data
"""
class Mongo_TPCH:
    def __init__(self, host, port, db_name, chunk_size=100000, threads_number=4):
        self.host = host
        self.port = port
        self.db_name = db_name
        self.client = self.connect()
        self.collections = [
            'REGION',
            'LINEITEM', 'PARTSUPP', 'ORDERS',
            'CUSTOMER', 'SUPPLIER', 'NATION', 'PART'
            ]
        self.headers = {}
        with open("collections_schemas.json") as f:
            self.headers = json.load(f)
        self.client.drop_database(self.db_name)
        self.db = self.client[self.db_name]
        self.threads_number = threads_number
        self.chunk_size = chunk_size

    def __del__(self):
        self.client.close()
    
    def connect(self):
        connection = None
        try:
            connection = MongoClient(host=self.host, port=int(self.port))
        except:
            print("Error connecting to mongo service")
        return connection
    
    def get_header(self, collection_name):       
        return self.headers[collection_name]


    def set_collection(self, collection_name) -> dict:
        try:
            print("Setting Collection " + collection_name)
            header = self.get_header(collection_name)
            
            with open( "tpch-dbgen/" + collection_name.lower() + ".tbl") as f:
                csvreader = csv.reader(f, delimiter="|")
                chunk = []
                threads = []
                for row in csvreader:
                    registry = {}
                    for i in range(len(header)):
                        registry[header[i]] = row[i]
                    chunk.append(registry)

                    if len(chunk) % self.chunk_size == 0:
                        print("Starting Insertion Thread")
                        thread = threading.Thread(
                            target= self.insert,
                            args=(collection_name, chunk))
                        thread.start()
                        threads.append(thread)
                        chunk = []

                    if len(threads) == self.threads_number:
                        print("Waiting Threads")
                        for thread in threads:
                            thread.join()
                        threads = []
                if len(chunk) > 0:
                    print("Starting Insertion Thread")
                    thread = threading.Thread(
                        target= self.insert,
                        args=(collection_name, chunk))
                    thread.start()
                    threads.append(thread)

                print("Waiting Threads")
                for thread in threads:
                    thread.join()

        except :
            print("Error getting collection " + collection_name)
                    

                

    def generate(self):
        for collection in self.collections:
            self.set_collection(collection)

    def insert(self, collection_name, chunk):
        self.db[collection_name].insert_many(chunk)
        