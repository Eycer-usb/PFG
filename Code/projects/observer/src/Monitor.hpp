#if !defined(MONITOR_H)
#define MONITOR_H

class Monitor
{

public:
    Monitor() {};
    virtual ~Monitor() {};
    virtual void start(int pid) = 0;
    virtual std::pair<long, long> stop() = 0;
};

#endif // MONITOR_H
