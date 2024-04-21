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
#include <thread>
#include "Monitor.hpp"
#include "Colors.hpp"

using namespace std;

class Executor
{
private:
    int serverSocket;
    int clientConnection;
    int port;
    Monitor monitor;
    unique_ptr<thread> monitorThread;
    pair<long, long> metrics;
    
    void talk();
    void acceptConnection();
    void closeConnection();
    void sendMessage( char* message );
    void startMonitoring( long pid );
    void stopMonitoring();
    void reportToCollector( char* message );
    void sendSuccess();
    void monitorThreadFunction(int pid);

public:
    Executor( map<string, string> config );
    ~Executor();
    void listen();
};


#endif // EXECUTOR_H
