#!/bin/bash

export $(grep -v '^#' environment.env |  xargs -d '\n')

cd executor
mvn clean install package
cd ..
cp executor/target/*-executor-*jar-with-dependencies.jar orchestrator/$jar_file

cd orchestrator
sudo -E ./run.sh