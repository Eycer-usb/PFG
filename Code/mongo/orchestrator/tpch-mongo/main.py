import sys
from mongo_tpch import Mongo_TPCH


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
def create():
    db = Mongo_TPCH(HOST, PORT, DB_NAME)
    db.generate()


"""
Show the help message
"""
def print_help():
    help = "Usage: main.py [option] \n Options: \n\
    create [<host, port, db_name>]\t Create [or rewrite] TPCH database \n\
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
    elif sys.argv[1] == 'create' and len(sys.argv == 5):
        create(sys.argv[2], sys.argv[3], sys.argv[4])
    else:
        print_help()
    

