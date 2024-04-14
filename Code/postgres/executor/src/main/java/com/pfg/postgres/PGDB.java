package com.pfg.postgres;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.*;

/**
 * A very simple PostgreSQL database client.
 *
 * This class is not thread-safe.
 *
 * @constructor Creates a new PostgreSQL database client.
 */
public class PGDB {

    private Connection conn;
    // constructor

    /**
     * @param host The host name of the database server.
     * @param port The port number of the database server.
     * @param user The username to use for authentication.
     * @param password The password to use for authentication.
     * @param database The name of the database to connect to.
     * @throws SQLException
     */
    public PGDB(String host, int port, String user, String password, String database) 
        throws SQLException, IOException {
        String url = "jdbc:postgresql://" + host + ":" + port + "/" + database;
        try {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            printLog(e + "\n");
        }
    }

    private static void printLog(String msg) throws IOException {
        try {
            FileWriter fWriter = new FileWriter("log.txt", true);
            BufferedWriter bWriter = new BufferedWriter(fWriter);
            bWriter.write(msg);
            bWriter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
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

    public String getConnectionPid() throws SQLException{
        return this.querySingle("SELECT pg_backend_pid();");
    }

    public void close() throws SQLException{
        try {
            this.conn.close();
        } catch (Exception e) {
            System.out.println("Error Closing Connection");
        }
    }

}