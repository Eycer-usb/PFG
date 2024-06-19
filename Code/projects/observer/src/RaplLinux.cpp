#include "RaplLinux.hpp"

RaplLinux::RaplLinux()
{

}

RaplLinux::~RaplLinux()
{
}

void RaplLinux::initializate()
{
    cout << "Initializing RAPL..." << endl; // TODO: Remove this line
    // Initialize RAPL
    array<string, 3> powercapPaths = this->getPowercapPath();
    cout << "Powercap Psys path: " << powercapPaths[0] << endl; // TODO: Remove this line
    fstream psysFile(powercapPaths[0], ios::in);
    if( psysFile.good() )
    {
        cout << "Powercap Psys interface detected." << endl; // TODO: Remove this line
        psysFile.close();
        this->raplFilesToRead.push_back(powercapPaths[0]);
    }
    else
    {
        fstream pkgFile(powercapPaths[1], ios::in);
        if( pkgFile.good() )
        {
            cout << "Powercap Pkg interface detected." << endl; // TODO: Remove this line
            pkgFile.close();
            this->raplFilesToRead.push_back(powercapPaths[1]);
            
            fstream dramFile(powercapPaths[2], ios::in);
            if( dramFile.good() )
            {
                cout << "Powercap Dram interface detected." << endl; // TODO: Remove this line
                dramFile.close();
                this->raplFilesToRead.push_back(powercapPaths[2]);
            }
        }
    }

    if (this->raplFilesToRead.size() == 0)
    {
        cout << "Error initializing RAPL." << endl;
        cout << "Is the program running with root privileges?" << endl;
        exit(EXIT_FAILURE);
    }
    else
    {
        cout << "RAPL initialized." << endl; // TODO: Remove this line
    }

}

long long int RaplLinux::getCurrentEnergy()
{
    long long int energy = 0;
    for (auto raplFile : this->raplFilesToRead)
    {
        fstream file;
        file.open(raplFile, ios::in);
        if (file.good())
        {
            string line;
            getline(file, line);
            file.close();
            energy += stod(line);
        }
        else
        {
            cout << "Error opening file getting initial energy: " << raplFile << endl;
            exit(EXIT_FAILURE);
        }
    }
    return energy;
}

long long int RaplLinux::getInitialEnergy()
{
    return this->getCurrentEnergy();
}

array<string, 3> RaplLinux::getPowercapPath()
{
    array<string, 3> powercapPath;
    powercapPath[1] = "/sys/class/powercap/intel-rapl/intel-rapl:1/energy_uj";
    powercapPath[0] = "/sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj";
    powercapPath[2] = "/sys/class/powercap/intel-rapl/intel-rapl:0/intel-rapl:0:2/energy_uj";
    return powercapPath;
}