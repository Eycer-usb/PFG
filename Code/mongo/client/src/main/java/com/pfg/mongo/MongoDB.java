package com.pfg.mongo;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;

import org.bson.Document;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import com.pfg.library.Database;

public class MongoDB implements Database {

    private MongoClient client;
    private JSONObject databaseConfig;
    private MongoDatabase database;
    private String host;
    private String port;
    private String user;
    private String password;
    private String databaseName;
    private String rootPassword;
    private int sshPort;
    private String root;
    private String queriesDir;

    // constructor

    /**
     * @param host     The host name of the database server.
     * @param port     The port number of the database server.
     * @param user     The username to use for authentication.
     * @param password The password to use for authentication.
     * @param database The name of the database to connect to.
     */
    public MongoDB(JSONObject config) {
        this.databaseConfig = (JSONObject) config.get("database");
        host = (String) databaseConfig.get("host");
        port = (String) databaseConfig.get("port");
        user = (String) databaseConfig.get("user");
        password = (String) databaseConfig.get("password");
        databaseName = (String) databaseConfig.get("name");
        rootPassword = (String) databaseConfig.get("rootPassword");
        sshPort = Integer.parseInt((String) databaseConfig.get("sshPort"));
        root = "root";
        queriesDir = (String) databaseConfig.get("queriesDirectory");
    }

    public String getConnectionPid() {
        try {
            Document serverStatus = database.runCommand(new Document("serverStatus", 1));
            JSONParser parser = new JSONParser();
            JSONObject serverStatusJson = (JSONObject) parser.parse(serverStatus.toJson());
            return (String) serverStatusJson.get("pid");
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

    public String getOptimizationKey() {
        return (String) this.databaseConfig.get("optimization");
    }

    public String getQueryKey() {
        return (String) this.databaseConfig.get("queryKey");
    }

    public void runQuery() {
        System.out.println("Running Query");
        String queryPath = (String) this.databaseConfig.get("queryPath");
        try {
            this.executeFile(queryPath);
        } catch (Exception e) {
            System.err.println(e);
            System.exit(-1);
        }
        System.out.println("Done");
    }

    public void execute(String query){
        Document result = database.runCommand(Document.parse(query));
        // Print the result
        System.out.println("Query: " + query);
        System.out.println("Result: " + result.toJson());
    }

    public void executeFile(String filepath) throws SQLException, IOException {
        Path path = new File(filepath).toPath();
        String file = Files.readAllLines(path).stream().reduce("", (a, b) -> a + "\n" + b);
        execute(file);
    }

    public void connect() {
        String connectionString = "mongodb://" + host + ":" + port;
        client = MongoClients.create(connectionString);
    }

    public void close() {
        client.close();
    }

    public void restartService() {
        try {
            System.out.println("Restarting Service");
            JSch jsch = new JSch();
            Session session = jsch.getSession(root, host, sshPort);
            session.setPassword(rootPassword);
            session.setConfig("StrictHostKeyChecking", "no");
            System.out.println("Establishing Connection...");
            session.connect();
            System.out.println("Connection established.");

            ChannelExec channelExec = (ChannelExec) session.openChannel("exec");
            InputStream in = channelExec.getInputStream();

            // Running the command
            String command = (String) databaseConfig.get("restartCommand");
            channelExec.setCommand(command);
            channelExec.connect();

            BufferedReader reader = new BufferedReader(new InputStreamReader(in));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
            channelExec.disconnect();

        } catch (Exception e) {
            System.out.println("Error Restarting Service in host");
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
        ArrayList<String> args = new ArrayList<String>(Arrays.asList("python3",
                "main.py", action,
                host, String.valueOf(port),
                databaseName));
        if (compression) {
            args.add(compression_flag);
            
        }
        if (index) {
            args.add(index_flag);
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
            close();
            dropDatabase();
            createDatabase();
            prepareBenchmark();
            loadBenchmark(false, false);
            connect();
        } catch (Exception e) {
            System.out.println("Error Setting up Base option");
            e.printStackTrace();
            System.exit(-1);
        }
    }

    public void setIndex() {
        try {
            close();
            dropDatabase();
            createDatabase();
            loadBenchmark(true, false);
            prepareBenchmark();
            connect();

        } catch (Exception e) {
            System.out.println("Error Setting up Index option");
            e.printStackTrace();
            System.exit(-1);
        }
    }

    public void setCompression() {
        try {
            close();
            dropDatabase();
            createDatabase();
            connect();
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
            close();
            dropDatabase();
            createDatabase();
            connect();
            prepareBenchmark();
            loadBenchmark(true, true);

        } catch (Exception e) {
            System.out.println("Error Setting up Index Compression option");
            e.printStackTrace();
            System.exit(-1);
        }
    }

}
