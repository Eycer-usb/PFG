#if !defined(MONITOR_HPP)
#define MONITOR_HPP

#include <iostream>
#include <string>
#include <map>
#include <vector>
#include <unistd.h>
#include "System.hpp"
#include "Cpu.hpp"

class Monitor
{
private:
    bool monitoring;
    string pname;
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
    Monitor();
    ~Monitor();
    void start(string pname);
    void stop();
    void init(double samplingRate, double samplingTime);
    void updateEnergy(vector<map<string,double>> sample);
    vector<map<string,double>>  takeSample();
    double getEnergyConsumed(map<string,double> iteration);
};

#endif // MONITOR_HPP