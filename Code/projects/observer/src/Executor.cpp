#include "Executor.hpp"

using namespace std;

Executor::Executor(map<string, string> config, Monitor* monitor)
{
    printf(TITLE "Configuring Socket" ENDL);
    this->config = config;
    this->monitor = monitor;
    const int type = SOCK_STREAM; // TCP(reliable, connection-oriented)
    const int domain = AF_INET;   // For Connections in different host
    const int protocol = 0;       // Protocol value for Internet Protocol(IP), which is 0
    const int status = this->serverSocket = socket(domain, type, protocol);
    this->port = stoi(config["SOCKET_PORT"]);

    sockaddr_in serverAddress;
    serverAddress.sin_family = domain;
    serverAddress.sin_port = htons(8080);
    serverAddress.sin_addr.s_addr = INADDR_ANY;
    serverAddress.sin_port = htons(this->port);

    if (status < 0)
    {
        printf(ERROR "Socket failed" ENDL);
        exit(EXIT_FAILURE);
    }

    if (bind(this->serverSocket,
             (struct sockaddr *)&serverAddress,
             sizeof(serverAddress)) < 0)
    {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }

    printf(SUCCESS "Socket Binding Success" ENDL);
}
Executor::~Executor()
{
    this->stopMonitoring();
    this->closeConnection();
    close(this->serverSocket);
}
void Executor::listen()
{
    const int backlog = 1; // maximum length to which the queue of pending connections

    if (::listen(this->serverSocket, backlog) < 0)
    {
        printf(ERROR "Error starting listening on port" ENDL);
        exit(EXIT_FAILURE);
    }

    while (1)
    {
        printf(SUCCESS "Socket Listening on Port: %i" ENDL, this->port);
        printf(SUCCESS "Socket Accepting Connection" ENDL);
        this->acceptConnection();
        this->talk();
    }
}

void Executor::acceptConnection()
{
    const int status = this->clientConnection = accept(this->serverSocket, nullptr, nullptr);
    if (status < 0)
    {
        printf(ERROR "Error accepting connection" ENDL);
        exit(EXIT_FAILURE);
    }
    else
    {
        printf(SUCCESS "Connection Stablish Successfully" ENDL);
    }
}

void Executor::talk()
{
    while (this->clientConnection != -1)
    {
        char buffer[1024] {0};
        recv(this->clientConnection, buffer, sizeof(buffer), 0);
        printf(INFO "Received: " END "%s", buffer);
        const int code = buffer[0] - '0';
        long result;
        buffer[0] = '0';
        char* output;
        result = strtol(buffer, &output, 10);
        switch (code)
        {
        case 9:
            this->closeConnection();
            break;
        
        case 0:
            printf(SUCCESS "Sended" ENDL);
            break;
        case 1:
            this->startMonitoring(result);
            break;
        case 2:
            this->stopMonitoring();
            break;
        case 3:
            this->reportToCollector(result);
            break;
        default:
            printf(ERROR "Unknow message code" ENDL);
            this->sendSuccess();
            break;
        }
    }
}



void Executor::sendMessage(char* message) {
    send(this->clientConnection, message, strlen(message), 0);
}

void Executor::sendSuccess() {
    this->sendMessage((char*) "0\n");
    printf(SUCCESS "Received Notification sended" ENDL);

}

void Executor::startMonitoring(long pid){
    printf(ACTION "Starting Monitoring" ENDL);
    // Starting
    monitorThread.reset(new thread(&Executor::monitorThreadFunction, this, pid));
    while (!this->monitor->isMonitoring); // Wait for monitoring to start
    this->sendSuccess();
}

void Executor::stopMonitoring(){
    printf(ACTION "Monitoring Stoped" ENDL);
    this->metrics = this->monitor->stop();
    this->monitorThread->join();
    this->sendSuccess();
}

void Executor::closeConnection() {
    printf(ACTION "Closing Client Connection" ENDL);
    this->sendSuccess();
    close(this->clientConnection);
    this->clientConnection = -1;
}

void Executor::reportToCollector(long directiveIdFk) {
    printf(ACTION "Reporting to Collector" ENDL);
    printf(ACTION "Reporting %f and %f" ENDL, this->metrics.first, this->metrics.second );
    char body[1024];
    sprintf(body, "{\
    \"directiveIdFk\": %li,\
    \"energyConsumed\": \"%.3f\",\
    \"cpuUsage\": \"%s\"\
    }",
    directiveIdFk, this->metrics.second, "N/A");
    this->collector.storeMetrics(this->config["COLLECTOR_ENDPOINT"], body);
    cout << endl;
    this->sendSuccess();
}


void Executor::monitorThreadFunction(int pid){
    this->monitor->start(pid);
}