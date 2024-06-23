package com.pfg.postgres;

import java.io.*;
import java.sql.*;

import org.json.simple.JSONObject;

import com.pfg.library.GenericDatabase;

/**
 * A very simple PostgreSQL database client.
 *
 * This class is not thread-safe.
 *
 * @constructor Creates a new PostgreSQL database client.
 */
public class PGDB extends GenericDatabase {

    private Connection conn;
   

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
    public PGDB(JSONObject config) {
        super(config);
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

    public void close() {
        try {
            if (this.conn == null || this.conn.isClosed()) {
                return;
            }
            this.conn.close();
        } catch (Exception e) {
            e.printStackTrace();
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
        try {
            System.out.println("Dropping Database");
            System.out.println("jdbc:postgresql://" + host + ":" + port + "/" + user + ":" + password);
            Connection c = DriverManager
                    .getConnection("jdbc:postgresql://" + host + ":" + port + "/", user, password);
            Statement statement = c.createStatement();
            statement.executeUpdate("DROP DATABASE IF EXISTS " + databaseName);
        } catch (SQLException e) {
            System.out.println("Error Dropping database");
            e.printStackTrace();
            System.exit(-1);
        }
    }

    public void createDatabase() {
        try {
            System.out.println("Creating Database");
            Connection c = DriverManager
                    .getConnection("jdbc:postgresql://" + host + ":" + port + "/", user, password);
            Statement statement = c.createStatement();
            statement.executeUpdate("CREATE DATABASE " + databaseName);
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error Creating Database");
            System.exit(-1);
        }
    }

    public void prepareBenchmark() {
        System.out.println("Generating Benchmark Data");
        String action = "prepare";
        String cwd = "postgres/client/tpch-pgsql";

        try {
            ProcessBuilder processBuilder = new ProcessBuilder("python3",
                    "tpch_pgsql.py", action,
                    "-H", host, "-p", String.valueOf(port),
                    "-U", user, "-W", password, "-d", databaseName);
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
        String cwd = "postgres/client/tpch-pgsql";
        String action = "load";
        String decompression_flag = "-z";
        String[] args;
        if(compression) {
            args = new String[]{
                "python3",
                "tpch_pgsql.py", action,
                "-H", host, "-p", String.valueOf(port),
                "-U", user, "-W", password, "-d", databaseName
            };
        }
        else{
            args = new String[]{
                "python3",
                "tpch_pgsql.py", action,
                "-H", host, "-p", String.valueOf(port),
                "-U", user, "-W", password, "-d", databaseName, decompression_flag
            };
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
            executeFile(optimizationsDir + "/reset.sql");
            close();
            setOptimizationKey("base");
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
            prepareBenchmark();
            loadBenchmark(true, false);
            connect();
            executeFile(optimizationsDir + "/index.sql");
            close();
            setOptimizationKey("index");

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
            executeFile(optimizationsDir + "/reset.sql");
            close();
            setOptimizationKey("compression");
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
            executeFile(optimizationsDir + "/index.sql");
            close();
            setOptimizationKey("index-compression");
        } catch (Exception e) {
            System.out.println("Error Setting up Index Compression option");
            e.printStackTrace();
            System.exit(-1);
        }
    }

}