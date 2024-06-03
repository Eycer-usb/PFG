package com.pfg.mongo;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;

import org.bson.Document;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import com.pfg.library.GenericDatabase;

public class MongoDB extends GenericDatabase {

    private MongoClient client;
    private MongoDatabase database;

    /**
     * @param host         The host address
     * @param port         Port in the host
     * @param user         Username to login in database management system
     * @param password     Password to login in database management system
     * @param databaseName Database to connect
     * @param rootPassword Password of the root user in the server, used to restart
     *                     service
     * @param sshPort      Port listening ssh connections
     * @param queriesDir   Directory where the benchmark queries are stored
     */
    public MongoDB(JSONObject config) {
        super(config);
    }

    public String getConnectionPid() {
        try {
            Document serverStatus = database.runCommand(new Document("serverStatus", 1));
            JSONParser parser = new JSONParser();
            JSONObject serverStatusJson = (JSONObject) parser.parse(serverStatus.toJson());
            return Long.toString((Long) serverStatusJson.get("pid"));
        } catch (Exception e) {
            System.out.println("Error getting Mongo PID");
            e.printStackTrace();
            System.exit(-1);
            return "";
        }
    }

    public String getDatabaseKey() {
        return "mongodb";
    }

    public void execute(String query) {
        Document result = database.runCommand(Document.parse(query));
        // Print the result
        System.out.println("Query: " + query);
        System.out.println("Result: " + result.toJson());
    }

    public void connect() {
        if (client == null) {
            System.out.println("Connecting to Mongo Server");
            String connectionString = "mongodb://" + host + ":" + port;
            client = MongoClients.create(connectionString);
            database = client.getDatabase(databaseName);
        }
    }

    public void close() {
        if (client != null) {
            client.close();
        }
    }

    public void dropDatabase() {
        // Already done in tpch-mongo benchmark
    }

    public void createDatabase() {
        // Already done in tpch-mongo benchmark
    }

    public void prepareBenchmark() {
        System.out.println("Generating Queries Data");
        String action = "generate-queries";
        String cwd = "mongo/client/tpch-mongo";

        try {
            ProcessBuilder processBuilder = new ProcessBuilder("python3",
                    "main.py", action);
            processBuilder.directory(new File(cwd));
            processBuilder.redirectErrorStream(true);
            Process process = processBuilder.start();

            // Capture and print the output
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }

            int exitCode = process.waitFor();
            System.out.println("Command exited with code " + exitCode);
        } catch (Exception e) {
            System.out.println("Error preparing Benchmark");
            e.printStackTrace();
        }
    }

    public void loadBenchmark(boolean index, boolean compression) {
        System.out.println("Loading Benchmark in database");
        String cwd = "mongo/client/tpch-mongo";
        String action = "create";
        String compression_flag = "compression";
        String index_flag = "index";
        String base_flag = "base";
        ArrayList<String> args = new ArrayList<>(Arrays.asList("python3",
                "main.py", action,
                host, String.valueOf(port),
                databaseName));
        if (compression) {
            args.add(compression_flag);

        }
        if (index) {
            args.add(index_flag);
        }

        if (!compression && !index) {
            args.add(base_flag);
        }

        try {
            ProcessBuilder processBuilder = new ProcessBuilder(args);
            processBuilder.directory(new File(cwd));
            processBuilder.redirectErrorStream(true);
            Process process = processBuilder.start();

            // Capture and print the output
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }

            int exitCode = process.waitFor();
            System.out.println("Command exited with code " + exitCode);
        } catch (Exception e) {
            System.out.println("Error loading Benchmark");
        }
    }

    // Available Setups
    public void setBase() {
        try {
            prepareBenchmark();
            loadBenchmark(false, false);
        } catch (Exception e) {
            System.out.println("Error Setting up Base option");
            e.printStackTrace();
            System.exit(-1);
        }
    }

    public void setIndex() {
        try {
            loadBenchmark(true, false);
            prepareBenchmark();

        } catch (Exception e) {
            System.out.println("Error Setting up Index option");
            e.printStackTrace();
            System.exit(-1);
        }
    }

    public void setCompression() {
        try {
            prepareBenchmark();
            loadBenchmark(false, true);
        } catch (Exception e) {
            System.out.println("Error Setting up Compress option");
            e.printStackTrace();
            System.exit(-1);
        }
    }

    public void setIndexCompression() {
        try {
            prepareBenchmark();
            loadBenchmark(true, true);

        } catch (Exception e) {
            System.out.println("Error Setting up Index Compression option");
            e.printStackTrace();
            System.exit(-1);
        }
    }

}
