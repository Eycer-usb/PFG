#include <stdlib.h>
#include <string>
#include <iostream>
#include <map>
#include <vector>
#include "src/Executor.hpp"
#include "src/Colors.hpp"

using namespace std;

map<string, string> config; // Configurations

#include <stdio.h>


void getConfigFromEnvironment()
{

    printf(TITLE "Setting Configurations" ENDL);
    const vector<string> variable{
        "SOCKET_PORT",
        "EXECUTOR_PORT",
        "COLLECTOR_ENDPOINT"};

    for (size_t i = 0; i < variable.size(); i++)
    {
        const char *key = variable[i].c_str();
        if (getenv(key))
        {
            const char* value = getenv(key);
            config[variable[i]] = value;
            cout << key << ": " << value << endl;
        }
        else
        {
            printf(ERROR "Error: Environment Variable %s undefined" ENDL, key);
            exit(EXIT_FAILURE);
        }
    }
}

// Main function of the program
int main(int argc, char const *argv[])
{
    printf(TITLE "JuletX Monitor Tool Started!" ENDL);
    // Error handling
    if (argc != 1)
    {
        cout << "Usage: " << argv[0] << " <config.json>" << endl;
        cout << "Example: " << argv[0] << " config.json" << endl;
        exit(EXIT_FAILURE);
    }

    // Get Arguments
    getConfigFromEnvironment();

    // Starting sockets connections
    Executor executor = Executor(config);
    executor.listen();

    return 0;
}
