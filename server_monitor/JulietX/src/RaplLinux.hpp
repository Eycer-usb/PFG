#if !defined(RAPL_LINUX_H)
#define RAPL_LINUX_H

#include <string>
#include <iostream>
#include <fstream>
#include "Cpu.hpp"
#include <array>
#include <vector>

using namespace std;

class RaplLinux : public Cpu
{
private:
    
public:
    RaplLinux();
    ~RaplLinux();
    void initializate() override;
    double getInitialPower() override;
    double getCurrentPower() override;
    std::array <string, 3> getPowercapPath();
    std::vector <string> raplFilesToRead = {};
};


#endif // RAPL_LINUX_H
