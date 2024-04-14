#include "Executor.hpp"

using namespace std;

Executor::Executor(map<string, string> config)
{
    printf(TITLE "Configuring Socket" END);
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
        printf(ERROR "Socket failed" END);
        exit(EXIT_FAILURE);
    }

    if (bind(this->serverSocket,
             (struct sockaddr *)&serverAddress,
             sizeof(serverAddress)) < 0)
    {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }

    printf(SUCCESS "Socket Binding Success" END);
}
Executor::~Executor()
{
    close(this->serverSocket);
}
void Executor::listen()
{
    const int backlog = 1; // maximum length to which the queue of pending connections

    if (::listen(this->serverSocket, backlog) < 0)
    {
        printf(ERROR "Error starting listening on port" END);
        exit(EXIT_FAILURE);
    }

    while (1)
    {
        printf(TITLE "Socket Listening on Port: %i" END, this->port);
        printf(TITLE "Socket Accepting Connection" END);
        this->acceptConnection();
        this->talk();
    }
}

void Executor::acceptConnection()
{
    const int status = this->clientConnection = accept(this->serverSocket, nullptr, nullptr);
    if (status < 0)
    {
        printf(ERROR "Error accepting connection");
        exit(EXIT_FAILURE);
    }
    else
    {
        printf(SUCCESS "Connection Stablish Successfully" END);
    }
}

void Executor::talk()
{
    char buffer[1024];
    while (this->clientConnection != -1)
    {
        buffer[1024] = {0};
        recv(this->clientConnection, buffer, sizeof(buffer), 0);
        printf(INFO "Received: %s" END, buffer);
        printf(INFO "Sending: %s" END, buffer);
        const int code = buffer[0] - '0';
        switch (code)
        {
        case -1:
            this->closeConnection();
            break;
        
        case 0:
            printf(SUCCESS "Sended" END);
            break;
        case 1:
            this->startMonitoring(buffer);
            break;
        case 2:
            this->stopMonitoring();
            break;
        case 3:
            this->reportToCollector(buffer);
            break;
        default:
            printf(ERROR "Unknow message code" END);
            break;
        }
    }
}

void Executor::closeConnection() {
    close(this->clientConnection);
    this->clientConnection = -1;
    this->sendMessage("0");
}

void Executor::sendMessage(char* message) {
    send(this->clientConnection, message, strlen(message), 0);
}

void Executor::startMonitoring(char* message){
    printf(TITLE "Starting Monitoring" END);
    // Starting
    this->sendMessage("0");
}

void Executor::stopMonitoring(){
    printf(TITLE "Monitoring Stoped" END);
    this->sendMessage("0");
    // Stopping
}

void Executor::reportToCollector(char* buffer) {
    printf(TITLE "Reporting to Collector" END);
    this->sendMessage("0");
    // Reporting
}