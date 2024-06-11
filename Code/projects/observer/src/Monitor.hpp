#if !defined(MONITOR_H)
#define MONITOR_H

class Monitor
{

public:
    Monitor() {};
    virtual ~Monitor() {};
    virtual void start(int pid) = 0;
    virtual std::pair<double, double> stop() = 0;
    virtual bool isMonitoring() = 0;
};

#endif // MONITOR_H
