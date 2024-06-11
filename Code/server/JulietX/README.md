# Juliet - Energy Mesurement Tool for Linux Process

This tool is designed to measure the energy consumption of any process in the Linux operating system with Intel RAPL interface and with process management accessible from /proc.

Juliet search for all process maching a given name and analize the energy compsumtion of all of its returning the total energy compsumed by all system and the selected application once the SIGUSER1 (10) signal is recieved.

## Requierements

- G++ compiler with C++ version 11
- Linux Operative System
- Intel Proccessor x86_64 with RAPL Interface

## Installation

To start the compilation run

```bash
make all
```

To delete binary files

```bash
make clean
```

## Usage

```bash
sudo ./juliet <process name> [<sampling rate> <sampling time>]
```

If sampling rate and sampling time are not provided, the default values are used
Sampling rate: 250 ms
Sampling time: 1000 ms



## Stop Monitoring

To stop monitoring and show results use

```bash
sudo pkill -10 juliet
```

## Examples

```bash
sudo ./juliet chrome 250 1000
```

Will monitor chrome process in an rate of 250 ms every 1000 ms.

```bash
sudo ./juliet postgres > postgres_results.txt
```

Start monitoring for postgres process and store results in postgres_results.txt
