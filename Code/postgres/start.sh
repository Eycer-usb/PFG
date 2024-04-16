#!/bin/bash

cd executor
mvn clean install package
cd ..
cp executor/target/*-executor-*.jar orchestrator/executor.jar
cd orchestrator
sudo ./prepare.sh
sudo ./run.sh