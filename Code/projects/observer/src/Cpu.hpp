// This class is an abstract class that represents a CPU. It has the following methods:
// - initializate: This method is used to initialize the CPU type.
// - getInitialEnergy: This method is used to get the initial Energy of the CPU.
// - getCurrentEnergy: This method is used to get the current Energy of the CPU.

#ifndef CPU_HPP
#define CPU_HPP

class Cpu
{    
public:
    virtual void initializate() = 0;
    virtual long long int getInitialEnergy() = 0;
    virtual long long int getCurrentEnergy() = 0;
};

#endif // CPU_HPP