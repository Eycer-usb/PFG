#include "src/System.hpp"
#include "src/Monitor.hpp"
#include <iostream>
#include <fstream>
#include <signal.h>
#include "test/SystemTest.cpp"


using namespace std;

Monitor monitor = Monitor(); // Monitor
int mode = 0; // 0 = normal, 1 = testing

// Signal handler for SIGUSR1
void signalHandler(int signum)
{
    cout << "Interrupt signal (" << signum << ") received.\n"; // TODO: Remove this line
    if (mode)
    {
        cout << "Exiting from testing mode..." << endl;
        exit(signum);
    }

    monitor.stop();
    exit(signum);
}

// Run tests
void runTests()
{
    _SystemTest();
}

// Main function of the program
int main(int argc, char const *argv[])
{
    //Error handling
    if (argc != 2 && argc != 4)
    {
        cout << "Usage: " << argv[0] << " <process name> [<sampling rate> <sampling time>]" << endl;
        cout << "If sampling rate and sampling time are not provided, the default values are used." << endl;
        cout << "Sampling rate: 250 ms" << endl;
        cout << "Sampling time: 1000 ms" << endl << endl;
        cout << "Example: " << argv[0] << " chrome 250 1000" << endl;
        exit(EXIT_FAILURE);
    }

    // Check if is running in testing mode
    if (argc == 2 && string(argv[1]) == "test")
    {
        cout << "Running tests..." << endl;
        mode = 1;
        runTests();
        exit(EXIT_SUCCESS);
    }

    // Get Arguments
    string pname = argv[1]; // Process name
    double samplingRate = 250; // Sampling rate in milliseconds
    double samplingTime = 1000; // Sampling time in milliseconds

    if ( argc == 4 )
    {
        //Collecting Sampling Rate and Sampling Time
        try 
        {
            if (stod(argv[3]) < stod(argv[2]))
            {
                cout << "Sampling time must be greater than sample rate" << endl;
                exit(EXIT_FAILURE);
            }
            samplingRate = stod(argv[2]);
            samplingTime = stod(argv[3]);
        }
        catch (const std::invalid_argument& ia) 
        {
            std::cerr << "Invalid argument: " << ia.what() << '\n';
            exit(EXIT_FAILURE);
        }
    }
    
    
    // Initialize monitor
    monitor.init(samplingRate, samplingTime);

    // Start monitoring
    signal(SIGUSR1, signalHandler);
    monitor.start(pname);
    return 0;
}
