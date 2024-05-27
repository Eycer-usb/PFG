package com.pfg.postgres;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.*;

import org.json.simple.JSONObject;

import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import com.pfg.library.Database;

/**
 * A very simple PostgreSQL database client.
 *
 * This class is not thread-safe.
 *
 * @constructor Creates a new PostgreSQL database client.
 */
public class PGDB implements Database {

    private Connection conn;
    private JSONObject databaseConfig;
    private String host;
    private String port;
    private String user;
    private String password;
    private String databaseName;
    private String rootPassword;
    private int sshPort;
    private String root;
    // constructor

    /**
     * @param host     The host name of the database server.
     * @param port     The port number of the database server.
     * @param user     The username to use for authentication.
     * @param password The password to use for authentication.
     * @param database The name of the database to connect to.
     */
    public PGDB(JSONObject config) {
        this.databaseConfig = (JSONObject) config.get("database");
        host = (String) databaseConfig.get("host");
        port = (String) databaseConfig.get("port");
        user = (String) databaseConfig.get("user");
        password = (String) databaseConfig.get("password");
        databaseName = (String) databaseConfig.get("name");
        rootPassword = (String) databaseConfig.get("rootPassword");
        sshPort = (int) databaseConfig.get("sshPort");
        root = "root";
    }

    /**
     * Executes a SQL statement.
     *
     * @param sql The SQL statement to execute.
     */
    public void execute(String sql) throws SQLException {
        Statement stmt = conn.createStatement();
        stmt.execute(sql);
        stmt.close();
    }

    /**
     * Executes a SQL query.
     *
     * @param sql The SQL query to execute.
     * @return The result set of the query.
     */
    public ResultSet query(String sql) throws SQLException {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        return rs;
    }

    /**
     * Executes a SQL query and returns the first column of the first row.
     *
     * @param sql The SQL query to execute.
     * @return The first column of the first row of the result set.
     */
    public String querySingle(String sql) throws SQLException {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        rs.next();
        String result = rs.getString(1);
        rs.close();
        stmt.close();
        return result;
    }

    /**
     * Executes a SQL file.
     *
     * @param filename The name of the file to execute.
     */
    public void executeFile(String filename) throws SQLException, IOException {
        Path path = new File(filename).toPath();
        String file = Files.readAllLines(path).stream().reduce("", (a, b) -> a + "\n" + b);
        execute(file);
    }

    public void close() {
        try {
            this.conn.close();
        } catch (Exception e) {
            System.out.println("Error Closing Connection");
        }
    }

    public String getConnectionPid() {
        try {
            return this.querySingle("SELECT pg_backend_pid();");
        } catch (Exception e) {
            System.err.println(e);
            System.exit(-1);
        }
        return "";
    }

    public String getDatabaseKey() {
        return "postgres";
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

    public void connect() {
        String url = "jdbc:postgresql://" + host + ":" + port + "/" + databaseName;
        try {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            System.out.println("Error Connecting to Postgres Database");
            e.printStackTrace();
            System.exit(-1);
        }
        System.out.println("Database Connection Success");
    }

    public void dropDatabase() {
        try{
            Connection c = DriverManager
                    .getConnection("jdbc:postgresql://" + host + ":" + port, user, password);
            Statement statement = c.createStatement();
            statement.executeUpdate("DROP DATABASE " + databaseName);
        } catch( SQLException e){
            System.out.println("Error Dropping database");
            e.printStackTrace();
            System.exit(-1);
        }
    }

    public void restartService() { // Connect via ssh and restart service
        try {
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
            System.out.println("Error Restarting Postgresql Service in host");
        }
    }

    public void createDatabase() {
        try {
            Connection c = DriverManager
                    .getConnection("jdbc:postgresql://" + host + ":" + port, user, password);
            Statement statement = c.createStatement();
            statement.executeUpdate("CREATE DATABASE " + databaseName);
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error Creating Database");
            System.exit(-1);
        }
        loadBenchmark();
    }

    public void loadBenchmark() {

    }

    private void compressDatabase() {
    }

    // Available Setups
    public void setBase() {
        try {
            close();
            dropDatabase();
            createDatabase();
            connect();
            executeFile("src/main/resources/optimization/reset.sql");
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
            connect();
            executeFile("src/main/resources/optimization/index.sql");
            
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
            compressDatabase();
            executeFile("src/main/resources/optimization/reset.sql");
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
            compressDatabase();
            executeFile("src/main/resources/optimization/index.sql");
            
        } catch (Exception e) {
            System.out.println("Error Setting up Index Compression option");
            e.printStackTrace();
            System.exit(-1);
        }
    }

}