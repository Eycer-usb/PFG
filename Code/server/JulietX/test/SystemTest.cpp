#include <iostream>
#include "../src/Cpu.hpp"
#include "../src/System.hpp"
#include <unistd.h>
#include <vector>

using namespace std;

int _SystemTest()
{
    System sys;
    Cpu * cpu = sys.getCpu();
    cpu->initializate();
    cout << "Number of CPUs: " << sys.getNumberOfCpus() << endl;
    
    while (1)
    {
    
        for ( auto pid : sys.getProcessMachingName("chrome") )
        {
            if (sys.isProcessRunning(pid))
            {
                vector<double> initialLoad = sys.getSystemLoad();
                vector<double> initialProcessLoad = sys.getProcessLoad(pid);
                sleep(1);
                vector<double> finalProcessLoad = sys.getProcessLoad(pid);
                vector<double> finalLoad = sys.getSystemLoad();
                vector<double> cpuUsage = sys.getSystemCpuUsage(initialLoad, finalLoad);

                cout << "Process " << pid << " CPU Usage: " << sys.getProcessCpuUsage(initialProcessLoad, finalProcessLoad, cpuUsage)[0] << endl;
                cout << "System CPU Usage: " << cpuUsage[0] << endl;
            }
        }
        sleep(1); 
    }
    return 0;
}
