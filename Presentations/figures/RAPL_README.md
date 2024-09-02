
# Leer el consumo de energía actual en microjules
```bash
cat /sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj
```

# Leer el nombre del dominio
```bash
cat /sys/class/powercap/intel-rapl/intel-rapl:0/name
```

# Leer el consumo de energía del dominio de la CPU
```bash
cat /sys/class/powercap/intel-rapl/intel-rapl:0:0/energy_uj
```