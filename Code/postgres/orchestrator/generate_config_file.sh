#!/bin/bash

cat << EOF > $4
{
    "database": {
        "host": "$database_host",
        "port": "$database_port",
        "name": "$database_name",
        "user": "$database_user",
        "password": "$database_password",
        "optimization": "$1",
        "queryKey": "$2",
        "queryPath": "$queries_path_from_orchestrator/$2.$queries_extension"
    },
    "executor": {
        "iteration": "$3",
        "clientObserver": {
            "address": "$client_observer_address",
            "port": "$client_observer_port"
        },
        "serverObserver": {
            "address": "$server_observer_address",
            "port": "$server_observer_port"
        },
        "collector": {
            "endpoint": "$collector_endpoint"
        }
    }
}
EOF

