package benchmark;

import java.io.IOException;
import java.util.Arrays;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class Query {
    public static void main(String[] args) throws Exception {
        // Constants
        Integer queryNum = 22;
        // Integer maxStreams = 11;
        Integer maxStreams = Runtime.getRuntime().availableProcessors();

        // Variables (Defaults)
        Boolean verbose = true;
        Boolean power = true;
        Boolean throughput = true;
        Integer query = 0;
        Integer numStreams = maxStreams;
        Boolean debug = false;

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
            } else if (args[i].startsWith("p=")) {
                String value = args[i].split("=")[1];
                if (value.equalsIgnoreCase("false") ||
                        value.equalsIgnoreCase("0")) {
                    power = false;
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

            } else {
                System.out.println("Undefined argument");
                print_help();
                System.exit(-1);
            }
            i++;
        }

        // Start tests
        if (power) {
            powerTest(query, verbose);
        }
        if (debug)
            System.out.println("throughput = " + throughput + ""
                    + "\nquery = " + query + ""
                    + "\nnumStreams = " + numStreams + "");
        if (throughput) {
            throughputTest(query, numStreams, verbose);
        }
        if (!power && !throughput) {
            System.out.println("Doing nothing...");
        }
    }

    private static void print_help() {
        System.out
                .println("Usage: java Query [v=<true|false>] [p=<true|false>] [t=<true|false>] [q=<1-22>] [s=<1-11>]");
        System.out.println("v: verbose");
        System.out.println("p: power test");
        System.out.println("t: throughput test");
        System.out.println("q: query number");
        System.out.println("s: number of streams");
    }

    private static final Integer[][] QUERY_ORDER = {
            { 14, 2, 9, 20, 6, 17, 18, 8, 21, 13, 3, 22, 16, 4, 11, 15, 1, 10, 19, 5, 7, 12 },
            { 14, 2, 9, 20, 6, 17, 18, 8, 21, 13, 3, 22, 16, 4, 11, 15, 1, 10, 19, 5, 7, 12 },
            { 6, 17, 14, 16, 19, 10, 9, 2, 15, 8, 5, 22, 12, 7, 13, 18, 1, 4, 20, 3, 11, 21 },
            { 8, 5, 4, 6, 17, 7, 1, 18, 22, 14, 9, 10, 15, 11, 20, 2, 21, 19, 13, 16, 12, 3 },
            { 5, 21, 14, 19, 15, 17, 12, 6, 4, 9, 8, 16, 11, 2, 10, 18, 1, 13, 7, 22, 3, 20 },
            { 21, 15, 4, 6, 7, 16, 19, 18, 14, 22, 11, 13, 3, 1, 2, 5, 8, 20, 12, 17, 10, 9 },
            { 10, 3, 15, 13, 6, 8, 9, 7, 4, 11, 22, 18, 12, 1, 5, 16, 2, 14, 19, 20, 17, 21 },
            { 18, 8, 20, 21, 2, 4, 22, 17, 1, 11, 9, 19, 3, 13, 5, 7, 10, 16, 6, 14, 15, 12 },
            { 19, 1, 15, 17, 5, 8, 9, 12, 14, 7, 4, 3, 20, 16, 6, 22, 10, 13, 2, 21, 18, 11 },
            { 8, 13, 2, 20, 17, 3, 6, 21, 18, 11, 19, 10, 15, 4, 22, 1, 7, 12, 9, 14, 5, 16 },
            { 6, 15, 18, 17, 12, 1, 7, 2, 22, 13, 21, 10, 14, 9, 3, 16, 20, 19, 11, 4, 8, 5 },
            { 15, 14, 18, 17, 10, 20, 16, 11, 1, 8, 4, 22, 5, 12, 3, 9, 21, 2, 13, 6, 19, 7 },
            { 1, 7, 16, 17, 18, 22, 12, 6, 8, 9, 11, 4, 2, 5, 20, 21, 13, 10, 19, 3, 14, 15 },
            { 21, 17, 7, 3, 1, 10, 12, 22, 9, 16, 6, 11, 2, 4, 5, 14, 8, 20, 13, 18, 15, 19 },
            { 2, 9, 5, 4, 18, 1, 20, 15, 16, 17, 7, 21, 13, 14, 19, 8, 22, 11, 10, 3, 12, 6 },
            { 16, 9, 17, 8, 14, 11, 10, 12, 6, 21, 7, 3, 15, 5, 22, 20, 1, 13, 19, 2, 4, 18 },
            { 1, 3, 6, 5, 2, 16, 14, 22, 17, 20, 4, 9, 10, 11, 15, 8, 12, 19, 18, 13, 7, 21 },
            { 3, 16, 5, 11, 21, 9, 2, 15, 10, 18, 17, 7, 8, 19, 14, 13, 1, 4, 22, 20, 6, 12 },
            { 14, 4, 13, 5, 21, 11, 8, 6, 3, 17, 2, 20, 1, 19, 10, 9, 12, 18, 15, 7, 22, 16 },
            { 4, 12, 22, 14, 5, 15, 16, 2, 8, 10, 17, 9, 21, 7, 3, 6, 13, 18, 11, 20, 19, 1 },
            { 16, 15, 14, 13, 4, 22, 18, 19, 7, 1, 12, 17, 5, 10, 20, 3, 9, 21, 11, 2, 6, 8 },
            { 20, 14, 21, 12, 15, 17, 4, 19, 13, 10, 11, 1, 16, 5, 18, 7, 8, 22, 9, 6, 3, 2 },
            { 16, 14, 13, 2, 21, 10, 11, 4, 1, 22, 18, 12, 19, 5, 7, 8, 6, 3, 15, 20, 9, 17 },
            { 18, 15, 9, 14, 12, 2, 8, 11, 22, 21, 16, 1, 6, 17, 5, 10, 19, 4, 20, 13, 3, 7 },
            { 7, 3, 10, 14, 13, 21, 18, 6, 20, 4, 9, 8, 22, 15, 2, 1, 5, 12, 19, 17, 11, 16 },
            { 18, 1, 13, 7, 16, 10, 14, 2, 19, 5, 21, 11, 22, 15, 8, 17, 20, 3, 4, 12, 6, 9 },
            { 13, 2, 22, 5, 11, 21, 20, 14, 7, 10, 4, 9, 19, 18, 6, 3, 1, 8, 15, 12, 17, 16 },
            { 14, 17, 21, 8, 2, 9, 6, 4, 5, 13, 22, 7, 15, 3, 1, 18, 16, 11, 10, 12, 20, 19 },
            { 10, 22, 1, 12, 13, 18, 21, 20, 2, 14, 16, 7, 15, 3, 4, 17, 5, 19, 6, 8, 9, 11 },
            { 10, 8, 9, 18, 12, 6, 1, 5, 20, 11, 17, 22, 16, 3, 13, 2, 15, 21, 14, 19, 7, 4 },
            { 7, 17, 22, 5, 3, 10, 13, 18, 9, 1, 14, 15, 21, 19, 16, 12, 8, 6, 11, 20, 4, 2 },
            { 2, 9, 21, 3, 4, 7, 1, 11, 16, 5, 20, 19, 18, 8, 17, 13, 10, 12, 15, 6, 14, 22 },
            { 15, 12, 8, 4, 22, 13, 16, 17, 18, 3, 7, 5, 6, 1, 9, 11, 21, 10, 14, 20, 19, 2 },
            { 15, 16, 2, 11, 17, 7, 5, 14, 20, 4, 21, 3, 10, 9, 12, 8, 13, 6, 18, 19, 22, 1 },
            { 1, 13, 11, 3, 4, 21, 6, 14, 15, 22, 18, 9, 7, 5, 10, 20, 12, 16, 17, 8, 19, 2 },
            { 14, 17, 22, 20, 8, 16, 5, 10, 1, 13, 2, 21, 12, 9, 4, 18, 3, 7, 6, 19, 15, 11 },
            { 9, 17, 7, 4, 5, 13, 21, 18, 11, 3, 22, 1, 6, 16, 20, 14, 15, 10, 8, 2, 12, 19 },
            { 13, 14, 5, 22, 19, 11, 9, 6, 18, 15, 8, 10, 7, 4, 17, 16, 3, 1, 12, 2, 21, 20 },
            { 20, 5, 4, 14, 11, 1, 6, 16, 8, 22, 7, 3, 2, 12, 21, 19, 17, 13, 10, 15, 18, 9 },
            { 3, 7, 14, 15, 6, 5, 21, 20, 18, 10, 4, 16, 19, 1, 13, 9, 8, 17, 11, 12, 22, 2 },
            { 13, 15, 17, 1, 22, 11, 3, 4, 7, 20, 14, 21, 9, 8, 2, 18, 16, 6, 10, 12, 5, 19 },
    };

    private static PGDB PGDBConnector(Boolean verbose) throws Exception {
        if (verbose) {
            System.out.println("Connecting to database...");
        }
        try {
            PGDB pgdb = new PGDB(
                    "localhost",
                    5432,
                    "tpch",
                    "********",
                    "tpch");
            if (verbose) {
                System.out.println("Connected to database.");
            }

            return pgdb;
        } catch (Exception e) {
            String textHelper = "Error connecting to database: ";
            System.out.println(textHelper + e.getMessage());
            return null;
        }
    }

    private static void testQuery(Integer number, PGDB pgdb, Boolean verbose)
            throws Exception {
        String queryPath = "benchmark/queries/" + number.toString() + ".sql";
        if (verbose) {
            System.out.println("Running query " + queryPath + "...");
        }

        try {
            pgdb.executeFile(queryPath);
        } catch (Exception e) {
            String textHelper = "Error running query: ";
            System.out.println(textHelper + queryPath + ": " + e.getMessage());
        }
    }

    private static void queryStream(
            Integer stream,
            Integer query,
            Boolean verbose) throws IOException, Exception {
        Integer index = stream % QUERY_ORDER.length;
        Integer[] order = QUERY_ORDER[index];

        PGDB pgdb = PGDBConnector(verbose);

        if (query == 0) {
            for (Integer i = 0; i < order.length; i++) {
                testQuery(order[i], pgdb, verbose);
            }
        } else {
            testQuery(query, pgdb, verbose);
        }
    }

    private static void powerTest(Integer query, Boolean verbose)
            throws Exception {
        int stream = 0;
        if (verbose) {
            System.out.println("Power test started...");
        }
        try {
            queryStream(stream, query, verbose);
            if (verbose) {
                System.out.println("Power test finished...");
            }
        } catch (Exception e) {
            System.out.println("Error running Power test: " + e.getMessage());
            return;
        }
    }

    public static Runnable innerThroughputTest(
            Integer stream,
            Integer query,
            Boolean verbose) throws Exception {
        queryStream(stream, query, verbose);
        return null;
    }

    private static void throughputTest(
            Integer query,
            Integer numStreams,
            Boolean verbose) throws InterruptedException {
        ExecutorService service = Executors.newFixedThreadPool(numStreams);

        if (verbose) {
            System.out.println("Throughput test started...");
        }
        for (int i = 0; i < numStreams; i++) {
            int stream = i + 1;
            try {
                String textHelper = "Throughput tests in stream ";
                if (verbose) {
                    System.out.println(textHelper + stream + " started ...");
                }
                // service.execute(Objects.requireNonNull(
                // Query.innerThroughputTest(stream, query, verbose)
                // ));
                service.submit(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            if (verbose) {
                                System.out.println("Running inner throughput test, Thread ID: "
                                        + Thread.currentThread().getId() + " ...");
                            }
                            queryStream(stream, query, verbose);
                        } catch (Exception e) {
                            String textHelper = "Error running inner throughput test: ";
                            System.out.println(textHelper + e.getMessage());
                        }
                    }
                });
            } catch (Exception e) {
                // String textHelper = "Error running inner throughput test: ";
                // System.out.println(textHelper + e.getMessage());
            }
        }

        service.shutdown();
        try {
            service.awaitTermination(Long.MAX_VALUE, TimeUnit.MILLISECONDS);
        } catch (InterruptedException e) {
            String textHelper = "Error running throughput test: ";
            System.out.println(textHelper + e.getMessage());
        }
    }
}