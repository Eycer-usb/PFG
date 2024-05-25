package com.pfg.postgres;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.*;

import org.json.simple.JSONObject;

import com.pfg.library.Database;

/**
 * A very simple PostgreSQL database client.
 *
 * This class is not thread-safe.
 *
 * @constructor Creates a new PostgreSQL database client.
 */
public class PGDB implements Database{

    private Connection conn;
    private JSONObject databaseConfig;
    // constructor

    /**
     * @param host     The host name of the database server.
     * @param port     The port number of the database server.
     * @param user     The username to use for authentication.
     * @param password The password to use for authentication.
     * @param database The name of the database to connect to.
     */
    public PGDB(JSONObject config)
            throws SQLException, IOException {
        databaseConfig = (JSONObject) config.get("database");
        String host = (String) databaseConfig.get("host");
        String port = (String) databaseConfig.get("port");
        String databaseName = (String) databaseConfig.get("name");
        String user = (String) databaseConfig.get("user");
        String password = (String) databaseConfig.get("password");
        String url = "jdbc:postgresql://" + host + ":" + port + "/" + databaseName;
        try {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            throw new SQLException("Error in connection");
        }
        System.out.println("Database Connection Success");
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

    public String getDatabaseKey(){
        return "postgres";
    }
    public String getOptimizationKey(){
        return (String) this.databaseConfig.get("optimization");
    };

    public String getQueryKey(){
        return (String) this.databaseConfig.get("queryKey");
    };
    
    public void runQuery(){
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

}