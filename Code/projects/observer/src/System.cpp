#include "System.hpp"
#include <cmath>

// Get the load of the system
vector<double> System::getSystemLoad()
{
    double user, nice, system, idle;
    FILE* file = fopen("/proc/stat", "r");
    if (file == NULL)
    {
        return {0, 0, 0, 0};
    }
    fscanf(file, "%*s %lf %lf %lf %lf", &user, &nice, &system, &idle);
    fclose(file);
    return {user, nice, system, idle};
}

// Get the load of a process given a process id
vector<double> System::getProcessLoad(int pid)
{
    double utime, stime, cutime, cstime;
    FILE* file = fopen(("/proc/" + to_string(pid) + "/stat").c_str(), "r");
    if (file == NULL)
    {
        return {0, 0, 0, 0};
    }
    fscanf(file, "%*d %*s %*c %*d %*d %*d %*d %*d %*u %*u %*u %*u %*u %lf %lf %lf %lf", &utime, &stime, &cutime, &cstime);
    fclose(file);
    return {utime, stime, cutime, cstime};
}

// Get the number of cpus in the system
int System::getNumberOfCpus()
{
    int numberOfCpus = 0;
    string line;
    ifstream file("/proc/cpuinfo");
    if (file.is_open())
    {
        while (getline(file, line))
        {
            if (line.find("processor") != string::npos)
            {
                numberOfCpus++;
            }
        }
        file.close();
    }
    return numberOfCpus;
}

// Get the percentage of cpu usage between two system loads
vector <double> System::getSystemCpuUsage( vector<double> load1, vector<double> load2 )
{
    for (size_t i = 0; i < 3; i++)
    {
        if (load2[i] < load1[i])
        {
            return {0, 0, 0};
        }
        
    }
    
    double user = load2[0] - load1[0];
    double nice = load2[1] - load1[1];
    double system = load2[2] - load1[2];
    double idle = load2[3] - load1[3];
    double totalUsageCpuTime = user + nice + system;
    double percentage = totalUsageCpuTime / ((totalUsageCpuTime + idle));
    return { percentage, totalUsageCpuTime, idle };
}

// Check if a process is running or not given a process id
bool System::isProcessRunning(int pid)
{
    FILE* file = fopen(("/proc/" + to_string(pid) + "/stat").c_str(), "r");
    char status;
    if (file != NULL)
    {
        fscanf( file, "%*d %*s %c", &status );
        fclose(file);
        return status == 'R';
    }
    
    return false;
}

// Get the process id of all processes with a given name
// Depends on linux pgrep command
vector<int> System::getProcessMachingName(string pname)
{
    vector<int> pids;
    string line;
    string command = "pgrep " + pname;
    FILE* pipe = popen(command.c_str(), "r");
    if (pipe != nullptr)
    {
        char buffer[128];
        while (fgets(buffer, sizeof(buffer), pipe) != nullptr)
        {
            line = buffer;
            pids.push_back(stoi(line));
        }
        pclose(pipe);
    }
    return pids;
}

// Get the name of the operative system and return 1 if is linux
int System::getOsName()
{
    string osName;
    #ifdef _WIN32
    osName =  "Windows 32-bit";
    #elif _WIN64
    osName =  "Windows 64-bit";
    #elif __APPLE__ || __MACH__
    osName =  "Mac OSX";
    #elif __linux__
    osName =  "Linux";
    #elif __FreeBSD__
    osName =  "FreeBSD";
    #elif __unix || __unix__
    osName =  "Unix";
    #else
    osName =  "Other";
    #endif

    if (osName.find("Windows") != string::npos)
    {
        cout << "Operative System: " << osName << " No sopported yet" << endl; 
        return 0;
    }
    else if (osName.find("Mac OSX") != string::npos)
    {
        cout << "Operative System: " << osName << " No sopported yet" << endl; 
        return 0;
    }
    else if (osName.find("Linux") != string::npos)
    {
        cout << "Operative System: " << osName << " detected!" << endl; 
        return 1;
    }
    else if (osName.find("FreeBSD") != string::npos)
    {
        cout << "Operative System: " << osName << " No sopported yet" << endl; 
        return 0;
    }
    else if (osName.find("Unix") != string::npos)
    {
        cout << "Operative System: " << osName << " No sopported yet" << endl; 
        return 0;
    }
    else if (osName.find("Other") != string::npos)
    {
        cout << "Operative System: " << osName << " No sopported yet" << endl; 
        return 0;
    }
    return -1;
}

Cpu* System::getCpu()
{
    // Check if Operative System is Linux
    if( this->getOsName() == 0)
    {
        cout << "Operative System no sopported yet" << endl; 
        exit(EXIT_FAILURE);
    }
    else
    {
        cout << "Linux detected!" << endl;
    }

    // Check architecture to be x86_64
    if( system("uname -m | grep -q x86_64") == 0 )
    {
        cout << "x86_64 architecture detected!" << endl;
    }
    else
    {
        cout << "x86_64 architecture not detected!" << endl;
        exit(EXIT_FAILURE);
    }


    // Look for powercap RAPL interface. If exist return a RaplLinux Instance
    // else stop execution and return an error message
    try
    {
        string powercapPath = "/sys/class/powercap/intel-rapl/intel-rapl:0";
        fstream file;
        file.open(powercapPath, ios::in);
        if (file.is_open())
        {
            cout << "RAPL powercap interface detected!" << endl;
            file.close();
            return new RaplLinux();
        }
        else
        {
            cout << "RAPL powercap interface not detected!" << endl;
            exit(EXIT_FAILURE);
        }

        
    }
    catch(const exception& e)
    {
        cerr << e.what() << '\n';
    }
    return NULL;
}

// Get the percentage of cpu usage between two process loads
vector<double> System::getProcessCpuUsage( vector<double> load1, vector<double> load2, vector<double> cpuUsage )
{
    for (size_t i = 0; i < 3; i++)
    {
        if (load2[i] < load1[i])
        {
            return {0, 0, 0};
        }
        
    }
    double totalCpuTime = cpuUsage[1];
    double totalCpuPercentage = cpuUsage[0];
    double utime = load2[0] - load1[0]; // user time
    double stime = load2[1] - load1[1]; // system time

    double percentage = ((utime + stime) * totalCpuPercentage) / totalCpuTime;

    if (std::isnan(percentage) || std::isinf(percentage) || percentage < 0 || percentage > totalCpuTime)
    {
        return {0, 0, 0};
    }
    return { percentage, utime, stime };
}