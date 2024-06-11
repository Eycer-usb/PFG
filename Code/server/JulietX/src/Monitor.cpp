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

void Monitor::start(string pname)
{
    this->monitoring = true;
    this->pname = pname;
    cout << "Monitor started for process name " << pname << endl;
    
    while (this->monitoring)
    {
        vector<map<string,double>> sample = this->takeSample();

        if (sample.size() == 0)
        {
            continue;
        }

        // Update total energy consumed
        this->updateEnergy(sample);
    }

}

void Monitor::stop()
{
    this->monitoring = false;
    cout << "Monitor stopped" << endl;
    if (this->energy.size() == 0)
    {
        cout << "No energy consumed" << endl;
        return;
    }
    // Print last energy consumed
    cout << "Total System energy consumed: " << this->sysEnergy[this->energy.size() - 1] << " J" << endl;
    cout << "Energy consumed by process: " << this->energy[this->energy.size() - 1] << " J" << endl;


}


double Monitor::getEnergyConsumed(map<string,double> iteration)
{
    double energy = 0;
    for (map<string,double>::iterator it = iteration.begin(); it != iteration.end(); ++it)
    {
        string key = it->first;
        if (key.find("process") != string::npos)
        {
            double cpuPercentageUsedByPid = iteration[key];
            energy += cpuPercentageUsedByPid * iteration["energy"];
        }
    }
    return energy;
}

void Monitor::updateEnergy(vector<map<string,double>> sample)
{
    double energy = this->energy.size() == 0 ? 0 : this->energy[this->energy.size() - 1];
    for (map<string,double> iteration : sample)
    {
        energy += this->getEnergyConsumed(iteration);
    }
    this->energy.push_back(energy);
    double systemConsumedEnergy = this->sysEnergy.size() == 0 ? 0 : this->sysEnergy[this->sysEnergy.size() - 1];
    double systemConsumedEnergyIteration = 0;
    for (map<string,double> iteration : sample)
    {
        systemConsumedEnergyIteration += iteration["energy"];
    }
    this->sysEnergy.push_back(systemConsumedEnergy + systemConsumedEnergyIteration);

    // cout << "Total energy consumed: " << this->sysEnergy[this->energy.size() - 1] << " J" << endl;
    // cout << "Energy consumed by process: " << this->energy[this->energy.size() - 1] << " J" << endl;
}

vector<map<string,double>>  Monitor::takeSample()
{
    vector<double> energySamples; // energy samples
    vector<vector<double>> systemLoadSamples; // system load samples
    vector<map<string,double>> sample; // sample to return


    // Get the first sample
    energySamples.push_back(this->cpu->getCurrentPower());
    systemLoadSamples.push_back(this->sys->getSystemLoad());
    
    for (int i = 1; i < this->samplingTime / this->samplingRate + 1; i++)
    {
        // Process samples
        map<int, array<vector<double>, 2>> processSample; // pid -> sample

        // Get the process id of the process with name pname
        vector<int> pids = this->sys->getProcessMachingName(this->pname);

        // Check if the process is running
        if (pids.size() == 0)
        {
            // cout << "No process with name " << this->pname << " found" << endl;
        }
        // Get the initials load of the process
        for (int pid : pids)
        {
            vector<double> processLoad = this->sys->getProcessLoad(pid);
            processSample[pid][0] = processLoad;
        }

        usleep(this->samplingRate * 1000);

        // Get the final load of the process
        for (int pid : pids)
        {
            vector<double> processLoad = this->sys->getProcessLoad(pid);
            processSample[pid][1] = processLoad;
        }
        
        energySamples.push_back(this->cpu->getCurrentPower());
        systemLoadSamples.push_back(this->sys->getSystemLoad());

        // Calculate the energy consumed in the last sampling period
        map<string, double> iteration;
        iteration["energy"] = energySamples[i] - energySamples[i - 1];


        //Calculate the cpu usage in the last sampling period
        vector<double> cpuUsage = this->sys->getSystemCpuUsage(systemLoadSamples[i - 1], systemLoadSamples[i]);
        iteration["cpu_percentage"] = cpuUsage[0];


        // Calculate the cpu usage of the process in the last sampling period
        for ( std::map<int, array<vector<double>, 2>>::iterator it = processSample.begin(); it != processSample.end(); ++it )
        {
            int pid = it->first;
            vector<double> processCpuUsage = this->sys->getProcessCpuUsage(
                        processSample[pid][0],
                        processSample[pid][1],
                        cpuUsage
                    );

            iteration["process_" + to_string(pid) + "_cpu_percentage"] = processCpuUsage[0];
        }

        sample.push_back(iteration);
            
    }


    return sample;    
}