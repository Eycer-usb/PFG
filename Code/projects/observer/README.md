# JulietX Observer - Process monitoring tool

## Introduction
This monitoring tool is in constant communication with a executors of a client and emit reports to the collector.

This Observer implementation is based on Juliet project developed for paper "An evaluation of the impact of end-to-end query optimization strategies
on energy consumption" stored in papers folder, but with sockets and API communication for distributed systems architectures or microservices infrastructures.

## Description
This tool is designed to measure the energy consumption of any process in the Linux operating system with Intel RAPL interface and with process management accessible from /proc.

JulietX differently to Juliet does not search for process matching a given name and analyze the energy consumption this. JulietX works like a deamon, when JulietX start receive a configuration file with the Executor sockets connection parameters and the Collector REST API Endpoints but does not start any monitoring action.

When the socket connection with the executor is done and is received and PID to monitor from executor then JulietX start monitoring until executor stop it. Finally when executor give the order (And probably an ID to store in database) JulietX send a HTTP Request to Collector API to store in de Collector's Database the metrics collected.