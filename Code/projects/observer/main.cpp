#include <stdlib.h>
#include <string>
#include <iostream>
#include <map>
#include <vector>
#include "src/Executor.hpp"
#include "src/JulietMonitor.hpp"
#include "src/Colors.hpp"

using namespace std;

map<string, string> config; // Configurations

#include <stdio.h>


void getConfigFromEnvironment()
{

    printf(TITLE "Setting Configurations" ENDL);
    const vector<string> variable{
        "SOCKET_PORT",
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
    printf(TITLE "JulietX Monitor Tool Started!" ENDL);
    // Error handling
    if (argc != 1)
    {
        cout << "Usage: " << argv[0] << endl;
        cout << "Is necessary the follow environment variables:" << endl;
        cout << "\tSOCKET_PORT - Port where the observer will listen" << argv[0] << endl;
        cout << "\tCOLLECTOR_ENDPOINT - Service Endpoint to storage results" << argv[0] << endl;
        exit(EXIT_FAILURE);
    }

    // Get Arguments
    getConfigFromEnvironment();

    // Choosing Juliet as Monitor
    JulietMonitor julietMonitor = JulietMonitor(250, 1000);

    // Starting sockets connections
    Executor executor(config, &julietMonitor);
    executor.listen();

    return 0;
}
