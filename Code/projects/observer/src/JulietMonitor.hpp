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
    bool started_signal;
    int pid;
    double samplingRate;
    double samplingTime;
    map<int, double> cpuUseByPid;
    map<int, double> energyByPid;
    vector<double> power;
    vector<long double> energy;
    vector<long double> sysEnergy;
    System* sys;
    Cpu* cpu;

public:
    JulietMonitor(double samplingRate, double samplingTime);
    ~JulietMonitor();
    void start(int pid);
    pair<long double, long double> stop();
    bool isMonitoring();
    void updateEnergy(vector<map<string,long double>> sample);
    vector<map<string, long double>>  takeSample();
    long double getEnergyConsumed(map<string, long double> iteration);
};

#endif // JULIET_MONITOR_HPP