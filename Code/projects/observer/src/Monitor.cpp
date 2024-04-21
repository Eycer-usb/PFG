#include "Monitor.hpp"

using namespace std;

// Simple Rate is the number of samples per second
// Sampling Time is the time between samples in seconds
Monitor::Monitor()
{
    this->monitoring = true;
    this->sys = new System();
    this->cpu = sys->getCpu();
    cpu->initializate();
}

Monitor::~Monitor()
{
    delete this->sys;
    delete this->cpu;
}

void Monitor::init(double samplingRate, double samplingTime)
{
    this->samplingRate = samplingRate;
    this->samplingTime = samplingTime;
}

void Monitor::start(int pid)
{
    this->monitoring = true;
    this->pid = pid;
    cout << "Monitor started for process id " << pid << endl;

    while (this->monitoring)
    {
        vector<map<string, double>> sample = this->takeSample();

        if (sample.size() == 0)
        {
            continue;
        }

        // Update total energy consumed
        this->updateEnergy(sample);
    }
}

pair<long, long> Monitor::stop()
{
    pair<long, long> energyMeasured;
    this->monitoring = false;
    cout << "Monitor stopped" << endl;
    if (this->energy.size() == 0)
    {
        cout << "No energy consumed" << endl;
        energyMeasured.first = 0;
        energyMeasured.second = 0;
        return energyMeasured;
    }
    // Print last energy consumed
    cout << "Total System energy consumed: " << this->sysEnergy[this->energy.size() - 1] << " J" << endl;
    cout << "Energy consumed by process: " << this->energy[this->energy.size() - 1] << " J" << endl;
    energyMeasured.first = this->sysEnergy[this->energy.size() - 1];
    energyMeasured.second = this->energy[this->energy.size() - 1];
    return energyMeasured;
}

double Monitor::getEnergyConsumed(map<string, double> iteration)
{
    double energy = 0;
    double cpuPercentageUsedByPid = iteration["process_" + to_string(pid) + "_cpu_percentage"];
    energy += cpuPercentageUsedByPid * iteration["energy"];
    return energy;
}

void Monitor::updateEnergy(vector<map<string, double>> sample)
{
    // Updating energy Consumed by process
    double energy = this->energy.size() == 0 ? 0 : this->energy[this->energy.size() - 1];
    for (map<string, double> iteration : sample)
    {
        energy += this->getEnergyConsumed(iteration);
    }
    this->energy.push_back(energy);

    // Updating energy consumed by system
    double systemConsumedEnergy = this->sysEnergy.size() == 0 ? 0 : this->sysEnergy[this->sysEnergy.size() - 1];
    double systemConsumedEnergyIteration = 0;
    for (map<string, double> iteration : sample)
    {
        systemConsumedEnergyIteration += iteration["energy"];
    }
    this->sysEnergy.push_back(systemConsumedEnergy + systemConsumedEnergyIteration);

    // cout << "Total energy consumed: " << this->sysEnergy[this->energy.size() - 1] << " J" << endl;
    // cout << "Energy consumed by process: " << this->energy[this->energy.size() - 1] << " J" << endl;
}

vector<map<string, double>> Monitor::takeSample()
{
    vector<double> energySamples;             // energy samples
    vector<vector<double>> systemLoadSamples; // system load samples
    vector<map<string, double>> sample;       // sample to return

    // Get the first sample
    energySamples.push_back(this->cpu->getCurrentEnergy());
    systemLoadSamples.push_back(this->sys->getSystemLoad());

    for (int i = 1; i < this->samplingTime / this->samplingRate + 1; i++)
    {
        // Process samples
        array<vector<double>, 2> processSample; // [ initalProcessLoad, finalProcessLoad ]

        // Get the initial and final load of the process
        processSample[0] = this->sys->getProcessLoad(pid);
        usleep(this->samplingRate * 1000);
        processSample[1] = this->sys->getProcessLoad(pid);

        // The energy and CPU usage of the entire System at the end  of a sample
        energySamples.push_back(this->cpu->getCurrentEnergy());
        systemLoadSamples.push_back(this->sys->getSystemLoad());

        // Calculate the energy consumed in the last sampling period
        map<string, double> iteration;
        iteration["energy"] = energySamples[i] - energySamples[i - 1];

        // Calculate the cpu usage in the last sampling period
        vector<double> cpuUsage = this->sys->getSystemCpuUsage(systemLoadSamples[i - 1], systemLoadSamples[i]);
        iteration["cpu_percentage"] = cpuUsage[0];

        vector<double> processCpuUsage = this->sys->getProcessCpuUsage(
            processSample[0],
            processSample[1],
            cpuUsage);

        iteration["process_" + to_string(pid) + "_cpu_percentage"] = processCpuUsage[0];
        sample.push_back(iteration);
    }

    return sample;
}