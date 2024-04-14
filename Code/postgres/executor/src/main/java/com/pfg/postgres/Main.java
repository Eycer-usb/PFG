package com.pfg.postgres;

import java.sql.Timestamp;
import java.util.Arrays;

public class Main {
    public static void main(String[] args) throws Exception {
        // Constants
        Integer queryNum = 22;
        Integer maxStreams = Runtime.getRuntime().availableProcessors();
        String[] header = {"iteration", "pid", "start_time", "end_time", "runtime"};

        // Variables (Defaults)
        Boolean verbose = true;
        Boolean throughput = true;
        Integer query = 0;
        Integer numStreams = maxStreams;
        Boolean debug = false;
        String queriesFolderPath = "src/queries";
        String objetiveFile = null;
        Boolean multipleConections = false;
        Integer iteration = -1;

        // Process args
        int i = 0;
        // if there is a -d in the args, then we are running in debug mode
        if (Arrays.asList(args).contains("-d")) {
            System.out.println("Running in debug mode");
            debug = true;
        }
        if (debug) {
            System.out.println("args.length = " + args.length + "");
            System.out.println("args = " + Arrays.toString(args) + "");
        }
        while (i < args.length) {
            if (debug)
                System.out.println(args[i]);
            if (args[i].startsWith("v=")) {
                String value = args[i].split("=")[1];
                if (value.equalsIgnoreCase("true") ||
                        value.equalsIgnoreCase("1")) {
                    verbose = true;
                } else if (value.equalsIgnoreCase("false") ||
                        value.equalsIgnoreCase("0")) {
                    verbose = false;
                }
            } else if (args[i].startsWith("t=")) {
                String value = args[i].split("=")[1];
                if (value.equalsIgnoreCase("false") ||
                        value.equalsIgnoreCase("0")) {
                    throughput = false;
                }
            } else if (args[i].startsWith("q=")) {
                Integer value = Integer.valueOf(args[i].split("=")[1]);
                if (1 <= value && value <= queryNum) {
                    query = value;
                }
            } else if (args[i].startsWith("s=")) {
                Integer value = Integer.valueOf(args[i].split("=")[1]);
                if (1 <= value && value <= maxStreams) {
                    numStreams = value;
                }
            } else if (args[i].startsWith("h") || args[i].startsWith("-h")) {
                print_help();
                System.exit(0);
            } else if (args[i].startsWith("d") || args[i].startsWith("-d")) {
                debug = true;
            } else if (args[i].startsWith("f") || args[i].startsWith("-f")) {
                String value = args[i].split("=")[1];
                queriesFolderPath = value;
                
            } else if (args[i].startsWith("i=")) {
                iteration = Integer.valueOf(args[i].split("=")[1]);
            } else if (args[i].startsWith("o=")) {
                objetiveFile = args[i].split("=")[1];
            } else if (args[i].startsWith("m=")) {
                String value = args[i].split("=")[1];
                if (value.equalsIgnoreCase("true") ||
                        value.equalsIgnoreCase("1")) {
                    multipleConections = true;
                } else if (value.equalsIgnoreCase("false") ||
                        value.equalsIgnoreCase("0")) {
                    verbose = false;
                }
            }        
             else {
                System.out.print("Undefined argument ");
                System.out.println(args[i]);
                print_help();
                System.exit(-1);
            }
            i++;
        }

        // Start tests
        PGDB pgdb = null;
        String pgPid = null;
        Register register = new Register( objetiveFile, header, iteration );
        if(!multipleConections){
            pgdb = Query.PGDBConnector(verbose);
            pgPid = pgdb.getConnectionPid();
            System.out.println("Postgres Process ID: " + pgPid);
        }
        Integer[] runtimePerStream = {};

        if (debug)
            System.out.println("throughput = " + throughput + ""
                    + "\nquery = " + query + ""
                    + "\nnumStreams = " + numStreams + "");
        if (throughput) {
            Timestamp startTest = Query.getCurrentTimestamp();
            Query.throughputTest(pgdb, query, numStreams, runtimePerStream, queriesFolderPath, verbose, register);
            Timestamp endTest = Query.getCurrentTimestamp();
            if (!multipleConections) {
                String[] line = { pgPid, 
                    Long.toString(startTest.getTime()), Long.toString(endTest.getTime()), 
                    Long.toString(Query.getDuration(startTest, endTest))
                };
                register.storeCSVLine(line);
            }
        }
        if (!throughput) {
            System.out.println("Doing nothing...");
        }

        if (!multipleConections) {
            pgdb.close();
        }
    }

    private static void print_help() {
        System.out
            .println("Usage: java Query [v=<true|false>] [t=<true|false>] [f=<string>] [q=<1-22>] [s=<1-11>] [i=<iteration number>] [o=<objetive file path>] [m=<true|false>]");
        System.out.println("v: verbose");
        System.out.println("t: throughput test");
        System.out.println("q: query number");
        System.out.println("s: number of streams");
        System.out.println("h: this help message");
        System.out.println("d: run in debug mode");
        System.out.println("f: Queries Folder path");
        System.out.println("i: iteration number");
        System.out.println("o: objetive file path to register results");
        System.out.println("m: multiple database connection (one per thread)");;
    }

    
}