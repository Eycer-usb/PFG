import sys
from mongo_tpch import Mongo_TPCH
from mongo_qgen import MongoQGen

"""
Default Configuration
"""
HOST="localhost"
PORT=27017
DB_NAME="tpch"

"""
Prepare the database:
Create connection, drop the database
and load with the tpch benchmark
"""
def create(host, port, db_name, optimizations):
    HOST = host,
    PORT = int(port,)
    DB_NAME = db_name
    db = Mongo_TPCH(HOST, PORT, DB_NAME, optimizations=optimizations)
    db.generate()

def generate_queries():
    target_folder = "queries"
    queries_template_folder = "queries_templates"
    tpch_dbgen = "tpch-dbgen"

    qgen = MongoQGen(target_folder, 
                queries_template_folder, tpch_dbgen)
    for i in range(1,23):
        qgen.generate(i)


"""
Show the help message
"""
def print_help():
    help = "Usage: main.py [option] \n Options: \n\
    create [<host, port, db_name>]\t Create [or rewrite] TPCH database \n \
    generate-queries              \t Generate 22 mongo queries from tpch benchmark\
    "

    print(help)



"""
If is running as a scrypt check for correct arguments
"""
if '__main__' == __name__:
    if len(sys.argv) < 2:
        print_help()
    elif sys.argv[1] == 'create' and len(sys.argv) == 2:
        create()
    elif sys.argv[1] == 'create' and len(sys.argv) > 5:
        create(sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5:])
    elif sys.argv[1] == "generate-queries":
        generate_queries()
    else:
        print_help()
    

