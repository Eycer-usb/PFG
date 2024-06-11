# Configuration Instructions

Before compile any executor ensure to install the following requirements:

## For Client
- Maven
- Java 17
- ssh client
- G++ compiler

## For server

- Postgresql
- MongoDB
- ssh server
- G++ compiler

for each case

## Collector
- Maven
- Java 17

## Analyst
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

