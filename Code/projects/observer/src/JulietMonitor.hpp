#if !defined(JULIET_MONITOR_HPP)
#define JULIET_MONITOR_HPP

#include <iostream>
#include <string>
#include <map>
#include <vector>
#include <unistd.h>
#include "System.hpp"
#include "Cpu.hpp"
#include "Monitor.hpp"

class JulietMonitor : public Monitor
{
private:
    bool monitoring;
    int pid;
    double samplingRate;
    double samplingTime;
    map<int, double> cpuUseByPid;
    map<int, double> energyByPid;
    vector<double> power;
    vector<double> energy;
    vector<double> sysEnergy;
    System* sys;
    Cpu* cpu;

public:
    JulietMonitor(double samplingRate, double samplingTime);
    ~JulietMonitor();
    void start(int pid);
    pair<double, double> stop();
    void updateEnergy(vector<map<string,double>> sample);
    vector<map<string,double>>  takeSample();
    double getEnergyConsumed(map<string,double> iteration);
};

#endif // JULIET_MONITOR_HPP