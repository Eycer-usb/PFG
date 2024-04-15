#!/bin/bash

# Importing environment variables
 export $(grep -v '^#' environment.env | xargs -0)

# Compile
make all

# run 
chmod +x julietX
./julietX
