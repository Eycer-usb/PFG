package com.pfg.library;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;

import org.json.simple.JSONObject;

import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;

public abstract class GenericDatabase implements Database {

    protected JSONObject databaseConfig;
    protected String host;
    protected String port;
    protected String user;
    protected String password;
    protected String databaseName;
    protected String rootPassword;
    protected int sshPort;
    protected String root;
    protected String optimizationsDir;
    protected String queriesDir;

       /**
     * @param host              The host address
     * @param port              Port in the host
     * @param user              Username to login in database management system
     * @param password          Password to login in database management system
     * @param databaseName      Database to connect
     * @param rootPassword      Password of the root user in the server, used to restart service
     * @param sshPort           Port listening ssh connections
     * @param optimizationsDir  Directory where optimizations are stored if apply 
     * @param queriesDir        Directory where the benchmark queries are stored
     */
    protected GenericDatabase(JSONObject config){
        this.databaseConfig = (JSONObject) config.get("database");
        host = (String) databaseConfig.get("host");
        port = (String) databaseConfig.get("port");
        user = (String) databaseConfig.get("user");
        password = (String) databaseConfig.get("password");
        databaseName = (String) databaseConfig.get("name");
        rootPassword = (String) databaseConfig.get("rootPassword");
        sshPort = Integer.parseInt((String) databaseConfig.get("sshPort"));
        root = "root";
        optimizationsDir = (String) databaseConfig.get("optimizationsDirectory");
        queriesDir = (String) databaseConfig.get("queriesDirectory");
    }

    /**
     * Executes a file.
     *
     * @param filename The name of the file to execute.
     */
    public void executeFile(String filename) throws Exception {
        Path path = new File(filename).toPath();
        String file = Files.readAllLines(path).stream().reduce("", (a, b) -> a + "\n" + b);
        execute(file);
    }

    public String getOptimizationKey() {
        return (String) this.databaseConfig.get("optimization");
    };

    public String getQueryKey() {
        return (String) this.databaseConfig.get("queryKey");
    };

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
    };

    public void restartService() { // Connect via ssh and restart service
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


}
