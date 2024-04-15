#if !defined(EXECUTOR_H)
#define EXECUTOR_H

#include <string>
#include <cstring> 
#include <iostream>
#include <fstream>
#include <array>
#include <vector>
#include <map>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h> 
#include "Monitor.hpp"
#include "Colors.hpp"

using namespace std;

class Executor
{
private:
    int serverSocket;
    int clientConnection;
    int port;
    void talk();
    void acceptConnection();
    void closeConnection();
    void sendMessage( char* message );
    void startMonitoring( char* message );
    void stopMonitoring();
    void reportToCollector( char* message );
    void sendSuccess();

public:
    Executor( map<string, string> config );
    ~Executor();
    void listen();
};


#endif // EXECUTOR_H
