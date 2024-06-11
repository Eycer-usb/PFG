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
#include <unistd.h>
#include <thread>
#include "Monitor.hpp"
#include "Colors.hpp"
#include "Collector.hpp"

using namespace std;

class Executor
{
private:
    map<string, string> config;
    int serverSocket;
    int clientConnection;
    int port;
    Monitor* monitor;
    Collector collector;
    unique_ptr<thread> monitorThread;
    pair<double, double> metrics;
    
    void talk();
    void acceptConnection();
    void closeConnection();
    void sendMessage( char* message );
    void startMonitoring( long pid );
    void stopMonitoring();
    void reportToCollector( long directiveIdFk );
    void sendSuccess();
    void monitorThreadFunction(int pid);

public:
    Executor( map<string, string>, Monitor* monitor );
    ~Executor();
    void listen();
};


#endif // EXECUTOR_H
