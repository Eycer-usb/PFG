# Configuration Instructions

Before compile any executor ensure to install the following requirements:

## For Client
- Maven
- Java 17
- ssh client
- G++ compiler

```console
sudo apt install -y openjdk-17-jdk \
    openjdk-17-jre \
    libcurl4-openssl-dev
    
sudo apt-get install --reinstall libpq-dev
```

If found any problem with the mongo or postgres database generation:
```console
sudo chmod -R 777 Code/mongo/client/tpch-mongo/tpch-dbgen 
sudo chmod -R 777 Code/postgres/client/tpch-pgsql/tpch-dbgen
```

## For server Postgres

- Postgresql
- ssh server
- G++ compiler

```console
sudo apt install -y postgresql-common \
    postgresql-client-14 \
    postgresql-14 \
    postgresql-server-dev-14 \
    postgresql-contrib \
    postgresql-server-dev-all \
    libcurl4-openssl-dev
```

for each case

## For server Mongo
- Mongodb
```console
sudo apt install -y libcurl4-openssl-dev
```

## Collector
- Maven
- Java 17
- Postgresql (With database collector created)


## Analyst
```
sudo apt get install libpq-dev
```
- Python3 and its requirementes in the file requirements.txt


# Execution Instructions

For the execution run:

```console
(env)$ python3 juliet_cli.py <configuration file> <instance> [options]

```
Where :
- Configuration file: is the configuration file path (an example can be found in config.json file in this folder)
- Instance: the instance type (Analyst, Collector, Client, Server)
- Options: Postgres o Mongo in case of server or client instance

