from pymongo import MongoClient
import csv
import json
import threading
from datetime import datetime

"""
Mongo TPCH class to manage every aspect of TPCH benchmark generation

Methods:
- generate          Create the data base with the data
"""
class Mongo_TPCH:
    def __init__(self, host, port, db_name, chunk_size=100000, threads_number=4, optimizations=[]):
        self.host = host
        self.port = port
        self.db_name = db_name
        self.client = self.connect()
        self.collections = [
            'region',
            'lineitem', 'partsupp', 'orders',
            'customer', 'supplier', 'nation', 'part'
            ]
        self.schemas = {}
        with open("collections_schemas.json") as f:
            self.schemas = json.load(f)
        self.client.drop_database(self.db_name)
        self.db = self.client[self.db_name]
        self.threads_number = threads_number
        self.chunk_size = chunk_size
        self.compression = "compression" in optimizations
        self.index = "index" in optimizations

    def __del__(self):
        self.client.close()
    
    def connect(self):
        connection = None
        try:
            connection = MongoClient(host=self.host, port=int(self.port))
        except:
            print("Error connecting to mongo service")
        return connection
    
    def get_schema(self, collection_name):       
        return self.schemas[collection_name]


    def set_collection(self, collection_name) -> dict:
        try:
            print("Setting Collection " + collection_name)
            schema = self.get_schema(collection_name)
            if(self.compression):
                compress_config = {
                    "wiredTiger": { "configString": "block_compressor=zstd" }
                }
                self.db.create_collection(collection_name,
                                          storageEngine=compress_config)
            
            with open( "tpch-dbgen/" + collection_name + ".tbl") as f:
                csvreader = csv.reader(f, delimiter="|")
                chunk = []
                threads = []
                for row in csvreader:
                    registry = {}
                    for i in range(len(schema)):
                        name = schema[i]["name"]
                        value_type = schema[i]["type"]
                        registry[name] = self.get_value_with_type(row[i], value_type)
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

                for thread in threads:
                    print("Waiting Threads")
                    thread.join()

        except :
            print("Error getting collection " + collection_name)
                    

                

    def generate(self):
        for collection in self.collections:
            self.set_collection(collection)
        self.apply_optimizations()

    def insert(self, collection_name, chunk):
        self.db[collection_name].insert_many(chunk)

    def get_value_with_type(self, value, value_type):
        if( value_type == "int" ):
            return int(value)
        elif( value_type == "string" ):
            return str(value)
        elif( value_type == "float" ):
            return float(value)
        elif( value_type == "date" ):
            return datetime.strptime(value, '%Y-%m-%d')
        else:
            print("Unknown type")
            return value
    
    def apply_optimizations(self):
        self.default_indexes()
        if(self.index):
            self.added_index()
            

    def default_indexes(self):
        print("Adding Default index to collections")
        self.db['supplier'].create_index([('s_nationkey', 1)])
        self.db['partsupp'].create_index([('ps_partkey', 1)])
        self.db['partsupp'].create_index([('ps_suppkey', 1)])
        self.db['customer'].create_index([('c_nationkey', 1)])
        self.db['orders'].create_index([('o_custkey', 1)])
        self.db['lineitem'].create_index([('l_orderkey', 1)])
        self.db['lineitem'].create_index([('l_partkey', 1),
                                          ('l_suppkey', 1)])
        self.db['nation'].create_index([('n_regionkey', 1)])
        

    def added_index(self):
        print("Adding Additional index to collections")
        self.db['lineitem'].create_index([('L_SHIPDATE'.lower(), 1)])
        self.db['lineitem'].create_index([('L_DISCOUNT'.lower(), 1)])
        self.db['lineitem'].create_index([('L_QUANTITY'.lower(), 1)])
        self.db['lineitem'].create_index([('L_SHIPMODE'.lower(), 1)])
        self.db['lineitem'].create_index([('L_RETURNFLAG'.lower(), 1)])
        self.db['lineitem'].create_index([('L_LINESTATUS'.lower(), 1)])
        self.db['lineitem'].create_index([('L_COMMITDATE'.lower(), 1)])
        self.db['lineitem'].create_index([('L_RECEIPTDATE'.lower(), 1)])
        self.db['lineitem'].create_index([('L_SHIPINSTRUCT'.lower(), 1)])

        self.db['part'].create_index([('P_TYPE'.lower(), 1)])
        self.db['part'].create_index([('P_SIZE'.lower(), 1)])
        self.db['part'].create_index([('P_BRAND'.lower(), 1)])
        self.db['part'].create_index([('P_PARTKEY'.lower(), 1)])
        self.db['part'].create_index([('P_CONTAINER'.lower(), 1)])

        self.db['orders'].create_index([('O_ORDERKEY'.lower(), 1)])
        self.db['orders'].create_index([('O_ORDERDATE'.lower(), 1)])
        self.db['orders'].create_index([('O_ORDERSTATUS'.lower(), 1)])

        self.db['supplier'].create_index([('S_SUPPKEY'.lower(), 1)])

        self.db['customer'].create_index([('C_CUSTKEY'.lower(), 1)])
        self.db['customer'].create_index([('C_ACCTBAL'.lower(), 1)])

        self.db['nation'].create_index([('N_NAME'.lower(), 1)])

        self.db['region'].create_index([('R_NAME'.lower(), 1)])
        self.db['region'].create_index([('r_REGIONKEY'.lower(), 1)])

    