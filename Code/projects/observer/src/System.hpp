#if !defined(SYSTEM_H)
#define SYSTEM_H

#include <string>
#include <vector>
#include <stdio.h>
#include "Cpu.hpp"
#include "RaplLinux.hpp"

class System
{
private:
    
public:
    static int getOsName();
    Cpu* getCpu();
    int getNumberOfCpus();
    static vector<int> getProcessMachingName(string pname);
    static bool isProcessRunning(int pid);
    static vector<double> getSystemLoad();
    static vector<double> getProcessLoad(int pid);
    static vector<double> getSystemCpuUsage( vector<double> load1, vector<double> load2 ); 
    static vector<double> getProcessCpuUsage( vector<double> load1, vector<double> load2, vector<double> totalCpuTime );

};

#endif // SYSTEM_H
