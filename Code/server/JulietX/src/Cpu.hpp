// This class is an abstract class that represents a CPU. It has the following methods:
// - initializate: This method is used to initialize the CPU type.
// - getInitialPower: This method is used to get the initial power of the CPU.
// - getCurrentPower: This method is used to get the current power of the CPU.

#ifndef CPU_HPP
#define CPU_HPP

class Cpu
{    
public:
    virtual void initializate() = 0;
    virtual double getInitialPower() = 0;
    virtual double getCurrentPower() = 0;
};

#endif // CPU_HPP